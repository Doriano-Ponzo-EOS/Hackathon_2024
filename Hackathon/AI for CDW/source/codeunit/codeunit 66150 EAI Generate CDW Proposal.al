codeunit 66150 "EAI Generate CDW Proposal"
{
    trigger OnRun()
    begin
        GenerateCDWProposal();
    end;

    procedure SetUserPrompt(InputUserPrompt: Text)
    begin
        UserPrompt := InputUserPrompt;
    end;

    procedure SetCDWKey(TableID2: Integer)
    begin
        TableID := TableID2;
    end;

    procedure GetResult(var TmpCDWAIProposal2: Record "EAI Copilot CDW Proposal" temporary; var Intent2: Enum "EAI Intent")
    begin
        TmpCDWAIProposal2.Copy(TmpCDWAIProposal, true);
        Intent2 := Intent;
    end;

    local procedure GenerateCDWProposal()
    var
        SalesHeader: Record "Sales Header";
        Customer: Record Customer;
        EAIEntities: Record "EAI Entities";
        TmpXmlBuffer: Record "XML Buffer" temporary;
        TempDocumentLine: Record "EOS041 CDW Journal Line" temporary;
        TempDocumentLine2: Record "EOS041 CDW Journal Line" temporary;
        Filters: Record "EOS041 Document Filter";
        DocumentLinePage: Page "EOS041 Document Lines";
        TempBlob: Codeunit "Temp Blob";
        Document: Interface "EOS041 IDocumentHandler v2";
        CdwDocument: Enum "EOS041 Document Type";
        newLabel: Label 'No CDW type found in AI entities';
        InStr: InStream;
        OutStr: OutStream;
        CurrInd, LineNo : Integer;
        DateVar: Date;
        TmpText: Text;
        ReasonCode: Code[10];
    begin
        TempBlob.CreateOutStream(OutStr);
        Chat(UserPrompt, EAIEntities);
        OutStr.WriteText(TmpText);
        TempBlob.CreateInStream(InStr);

        // filter from AI entities
        EAIEntities.Reset();
        EAIEntities.SetRange(Entity, 'cdw_type');
        if not EAIEntities.FindSet() then
            error(newLabel);

        Intent := Intent::CDWPrepare;

        case EAIEntities.Text of
            'Shipment':
                begin
                    Document := CdwDocument::"Sales Shipment Line";
                    Document.GetDocumentLines(Filters, TempDocumentLine);

                    RegroupDocumentLines(TempDocumentLine);

                    TempDocumentLine.SetCurrentKey("Source Document Type", "Source Document No.", "Source Document Line No.");

                    EAIEntities.SetRange(Entity, 'cdw_reason');
                    EAIEntities.FindFirst();
                    ReasonCode := EAIEntities.Text;

                    EAIEntities.SetRange(Entity, 'filter_value');
                    EAIEntities.FindFirst();

                    TempDocumentLine2.Copy(TempDocumentLine, true);

                    TempDocumentLine.SetRange("Source Document Line No.", 0);
                    TempDocumentLine.SetRange("Sell-To/Buy-From Name", EAIEntities.Text);

                    if TempDocumentLine.FindSet() then begin

                        repeat

                            TempDocumentLine2.SetFilter("Source Document Line No.", '<>0');
                            TempDocumentLine2.SetRange("Document No.", TempDocumentLine."Document No.");
                            TempDocumentLine2.Findset();
                            repeat

                                TmpCDWAIProposal.Init();
                                TmpCDWAIProposal.TransferFields(TempDocumentLine2);
                                TmpCDWAIProposal."Journal Batch Name" := 'DEFAULT';
                                TmpCDWAIProposal."Reason Code" := ReasonCode;
                                TmpCDWAIProposal.Insert();

                            until TempDocumentLine2.Next() = 0;
                        until TempDocumentLine.Next() = 0;
                    end;
                end;
        end;
    end;

    procedure Chat(ChatUserPrompt: Text; var EAIEntities: Record "EAI Entities")
    var
        EAILibrarySetup: Record "EAI Library Setup";
        EAISendRequest: Codeunit "EAI SendRequest";
        Result: Text;
    begin
        EAILibrarySetup.Get();
        EAILibrarySetup.TestField("EAI CDW Project Name");

        EAIEntities.Reset();
        EAIEntities.DeleteAll();

        EAISendRequest.SendLSRequest(ChatUserPrompt, Intent, EAIEntities, EAILibrarySetup."EAI CDW Project Name");
    end;

    var
        TmpCDWAIProposal: Record "EAI Copilot CDW Proposal" temporary;
        TableID: Integer;
        DocumentType: Integer;
        UserPrompt: Text;
        Intent: Enum "EAI Intent";


    local procedure RegroupDocumentLines(var TempDocumentLine: Record "EOS041 CDW Journal Line" temporary)
    var
        GroupBuffer: Record "EOS041 CDW Journal Line";
        TempDocumentLine2: Record "EOS041 CDW Journal Line" temporary;
        NextLineNo: Integer;
    begin
        TempDocumentLine.Reset();
        if TempDocumentLine.FindLast() then;
        NextLineNo := TempDocumentLine."Line No.";

        TempDocumentLine.SetCurrentKey("Source Document Type", "Source Document Subtype", "Source Document No.");
        if TempDocumentLine.FindSet() then
            repeat
                if (TempDocumentLine."Source Document Type" <> GroupBuffer."Source Document Type") or
                   (TempDocumentLine."Source Document Subtype" <> GroupBuffer."Source Document Subtype") or
                   (TempDocumentLine."Source Document No." <> GroupBuffer."Source Document No.")
                then begin
                    GroupBuffer.Init();
                    GroupBuffer."Source Document Type" := TempDocumentLine."Source Document Type";
                    GroupBuffer."Source Document Subtype" := TempDocumentLine."Source Document Subtype";
                    GroupBuffer."Source Document No." := TempDocumentLine."Source Document No.";
                    GroupBuffer."Source Document Line No." := 0;
                    GroupBuffer."Document No." := TempDocumentLine."Document No.";
                    GroupBuffer."Posting Date" := TempDocumentLine."Posting Date";
                    GroupBuffer."Document Date" := TempDocumentLine."Document Date";
                    GroupBuffer."External Document No." := TempDocumentLine."External Document No.";
                    GroupBuffer."Sell-To/Buy-From No." := TempDocumentLine."Sell-To/Buy-From No.";
                    GroupBuffer."Sell-To/Buy-From Name" := TempDocumentLine."Sell-To/Buy-From Name";
                    GroupBuffer.Description := TempDocumentLine."Sell-To/Buy-From Name";
                    GroupBuffer."No." := TempDocumentLine."Sell-To/Buy-From No.";

                    TempDocumentLine2 := GroupBuffer;
                    NextLineNo += 1;
                    TempDocumentLine2."Line No." := NextLineNo;
                    TempDocumentLine2.Insert();
                end;

                TempDocumentLine2 := TempDocumentLine;
                TempDocumentLine2.Insert();

            until TempDocumentLine.Next() = 0;
        TempDocumentLine.Copy(TempDocumentLine2, true);
        TempDocumentLine.Reset();
    end;

}