page 66000 "AIL Library Setup"
{
    Caption = 'AI Library Setup (AIL)';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "AIL Library Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("AIL Endpoint"; Rec."AIL Endpoint")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the AIL Endpoint field.';
                }
                field(Subscription; Rec.SubscriptionKey)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Subscription field.';
                }
                field("API Version"; Rec."API Version")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the API Version field.';
                }
                field("Project Name"; Rec."Project Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Project Name field.';
                }
                field("Deployment Name"; Rec."Deployment Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deployment Name field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}