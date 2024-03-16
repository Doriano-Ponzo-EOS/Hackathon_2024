page 66002 "AIL Utterance Worksheet"
{
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "AIL Utterance Worksheet";
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
                    AILIntentSelection: Page "AIL Intent Selection";
                begin
                    AILIntentSelection.LookupMode(true);
                    if AILIntentSelection.RunModal() = Action::LookupOK then
                        SessionIntent := Enum::"AIL Intent".FromInteger(AILIntentSelection.GetIntent())
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
        SessionIntent: Enum "AIL Intent";

    procedure SetIntent(IntentParameter: Enum "AIL Intent")
    begin
        SessionIntent := IntentParameter;
    end;
}