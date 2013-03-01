unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TAppBuilder = class(TForm)
    OpenFileDialog: TOpenDialog;
    SaveFileDialog: TSaveDialog;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AppBuilder: TAppBuilder;

implementation

uses IDEDlgs;

{$R *.DFM}

procedure TAppBuilder.Button1Click(Sender: TObject);
begin
  OpenFileDialog.Execute;
end;

procedure TAppBuilder.Button2Click(Sender: TObject);
begin
  SaveFileDialog.Execute
end;

procedure TAppBuilder.Button3Click(Sender: TObject);
begin
  InstallDlgs;
end;

procedure TAppBuilder.Button4Click(Sender: TObject);
begin
  UnInstallDlgs;
end;

end.
