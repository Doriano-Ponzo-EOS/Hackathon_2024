table 66001 "AIL Utterance Worksheet"
{
    DataClassification = CustomerContent;
    Caption = 'Utterance Worksheet';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; Intent; Enum "AIL Intent")
        {
            DataClassification = CustomerContent;
            Caption = 'Intent';
        }
        field(3; Utterance; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Utterance';
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