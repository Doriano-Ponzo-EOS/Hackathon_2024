codeunit 66000 "EAI SendRequest"
{

    procedure SendLSRequest(Question: Text; var TopIntent: Enum "EAI Intent"; var tmp_entities: Record "EAI Entities"; ProjectName: Text)
    var
        jsonData: Text;
        RequestMessage: HttpRequestMessage;
        ResponseTxt: Text;
    begin
        jsonData := GetRequestBody(Question, ProjectName);
        GetRequestMessage(RequestMessage, jsonData);
        ResponseTxt := SendRequestMessage(RequestMessage);
        ParseResponseText(ResponseTxt, TopIntent, tmp_entities);
    end;


    local procedure GetRequestBody(Question: Text; ProjectName: Text) requestBody: Text
    var
        EAISetup: Record "EAI Library Setup";
        JsonDataSrc: Label '{"kind":"Conversation","analysisInput":{"conversationItem":{"id":"{{userID}}","text":"{{RequestText}}","modality":"text","language":"it","participantId":"{{userID}}"}},"parameters":{"projectName":"{{ProjectName}}","verbose":true,"deploymentName":"{{Deployment}}","stringIndexType":"TextElement_V8"}}';
    begin
        EAISetup.Get();
        requestBody := JsonDataSrc;
        requestBody := requestBody.Replace('{{userID}}', UserId);
        requestBody := requestBody.Replace('{{RequestText}}', Question);
        requestBody := requestBody.Replace('{{ProjectName}}', ProjectName);
        requestBody := requestBody.Replace('{{Deployment}}', EAISetup."Deployment Name");
    end;

    local procedure GetRequestMessage(var RequestMessage: HttpRequestMessage; JsonData: Text)
    var
        EAISetup: Record "EAI Library Setup";
        Base64Convert: Codeunit "Base64 Convert";
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        RequestHeader: HttpHeaders;
        Auth: Text;
        UserPasswordBase64: Text;
        URILbl: Label '%1/language/:analyze-conversations?api-version=%2', Locked = true;
        UserPasswordLbl: Label '%1:%2', Locked = true;
    begin
        Clear(RequestMessage);
        EAISetup.Get();


        RequestHeader.Clear();
        RequestMessage.GetHeaders(RequestHeader);
        RequestHeader.Add('Ocp-Apim-Subscription-Key', EAISetup.SubscriptionKey);

        RequestMessage.SetRequestUri(StrSubstNo(URILbl, EAISetup."EAI Endpoint", EAISetup."API Version"));
        RequestMessage.Method('POST');

        Content.WriteFrom(JsonData);
        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
        RequestMessage.Content := Content;
    end;

    local procedure SendRequestMessage(var RequestMessage: HttpRequestMessage) ResponseText: Text
    var
        ResponseContent: HttpContent;
        HttpClient: HttpClient;
        ResponseMessage: HttpResponseMessage;
        Sent: Boolean;
    begin
        Sent := HttpClient.Send(RequestMessage, ResponseMessage);

        //write "Label Log Entry"
        if Sent then begin

            case ResponseMessage.HttpStatusCode() of
                200:
                    begin
                        ResponseContent := ResponseMessage.Content();
                        ResponseMessage.Content().ReadAs(ResponseText);
                    end;
            end;
        end else
            Error(ResponseMessage.ReasonPhrase());
    end;

    local procedure ParseResponseText(ResponseTxt: Text; var TopIntent: Enum "EAI Intent"; var tmp_entities: Record "EAI Entities")
    var
        JObj: JsonObject;
        JTok: JsonToken;
        JTopIntent: JsonToken;
        JEntities: JsonToken;
        JExtraInfo: JsonToken;
        JFromDate: JsonToken;
        JToDate: JsonToken;
        TopIntentTxt: Text;
        JArray: JsonArray;
        jEntityTok: JsonToken;
        Intents: List of [Text];
        OrdinalValue: Integer;
        Index: Integer;
        LevelName: Text;
        i: Integer;
    begin
        JObj.ReadFrom(ResponseTxt);
        JObj.SelectToken('$.result.prediction.topIntent', JTopIntent);
        JObj.SelectToken('$.result.prediction.entities', JEntities);

        TopIntentTxt := JTopIntent.AsValue().AsText();
        Index := "EAI Intent".Names.IndexOf(TopIntentTxt);
        OrdinalValue := "EAI Intent".Ordinals.Get(Index);
        TopIntent := Enum::"EAI Intent".FromInteger(OrdinalValue);

        JArray := JEntities.AsArray();
        i := 0;
        foreach jEntityTok in JArray do begin
            tmp_entities.Init();
            tmp_entities."Entry No." := i;
            i += 1;
            jEntityTok.AsObject().Get('category', JTok);
            tmp_entities.Entity := JTok.AsValue().AsText();
            if jEntityTok.SelectToken('$.extraInformation[0].key', JExtraInfo) then begin
                tmp_entities.Text := JExtraInfo.AsValue().AsText();
            end else begin
                jEntityTok.AsObject().Get('text', JTok);
                tmp_entities.Text := JTok.AsValue().AsText();
                if jEntityTok.SelectToken('$.resolutions[0].begin', JFromDate) then
                    Evaluate(tmp_entities."From Date", JFromDate.AsValue().AsText());
                if jEntityTok.SelectToken('$.resolutions[0].end', JToDate) then
                    Evaluate(tmp_entities."To Date", JToDate.AsValue().AsText());
                if jEntityTok.SelectToken('$.resolutions[0].value', JFromDate) then begin
                    Evaluate(tmp_entities."From Date", JFromDate.AsValue().AsText());
                    Evaluate(tmp_entities."To Date", JFromDate.AsValue().AsText());
                end;
            end;
            tmp_entities.Insert();
        end;

    end;


}