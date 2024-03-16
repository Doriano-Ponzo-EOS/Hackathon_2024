table 66003 "AIL Entities"
{
    Caption = 'AIL Entities';
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; Entity; Text[250])
        {
        }
        field(3; Text; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

}