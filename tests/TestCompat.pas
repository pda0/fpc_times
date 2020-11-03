{**********************************************************************
    ● Copyright(c) 2020 Dmitriy Pomerantsev <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit TestCompat;

interface

uses
  TestFramework;

type
  TTestCase = class(TestFramework.TTestCase)
  protected
    procedure CheckEquals64(Expected, Actual: Int64; msg: string = ''); virtual;
    procedure CheckNotEquals64(Expected, Actual: Int64; msg: string = ''); virtual;
  end;

implementation

uses
  SysUtils;

{ TTestCase }

procedure TTestCase.CheckEquals64(Expected, Actual: Int64; msg: string);
begin
  FCheckCalled := True;
  if Expected <> Actual then
    FailNotEquals(IntToStr(Expected), IntToStr(Actual), msg, CallerAddr);
end;

procedure TTestCase.CheckNotEquals64(Expected, Actual: Int64; msg: string);
begin
  FCheckCalled := True;
  if Expected = Actual then
    FailEquals(IntToStr(Expected), IntToStr(Actual), msg, CallerAddr);
end;

end.
