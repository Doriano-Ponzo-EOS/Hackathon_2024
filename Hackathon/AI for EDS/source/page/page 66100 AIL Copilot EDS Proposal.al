page 66100 "AIL Copilot EDS Proposal"
{
    PageType = PromptDialog;
    Extensible = false;
    IsPreview = true;
    Caption = 'Suggest EDS with Copilot';

    // PromptMode = Content;
    // With PromptMode you can choose if the PromptDialog will open in:
    // - Prompt mode (ask the user for input)
    // - Generate mode (it will call the Generate system action the moment the page opens)
    // - Content mode ()
    // You can also programmaticaly set this property by setting the variable CurrPage.PromptMode before the page is opened.

    // SourceTable = ;
    // SourceTableTemporary = true;
    // You can have a source table for a PromptDialog page, as long as the source table is temporary. This is optional, though. 
    // The meaning of this source table is slightly different than for the other page types. In a PromptDialog page, the source table should represent an
    // instance of a copilot suggestion, that can include both the user inputs and the Copilot results. You should insert a new record each time the user
    // tries to regenerate a suggestion (before the page is closed and the suggestion saved). This way, the Business Central web client will show a new
    // history control, that allows the user to go back and forth between the different suggestions that Copilot provided, and choose the best one to save.

    layout
    {
        // In PromptDialog pages, you can define a PromptOptions area. Here you can add different settings to tweak the output that Copilot will generate.
        // These settings must be defined as page fields, and must be of type Option or Enum. You cannot define groups in this area.

        // The Prompt area is where the user can provide input for your Copilot feature. The PromptOptions area should contain fields that have a limited set of options,
        // whereas the Prompt area can contain more structured and powerful controls, such as free text controls and subparts with grids.
        area(Prompt)
        {
            field(Title; Title)
            {
                Editable = false;
                ShowCaption = false;
            }
            field(ChatRequest; ChatRequest)
            {
                ShowCaption = false;
                MultiLine = true;
                ApplicationArea = All;
                //InstructionalText = 'Provide a description of the item you want to find substitutions for.';

                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
        }

        // The Content area is the output of the Copilot feature. This can contain fields or parts, so that you can have all the flexibility you need to
        // show the user the suggestion that your Copilot feature generated.
        area(Content)
        {
            part(SubsProposalSub; "AIL Copilot EDS Proposal Sub")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        area(SystemActions)
        {
            // You can have custom behaviour for the main system actions in a PromptDialog page, such as generating a suggestion with copilot, regenerate, or discard the
            // suggestion. When you develop a Copilot feature, remember: the user should always be in control (the user must confirm anything Copilot suggests before any
            // change is saved).
            // This is also the reason why you cannot have a physical SourceTable in a PromptDialog page (you either use a temporary table, or no table).
            systemaction(Generate)
            {
                Caption = 'Generate';
                ToolTip = 'Generate EDS proposal with Dynamics 365 Copilot.';

                trigger OnAction()
                begin
                    RunGeneration();
                end;
            }
            systemaction(OK)
            {
                Caption = 'Confirm';
                Enabled = Intent = Intent::"EDSChange";
            }
            systemaction(Cancel)
            {
                Caption = 'Discard';
            }
            systemaction(Regenerate)
            {
                Caption = 'Regenerate';
                ToolTip = 'Regenerate EDS proposal with Dynamics 365 Copilot.';
                trigger OnAction()
                begin
                    RunGeneration();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        CurrPage.Caption := Text001Lbl;
        Title := Text002Lbl;
        ChatRequest := 'Mostra gli ordini aperti del mese scorso';
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = CloseAction::OK then begin
            CurrPage.SubsProposalSub.Page.ChangeEDSStatus();
        end;
    end;

    local procedure RunGeneration()
    var
        InStr: InStream;
        Attempts: Integer;
    begin
        if ChatRequest <> '' then
            CurrPage.Caption := Text001Lbl + ' - ' + ChatRequest;
        GenEDSProposal.SetUserPrompt(ChatRequest);
        GenEDSProposal.SetEDSKey(TableID, DocumentType);

        TmpEDSAIProposal.Reset();
        TmpEDSAIProposal.DeleteAll();

        Attempts := 0;
        while TmpEDSAIProposal.IsEmpty and (Attempts < 5) do begin
            if GenEDSProposal.Run() then
                GenEDSProposal.GetResult(TmpEDSAIProposal, Intent);
            Attempts += 1;
        end;

        if (Attempts < 5) then begin
            Load(TmpEDSAIProposal);
        end else
            Error(Text003Err + GetLastErrorText());
    end;

    procedure SetEDSKey(TableID2: Integer)
    begin
        SetEDSKey(TableID2, 0);
    end;

    procedure SetEDSKey(TableID2: Integer; DocumentType2: Integer)
    begin
        TableID := TableID2;
        DocumentType := DocumentType2;
    end;

    procedure Load(var TmpEDSProposal: Record "AIL Copilot EDS Proposal" temporary)
    begin
        CurrPage.SubsProposalSub.Page.Load(TmpEDSProposal, Intent);
        CurrPage.Update(false);
    end;

    var
        TableID: Integer;
        DocumentType: Integer;
        Intent: Enum "AIL Intent";
        TmpEDSAIProposal: Record "AIL Copilot EDS Proposal" temporary;
        GenEDSProposal: Codeunit "AIL Generate EDS Proposal";
        Text001Lbl: Label 'Suggest EDS changes with Copilot';
        Text002Lbl: Label 'Request table to inspect or propose change status. Example: Close all open sales orders not modified since 3 days';
        Text003Err: Label 'Something went wrong. Please try again. ';
        ChatRequest: Text;
        Title: Text;
}