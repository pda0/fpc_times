{**********************************************************************
    ● Copyright(c) 2020 Dmitriy Pomerantsev <pda2@yandex.ru>
    Alternative Delphi's System.Diagnostics implementation.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    https://gitlab.com/pda_fpc/times

    Ver 1.0.0
    * Initial release.

 **********************************************************************}
unit Diagnostics;

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
  TimeSpan;

type
  { Type description taken from: http://docwiki.embarcadero.com/Libraries/Tokyo/en/System.Diagnostics.TStopwatch }
  TStopwatch = record
  strict private
    class var FFrequency: Int64;
    class var FIsHighResolution: Boolean;
    class var TickFrequency: Double;
  strict private
    FElapsed: Int64;
    FRunning: Boolean;
    FStartTimeStamp: Int64;
    function GetElapsed: TTimeSpan; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function GetElapsedDateTimeTicks: Int64; {$IFDEF HAS_INLINE}inline;{$ENDIF}
    function GetElapsedMilliseconds: Int64;
    function GetElapsedTicks: Int64;
  private
    class procedure Init; static;
  public
    class function Create: TStopwatch; static;
    class function GetTimeStamp: Int64; static;
    procedure Reset;
    procedure Start;
    class function StartNew: TStopwatch; static;
    procedure Stop;
    property Elapsed: TTimeSpan read GetElapsed;
    property ElapsedMilliseconds: Int64 read GetElapsedMilliseconds;
    property ElapsedTicks: Int64 read GetElapsedTicks;
    class property Frequency: Int64 read FFrequency;
    class property IsHighResolution: Boolean read FIsHighResolution;
    property IsRunning: Boolean read FRunning;
  end;

implementation

uses
  {$IF DEFINED(MSWINDOWS)}
  Windows,
  {$IFEND}
  SysUtils;

{$IF DEFINED(MSWINDOWS) AND NOT DECLARED(GetTickCount64)}
type
  TGetTickCount64 = function: UInt64; stdcall;
var
  GetTickCount64: TGetTickCount64 = nil;
  _TickCount64Base: UInt64 = 0;

function _GetTickCount64: UInt64; stdcall;
var
  SysTime: TFileTime;
  OverflowCount: UInt64; { ~49.71 days periods }
  Ticks32: Cardinal;
begin
  GetSystemTimeAsFileTime(SysTime);
  Ticks32 := GetTickCount;
  Result := (UInt64(SysTime.dwHighDateTime) shl 32 or SysTime.dwLowDateTime) div 10000;
  if Result > _TickCount64Base then
    OverflowCount := (Result - _TickCount64Base) div High(Ticks32)
  else
    OverflowCount := 0;
  Result := OverflowCount * High(Ticks32) + Ticks32;
end;
{$IFEND}

{ TStopwatch }

class function TStopwatch.Create: TStopwatch;
begin
  Result.Reset;
end;

function TStopwatch.GetElapsed: TTimeSpan;
begin
  Result := TTimeSpan.Create(GetElapsedDateTimeTicks);
end;

function TStopwatch.GetElapsedDateTimeTicks: Int64;
begin
  Result := ElapsedTicks;

  if FIsHighResolution then
    Result := Trunc(Result * TickFrequency);
end;

function TStopwatch.GetElapsedMilliseconds: Int64;
begin
  Result := GetElapsedDateTimeTicks div TTimeSpan.TicksPerMillisecond;
end;

function TStopwatch.GetElapsedTicks: Int64;
begin
  if FRunning then
    Result := GetTimeStamp + FElapsed - FStartTimeStamp
  else
    Result := FElapsed;
end;

class procedure TStopwatch.Init;
begin
  FIsHighResolution := False;
  {$IF DEFINED(FPC)}
    {$IFDEF HAVECLOCKGETTIME}
    FIsHighResolution := True;
    FFrequency := TTimeSpan.TicksPerSecond;
    TickFrequency := 1;
    {$ENDIF}
  {$ELSEIF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
  FIsHighResolution := QueryPerformanceFrequency(FFrequency);
  FIsHighResolution := FIsHighResolution and (FFrequency > 0);

  if FIsHighResolution then
    TickFrequency := TTimeSpan.TicksPerSecond / FFrequency;

    {$IF NOT DECLARED(GetTickCount64)}
    if CheckWin32Version(6, 0) then
      GetTickCount64 := GetProcAddress(GetModuleHandle(kernel32), 'GetTickCount64');

    if not Assigned(GetTickCount64) then
      GetTickCount64 := _GetTickCount64;
    {$IFEND}
  {$IFEND}

  if not FIsHighResolution then
  begin
    FFrequency := TTimeSpan.TicksPerSecond;
    TickFrequency := 1;
  end;
end;

class function TStopwatch.GetTimeStamp: Int64;
begin
  {$IFNDEF FPC}
  if FIsHighResolution then
    QueryPerformanceCounter(Result)
  else
  {$ENDIF}
    Result := Int64(GetTickCount64) * TTimeSpan.TicksPerMillisecond;
end;

procedure TStopwatch.Reset;
begin
  FRunning := False;
  FStartTimeStamp := 0;
  FElapsed := 0;
end;

procedure TStopwatch.Start;
begin
  if not FRunning then
  begin
    FRunning := True;
    FStartTimeStamp := GetTimeStamp;
  end;
end;

class function TStopwatch.StartNew: TStopwatch;
begin
  Result := TStopwatch.Create;
  Result.Start;
end;

procedure TStopwatch.Stop;
begin
  if FRunning then
  begin
    FRunning := False;
    FElapsed := FElapsed + GetTimeStamp - FStartTimeStamp;
  end;
end;

initialization
  TStopwatch.Init;

end.
