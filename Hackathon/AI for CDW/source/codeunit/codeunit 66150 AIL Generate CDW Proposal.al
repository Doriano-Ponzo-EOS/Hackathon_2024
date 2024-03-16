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
        AILEntities: Record "AIL Entities";
        TmpXmlBuffer: Record "XML Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
        OutStr: OutStream;
        CurrInd, LineNo : Integer;
        DateVar: Date;
        TmpText: Text;
    begin
        TempBlob.CreateOutStream(OutStr);
        Chat(UserPrompt, AILEntities);
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

    procedure Chat(ChatUserPrompt: Text; var AILEntities: Record "AIL Entities")
    var
        AILLibrarySetup: Record "AIL Library Setup";
        AILSendRequest: Codeunit "AIL SendRequest";
        Result: Text;
    begin
        AILLibrarySetup.Get();
        AILLibrarySetup.TestField("AIL CDW Project Name");

        AILEntities.Reset();
        AILEntities.DeleteAll();

        AILSendRequest.SendLSRequest(ChatUserPrompt, Intent, AILEntities, AILLibrarySetup."AIL CDW Project Name");
    end;

    var
        TmpCDWAIProposal: Record "AIL Copilot CDW Proposal" temporary;
        TableID: Integer;
        DocumentType: Integer;
        UserPrompt: Text;
        Intent: Enum "AIL Intent";
}