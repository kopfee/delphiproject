unit UDataError;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, WVCtrls, WorkViews;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    btnReset: TButton;
    WorkView1: TWorkView;
    WVEdit1: TWVEdit;
    btnUse: TButton;
    procedure btnResetClick(Sender: TObject);
    procedure btnUseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnResetClick(Sender: TObject);
begin
  WorkView1.Reset;
end;

procedure TForm1.btnUseClick(Sender: TObject);
begin
  ShowMessage(Format('%d',[WorkView1.FieldByName('Êý×Ö').Data.AsInteger]));
end;

end.
