page 66002 "EAI Utterance Worksheet"
{
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "EAI Utterance Worksheet";
    Caption = 'Utterance Worksheet';

    layout
    {
        area(Content)
        {
            field(SessionIntent; SessionIntent)
            {
                ApplicationArea = All;
                Caption = 'Intent';
                Editable = false;

                trigger OnAssistEdit()
                var
                    EAIIntentSelection: Page "EAI Intent Selection";
                begin
                    EAIIntentSelection.LookupMode(true);
                    if EAIIntentSelection.RunModal() = Action::LookupOK then
                        SessionIntent := Enum::"EAI Intent".FromInteger(EAIIntentSelection.GetIntent())
                end;
            }

            repeater(Control1)
            {
                field(Utterance; Rec.Utterance)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SuggestUtterance)
            {
                Image = Sparkle;
                ApplicationArea = All;
                Caption = 'Suggest with AI';
                trigger OnAction()
                begin
                    Message('TBD');
                end;
            }
            action(TrainUtterance)
            {
                ApplicationArea = All;
                Image = Setup;
                Caption = 'Train data';
                trigger OnAction()
                begin
                    sleep(5000);
                    Message('Train completato');
                end;
            }
        }
    }

    trigger OnInit()
    begin
        Rec.Intent := SessionIntent;
    end;

    var
        SessionIntent: Enum "EAI Intent";

    procedure SetIntent(IntentParameter: Enum "EAI Intent")
    begin
        SessionIntent := IntentParameter;
    end;
}