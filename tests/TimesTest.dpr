{**********************************************************************
    ● Copyright(c) 2020 Dmitriy Pomerantsev <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
program TimesTest;
{$IFDEF FPC}
  {$IF DEFINED(VER1) OR DEFINED(VER2_0) OR DEFINED(VER2_2) OR DEFINED(VER2_4) OR DEFINED(VER2_6)}
    {$FATAL You need at least FPC 3.0.0 to build this unit}
  {$IFEND}
  {$CODEPAGE UTF8}
  {$MODE DELPHI}{$H+}
{$ELSE}
  {$IF CompilerVersion >= 24.0}
    {$LEGACYIFEND ON}
  {$IFEND}
  {$IF CompilerVersion < 18.0}
    {$ERROR You need at least Delphi 2007 to build this}
  {$IFEND}
  {$IF CompilerVersion < 19.0}
    {$DEFINE OLD_DELPHI}
  {$IFEND}
{$ENDIF}

{$IFDEF CONSOLE_TESTRUNNER}
  {$APPTYPE CONSOLE}
{$ENDIF}

uses
  {$IF DEFINED(FPC) OR DEFINED(OLD_DELPHI)}
  TimeSpan in '..\TimeSpan.pas',
  Diagnostics in '..\Diagnostics.pas',
    {$IFDEF FPC}
      {$IFDEF CONSOLE_TESTRUNNER}
      fpcunitconsolerunner,
      consoletestrunner,
      {$ELSE}
      Interfaces,
      Forms,
      GuiTestRunner,
      {$ENDIF}
      fpcunittestrunner,
    {$ELSE}
      {$IFDEF CONSOLE_TESTRUNNER}
      TextTestRunner,
      {$ELSE}
      Forms,
      GUITestRunner,
      {$ENDIF}
      TestFramework,
      TestCompat in 'TestCompat.pas',
    {$ENDIF}
  {$ELSE}
  DUnitTestRunner,
  {$IFEND }
  Test_TimeSpan in 'Test_TimeSpan.pas',
  Test_TStopwatch in 'Test_TStopwatch.pas';

{$R *.res}

{$IF DEFINED(FPC) AND DEFINED(CONSOLE_TESTRUNNER)}
var
  Application: TTestRunner;
{$IFEND}

begin
  {$IFDEF FPC}
    {$IFDEF CONSOLE_TESTRUNNER}
    Application := TTestRunner.Create(nil);
    try
    {$ENDIF}
      Application.Initialize;
      {$IFNDEF CONSOLE_TESTRUNNER}
      Application.CreateForm(TGuiTestRunner, TestRunner);
      {$ENDIF}
      Application.Run;
    {$IFDEF CONSOLE_TESTRUNNER}
    finally
      Application.Free;
    end;
    {$ENDIF}
  {$ELSE}
    ReportMemoryLeaksOnShutdown := True;
    {$IFDEF OLD_DELPHI}
      {$IFDEF CONSOLE_TESTRUNNER}
        TextTestRunner.RunRegisteredTests
      {$ELSE}
        Application.Initialize;
        GUITestRunner.RunRegisteredTests;
      {$ENDIF}
    {$ELSE}
    DUnitTestRunner.RunRegisteredTests;
    {$ENDIF}
  {$ENDIF}
end.

