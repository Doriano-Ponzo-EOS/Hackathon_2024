page 66151 "AIL Copilot CDW Proposal Sub"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "AIL Copilot CDW Proposal";
    Caption = 'CDW Proposal';

    layout
    {
        area(Content)
        {
            repeater(CDWDetails)
            {
                Caption = ' ';
                ShowCaption = false;

                field(Select; Rec.Select)
                {
                    ApplicationArea = All;
                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }


    procedure Load(var TmpCDWAIProposal: Record "AIL Copilot CDW Proposal"; Intent2: Enum "AIL Intent")
    begin
        Rec.Reset();
        Rec.DeleteAll();

        TmpCDWAIProposal.Reset();
        if TmpCDWAIProposal.FindSet() then
            repeat
                Rec.Copy(TmpCDWAIProposal, false);
                Rec.Insert();
            until TmpCDWAIProposal.Next() = 0;

        Intent := Intent2;

        CurrPage.Update(false);
    end;

    procedure ProposeCDWJournal()
    var
        CDWAIProposal2: Record "AIL Copilot CDW Proposal";
        RecRef: RecordRef;
    begin
        CDWAIProposal2.Copy(Rec, true);
        CDWAIProposal2.SetRange(Select, true);

        if CDWAIProposal2.FindSet() then
            repeat
            // Scrivi CDW journal
            until CDWAIProposal2.Next() = 0;
    end;

    var
        Intent: Enum "AIL Intent";
}