page 66001 "AIL Intent Selection"
{
    PageType = List;
    SourceTable = "AIL Intent Selection Temporary";
    SourceTableTemporary = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Intent Description"; Rec."Intent Description")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {

        }
    }


    trigger OnOpenPage()
    var
        Intent: Enum "AIL Intent";
    begin
        BuildPage();
    end;

    local procedure BuildPage()
    var
        Intent: Enum "AIL Intent";
        CurrOrdinal: Integer;
        Index: Integer;
    begin
        foreach CurrOrdinal in Enum::"AIL Intent".Ordinals() do begin
            Intent := Enum::"AIL Intent".FromInteger(CurrOrdinal);
            if Intent <> Intent::" " then begin
                Index := Intent.Ordinals.IndexOf(CurrOrdinal);
                Rec.Init();
                Rec."Intent ID" := CurrOrdinal;
                Rec."Intent Description" := Intent.Names.Get(Index);
                Rec.Insert();
            end;
        end;
    end;

    procedure GetIntent(): Integer
    var
        Intent: Enum "AIL Intent";
    begin
        exit(Rec."Intent ID");
    end;
}