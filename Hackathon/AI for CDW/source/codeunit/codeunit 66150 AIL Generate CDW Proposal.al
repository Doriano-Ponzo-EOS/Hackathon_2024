codeunit 66150 "AIL Generate CDW Proposal"
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

    procedure GetResult(var TmpCDWAIProposal2: Record "AIL Copilot CDW Proposal" temporary; var Intent2: Enum "AIL Intent")
    begin
        TmpCDWAIProposal2.Copy(TmpCDWAIProposal, true);
        Intent2 := Intent;
    end;

    local procedure GenerateCDWProposal()
    var
        SalesHeader: Record "Sales Header";
        Customer: Record Customer;
        AILEntities: Record "AIL Entities";
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
        Chat(UserPrompt, AILEntities);
        OutStr.WriteText(TmpText);
        TempBlob.CreateInStream(InStr);

        // filter from AI entities
        AILEntities.Reset();
        AILEntities.SetRange(Entity, 'cdw_type');
        if not AILEntities.FindSet() then
            error(newLabel);

        case AILEntities.Entity of
            'cdw_type':
                begin
                    Document := CdwDocument::"Sales Shipment Line";
                    Document.GetDocumentLines(Filters, TempDocumentLine);
                    RegroupDocumentLines(TempDocumentLine);
                    TempDocumentLine.SetCurrentKey("Source Document Type", "Source Document No.", "Source Document Line No.");

                    AILEntities.SetRange(Entity, 'cdw_reason');
                    AILEntities.FindFirst();
                    ReasonCode := AILEntities.Text;

                    AILEntities.SetRange(Entity, 'filter_source');
                    AILEntities.FindFirst();

                    TempDocumentLine2.Copy(TempDocumentLine, true);

                    TempDocumentLine.SetRange("Source Document Line No.", 0);
                    TempDocumentLine.SetRange("Sell-To/Buy-From Name", AILEntities.Text);
                    if TempDocumentLine.FindSet() then begin

                        repeat

                            TempDocumentLine2.SetFilter("Source Document Line No.", '<>0');
                            TempDocumentLine2.SetRange("Document No.", TempDocumentLine."Document No.");
                            TempDocumentLine2.Findset();
                            repeat

                                TmpCDWAIProposal.Init();
                                TmpCDWAIProposal."Table ID" := TableID;
                                TmpCDWAIProposal."System ID" := TempDocumentLine2.SystemId;
                                TmpCDWAIProposal."Document No." := TempDocumentLine2."Document No.";
                                TmpCDWAIProposal."Posting Date" := TempDocumentLine2."Posting Date";
                                TmpCDWAIProposal."Document Date" := TempDocumentLine2."Document Date";
                                TmpCDWAIProposal."No." := TempDocumentLine2."External Document No.";
                                TmpCDWAIProposal.Description := TempDocumentLine2.Description;
                                TmpCDWAIProposal.Quantity := TempDocumentLine2.Quantity;
                                TmpCDWAIProposal."Reason Code" := ReasonCode;
                                TmpCDWAIProposal.Insert();

                            until TempDocumentLine2.Next() = 0;
                        until TempDocumentLine.Next() = 0;
                    end;


                end;


        end;
    end;

    procedure Chat(ChatUserPrompt: Text; var AILEntities: Record "AIL Entities")
    var
        AILLibrarySetup: Record "AIL Library Setup";
        AILSendRequest: Codeunit "AIL SendRequest";
        Result: Text;
    begin
        AILLibrarySetup.Get();
        AILLibrarySetup.TestField("AIL CDW Project Name");

        AILEntities.Reset();
        AILEntities.DeleteAll();

        AILSendRequest.SendLSRequest(ChatUserPrompt, Intent, AILEntities);
    end;

    var
        TmpCDWAIProposal: Record "AIL Copilot CDW Proposal" temporary;
        TableID: Integer;
        DocumentType: Integer;
        UserPrompt: Text;
        Intent: Enum "AIL Intent";


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
                    TempDocumentLine.Insert();
                end;

                TempDocumentLine2 := TempDocumentLine;
                TempDocumentLine.Insert();

            until TempDocumentLine.Next() = 0;
        TempDocumentLine.Copy(TempDocumentLine2, true);
        TempDocumentLine.Reset();
    end;

}