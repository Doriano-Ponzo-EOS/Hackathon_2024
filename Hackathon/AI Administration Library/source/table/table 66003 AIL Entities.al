table 66003 "AIL Entities"
{
    Caption = 'AIL Entities';
    TableType = Temporary;

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