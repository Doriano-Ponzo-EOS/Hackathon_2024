pageextension 66100 "AIL PageExt66100" extends "Sales Order List" //9305
{
    actions
    {
        addLast("F&unctions")
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
        CopilotEDSProposal.SetEDSKey(Database::"Sales Header", Rec."Document Type".AsInteger());
        CopilotEDSProposal.RunModal();
        CurrPage.Update(false);
    end;
}