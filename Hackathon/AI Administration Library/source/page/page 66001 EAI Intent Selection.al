page 66001 "EAI Intent Selection"
{
    PageType = List;
    SourceTable = "EAI Intent Selection Temporary";
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
        Intent: Enum "EAI Intent";
    begin
        BuildPage();
    end;

    local procedure BuildPage()
    var
        Intent: Enum "EAI Intent";
        CurrOrdinal: Integer;
        Index: Integer;
    begin
        foreach CurrOrdinal in Enum::"EAI Intent".Ordinals() do begin
            Intent := Enum::"EAI Intent".FromInteger(CurrOrdinal);
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
        Intent: Enum "EAI Intent";
    begin
        exit(Rec."Intent ID");
    end;
}