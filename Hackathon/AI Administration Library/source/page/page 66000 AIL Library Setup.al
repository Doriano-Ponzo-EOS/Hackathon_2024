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
    actions
    {
        area(Processing)
        {
            action(TestCall)
            {
                ApplicationArea = All;
                Image = ChangeTo;
                ToolTip = 'Test API Call';

                trigger OnAction()
                var
                    AILAPICall: Codeunit "AIL SendRequest";
                    TopIntent: Enum "AIL Intent";
                    TempAILEntities: Record "AIL Entities";
                begin
                    AILAPICall.SendLSRequest('Porta in stato chiuso ordine 15000', TopIntent, TempAILEntities);
                    Message('%1');
                    TempAILEntities.FindSet();
                    repeat
                        Message('%1 - %2', TempAILEntities."Entity", TempAILEntities.Text);
                    until TempAILEntities.Next() = 0;
                end;
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