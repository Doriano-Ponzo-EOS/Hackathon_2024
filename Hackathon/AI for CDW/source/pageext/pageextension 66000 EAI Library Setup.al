pageextension 66151 "EAI PagExt66151" extends "EAI Library Setup"   //66000
{
    layout
    {
        addafter(General)
        {
            group(CDW)
            {
                field("EAI CDW LS Model"; Rec."EAI CDW Project Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}