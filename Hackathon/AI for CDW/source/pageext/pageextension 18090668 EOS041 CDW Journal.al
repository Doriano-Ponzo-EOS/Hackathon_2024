pageextension 66150 "AIL PageExt66101" extends "EOS041 CDW Journal" //18090668
{
    actions
    {
        addLast(Processing)
        {
            action(AILSuggestCDWwithCopilot)
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
            actionref(AILSuggestCDWwithCopilot_Promoted; AILSuggestCDWwithCopilot)
            {
            }
        }
    }


    local procedure SuggestEDSChangesWithAI();
    var
        CopilotEDSProposal: Page "AIL Copilot CDW Proposal";
        AzureOpenAI: Codeunit "Azure OpenAI";
    begin
        CopilotEDSProposal.SetSource(Rec);
        CopilotEDSProposal.RunModal();
        CurrPage.Update(false);
    end;
}