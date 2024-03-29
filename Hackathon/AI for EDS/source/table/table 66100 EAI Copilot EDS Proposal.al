
table 66100 "EAI Copilot EDS Proposal"
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
        field(10; "EDS Status"; Code[10])
        {
            Caption = 'EDS Status';
            Editable = false;
        }
        field(11; "New EDS Status"; Code[10])
        {
            Caption = 'New EDS Status';
            Editable = false;
        }
        field(15; "Date"; Date)
        {
            Caption = 'Date';
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