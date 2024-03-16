
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
        field(5; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
        }
        field(6; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            Editable = false;
        }
        field(7; "Document Date"; Date)
        {
            Caption = 'Document Date';
            Editable = false;
        }
        field(8; "No."; Code[20])
        {
            Caption = 'Source No.';
            Editable = false;
        }
        field(9; "Description"; Text[250])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(10; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            Editable = false;
        }
        field(11; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
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