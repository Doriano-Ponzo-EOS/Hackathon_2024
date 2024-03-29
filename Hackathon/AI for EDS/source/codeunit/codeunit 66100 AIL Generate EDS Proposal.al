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
        AILEntities: Record "AIL Entities";
        FromEDSStatus: Code[10];
        ToEDSStatus: Code[10];
    begin
        Chat(UserPrompt, AILEntities);

        Clear(FromEDSStatus);
        Clear(ToEDSStatus);

        case TableID of
            Database::"Sales Header":
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", DocumentType);

                    // filter from AI entities
                    AILEntities.Reset();
                    if AILEntities.FindSet() then
                        repeat
                            case AILEntities.Entity of
                                'edsStatus':
                                    begin
                                        FromEDSStatus := AILEntities.Text;
                                        case Intent of
                                            Intent::edsInspect,
                                            Intent::edsChange:
                                                SalesHeader.SetFilter("EOS DS Status Code", '%1&<>%2', FromEDSStatus, '');
                                        end;
                                    end;
                                'edsStatusTo':
                                    begin
                                        ToEDSStatus := AILEntities.Text;
                                        case Intent of
                                            Intent::edsChange:
                                                SalesHeader.SetFilter("EOS DS Status Code", '<>%1&<>%2', '', ToEDSStatus);
                                        end;
                                    end;
                                'edsDate':
                                    begin
                                        SalesHeader.SetRange("Document Date", AILEntities."From Date", AILEntities."To Date");
                                    end;
                            end;
                        until AILEntities.Next() = 0;

                    if SalesHeader.FindSet() then
                        repeat
                            TmpEDSAIProposal.Init();
                            TmpEDSAIProposal."Table ID" := TableID;
                            TmpEDSAIProposal."System ID" := SalesHeader.SystemId;
                            TmpEDSAIProposal.Code := SalesHeader."No.";
                            TmpEDSAIProposal.Description := SalesHeader."Sell-to Customer Name";
                            TmpEDSAIProposal."EDS Status" := SalesHeader."EOS DS Status Code";
                            TmpEDSAIProposal."Date" := SalesHeader."Document Date";
                            TmpEDSAIProposal."New EDS Status" := ToEDSStatus;
                            TmpEDSAIProposal.Insert();
                        until SalesHeader.Next() = 0;
                end;
            Database::Customer:
                begin
                    Customer.Reset();
                    Customer.SetFilter("EOS DS Status Code", '<>%1', '');
                    // filter from AI entities
                    if Customer.FindSet() then
                        repeat
                            TmpEDSAIProposal.Init();
                            TmpEDSAIProposal."Table ID" := TableID;
                            TmpEDSAIProposal."System ID" := Customer.SystemId;
                            TmpEDSAIProposal.Code := Customer."No.";
                            TmpEDSAIProposal.Description := Customer.Name;
                            TmpEDSAIProposal."Date" := SalesHeader."Document Date";
                            TmpEDSAIProposal."EDS Status" := Customer."EOS DS Status Code";
                            TmpEDSAIProposal."New EDS Status" := ''; //TODO new status from AI
                            TmpEDSAIProposal.Insert();
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
        AILLibrarySetup.TestField("AIL EDS Project Name");

        AILEntities.Reset();
        AILEntities.DeleteAll();

        AILSendRequest.SendLSRequest(ChatUserPrompt, Intent, AILEntities, AILLibrarySetup."AIL EDS Project Name");
    end;

    var
        TmpEDSAIProposal: Record "AIL Copilot EDS Proposal" temporary;
        TableID: Integer;
        DocumentType: Integer;
        UserPrompt: Text;
        Intent: Enum "AIL Intent";
}