unit UMain1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComWriUtils, MDBCtrls, Mask, DBCtrls, ComCtrls,
  Buttons;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Edit1: TEdit;
    Edit2: TEdit;
    BevelStyles1: TBevelStyles;
    MDBCustomEdit1: TMDBCustomEdit;
    Button1: TButton;
    ListBox1: TListBox;
    Label1: TLabel;
    Memo1: TMemo;
    ComboBox1: TComboBox;
    MaskEdit1: TMaskEdit;
    BitBtn1: TBitBtn;
    DBEdit1: TDBEdit;
    DBMemo1: TDBMemo;
    DBListBox1: TDBListBox;
    DBRichEdit1: TDBRichEdit;
    DBLookupComboBox1: TDBLookupComboBox;
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

procedure TForm1.Button1Click(Sender: TObject);
begin
  BevelStyles1.SetCtrlBevelEx(MDBCustomEdit1);
end;

end.
