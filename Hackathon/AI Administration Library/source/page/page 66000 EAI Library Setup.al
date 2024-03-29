page 66000 "EAI Library Setup"
{
    Caption = 'AI Library Setup (EAI)';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "EAI Library Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("EAI Endpoint"; Rec."EAI Endpoint")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EAI Endpoint field.';
                }
                field(Subscription; Rec.SubscriptionKey)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Subscription field.';
                    ExtendedDatatype = Masked;
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
                    EAIAPICall: Codeunit "EAI SendRequest";
                    TopIntent: Enum "EAI Intent";
                    TempEAIEntities: Record "EAI Entities";
                begin
                    EAIAPICall.SendLSRequest('Porta in stato chiuso ordine 15000', TopIntent, TempEAIEntities, Rec."Project Name");
                    Message('%1');
                    TempEAIEntities.FindSet();
                    repeat
                        Message('%1 - %2', TempEAIEntities."Entity", TempEAIEntities.Text);
                    until TempEAIEntities.Next() = 0;
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