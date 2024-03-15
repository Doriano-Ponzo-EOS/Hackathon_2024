codeunit 66100 "AIL Generate EDS Proposal"
{
    trigger OnRun()
    begin
        GenerateEDSProposal();
    end;

    procedure SetUserPrompt(InputUserPrompt: Text)
    begin
        UserPrompt := InputUserPrompt;
    end;

    procedure SetEDSKey(TableID2: Integer; DocumentType2: Integer)
    begin
        TableID := TableID2;
        DocumentType := DocumentType2;
    end;

    procedure GetResult(var TmpEDSAIProposal2: Record "AIL Copilot EDS Proposal" temporary; var Intent2: Enum "AIL Intent")
    begin
        TmpEDSAIProposal2.Copy(TmpEDSAIProposal, true);
        Intent2 := Intent;
    end;

    local procedure GenerateEDSProposal()
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
        Intent := Intent::EDS_Change;

        case TableID of
            Database::"Sales Header":
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", DocumentType);
                    SalesHeader.SetFilter("EOS DS Status Code", '<>%1', '');
                    //TODO filter from AI
                    if SalesHeader.FindSet() then
                        repeat
                            TmpEDSAIProposal.Init();
                            TmpEDSAIProposal."Table ID" := TableID;
                            TmpEDSAIProposal."System ID" := SalesHeader.SystemId;
                            TmpEDSAIProposal.Code := SalesHeader."No.";
                            TmpEDSAIProposal.Description := SalesHeader."Sell-to Customer Name";
                            TmpEDSAIProposal."EDS Status" := SalesHeader."EOS DS Status Code";
                            TmpEDSAIProposal."New EDS Status" := ''; //TODO new status from AI
                            TmpEDSAIProposal.Insert();
                        until SalesHeader.Next() = 0;
                end;
            Database::Customer:
                begin
                    Customer.Reset();
                    Customer.SetFilter("EOS DS Status Code", '<>%1', '');
                    //TODO filter from AI
                    if Customer.FindSet() then
                        repeat
                            TmpEDSAIProposal.Init();
                            TmpEDSAIProposal."Table ID" := TableID;
                            TmpEDSAIProposal."System ID" := Customer.SystemId;
                            TmpEDSAIProposal.Code := Customer."No.";
                            TmpEDSAIProposal.Description := Customer.Name;
                            TmpEDSAIProposal."EDS Status" := Customer."EOS DS Status Code";
                            TmpEDSAIProposal."New EDS Status" := ''; //TODO new status from AI
                            TmpEDSAIProposal.Insert();
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
        //IsolatedStorageWrapper: Codeunit "Isolated Storage Wrapper";
        Result: Text;
        EntityTextModuleInfo: ModuleInfo;
    begin
        // These funtions in the "Azure Open AI" codeunit will be available in Business Central online later this year.
        // You will need to use your own key for Azure OpenAI for all your Copilot features (for both development and production).
        /*AzureOpenAI.SetAuthorization(Enum::"AOAI Model Type"::"Chat Completions", IsolatedStorageWrapper.GetEndpoint(), IsolatedStorageWrapper.GetDeployment(), IsolatedStorageWrapper.GetSecretKey());

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
        TmpEDSAIProposal: Record "AIL Copilot EDS Proposal" temporary;
        TableID: Integer;
        DocumentType: Integer;
        UserPrompt: Text;
        Intent: Enum "AIL Intent";
}