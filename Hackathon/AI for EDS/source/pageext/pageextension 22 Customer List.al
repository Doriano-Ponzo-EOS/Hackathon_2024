pageextension 66101 "EAI PageExt66101" extends "Customer List" //22
{
    actions
    {
        addLast("&Customer")
        {
            action(EAISuggestEDSwithCopilot)
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
            actionref(EAISuggestEDSwithCopilot_Promoted; EAISuggestEDSwithCopilot)
            {
            }
        }
    }


    local procedure SuggestEDSChangesWithAI();
    var
        CopilotEDSProposal: Page "EAI Copilot EDS Proposal";
        AzureOpenAI: Codeunit "Azure OpenAI";
    begin
        CopilotEDSProposal.SetEDSKey(Database::"Customer");
        CopilotEDSProposal.RunModal();
        CurrPage.Update(false);
    end;
}