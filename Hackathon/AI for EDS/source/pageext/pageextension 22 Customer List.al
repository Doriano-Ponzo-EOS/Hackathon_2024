pageextension 66101 "AIL PageExt66101" extends "Customer List" //22
{
    actions
    {
        addLast("&Customer")
        {
            action(AILSuggestEDSwithCopilot)
            {
                Caption = 'Suggest EDS with Copilot';
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
            actionref(AILSuggestEDSwithCopilot_Promoted; AILSuggestEDSwithCopilot)
            {
            }
        }
    }


    local procedure SuggestEDSChangesWithAI();
    var
        CopilotEDSProposal: Page "AIL Copilot EDS Proposal";
        AzureOpenAI: Codeunit "Azure OpenAI";
    begin
        CopilotEDSProposal.SetEDSKey(Database::"Customer");
        CopilotEDSProposal.RunModal();
        CurrPage.Update(false);
    end;
}