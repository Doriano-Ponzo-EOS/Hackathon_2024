page 66101 "AIL Copilot EDS Proposal Sub"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "AIL Copilot EDS Proposal";
    Caption = 'EDS Proposals';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(EDSDetails)
            {
                Caption = ' ';
                ShowCaption = false;

                field(Select; Rec.Select)
                {
                    ApplicationArea = All;
                    Visible = Intent = Intent::"EDSChange";
                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("EDS Status"; Rec."EDS Status")
                {
                    ApplicationArea = All;
                }
                field("New EDS Status"; Rec."New EDS Status")
                {
                    ApplicationArea = All;
                    Visible = Intent = Intent::"EDSChange";
                }
            }
        }
    }


    procedure Load(var TmpEDSAIProposal: Record "AIL Copilot EDS Proposal"; Intent2: Enum "AIL Intent")
    begin
        Rec.Reset();
        Rec.DeleteAll();

        TmpEDSAIProposal.Reset();
        if TmpEDSAIProposal.FindSet() then
            repeat
                Rec.Copy(TmpEDSAIProposal, false);
                Rec.Insert();
            until TmpEDSAIProposal.Next() = 0;

        Intent := Intent2;

        CurrPage.Update(false);
    end;

    procedure ChangeEDSStatus()
    var
        EDSAIProposal2: Record "AIL Copilot EDS Proposal";
        DSMgt: Codeunit "EOS DS Management";
        RecRef: RecordRef;
    begin
        EDSAIProposal2.Copy(Rec, true);
        EDSAIProposal2.SetRange(Select, true);

        if EDSAIProposal2.FindSet() then
            repeat
                // Aggiorna stato
                RecRef.Open(EDSAIProposal2."Table ID");
                RecRef.GetBySystemId(EDSAIProposal2."System ID");
                DSMgt.ChangeDirectStatus(RecRef, EDSAIProposal2."EDS Status", EDSAIProposal2."New EDS Status", '');
            until EDSAIProposal2.Next() = 0;
    end;

    var
        Intent: Enum "AIL Intent";
}