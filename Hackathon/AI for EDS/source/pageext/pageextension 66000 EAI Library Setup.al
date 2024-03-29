pageextension 66102 "EAI PagExt66102" extends "EAI Library Setup"   //66000
{
    layout
    {
        addafter(General)
        {
            group(EDS)
            {
                field("EAI EDS LS Model"; Rec."EAI EDS Project Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}