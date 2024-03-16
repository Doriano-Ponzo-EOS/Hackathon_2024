pageextension 66102 "AIL PagExt66102" extends "AIL Library Setup"   //66000
{
    layout
    {
        addafter(General)
        {
            group(EDS)
            {
                field("AIL EDS LS Model"; Rec."AIL EDS Project Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}