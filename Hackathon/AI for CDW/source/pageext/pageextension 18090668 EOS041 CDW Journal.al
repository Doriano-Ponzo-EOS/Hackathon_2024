pageextension 66150 "EAI PageExt66101" extends "EOS041 CDW Journal" //18090668
{
    actions
    {
        addLast(Processing)
        {
            action(EAISuggestCDWwithCopilot)
            {
                Caption = 'Suggest with Copilot';
                Image = Sparkle;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    SuggestEDSChangesWithAI();
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref(EAISuggestCDWwithCopilot_Promoted; EAISuggestCDWwithCopilot)
            {
            }
        }
    }


    local procedure SuggestEDSChangesWithAI();
    var
        CopilotEDSProposal: Page "EAI Copilot CDW Proposal";
        AzureOpenAI: Codeunit "Azure OpenAI";
    begin
        CopilotEDSProposal.SetSource(Rec);
        CopilotEDSProposal.RunModal();
        CurrPage.Update(false);
    end;
}