unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, ComWriUtils, ComboLists, StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ComboList1: TComboList;
    ComboList2: TComboList;
    ComboList3: TComboList;
    DBCodeValues1: TDBCodeValues;
    DBCodeValues2: TDBCodeValues;
    DBCodeValues3: TDBCodeValues;
    Label3: TLabel;
    Query1: TQuery;
    Database1: TDatabase;
    Label5: TLabel;
    Button1: TButton;
    edEduCode: TEdit;
    edSchCode: TEdit;
    edNatCode: TEdit;
    edEduValue: TEdit;
    edSchValue: TEdit;
    edNatValue: TEdit;
    Label4: TLabel;
    btnEduCode: TButton;
    btnSchCode: TButton;
    btnNatCode: TButton;
    btnEduValue: TButton;
    btnSchValue: TButton;
    btnNatValue: TButton;
    btnGoEduCode: TButton;
    btnGoEduValue: TButton;
    btnGoSchCode: TButton;
    btnGoSchValue: TButton;
    btnGoNatCode: TButton;
    btnGoNatValue: TButton;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure ComboList1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnEduCodeClick(Sender: TObject);
    procedure btnEduValueClick(Sender: TObject);
    procedure btnSchCodeClick(Sender: TObject);
    procedure btnSchValueClick(Sender: TObject);
    procedure btnNatCodeClick(Sender: TObject);
    procedure btnNatValueClick(Sender: TObject);
    procedure btnGoEduCodeClick(Sender: TObject);
    procedure btnGoEduValueClick(Sender: TObject);
    procedure btnGoSchCodeClick(Sender: TObject);
    procedure btnGoSchValueClick(Sender: TObject);
    procedure btnGoNatCodeClick(Sender: TObject);
    procedure btnGoNatValueClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  DBCodeValues1.Active := true;
  DBCodeValues2.Active := true;
  DBCodeValues3.Active := true;
  ComboList1Change(Sender);
end;

procedure TForm1.ComboList1Change(Sender: TObject);
begin
  edEduCode.text := ComboList1.Code;
  edEduValue.text := ComboList1.Value;
  edSchCode.text := ComboList2.Code;
  edSchValue.text := ComboList2.Value;
  edNatCode.text := ComboList3.Code;
  edNatValue.text := ComboList3.Value;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  {ComboList1.Code:='';
  ComboList2.Code:='';
  ComboList3.Code:='';}
  ComboList1.Clear;
  ComboList2.Clear;
  ComboList3.Clear;
end;

procedure TForm1.btnEduCodeClick(Sender: TObject);
begin
  ComboList1.Code := edEduCode.text;
end;

procedure TForm1.btnEduValueClick(Sender: TObject);
begin
  ComboList1.Value := edEduValue.text;
end;

procedure TForm1.btnSchCodeClick(Sender: TObject);
begin
  ComboList2.Code := edSchCode.text;
end;

procedure TForm1.btnSchValueClick(Sender: TObject);
begin
  ComboList2.Value := edSchValue.text;
end;

procedure TForm1.btnNatCodeClick(Sender: TObject);
begin
  ComboList3.Code := edNatCode.text;
end;

procedure TForm1.btnNatValueClick(Sender: TObject);
begin
  ComboList3.Value := edNatValue.text;
end;

procedure TForm1.btnGoEduCodeClick(Sender: TObject);
begin
  ComboList1.GoNearestCode(edEduCode.text);
end;

procedure TForm1.btnGoEduValueClick(Sender: TObject);
begin
  ComboList1.GoNearestValue(edEduValue.text);
end;

procedure TForm1.btnGoSchCodeClick(Sender: TObject);
begin
  ComboList2.GoNearestCode(edSchCode.text);
end;

procedure TForm1.btnGoSchValueClick(Sender: TObject);
begin
  ComboList2.GoNearestValue(edSchValue.text);
end;

procedure TForm1.btnGoNatCodeClick(Sender: TObject);
begin
  ComboList3.GoNearestCode(edNatCode.text);
end;

procedure TForm1.btnGoNatValueClick(Sender: TObject);
begin
  ComboList3.GoNearestValue(edNatValue.text);
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  ComboList1.CanEdit := CheckBox1.Checked;
  ComboList2.CanEdit := CheckBox1.Checked;
  ComboList3.CanEdit := CheckBox1.Checked;
end;

end.
