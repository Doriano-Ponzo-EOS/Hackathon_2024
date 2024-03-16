
table 66150 "AIL Copilot CDW Proposal"
{
    TableType = Temporary;

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            Editable = false;
        }
        field(2; "System ID"; Guid)
        {
            Caption = 'System ID';
            Editable = false;
        }
        field(5; "Code"; Code[20])
        {
            Caption = 'Code';
            Editable = false;
        }
        field(6; "Description"; Text[100])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(22; Select; Boolean)
        {
            Caption = 'Select';
        }
    }

    keys
    {
        key(Key1; "Table ID", "System ID")
        {
            Clustered = true;
        }
    }
}