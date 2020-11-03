{**********************************************************************
    ● Copyright(c) 2020 Dmitriy Pomerantsev <pda2@yandex.ru>
    Alternative Delphi's System.TimeSpan implementation.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    https://gitlab.com/pda_fpc/times

    Ver 1.0.0
    * Initial release.

 **********************************************************************}
unit TimeSpan;

{$IFDEF FPC}
  {$IF DEFINED(VER1) OR DEFINED(VER2_0) OR DEFINED(VER2_2) OR DEFINED(VER2_4) OR DEFINED(VER2_6)}
    {$FATAL You need at least FPC 3.0.0 to build this unit}
  {$IFEND}
  {$CODEPAGE UTF8}
  {$MODE DELPHI}{$H+}
  {$MODESWITCH ADVANCEDRECORDS}
{$ELSE}
  {$IF CompilerVersion >= 24.0}
    {$LEGACYIFEND ON}
  {$IFEND}
  {$DEFINE HAS_INLINE}
{$ENDIF}

interface

uses
  SysUtils;

type
  { Type description taken from: http://docwiki.embarcadero.com/Libraries/Tokyo/en/System.TimeSpan.TTimeSpan }
  TTimeSpan = record
  private
    FTicks: Int64;
    class procedure Init; static;
  strict private
    function GetDays: Integer; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function GetHours: Integer;
    function GetMinutes: Integer; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function GetSeconds: Integer; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function GetMilliseconds: Integer; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function GetTotalDays: Double; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function GetTotalHours: Double; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function GetTotalMinutes: Double; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function GetTotalSeconds: Double; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function GetTotalMilliseconds: Double;
    class function GetScaledInterval(Value: Double; Scale: Integer): TTimeSpan; static;
    class function InternalParse(const S: string; out Value: Int64): Integer; static;
  strict private class var
    FMinValue: TTimeSpan{ = (FTicks: -9223372036854775808)};
    FMaxValue: TTimeSpan{ = (FTicks: $7FFFFFFFFFFFFFFF)};
    FZero: TTimeSpan;
  strict private const
    MillisecondsPerTick = 0.0001;
    SecondsPerTick = 1e-07;
    MinutesPerTick = 1.6666666666666667E-09;
    HoursPerTick = 2.7777777777777777E-11;
    DaysPerTick = 1.1574074074074074E-12;
    MillisPerSecond = 1000;
    MillisPerMinute = 60 * MillisPerSecond;
    MillisPerHour = 60 * MillisPerMinute;
    MillisPerDay = 24 * MillisPerHour;
    MaxSeconds = 922337203685;
    MinSeconds = -922337203685;
    MaxMilliseconds = 922337203685477;
    MinMilliseconds = -922337203685477;
  public const
    TicksPerMillisecond = 10000;
    TicksPerSecond = 1000 * Int64(TicksPerMillisecond);
    TicksPerMinute = 60 * Int64(TicksPerSecond);
    TicksPerHour = 60 * Int64(TicksPerMinute);
    TicksPerDay = 24 * TIcksPerHour;
  public
    constructor Create(ATicks: Int64); overload;
    constructor Create(Hours, Minutes, Seconds: Integer); overload;
    constructor Create(Days, Hours, Minutes, Seconds: Integer); overload;
    constructor Create(Days, Hours, Minutes, Seconds, Milliseconds: Integer); overload;
    function Add(const TS: TTimeSpan): TTimeSpan; overload;
    function Duration: TTimeSpan;
    function Negate: TTimeSpan;
    function Subtract(const TS: TTimeSpan): TTimeSpan; overload;
    function ToString: string;
    class function FromDays(Value: Double): TTimeSpan; static; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    class function FromHours(Value: Double): TTimeSpan; static; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    class function FromMinutes(Value: Double): TTimeSpan; static; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    class function FromSeconds(Value: Double): TTimeSpan; static; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    class function FromMilliseconds(Value: Double): TTimeSpan; static; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    class function FromTicks(Value: Int64): TTimeSpan; static; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    class function Subtract(const D1, D2: TDateTime): TTimeSpan; overload; static;
    class function Parse(const S: string): TTimeSpan; static;
    class function TryParse(const S: string; out Value: TTimeSpan): Boolean; static;
    class operator Add(const Left, Right: TTimeSpan): TTimeSpan;
    class operator Add(const Left: TTimeSpan; Right: TDateTime): TDateTime;
    class operator Add(const Left: TDateTime; Right: TTimeSpan): TDateTime;
    class operator Subtract(const Left, Right: TTimeSpan): TTimeSpan;
    class operator Subtract(const Left: TDateTime; Right: TTimeSpan): TDateTime;
    class operator Equal(const Left, Right: TTimeSpan): Boolean;
    class operator NotEqual(const Left, Right: TTimeSpan): Boolean;
    class operator GreaterThan(const Left, Right: TTimeSpan): Boolean;
    class operator GreaterThanOrEqual(const Left, Right: TTimeSpan): Boolean;
    class operator LessThan(const Left, Right: TTimeSpan): Boolean;
    class operator LessThanOrEqual(const Left, Right: TTimeSpan): Boolean;
    class operator Negative(const Value: TTimeSpan): TTimeSpan;
    class operator Positive(const Value: TTimeSpan): TTimeSpan;
    class operator Implicit(const Value: TTimeSpan): string;
    class operator Explicit(const Value: TTimeSpan): string;
    property Ticks: Int64 read FTicks;
    property Days: Integer read GetDays;
    property Hours: Integer read GetHours;
    property Minutes: Integer read GetMinutes;
    property Seconds: Integer read GetSeconds;
    property Milliseconds: Integer read GetMilliseconds;
    property TotalDays: Double read GetTotalDays;
    property TotalHours: Double read GetTotalHours;
    property TotalMinutes: Double read GetTotalMinutes;
    property TotalSeconds: Double read GetTotalSeconds;
    property TotalMilliseconds: Double read GetTotalMilliseconds;
    class property MinValue: TTimeSpan read FMinValue;
    class property MaxValue: TTimeSpan read FMaxValue;
    class property Zero: TTimeSpan read FZero;
  end;

{$IF NOT DEFINED(EArgumentException)}
  EArgumentException = class(Exception);
{$IFEND}
{$IF NOT DEFINED(EArgumentOutOfRangeException)}
  EArgumentOutOfRangeException = class(Exception);
{$IFEND}

implementation

uses
  Math, RTLConsts;

{$IF NOT DECLARED(sTimespanTooLong)}
const sTimespanTooLong = 'Timespan too long';
{$IFEND}
{$IF NOT DECLARED(sInvalidTimespanDuration)}
const sInvalidTimespanDuration = 'The duration cannot be returned because the absolute value exceeds the value of TTimeSpan.MaxValue';
{$IFEND}
{$IF NOT DECLARED(sTimespanValueCannotBeNan)}
const sTimespanValueCannotBeNan = 'Value cannot be NaN';
{$IFEND}
{$IF NOT DECLARED(sCannotNegateTimespan)}
const sCannotNegateTimespan = 'Negating the minimum value of a Timespan is invalid';
{$IFEND}
{$IF NOT DECLARED(sInvalidTimespanFormat)}
const sInvalidTimespanFormat = 'Invalid Timespan format';
{$IFEND}
{$IF NOT DECLARED(sTimespanElementTooLong)}
const sTimespanElementTooLong = 'Timespan element too long';
{$IFEND}

{ TTimeSpan }

function TTimeSpan.GetDays: Integer;
begin
  Result := Integer(FTicks div TicksPerDay);
end;

function TTimeSpan.GetHours: Integer;
begin
  Result := Integer((FTicks div TicksPerHour) mod 24);
end;

function TTimeSpan.GetMinutes: Integer;
begin
  Result := Integer((FTicks div TicksPerMinute) mod 60);
end;

function TTimeSpan.GetSeconds: Integer;
begin
  Result := Integer((FTicks div TicksPerSecond) mod 60);
end;

function TTimeSpan.GetMilliseconds: Integer;
begin
  Result := Integer((FTicks div TicksPerMillisecond) mod 1000);
end;

function TTimeSpan.GetTotalDays: Double;
begin
  Result := FTicks * DaysPerTick;
end;

function TTimeSpan.GetTotalHours: Double;
begin
  Result := FTicks * HoursPerTick;
end;

function TTimeSpan.GetTotalMinutes: Double;
begin
  Result := FTicks * MinutesPerTick;
end;

function TTimeSpan.GetTotalSeconds: Double;
begin
  Result := FTicks * SecondsPerTick;
end;

function TTimeSpan.GetTotalMilliseconds: Double;
begin
  Result := FTicks * MillisecondsPerTick;

  if Result > MaxMilliseconds then
    Result := MaxMilliseconds
  else if Result < MinMilliseconds then
    Result := MinMilliseconds;
end;

class function TTimeSpan.GetScaledInterval(Value: Double; Scale: Integer): TTimeSpan;
begin
  if IsInfinite(Value) then
    raise EArgumentException.Create(sTimespanTooLong);

  if IsNan(Value) then
    raise EArgumentException.Create(sTimespanValueCannotBeNan);

  if Value > 0 then
    Value := Value * Scale + 0.5
  else
    Value := Value * Scale - 0.5;

  if (Value <= MaxMilliseconds) and (Value >= MinMilliseconds) then
    Result := TTimeSpan.Create(Trunc(Value) * TicksPerMillisecond)
  else
    raise EArgumentOutOfRangeException.Create(sTimespanTooLong);
end;

class procedure TTimeSpan.Init;
begin
  FMinValue.FTicks := -9223372036854775808;
  FMaxValue.FTicks := $7FFFFFFFFFFFFFFF;
end;

constructor TTimeSpan.Create(ATicks: Int64);
begin
  FTicks := ATicks;
end;

constructor TTimeSpan.Create(Hours, Minutes, Seconds: Integer);
begin
  Create(0, Hours, Minutes, Seconds, 0);
end;

constructor TTimeSpan.Create(Days, Hours, Minutes, Seconds: Integer);
begin
  Create(Days, Hours, Minutes, Seconds, 0);
end;

constructor TTimeSpan.Create(Days, Hours, Minutes, Seconds, Milliseconds: Integer);
var
  Ms: Int64;
begin
  Ms := MillisPerDay * Int64(Days) +
        MillisPerHour * Int64(Hours) +
        MillisPerMinute * Int64(Minutes) +
        MillisPerSecond * Int64(Seconds) +
        Int64(Milliseconds);

  if (Ms >= MinMilliseconds) and (Ms <= MaxMilliseconds) then
    FTicks := TicksPerMillisecond * Ms
  else
    raise EArgumentOutOfRangeException.Create(sTimespanTooLong);
end;

function TTimeSpan.Add(const TS: TTimeSpan): TTimeSpan;
begin
  { Overflow/underflow checking }
  if ((TS.FTicks > 0) and (FTicks > High(FTicks) - TS.FTicks)) or
    ((TS.FTicks < 0) and (FTicks < Low(FTicks) - TS.FTicks)) then
    raise EArgumentOutOfRangeException.Create(sTimespanTooLong);

  Result := TTimeSpan.Create(FTicks + TS.FTicks);
end;

function TTimeSpan.Duration: TTimeSpan;
begin
  if FTicks > MinValue.FTicks then
    Result := TTimeSpan.Create(Abs(FTicks))
  else
    raise EIntOverflow.Create(sInvalidTimespanDuration);
end;

function TTimeSpan.Negate: TTimeSpan;
begin
  if FTicks > MinValue.FTicks then
    Result := TTimeSpan.Create(-FTicks)
  else
    raise EIntOverflow.Create(sCannotNegateTimespan);
end;

function TTimeSpan.Subtract(const TS: TTimeSpan): TTimeSpan;
begin
  { Overflow/underflow checking }
  if ((TS.FTicks > 0) and (FTicks < Low(FTicks) + TS.FTicks)) or
    ((TS.FTicks < 0) and (FTicks > High(FTicks) + TS.FTicks)) then
    raise EArgumentOutOfRangeException.Create(sTimespanTooLong);

  Result := TTimeSpan.Create(FTicks - TS.FTicks);
end;

function TTimeSpan.ToString: string;
var
  RestTicks: Int64;
  Template: string;
  Days, MSecs: Integer;
begin
  Template := '%0:d.%1:.2d:%2:.2d:%3:.2d.%4:.7d';

  Days := FTicks div TicksPerDay;
  RestTicks := Abs(FTicks mod TicksPerDay);
  MSecs := RestTicks mod TicksPerSecond;

  if Days = 0 then
    Delete(Template, 1, 5);

  if MSecs = 0 then
    Delete(Template, Length(Template) - 7, 7);

  Result := Format(Template, [Days, (RestTicks div TicksPerHour) mod 24,
    (RestTicks div TicksPerMinute) mod 60, (RestTicks div TicksPerSecond) mod 60,
    MSecs]);
end;

class function TTimeSpan.FromDays(Value: Double): TTimeSpan;
begin
  Result := GetScaledInterval(Value, MillisPerDay);
end;

class function TTimeSpan.FromHours(Value: Double): TTimeSpan;
begin
  Result := GetScaledInterval(Value, MillisPerHour);
end;

class function TTimeSpan.FromMinutes(Value: Double): TTimeSpan;
begin
  Result := GetScaledInterval(Value, MillisPerMinute);
end;

class function TTimeSpan.FromSeconds(Value: Double): TTimeSpan;
begin
  Result := GetScaledInterval(Value, MillisPerSecond);
end;

class function TTimeSpan.FromMilliseconds(Value: Double): TTimeSpan;
begin
  Result := GetScaledInterval(Value, 1);
end;

class function TTimeSpan.FromTicks(Value: Int64): TTimeSpan;
begin
  Result := TTimeSpan.Create(Value);
end;

class function TTimeSpan.Subtract(const D1, D2: TDateTime): TTimeSpan;
begin
  Result := TTimeSpan.Create(Trunc(TimeStampToMSecs(DateTimeToTimeStamp(D1)) -
    TimeStampToMSecs(DateTimeToTimeStamp(D2))) * TicksPerMillisecond);
end;

class function TTimeSpan.InternalParse(const S: string; out Value: Int64): Integer;
label
  NextStage, TimeStage;
type
  TParseStage = (PreSpaces, Sign, Days, Hour, Minutes, Seconds, FraqSeconds, PostSpaces);
const
  MSecScale: array [0..6] of Integer = (10, 100, 1000, 10000, 100000, 1000000, 10000000);
var
  i, DigitStart, DigitEnd: Integer;
  ParseStage, PrevStage: TParseStage;
  IsNegative, HasDays: Boolean;

  function HandleDigits: Integer;
  var
    ParsedDigit, DigitLen: Integer;
  begin
    DigitLen := DigitEnd - DigitStart + 1;
    if (DigitStart < 1) or (DigitLen < 0) then
    begin
      Result := 1; { invalid format }
      Exit;
    end
    else
      Result := 0; { parsing ok }

    if TryStrToInt(Copy(S, DigitStart, DigitLen), ParsedDigit) then
    begin
      DigitStart := -1;
      case ParseStage of
        Days:
          if ParsedDigit <= 10675199 then
          begin
            Value := ParsedDigit * TTimeSpan.TicksPerDay;
            HasDays := True;
          end
          else
            Result := 2; { timespan too long }
        Hour:
          if ParsedDigit <= 23 then
            Value := Value + ParsedDigit * TTimeSpan.TicksPerHour
          else
            Result := 3; { timespan element too big }
        Minutes:
          if ParsedDigit <= 59 then
            Value := Value + ParsedDigit * TTimeSpan.TicksPerMinute
          else
            Result := 3; { timespan element too big }
        Seconds:
          if ParsedDigit <= 59 then
            Value := Value + ParsedDigit * TTimeSpan.TicksPerSecond
          else
            Result := 3; { timespan element too big }
        FraqSeconds:
        begin
          if DigitLen <= 7 then
            Value := Value + (Int64(ParsedDigit) * TTimeSpan.TicksPerSecond) div MSecScale[DigitLen - 1]
          else
            Result := 1; { invalid format }
        end;
        else
          Result := 1; { invalid format }
      end;
    end
    else
      Result := 2; { timespan too long }
  end;
begin
  Result := 0; { parsing ok }
  IsNegative := False;
  HasDays := False;
  Value := 0;
  DigitStart := -1;
  DigitEnd := -1;
  PrevStage := PreSpaces;

  ParseStage := PreSpaces;
  for i := 1 to Length(S) do
  begin
    case S[i] of
      ' ':
      begin
        case ParseStage of
          PreSpaces, PostSpaces:
            ;
          else begin
            PrevStage := ParseStage;
            ParseStage := PostSpaces;
          end;
        end;
      end;
      '-':
      begin
        case ParseStage of
          PreSpaces:
          begin
            ParseStage := Sign;
            IsNegative := True;
          end
          else
            Result := 1; { invalid format }
        end;
      end;
      '0'..'9':
      begin
        case ParseStage of
          PreSpaces:
          begin
            Inc(ParseStage);
            goto NextStage;
          end;
          Sign, Days, Hour, Minutes, Seconds, FraqSeconds:
          begin
            NextStage:
            DigitEnd := i;
            if DigitStart < 0 then
            begin
              DigitStart := i;
              Inc(ParseStage);
            end;
          end;
          else
            Result := 1; { invalid format }
        end;
      end;
      '.':
      begin
        case ParseStage of
          Days, Seconds:
            Result := HandleDigits;
          else
            Result := 1; { invalid format }
        end;
      end;
      ':':
      begin
        case ParseStage of
          Days:
          begin
            Inc(ParseStage);
            goto TimeStage;
          end;
          Hour, Minutes:
          begin
            TimeStage:
            Result := HandleDigits;
          end;
          else
            Result := 1; { invalid format }
        end;
      end;
      else
        Result := 1; { invalid format }
    end;

    if Result > 0 then
      Exit;
  end;

  if HasDays and (ParseStage = Hour) then
    Result := 1 { invalid format }
  else begin
    if PrevStage <> PreSpaces then
      ParseStage := PrevStage;
    Result := HandleDigits;

    if IsNegative then
      Value := -Value;
  end;
end;

class function TTimeSpan.Parse(const S: string): TTimeSpan;
var
  Ticks: Int64;
begin
  case InternalParse(S, Ticks) of
    0:
      Result := TTimeSpan.Create(Ticks);
    1:
      raise Exception.Create(sInvalidTimespanFormat);
    2:
      raise EIntOverflow.Create(sTimespanTooLong);
    3:
      raise EIntOverflow.Create(sTimespanElementTooLong);
  end;
end;

class function TTimeSpan.TryParse(const S: string; out Value: TTimeSpan): Boolean;
var
  Ticks: Int64;
begin
  Result := InternalParse(S, Ticks) = 0;
  
  if Result then
    Value := TTimeSpan.Create(Ticks)
  else
    Value := TTimeSpan.Zero;
end;

class operator TTimeSpan.Add(const Left, Right: TTimeSpan): TTimeSpan;
begin
  Result := Left.Add(Right);
end;

class operator TTimeSpan.Add(const Left: TTimeSpan; Right: TDateTime): TDateTime;
begin
  Result := Right + Left;
end;

class operator TTimeSpan.Add(const Left: TDateTime; Right: TTimeSpan): TDateTime;
begin
  Result := TimeStampToDateTime(MSecsToTimeStamp(TimeStampToMSecs(DateTimeToTimeStamp(Left)) +
    Trunc(Right.TotalMilliseconds)));
end;

class operator TTimeSpan.Subtract(const Left, Right: TTimeSpan): TTimeSpan;
begin
  Result := Left.Subtract(Right);
end;

class operator TTimeSpan.Subtract(const Left: TDateTime; Right: TTimeSpan): TDateTime;
begin
  Result := TimeStampToDateTime(MSecsToTimeStamp(TimeStampToMSecs(DateTimeToTimeStamp(Left)) -
    Trunc(Right.TotalMilliseconds)));
end;

class operator TTimeSpan.Equal(const Left, Right: TTimeSpan): Boolean;
begin
  Result := Left.FTicks = Right.FTicks;
end;

class operator TTimeSpan.NotEqual(const Left, Right: TTimeSpan): Boolean;
begin
  Result := Left.FTicks <> Right.FTicks;
end;

class operator TTimeSpan.GreaterThan(const Left, Right: TTimeSpan): Boolean;
begin
  Result := Left.FTicks > Right.FTicks;
end;

class operator TTimeSpan.GreaterThanOrEqual(const Left, Right: TTimeSpan): Boolean;
begin
  Result := Left.FTicks >= Right.FTicks;
end;

class operator TTimeSpan.LessThan(const Left, Right: TTimeSpan): Boolean;
begin
  Result := Left.FTicks < Right.FTicks;
end;

class operator TTimeSpan.LessThanOrEqual(const Left, Right: TTimeSpan): Boolean;
begin
  Result := Left.FTicks <= Right.FTicks;
end;

class operator TTimeSpan.Negative(const Value: TTimeSpan): TTimeSpan;
begin
  Result := Value.Negate;
end;

class operator TTimeSpan.Positive(const Value: TTimeSpan): TTimeSpan;
begin
  Result := Value;
end;

class operator TTimeSpan.Implicit(const Value: TTimeSpan): string;
begin
  Result := Value.ToString;
end;

class operator TTimeSpan.Explicit(const Value: TTimeSpan): string;
begin
  Result := Value.ToString;
end;

initialization
  TTimeSpan.Init;

end.
