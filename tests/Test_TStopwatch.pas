{**********************************************************************
    ● Copyright(c) 2020 Dmitriy Pomerantsev <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test_TStopwatch;

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
  Classes, SysUtils, TimeSpan, Diagnostics;

type
  TTestTStopwatch = class(TTestCase)
  strict private
    FStopwatch: TStopwatch;
  private
    class function GetZeroElapsed: TTimeSpan; static;
    class procedure SpinWait; static;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCreate;
    procedure TestGetTimeStamp;
    procedure TestStart;
    procedure TestStop;
    procedure TestStartNew;
    procedure TestReset;
    procedure TestElapsedMilliseconds;
    procedure TestElapsedTicks;
  end;

implementation

uses
  DateUtils;

{ TTestTStopwatch }

class function TTestTStopwatch.GetZeroElapsed: TTimeSpan;
begin
  Result := TTimeSpan.Create(0);
end;

class procedure TTestTStopwatch.SpinWait;
var
  StartTime: TDateTime;
begin
  StartTime := Now;
  repeat
    Sleep(50);
  until Now > StartTime;
end;

procedure TTestTStopwatch.SetUp;
begin
  FStopwatch := TStopwatch.Create;
end;

procedure TTestTStopwatch.TearDown;
begin
  {$IFDEF FPC}
  { We have to finalize record manually because fpcunit never frees TTestCase
    so our record never never runs out of scope. }
  Finalize(FStopwatch);
  {$ENDIF FPC}
end;

procedure TTestTStopwatch.TestCreate;
begin
  CheckFalse(FStopwatch.IsRunning);
  CheckTrue(FStopwatch.Elapsed = GetZeroElapsed);
end;

procedure TTestTStopwatch.TestGetTimeStamp;
var
  NowTimeStamp, StopWatchTimeStamp: Int64;
begin
  NowTimeStamp := DateTimeToUnix(Now);
  StopWatchTimeStamp := FStopwatch.GetTimeStamp;

  CheckTrue(StopWatchTimeStamp >= NowTimeStamp);
end;

procedure TTestTStopwatch.TestStart;
var
  ts1, ts2: TTimeSpan;
begin
  CheckFalse(FStopwatch.IsRunning);
  ts1 := FStopwatch.Elapsed;
  SpinWait;
  ts2 := FStopwatch.Elapsed;

  CheckTrue(ts1 = ts2);

  FStopwatch.Start;

  CheckTrue(FStopwatch.IsRunning);

  SpinWait;

  CheckFalse(FStopwatch.Elapsed = GetZeroElapsed);

  SpinWait;
  ts2 := FStopwatch.Elapsed;

  CheckTrue(ts1 < ts2);
end;

procedure TTestTStopwatch.TestStop;
var
  ts1, ts2: TTimeSpan;
begin
  FStopwatch.Start;
  ts1 := FStopwatch.Elapsed;

  CheckTrue(FStopwatch.IsRunning);

  SpinWait;
  FStopwatch.Stop;

  CheckFalse(FStopwatch.IsRunning);

  ts2 := FStopwatch.Elapsed;

  CheckTrue(ts1 < ts2);
end;

procedure TTestTStopwatch.TestStartNew;
begin
  CheckFalse(FStopwatch.IsRunning);

  FStopwatch := TStopwatch.StartNew;

  CheckTrue(FStopwatch.IsRunning);

  SpinWait;

  CheckFalse(FStopwatch.Elapsed = GetZeroElapsed);
end;

procedure TTestTStopwatch.TestReset;
begin
  FStopwatch.Start;
  SpinWait;

  CheckFalse(FStopwatch.Elapsed = GetZeroElapsed);

  FStopwatch.Reset;

  CheckFalse(FStopwatch.IsRunning);
  CheckTrue(FStopwatch.Elapsed = GetZeroElapsed);
end;

procedure TTestTStopwatch.TestElapsedMilliseconds;
var
  ms1: Int64;
begin
  ms1 := FStopwatch.ElapsedMilliseconds;

  SpinWait;

  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(ms1, FStopwatch.ElapsedMilliseconds);

  FStopwatch.Start;
  SpinWait;

  CheckTrue(ms1 < FStopwatch.ElapsedMilliseconds);
end;

procedure TTestTStopwatch.TestElapsedTicks;
var
  Ticks: Int64;
begin
  CheckFalse(FStopwatch.IsRunning);
  {$IFNDEF OLD_DELPHI}CheckEquals{$ELSE}CheckEquals64{$ENDIF}(0, FStopwatch.ElapsedTicks);

  FStopwatch.Start;
  SpinWait;
  Ticks := FStopwatch.ElapsedTicks;

  {$IFNDEF OLD_DELPHI}CheckNotEquals{$ELSE}CheckNotEquals64{$ENDIF}(0, Ticks);

  SpinWait;

  CheckTrue(Ticks < FStopwatch.ElapsedTicks);
end;

initialization
  RegisterTest('System.Diagnostics', TTestTStopwatch.Suite);

end.
