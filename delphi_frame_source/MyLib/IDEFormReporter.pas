unit IDEFormReporter;

interface

procedure Register;

implementation

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs,StdCtrls,ComCtrls,
  Buttons,ComWriUtils,TypInfo,dsgnintf;

type
  TIDEFormReporter = class(TComponentEditor)
  private

  protected

  public
    function  GetVerbCount: Integer; override;
    function  GetVerb(Index: Integer): string;override;
    procedure ExecuteVerb(Index: Integer); override;
  published

  end;

procedure Register;
begin
  RegisterComponentEditor(TForm,TIDEFormReporter);
end;

{ TIDEFormReporter }

procedure TIDEFormReporter.ExecuteVerb(Index: Integer);
begin

end;

function TIDEFormReporter.GetVerb(Index: Integer): string;
begin
  {if index=0 then
    result:='hyl'
  else
    result:=inherited GetVerb(Index);}
  result:='hyl';
end;

function TIDEFormReporter.GetVerbCount: Integer;
begin
  result:=2;
end;

end.
 