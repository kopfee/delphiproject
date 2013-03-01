unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, ComWriUtils, ComboLists, StdCtrls;

type
  TForm1 = class(TForm)
    Label2: TLabel;
    ComboList2: TComboList;
    ComboList3: TComboList;
    DBCodeValues2: TDBCodeValues;
    Label3: TLabel;
    Query1: TQuery;
    Database1: TDatabase;
    Label5: TLabel;
    edSchCode: TEdit;
    edNatCode: TEdit;
    edSchValue: TEdit;
    edNatValue: TEdit;
    Label4: TLabel;
    btnSchCode: TButton;
    btnNatCode: TButton;
    btnSchValue: TButton;
    btnNatValue: TButton;
    btnGoSchCode: TButton;
    btnGoSchValue: TButton;
    btnGoNatCode: TButton;
    btnGoNatValue: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ComboList1Change(Sender: TObject);
    procedure btnSchCodeClick(Sender: TObject);
    procedure btnSchValueClick(Sender: TObject);
    procedure btnNatCodeClick(Sender: TObject);
    procedure btnNatValueClick(Sender: TObject);
    procedure btnGoSchCodeClick(Sender: TObject);
    procedure btnGoSchValueClick(Sender: TObject);
    procedure btnGoNatCodeClick(Sender: TObject);
    procedure btnGoNatValueClick(Sender: TObject);
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
  DBCodeValues2.Active := true;
  ComboList1Change(Sender);
end;

procedure TForm1.ComboList1Change(Sender: TObject);
begin
  edSchCode.text := ComboList2.Code;
  edSchValue.text := ComboList2.Value;
  edNatCode.text := ComboList3.Code;
  edNatValue.text := ComboList3.Value;
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

end.
