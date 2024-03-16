pageextension 66151 "AIL PagExt66151" extends "AIL Library Setup"   //66000
{
    layout
    {
        addafter(General)
        {
            group(CDW)
            {
                field("AIL CDW LS Model"; Rec."AIL CDW Project Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}