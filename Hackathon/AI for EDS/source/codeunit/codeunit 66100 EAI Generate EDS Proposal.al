codeunit 66100 "EAI Generate EDS Proposal"
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

    procedure GetResult(var TmpEDSAIProposal2: Record "EAI Copilot EDS Proposal" temporary; var Intent2: Enum "EAI Intent")
    begin
        TmpEDSAIProposal2.Copy(TmpEDSAIProposal, true);
        Intent2 := Intent;
    end;

    local procedure GenerateEDSProposal()
    var
        SalesHeader: Record "Sales Header";
        Customer: Record Customer;
        EAIEntities: Record "EAI Entities";
        FromEDSStatus: Code[10];
        ToEDSStatus: Code[10];
    begin
        Chat(UserPrompt, EAIEntities);

        Clear(FromEDSStatus);
        Clear(ToEDSStatus);

        case TableID of
            Database::"Sales Header":
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", DocumentType);

                    // filter from AI entities
                    EAIEntities.Reset();
                    if EAIEntities.FindSet() then
                        repeat
                            case EAIEntities.Entity of
                                'edsStatus':
                                    begin
                                        FromEDSStatus := EAIEntities.Text;
                                        case Intent of
                                            Intent::edsInspect,
                                            Intent::edsChange:
                                                SalesHeader.SetFilter("EOS DS Status Code", '%1&<>%2', FromEDSStatus, '');
                                        end;
                                    end;
                                'edsStatusTo':
                                    begin
                                        ToEDSStatus := EAIEntities.Text;
                                        case Intent of
                                            Intent::edsChange:
                                                SalesHeader.SetFilter("EOS DS Status Code", '<>%1&<>%2', '', ToEDSStatus);
                                        end;
                                    end;
                                'edsDate':
                                    begin
                                        SalesHeader.SetRange("Document Date", EAIEntities."From Date", EAIEntities."To Date");
                                    end;
                            end;
                        until EAIEntities.Next() = 0;

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

    procedure Chat(ChatUserPrompt: Text; var EAIEntities: Record "EAI Entities")
    var
        EAILibrarySetup: Record "EAI Library Setup";
        EAISendRequest: Codeunit "EAI SendRequest";
        Result: Text;
    begin
        EAILibrarySetup.Get();
        EAILibrarySetup.TestField("EAI EDS Project Name");

        EAIEntities.Reset();
        EAIEntities.DeleteAll();

        EAISendRequest.SendLSRequest(ChatUserPrompt, Intent, EAIEntities, EAILibrarySetup."EAI EDS Project Name");
    end;

    var
        TmpEDSAIProposal: Record "EAI Copilot EDS Proposal" temporary;
        TableID: Integer;
        DocumentType: Integer;
        UserPrompt: Text;
        Intent: Enum "EAI Intent";
}