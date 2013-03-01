unit UValueChanged;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, WVCtrls, WorkViews, ExtCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    WVComboBox1: TWVComboBox;
    WVEdit1: TWVEdit;
    WorkView: TWorkView;
    WVLabel1: TWVLabel;
    Label3: TLabel;
    btnReset: TButton;
    Timer: TTimer;
    Button1: TButton;
    procedure WorkView1FieldsMonitors0ValueChanged(Sender: TWVFieldMonitor;
      Valid: Boolean);
    procedure btnResetClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses LogFile;

procedure TForm1.WorkView1FieldsMonitors0ValueChanged(
  Sender: TWVFieldMonitor; Valid: Boolean);
var
  MarketField, AccountField, NameField : TWVField;
begin
  MarketField := WorkView.FieldByName('市场');
  AccountField:= WorkView.FieldByName('股东代码');
  NameField   := WorkView.FieldByName('股东姓名');
  // Get Name
  if (MarketField.Data.AsString<>'') and (AccountField.Data.AsString<>'') then
  begin
    ShowMessage('取姓名');
    NameField.Data.AsString := MarketField.Data.AsString+' '+AccountField.Data.AsString;
  end else
  begin
    NameField.Data.AsString := '';
  end;
end;

procedure TForm1.btnResetClick(Sender: TObject);
begin
  WorkView.Reset;
end;

procedure TForm1.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;
  ShowMessage('ok');
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Timer.Enabled := True;
end;

end.
