unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, DBCtrls, StdCtrls, Mask, KeyCap;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    MaskEdit1: TMaskEdit;
    Label1: TLabel;
    Label2: TLabel;
    DBEdit1: TDBEdit;
    Table1: TTable;
    DataSource1: TDataSource;
    Button2: TButton;
    Button3: TButton;
    EnterKeyCapture1: TEnterKeyCapture;
    EnterKeyCapture2: TEnterKeyCapture;
    EnterKeyCapture3: TEnterKeyCapture;
    procedure ButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.ButtonClick(Sender: TObject);
begin
  label2.caption := 'Button'+IntToStr(TComponent(sender).tag)
  				+' clicked.';
end;

end.
