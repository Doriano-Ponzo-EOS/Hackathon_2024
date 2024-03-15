table 66000 "AIL Library Setup"
{
    Caption = 'AI Library Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "AIL Endpoint"; Text[250])
        {
            Caption = 'AIL Endpoint';
        }
        field(3; "SubscriptionKey"; Text[250])
        {
            Caption = 'Subscription Key';
        }
        field(4; "API Version"; Text[250])
        {
            Caption = 'API Version';
        }
        field(5; "Project Name"; Text[250])
        {
            Caption = 'Project Name';
        }
        field(6; "Deployment Name"; Text[250])
        {
            Caption = 'Deployment Name';
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
