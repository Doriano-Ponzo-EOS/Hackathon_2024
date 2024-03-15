codeunit 66150 "AIL Generate CDW Proposal"
{
    trigger OnRun()
    begin
        GenerateCDWProposal();
    end;

    procedure SetUserPrompt(InputUserPrompt: Text)
    begin
        UserPrompt := InputUserPrompt;
    end;

    procedure SetCDWKey(TableID2: Integer)
    begin
        TableID := TableID2;
    end;

    procedure GetResult(var TmpCDWAIProposal2: Record "AIL Copilot CDW Proposal" temporary; var Intent2: Enum "AIL Intent")
    begin
        TmpCDWAIProposal2.Copy(TmpCDWAIProposal, true);
        Intent2 := Intent;
    end;

    local procedure GenerateCDWProposal()
    var
        SalesHeader: Record "Sales Header";
        Customer: Record Customer;
        TmpXmlBuffer: Record "XML Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
        OutStr: OutStream;
        CurrInd, LineNo : Integer;
        DateVar: Date;
        TmpText: Text;
    begin
        TempBlob.CreateOutStream(OutStr);
        TmpText := Chat(UserPrompt);
        OutStr.WriteText(TmpText);
        TempBlob.CreateInStream(InStr);

        /*TmpXmlBuffer.DeleteAll();
        TmpXmlBuffer.LoadFromStream(InStr);*/

        Clear(OutStr);
        Intent := Intent::CDWPrepare;

        case TableID of
            Database::"Sales Header":
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", DocumentType);
                    //TODO filter from AI
                    if SalesHeader.FindSet() then
                        repeat
                            TmpCDWAIProposal.Init();
                            TmpCDWAIProposal."Table ID" := TableID;
                            TmpCDWAIProposal."System ID" := SalesHeader.SystemId;
                            TmpCDWAIProposal.Code := SalesHeader."No.";
                            TmpCDWAIProposal.Description := SalesHeader."Sell-to Customer Name";
                            TmpCDWAIProposal.Insert();
                        until SalesHeader.Next() = 0;
                end;
            Database::Customer:
                begin
                    Customer.Reset();
                    //TODO filter from AI
                    if Customer.FindSet() then
                        repeat
                            TmpCDWAIProposal.Init();
                            TmpCDWAIProposal."Table ID" := TableID;
                            TmpCDWAIProposal."System ID" := Customer.SystemId;
                            TmpCDWAIProposal.Code := Customer."No.";
                            TmpCDWAIProposal.Description := Customer.Name;
                            TmpCDWAIProposal.Insert();
                        until Customer.Next() = 0;
                end;
        end;
    end;

    procedure Chat(ChatUserPrompt: Text): Text
    var
        AzureOpenAI: Codeunit "Azure OpenAI";
        EnvironmentInformation: Codeunit "Environment Information";
        AOAIOperationResponse: Codeunit "AOAI Operation Response";
        AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params";
        AOAIChatMessages: Codeunit "AOAI Chat Messages";
        //IsolatCDWtorageWrapper: Codeunit "Isolated Storage Wrapper";
        Result: Text;
        EntityTextModuleInfo: ModuleInfo;
    begin
        // These funtions in the "Azure Open AI" codeunit will be available in Business Central online later this year.
        // You will need to use your own key for Azure OpenAI for all your Copilot features (for both development and production).
        /*AzureOpenAI.SetAuthorization(Enum::"AOAI Model Type"::"Chat Completions", IsolatCDWtorageWrapper.GetEndpoint(), IsolatCDWtorageWrapper.GetDeployment(), IsolatCDWtorageWrapper.GetSecretKey());

        AzureOpenAI.SetCopilotCapability(Enum::"Copilot Capability"::"Find Item Substitutions");

        AOAIChatCompletionParams.SetMaxTokens(2500);
        AOAIChatCompletionParams.SetTemperature(0);

        AOAIChatMessages.AddSystemMessage(ChatSystemPrompt);
        AOAIChatMessages.AddUserMessage(ChatUserPrompt);

        AzureOpenAI.GenerateChatCompletion(AOAIChatMessages, AOAIChatCompletionParams, AOAIOperationResponse);

        if AOAIOperationResponse.IsSuccess() then
            Result := AOAIChatMessages.GetLastMessage()
        else
            Error(AOAIOperationResponse.GetError());

        Result := Result.Replace('&', '&amp;');
        Result := Result.Replace('"', '');
        Result := Result.Replace('''', '');*/

        exit(Result);
    end;

    var
        TmpCDWAIProposal: Record "AIL Copilot CDW Proposal" temporary;
        TableID: Integer;
        DocumentType: Integer;
        UserPrompt: Text;
        Intent: Enum "AIL Intent";
}