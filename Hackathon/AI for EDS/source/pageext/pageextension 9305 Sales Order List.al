pageextension 66100 "EAI PageExt66100" extends "Sales Order List" //9305
{
    actions
    {
        addLast("F&unctions")
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
        CopilotEDSProposal.SetEDSKey(Database::"Sales Header", Rec."Document Type".AsInteger());
        CopilotEDSProposal.RunModal();
        CurrPage.Update(false);
    end;
}