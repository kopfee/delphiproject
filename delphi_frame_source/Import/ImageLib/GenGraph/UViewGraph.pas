unit UViewGraph;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgLibObjs;

type
  TfmViewer = class(TForm)
    ILImageView1: TILImageView;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Execute(const AFileName:string);
  end;

var
  fmViewer: TfmViewer;

implementation



{$R *.DFM}

{ TfmViewer }

procedure TfmViewer.Execute(const AFileName: string);
begin
  ILImageView1.ImageObj.LoadFromFile(AFileName);
  WindowState := wsNormal;
  Show;
end;

end.
