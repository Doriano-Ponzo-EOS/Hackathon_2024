table 66001 "AIL Entities"
{
    Caption = 'AIL Entities';

    fields
    {
        field(1; Entity; Text[250])
        {

        }
        field(2; Text; Text[250])
        {

        }
    }

    keys
    {
        key(Key1; Entity)
        {
            Clustered = true;
        }
    }

}