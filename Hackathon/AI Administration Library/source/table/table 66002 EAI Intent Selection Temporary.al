table 66002 "EAI Intent Selection Temporary"
{
    DataClassification = CustomerContent;
    Caption = 'Intent Selection';
    TableType = Temporary;

    fields
    {
        field(1; "Intent ID"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Intent ID';
        }
        field(2; "Intent Description"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Intent Description';
        }
    }

    keys
    {
        key(Key1; "Intent ID")
        {
            Clustered = true;
        }
    }
}