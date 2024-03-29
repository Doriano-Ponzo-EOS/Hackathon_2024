table 66003 "EAI Entities"
{
    Caption = 'EAI Entities';
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
        field(10; "From Date"; Date)
        {
        }
        field(11; "To Date"; Date)
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