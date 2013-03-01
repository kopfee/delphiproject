unit ImageFxEd;

interface

procedure Register;

implementation

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs,TypInfo,dsgnintf,ImageFXs;

type
  TImageFXEditor = class(TComponentEditor)
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
  RegisterComponentEditor(TImageFX,TImageFXEditor);
end;

{ TImageFXEditor }

procedure TImageFXEditor.ExecuteVerb(Index: Integer);
begin
  with Component as TImageFX do
  if Painter<>nil then
  case index of
    0 : StartFX;
    1 : EndFX;
  end;
end;

function TImageFXEditor.GetVerb(Index: Integer): string;
begin
  case index of
    0 : result:='StartFX';
    1 : result:='EndFX';
  end;
end;

function TImageFXEditor.GetVerbCount: Integer;
begin
  result:=2;
end;

end.
