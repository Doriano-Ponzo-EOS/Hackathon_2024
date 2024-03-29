codeunit 66001 "EAI Functions"
{
    trigger OnRun()
    begin

    end;

    procedure ConvertDurationISO8106(Duration: Text): Text
    begin
        //Letters to handle Y - M - W - D

        //remove the firt letter P
        Duration := DelChr(Duration, '=', 'P');

        //Y
        if StrPos(Duration, 'Y') <> 0 then
            Duration := CopyStr(Duration, 1, StrPos(Duration, 'Y')) + '+' + CopyStr(Duration, StrPos(Duration, 'Y') + 1, StrLen(Duration));

        //M
        if StrPos(Duration, 'M') <> 0 then
            Duration := CopyStr(Duration, 1, StrPos(Duration, 'M')) + '+' + CopyStr(Duration, StrPos(Duration, 'M') + 1, StrLen(Duration));

        //W
        if StrPos(Duration, 'W') <> 0 then
            Duration := CopyStr(Duration, 1, StrPos(Duration, 'W')) + '+' + CopyStr(Duration, StrPos(Duration, 'W') + 1, StrLen(Duration));

        exit(Duration);
    end;

    var
        myInt: Integer;
}
