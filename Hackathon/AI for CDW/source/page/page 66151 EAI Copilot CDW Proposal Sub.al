page 66151 "EAI Copilot CDW Proposal Sub"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "EAI Copilot CDW Proposal";
    Caption = 'CDW Proposal';
    InsertAllowed = false;
    DeleteAllowed = false;

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
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Nr."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the Nr. field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ToolTip = 'Specifies the value of the Reason Code field.';
                }

            }
        }
    }


    procedure Load(var TmpCDWAIProposal: Record "EAI Copilot CDW Proposal"; Intent2: Enum "EAI Intent")
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
        CDWAIProposal2: Record "EAI Copilot CDW Proposal";
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
        Intent: Enum "EAI Intent";

    procedure ImportCDWLines()
    var
        EDSAIProposal2: Record "EAI Copilot CDW Proposal";
        EOS041DocumentHandling: Codeunit "EOS041 Document Handling";
        RecRef: RecordRef;
        NextLineNo: Integer;
        CdwDocument: Enum "EOS041 Document Type";
        Document: Interface "EOS041 IDocumentHandler v2";

        CdwJnlLine: Record "EOS041 CDW Journal Line";
    begin
        EDSAIProposal2.Copy(Rec, true);
        EDSAIProposal2.SetRange(Select, true);

        if EDSAIProposal2.FindSet() then
            repeat
                // Aggiorna stato
                Document := CdwDocument::"Sales Shipment Line";
                NextLineNo += 10000;
                CdwJnlLine.Init();
                CdwJnlLine.TransferFields(EDSAIProposal2);
                CdwJnlLine.Insert();

            until EDSAIProposal2.Next() = 0;
    end;
}