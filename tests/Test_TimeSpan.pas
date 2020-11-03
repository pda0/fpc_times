{**********************************************************************
    ● Copyright(c) 2020 Dmitriy Pomerantsev <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test_TimeSpan;

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
  {$IF CompilerVersion < 19.0}
    {$DEFINE OLD_DELPHI}
  {$IFEND}
{$ENDIF}
{$M+}

interface

uses
  {$IFDEF FPC}
  fpcunit, testregistry,
  {$ELSE}
  TestFramework, {$IFDEF OLD_DELPHI}TestCompat,{$ENDIF}
  {$ENDIF}
  Classes, SysUtils, TimeSpan;

type
  TTestTTimeSpan = class(TTestCase)
  strict private
    FTs: TTimeSpan;
    FStr: string;
  private
    procedure CreateBad1;
    procedure CreateBad2;
    procedure DoParse;
    procedure BadAdd1;
    procedure BadAdd2;
    procedure BadSubtract1;
    procedure BadSubtract2;
    procedure BadDuration;
    procedure BadOpAdd1;
    procedure BadOpAdd2;
    procedure BadOpSubtract1;
    procedure BadOpSubtract2;
  published
    procedure TestConsts;
    procedure TestMinValue;
    procedure TestMaxValue;
    procedure TestZero;
    procedure TestCreate;
    procedure TestFromDays;
    procedure TestFromHours;
    procedure TestFromMinutes;
    procedure TestFromSeconds;
    procedure TestFromMilliseconds;
    procedure TestFromTicks;
    procedure TestToString;
    procedure TestTryParse;
    procedure TestParse;
    procedure TestAdd;
    procedure TestSubtract;
    procedure TestClassSubtract;
    procedure TestNegate;
    procedure TestDuration;
    procedure TestProperties;
    procedure TestOpAdd;
    procedure TestOpSubtract;
    procedure TestOpEqual;
    procedure TestOpNotEqual;
    procedure TestOpGreaterThan;
    procedure TestOpGreaterThanOrEqual;
    procedure TestOpLessThan;
    procedure TestOpLessThanOrEqual;
    procedure TestOpNegative;
    procedure TestOpPositive;
    procedure TestOpImplicit;
    procedure TestOpExplicit;
  end;

implementation

uses
  DateUtils;

{ TTestTTimeSpan }

procedure TTestTTimeSpan.TestConsts;
begin
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(10000), TTimeSpan.TicksPerMillisecond);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(10000000), TTimeSpan.TicksPerSecond);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(600000000), TTimeSpan.TicksPerMinute);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(36000000000), TTimeSpan.TicksPerHour);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(864000000000), TTimeSpan.TicksPerDay);
end;

procedure TTestTTimeSpan.TestMinValue;
begin
  CheckTrue(TTimeSpan.Create(Int64(-9223372036854775808)) = TTimeSpan.MinValue);
end;

procedure TTestTTimeSpan.TestMaxValue;
begin
  CheckTrue(TTimeSpan.Create(Int64(9223372036854775807)) = TTimeSpan.MaxValue);
end;

procedure TTestTTimeSpan.TestZero;
begin
  CheckTrue(TTimeSpan.Create(0) = TTimeSpan.Zero);
end;

procedure TTestTTimeSpan.CreateBad1;
begin
  TTimeSpan.Create(10675199, 23, 59, 59, 999);
end;

procedure TTestTTimeSpan.CreateBad2;
begin
  TTimeSpan.Create(-10675199, -23, -59, -59, -999);
end;

procedure TTestTTimeSpan.TestCreate;
var
  ts: TTimeSpan;
begin
  ts := TTimeSpan.Create(Int64(1000));

  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(1000), ts.Ticks);

  ts := TTimeSpan.Create(2, 17, 21);

  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(82410000000), ts.Ticks);

  ts := TTimeSpan.Create(10, 11, 53, 47);

  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(9068270000000), ts.Ticks);

  ts := TTimeSpan.Create(10, 11, 53, 47, 2);

  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(9068270020000), ts.Ticks);

  ts := TTimeSpan.Create(10675198, 23, 59, 59, 999);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(9223371935999990000), ts.Ticks);

  ts := TTimeSpan.Create(-10675198, -23, -59, -59, -999);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(-9223371935999990000), ts.Ticks);

  CheckException(CreateBad1, EArgumentOutOfRangeException);
  CheckException(CreateBad2, EArgumentOutOfRangeException);
end;

procedure TTestTTimeSpan.TestFromDays;
var
  ts: TTimeSpan;
begin
  ts := TTimeSpan.FromDays(12);

  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(10368000000000), ts.Ticks);
end;

procedure TTestTTimeSpan.TestFromHours;
var
  ts: TTimeSpan;
begin
  ts := TTimeSpan.FromHours(23);

  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(828000000000), ts.Ticks);
end;

procedure TTestTTimeSpan.TestFromMinutes;
var
  ts: TTimeSpan;
begin
  ts := TTimeSpan.FromMinutes(10);

  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(6000000000), ts.Ticks);
end;

procedure TTestTTimeSpan.TestFromSeconds;
var
  ts: TTimeSpan;
begin
  ts := TTimeSpan.FromSeconds(600);

  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(6000000000), ts.Ticks);
end;

procedure TTestTTimeSpan.TestFromMilliseconds;
var
  ts: TTimeSpan;
begin
  ts := TTimeSpan.FromMilliseconds(600000);

  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(6000000000), ts.Ticks);
end;

procedure TTestTTimeSpan.TestFromTicks;
var
  ts: TTimeSpan;
begin
  ts := TTimeSpan.FromTicks(600000);

  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(600000), ts.Ticks);
end;

procedure TTestTTimeSpan.TestToString;
var
  ts: TTimeSpan;
begin
  ts := TTimeSpan.FromTicks(Int64(0));
  CheckEquals('00:00:00', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(6));
  CheckEquals('00:00:00.0000006', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(61));
  CheckEquals('00:00:00.0000061', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(612));
  CheckEquals('00:00:00.0000612', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(6123));
  CheckEquals('00:00:00.0006123', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(61234));
  CheckEquals('00:00:00.0061234', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(612345));
  CheckEquals('00:00:00.0612345', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(6123456));
  CheckEquals('00:00:00.6123456', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(61234567));
  CheckEquals('00:00:06.1234567', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(612345678));
  CheckEquals('00:01:01.2345678', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(6123456789));
  CheckEquals('00:10:12.3456789', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(61234567891));
  CheckEquals('01:42:03.4567891', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(612345678912));
  CheckEquals('17:00:34.5678912', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(6123456789123));
  CheckEquals('7.02:05:45.6789123', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(61234567891234));
  CheckEquals('70.20:57:36.7891234', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(612345678912345));
  CheckEquals('708.17:36:07.8912345', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(6123456789123456));
  CheckEquals('7087.08:01:18.9123456', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(61234567891234567));
  CheckEquals('70873.08:13:09.1234567', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(612345678912345678));
  CheckEquals('708733.10:11:31.2345678', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(6123456789123456789));
  CheckEquals('7087334.05:55:12.3456789', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(60000000));
  CheckEquals('00:00:06', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(6120000000));
  CheckEquals('00:10:12', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(612340000000));
  CheckEquals('17:00:34', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(6123450000000));
  CheckEquals('7.02:05:45', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(-5));
  CheckEquals('00:00:00.0000005', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(-51));
  CheckEquals('00:00:00.0000051', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(-512));
  CheckEquals('00:00:00.0000512', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(-5123));
  CheckEquals('00:00:00.0005123', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(-51234));
  CheckEquals('00:00:00.0051234', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(-512345));
  CheckEquals('00:00:00.0512345', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(-5123456));
  CheckEquals('00:00:00.5123456', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(-51234567));
  CheckEquals('00:00:05.1234567', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(-512345678));
  CheckEquals('00:00:51.2345678', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(-5123456789));
  CheckEquals('00:08:32.3456789', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(-51234567891));
  CheckEquals('01:25:23.4567891', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(-512345678912));
  CheckEquals('14:13:54.5678912', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(-5123456789123));
  CheckEquals('-5.22:19:05.6789123', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(-51234567891234));
  CheckEquals('-59.07:10:56.7891234', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(-512345678912345));
  CheckEquals('-592.23:49:27.8912345', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(-5123456789123456));
  CheckEquals('-5929.22:14:38.9123456', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(-51234567891234567));
  CheckEquals('-59299.06:26:29.1234567', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(-512345678912345678));
  CheckEquals('-592992.16:24:51.2345678', ts.ToString);

  ts := TTimeSpan.FromTicks(Int64(-5123456789123456789));
  CheckEquals('-5929926.20:08:32.3456789', ts.ToString);
end;

procedure TTestTTimeSpan.TestTryParse;
var
  ts: TTimeSpan;
begin
  CheckTrue(TTimeSpan.TryParse('00:00:00', ts));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(0), ts.Ticks);

  CheckTrue(TTimeSpan.TryParse('00:00:00.0000001', ts));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(1), ts.Ticks);

  CheckTrue(TTimeSpan.TryParse('00:00:00.000001', ts));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(10), ts.Ticks);

  CheckTrue(TTimeSpan.TryParse('00:00:00.0100000', ts));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(100000), ts.Ticks);

  CheckTrue(TTimeSpan.TryParse('01:02:03.0000000', ts));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(37230000000), ts.Ticks);

  CheckTrue(TTimeSpan.TryParse('01:02:03', ts));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(37230000000), ts.Ticks);

  CheckTrue(TTimeSpan.TryParse('01:02:03', ts));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(37230000000), ts.Ticks);

  CheckTrue(TTimeSpan.TryParse('7.01:02:03', ts));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(6085230000000), ts.Ticks);

  CheckTrue(TTimeSpan.TryParse('7.01:02:03.123', ts));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(6085231230000), ts.Ticks);

  CheckTrue(TTimeSpan.TryParse('-00:00:00', ts));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(0), ts.Ticks);

  CheckTrue(TTimeSpan.TryParse('-00:00:00.0000001', ts));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(-1), ts.Ticks);

  CheckTrue(TTimeSpan.TryParse('-00:00:00.000001', ts));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(-10), ts.Ticks);

  CheckTrue(TTimeSpan.TryParse('-00:00:00.0100000', ts));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(-100000), ts.Ticks);

  CheckTrue(TTimeSpan.TryParse('-01:02:03.0000000', ts));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(-37230000000), ts.Ticks);

  CheckTrue(TTimeSpan.TryParse('-01:02:03', ts));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(-37230000000), ts.Ticks);

  CheckTrue(TTimeSpan.TryParse('-01:02:03', ts));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(-37230000000), ts.Ticks);

  CheckTrue(TTimeSpan.TryParse('-7.01:02:03', ts));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(-6085230000000), ts.Ticks);

  CheckTrue(TTimeSpan.TryParse('-7.01:02:03.123', ts));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(-6085231230000), ts.Ticks);

  CheckTrue(TTimeSpan.TryParse('10', ts));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(8640000000000), ts.Ticks);

  CheckTrue(TTimeSpan.TryParse('-10', ts));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(-8640000000000), ts.Ticks);

  CheckTrue(TTimeSpan.TryParse('10:12', ts));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(367200000000), ts.Ticks);

  CheckFalse(TTimeSpan.TryParse('', ts));
  CheckFalse(TTimeSpan.TryParse('-', ts));
  CheckFalse(TTimeSpan.TryParse('10.12', ts));
  CheckFalse(TTimeSpan.TryParse('+00:00:00', ts));
  CheckFalse(TTimeSpan.TryParse('+7.01:02:03.123', ts));
  CheckFalse(TTimeSpan.TryParse('INF', ts));
  CheckFalse(TTimeSpan.TryParse('INVALID VALUE', ts));
  CheckFalse(TTimeSpan.TryParse('1967200000000', ts));
  CheckFalse(TTimeSpan.TryParse('00:00:60', ts));
  CheckFalse(TTimeSpan.TryParse('00:60:00', ts));
  CheckFalse(TTimeSpan.TryParse('24:00:00', ts));
  CheckFalse(TTimeSpan.TryParse('00:00:00.00000001', ts));
end;

procedure TTestTTimeSpan.DoParse;
begin
  FTs := TTimeSpan.Parse(FStr);
end;

procedure TTestTTimeSpan.TestParse;
begin
  FStr := '00:00:00';
  DoParse;
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(0), FTs.Ticks);

  FStr := '0:0:0';
  DoParse;
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(0), FTs.Ticks);

  FStr := '-10:00:00';
  DoParse;
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(-360000000000), FTs.Ticks);

  FStr := '12:17';
  DoParse;
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(442200000000), FTs.Ticks);

  FStr := '32';
  DoParse;
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(27648000000000), FTs.Ticks);

  FStr := '2.5:17';
  DoParse;
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(1918200000000), FTs.Ticks);

  FStr := '7.01:02:03.123';
  DoParse;
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(6085231230000), FTs.Ticks);

  FStr := ' 7.01:02:03.123  ';
  DoParse;
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(6085231230000), FTs.Ticks);

  FStr := '0:0:0.1';
  DoParse;
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(1000000), FTs.Ticks);

  FStr := '0:0:0.12';
  DoParse;
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(1200000), FTs.Ticks);

  FStr := '0:0:0.123';
  DoParse;
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(1230000), FTs.Ticks);

  FStr := '0:0:0.1234';
  DoParse;
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(1234000), FTs.Ticks);

  FStr := '0:0:0.12345';
  DoParse;
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(1234500), FTs.Ticks);

  FStr := '0:0:0.123456';
  DoParse;
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(1234560), FTs.Ticks);

  FStr := '0:0:0.1234567';
  DoParse;
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(1234567), FTs.Ticks);

  FStr := '0:0:0.0000001';
  DoParse;
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(1), FTs.Ticks);

  FStr := '0:0:0.12345678';
  CheckException(DoParse, Exception); { invalid format }
  FStr := '0:0:0.00000001';
  CheckException(DoParse, Exception); { invalid format }
  FStr := '00:00:00.00000001';
  CheckException(DoParse, Exception); { invalid format }
  FStr := '';
  CheckException(DoParse, Exception); { invalid format }
  FStr := '-';
  CheckException(DoParse, Exception); { invalid format }
  FStr := '10.12';
  CheckException(DoParse, Exception); { invalid format }
  FStr := '+00:00:00';
  CheckException(DoParse, Exception); { invalid format }
  FStr := '+7.01:02:03.123';
  CheckException(DoParse, Exception); { invalid format }
  FStr := '7.01: 02:03.123';
  CheckException(DoParse, Exception); { invalid format }
  FStr := 'INF';
  CheckException(DoParse, Exception); { invalid format }
  FStr := 'INVALID VALUE';
  CheckException(DoParse, Exception); { invalid format }
  FStr := '1967200000000';
  CheckException(DoParse, EIntOverflow); { overflow }
  FStr := '00:00:60';
  CheckException(DoParse, EIntOverflow); { invalid time }
  FStr := '00:60:00';
  CheckException(DoParse, EIntOverflow); { invalid time }
  FStr := '24:00:00';
  CheckException(DoParse, EIntOverflow); { invalid time }
end;

procedure TTestTTimeSpan.BadAdd1;
var
  ts: TTimeSpan;
begin
  ts := TTimeSpan.FromTicks(Int64(10));
  ts.Add(TTimeSpan.FromTicks(Int64(9223372036854775798)));
end;

procedure TTestTTimeSpan.BadAdd2;
var
  ts: TTimeSpan;
begin
  ts := TTimeSpan.FromTicks(Int64(-1));
  ts.Add(TTimeSpan.FromTicks(Int64(-9223372036854775808)));
end;

procedure TTestTTimeSpan.TestAdd;
var
  ts: TTimeSpan;
begin
  ts := TTimeSpan.FromTicks(Int64(10));

  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(110), ts.Add(TTimeSpan.FromTicks(Int64(100))).Ticks);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(10), ts.Ticks);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(-90), ts.Add(TTimeSpan.FromTicks(Int64(-100))).Ticks);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(10), ts.Ticks);
  CheckException(BadAdd1, EArgumentOutOfRangeException);
  CheckException(BadAdd2, EArgumentOutOfRangeException);
end;

procedure TTestTTimeSpan.BadSubtract1;
var
  ts: TTimeSpan;
begin
  ts := TTimeSpan.FromTicks(Int64(-2));
  ts.Subtract(TTimeSpan.FromTicks(Int64(9223372036854775807)));
end;

procedure TTestTTimeSpan.BadSubtract2;
var
  ts: TTimeSpan;
begin
  ts := TTimeSpan.FromTicks(Int64(10));
  ts.Subtract(TTimeSpan.FromTicks(Int64(-9223372036854775808)));
end;

procedure TTestTTimeSpan.TestSubtract;
var
  ts: TTimeSpan;
begin
  ts := TTimeSpan.FromTicks(Int64(10));

  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(-90), ts.Subtract(TTimeSpan.FromTicks(Int64(100))).Ticks);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(10), ts.Ticks);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(110), ts.Subtract(TTimeSpan.FromTicks(Int64(-100))).Ticks);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(10), ts.Ticks);
  CheckException(BadSubtract1, EArgumentOutOfRangeException);
  CheckException(BadSubtract2, EArgumentOutOfRangeException);
end;

procedure TTestTTimeSpan.TestClassSubtract;
const
  dt1: TDateTime = 2.0;
  dt2: TDateTime = 1.0;
begin
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(864000000000), TTimeSpan.Subtract(dt1, dt2).Ticks);
end;

procedure TTestTTimeSpan.TestNegate;
var
  ts: TTimeSpan;
begin
  ts := TTimeSpan.FromTicks(Int64(10));

  CheckEquals(Int64(-10), ts.Negate.Ticks);
  CheckEquals(Int64(10), ts.Ticks);

  ts := TTimeSpan.FromTicks(Int64(-10));

  CheckEquals(Int64(10), ts.Negate.Ticks);
  CheckEquals(Int64(-10), ts.Ticks);

  ts := TTimeSpan.FromTicks(Int64(0));

  CheckEquals(Int64(0), ts.Negate.Ticks);
  CheckEquals(Int64(0), ts.Ticks);
end;

procedure TTestTTimeSpan.BadDuration;
begin
  TTimeSpan.MinValue.Duration;
end;

procedure TTestTTimeSpan.TestDuration;
var
  ts: TTimeSpan;
begin
  ts := TTimeSpan.FromTicks(Int64(10));

  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(10), ts.Duration.Ticks);

  ts := TTimeSpan.FromTicks(Int64(-10));

  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(10), ts.Duration.Ticks);

  CheckException(BadDuration, EIntOverflow);
end;

procedure TTestTTimeSpan.TestProperties;
var
  ts: TTimeSpan;
begin
  ts := TTimeSpan.FromTicks(Int64(61234567891234));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(70), ts.Days);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(20), ts.Hours);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(57), ts.Minutes);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(36), ts.Seconds);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(789), ts.Milliseconds);
  CheckEquals(70.873342466706, ts.TotalDays, 0.000000000001);
  CheckEquals(1700.96021920094, ts.TotalHours, 0.00000000001);
  CheckEquals(102057.613152057, ts.TotalMinutes, 0.000000001);
  CheckEquals(6123456.7891234, ts.TotalSeconds, 0.0000001);
  CheckEquals(6123456789.1234, ts.TotalMilliseconds, 0.0001);

  ts := TTimeSpan.FromTicks(Int64(-61234567891234));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(-70), ts.Days);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(-20), ts.Hours);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(-57), ts.Minutes);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(-36), ts.Seconds);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(-789), ts.Milliseconds);
  CheckEquals(-70.873342466706, ts.TotalDays, 0.000000000001);
  CheckEquals(-1700.96021920094, ts.TotalHours, 0.00000000001);
  CheckEquals(-102057.613152057, ts.TotalMinutes, 0.000000001);
  CheckEquals(-6123456.7891234, ts.TotalSeconds, 0.0000001);
  CheckEquals(-6123456789.1234, ts.TotalMilliseconds, 0.0001);
end;

procedure TTestTTimeSpan.BadOpAdd1;
var
  Dummy: TTimeSpan;
begin
  Dummy := TTimeSpan.FromTicks(Int64(10)) + TTimeSpan.FromTicks(Int64(9223372036854775798));
end;

procedure TTestTTimeSpan.BadOpAdd2;
var
  Dummy: TTimeSpan;
begin
  Dummy := TTimeSpan.FromTicks(Int64(-1)) + TTimeSpan.FromTicks(Int64(-9223372036854775808));
end;

procedure TTestTTimeSpan.TestOpAdd;
const
  dt1: TDateTime = 1.0;
  dt2: TDateTime = 2.0;
begin
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(25), (TTimeSpan.FromTicks(Int64(10)) + TTimeSpan.FromTicks(Int64(15))).Ticks);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(5), (TTimeSpan.FromTicks(Int64(-10)) + TTimeSpan.FromTicks(Int64(15))).Ticks);
  CheckTrue(SameDateTime(dt2, TTimeSpan.FromTicks(Int64(864000000000)) + dt1));
  CheckTrue(SameDateTime(dt2, dt1 + TTimeSpan.FromTicks(Int64(864000000000))));
  CheckException(BadOpAdd1, EArgumentOutOfRangeException);
  CheckException(BadOpAdd2, EArgumentOutOfRangeException);
end;

procedure TTestTTimeSpan.BadOpSubtract1;
var
  Dummy: TTimeSpan;
begin
  Dummy := TTimeSpan.FromTicks(Int64(-2)) - TTimeSpan.FromTicks(Int64(9223372036854775807));
end;

procedure TTestTTimeSpan.BadOpSubtract2;
var
  Dummy: TTimeSpan;
begin
  Dummy := TTimeSpan.FromTicks(Int64(10)) - TTimeSpan.FromTicks(Int64(-9223372036854775808));
end;

procedure TTestTTimeSpan.TestOpSubtract;
const
  dt1: TDateTime = 2.0;
  dt2: TDateTime = 1.0;
begin
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(15), (TTimeSpan.FromTicks(Int64(20)) - TTimeSpan.FromTicks(Int64(5))).Ticks);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(25), (TTimeSpan.FromTicks(Int64(20)) - TTimeSpan.FromTicks(Int64(-5))).Ticks);
  CheckTrue(SameDateTime(dt2, dt1 - TTimeSpan.FromTicks(864000000000)));
  CheckException(BadOpSubtract1, EArgumentOutOfRangeException);
  CheckException(BadOpSubtract2, EArgumentOutOfRangeException);
end;

procedure TTestTTimeSpan.TestOpEqual;
begin
  CheckTrue(TTimeSpan.FromTicks(Int64(0)) = TTimeSpan.FromTicks(Int64(0)));
  CheckTrue(TTimeSpan.FromTicks(Int64(0)) = TTimeSpan.FromTicks(Int64(-0)));
  CheckTrue(TTimeSpan.FromTicks(Int64(20)) = TTimeSpan.FromTicks(Int64(20)));
  CheckTrue(TTimeSpan.FromTicks(Int64(-5)) = TTimeSpan.FromTicks(Int64(-5)));
  CheckFalse(TTimeSpan.FromTicks(Int64(-5)) = TTimeSpan.FromTicks(Int64(10)));
  CheckFalse(TTimeSpan.FromTicks(Int64(0)) = TTimeSpan.FromTicks(Int64(-100)));
end;

procedure TTestTTimeSpan.TestOpNotEqual;
begin
  CheckFalse(TTimeSpan.FromTicks(Int64(0)) <> TTimeSpan.FromTicks(Int64(0)));
  CheckFalse(TTimeSpan.FromTicks(Int64(0)) <> TTimeSpan.FromTicks(Int64(-0)));
  CheckFalse(TTimeSpan.FromTicks(Int64(20)) <> TTimeSpan.FromTicks(Int64(20)));
  CheckFalse(TTimeSpan.FromTicks(Int64(-5)) <> TTimeSpan.FromTicks(Int64(-5)));
  CheckTrue(TTimeSpan.FromTicks(Int64(-5)) <> TTimeSpan.FromTicks(Int64(10)));
  CheckTrue(TTimeSpan.FromTicks(Int64(0)) <> TTimeSpan.FromTicks(Int64(-100)));
end;

procedure TTestTTimeSpan.TestOpGreaterThan;
begin
  CheckTrue(TTimeSpan.FromTicks(Int64(1)) > TTimeSpan.FromTicks(Int64(0)));
  CheckTrue(TTimeSpan.FromTicks(Int64(1)) > TTimeSpan.FromTicks(Int64(-1)));
  CheckFalse(TTimeSpan.FromTicks(Int64(0)) > TTimeSpan.FromTicks(Int64(0)));
  CheckFalse(TTimeSpan.FromTicks(Int64(1)) > TTimeSpan.FromTicks(Int64(1)));
  CheckFalse(TTimeSpan.FromTicks(Int64(-1)) > TTimeSpan.FromTicks(Int64(1)));
end;

procedure TTestTTimeSpan.TestOpGreaterThanOrEqual;
begin
  CheckTrue(TTimeSpan.FromTicks(Int64(1)) >= TTimeSpan.FromTicks(Int64(0)));
  CheckTrue(TTimeSpan.FromTicks(Int64(1)) >= TTimeSpan.FromTicks(Int64(-1)));
  CheckTrue(TTimeSpan.FromTicks(Int64(0)) >= TTimeSpan.FromTicks(Int64(0)));
  CheckTrue(TTimeSpan.FromTicks(Int64(1)) >= TTimeSpan.FromTicks(Int64(1)));
  CheckFalse(TTimeSpan.FromTicks(Int64(-1)) >= TTimeSpan.FromTicks(Int64(1)));
end;

procedure TTestTTimeSpan.TestOpLessThan;
begin
  CheckTrue(TTimeSpan.FromTicks(Int64(0)) < TTimeSpan.FromTicks(Int64(1)));
  CheckTrue(TTimeSpan.FromTicks(Int64(-1)) < TTimeSpan.FromTicks(Int64(1)));
  CheckFalse(TTimeSpan.FromTicks(Int64(0)) < TTimeSpan.FromTicks(Int64(0)));
  CheckFalse(TTimeSpan.FromTicks(Int64(1)) < TTimeSpan.FromTicks(Int64(1)));
  CheckFalse(TTimeSpan.FromTicks(Int64(1)) < TTimeSpan.FromTicks(Int64(-1)));
end;

procedure TTestTTimeSpan.TestOpLessThanOrEqual;
begin
  CheckTrue(TTimeSpan.FromTicks(Int64(0)) <= TTimeSpan.FromTicks(Int64(1)));
  CheckTrue(TTimeSpan.FromTicks(Int64(-1)) <= TTimeSpan.FromTicks(Int64(1)));
  CheckTrue(TTimeSpan.FromTicks(Int64(0)) <= TTimeSpan.FromTicks(Int64(0)));
  CheckTrue(TTimeSpan.FromTicks(Int64(1)) <= TTimeSpan.FromTicks(Int64(1)));
  CheckFalse(TTimeSpan.FromTicks(Int64(1)) <= TTimeSpan.FromTicks(Int64(-1)));
end;

procedure TTestTTimeSpan.TestOpNegative;
var
  ts: TTimeSpan;
begin
  ts := -TTimeSpan.FromTicks(Int64(10));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(-10), ts.Ticks);

  ts := -TTimeSpan.FromTicks(Int64(-10));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(10), ts.Ticks);
end;

procedure TTestTTimeSpan.TestOpPositive;
var
  ts: TTimeSpan;
begin
  ts := +TTimeSpan.FromTicks(Int64(-10));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(-10), ts.Ticks);

  ts := +TTimeSpan.FromTicks(Int64(10));
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(Int64(10), ts.Ticks);
end;

procedure TTestTTimeSpan.TestOpImplicit;
var
  ts: TTimeSpan;
  str: string;
begin
  ts := TTimeSpan.FromTicks(10);
  str := ts;

  CheckEquals('00:00:00.0000010', str);
end;

procedure TTestTTimeSpan.TestOpExplicit;
var
  ts: TTimeSpan;
begin
  ts := TTimeSpan.FromTicks(10);

  CheckEquals('00:00:00.0000010', string(ts));
end;

initialization
  RegisterTest('System.TimeSpan', TTestTTimeSpan.Suite);

end.
