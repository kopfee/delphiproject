{ :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: QuickReport 2.0 for Delphi 1.0/2.0/3.0                  ::
  ::                                                         ::
  :: QREXPBLD.PAS -  QuickReport expression builder          ::
  ::                                                         ::
  :: Copyright (c) 1997 QuSoft AS                            ::
  :: All Rights Reserved                                     ::
  ::                                                         ::
  :: web: http://www.qusoft.no    mail: support@qusoft.no    ::
  ::                              fax: +47 22 41 74 91       ::
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: }

unit qrexpbld;

interface

uses
{$ifdef win32}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, db, qrprntr, QR2Const;
{$else}
  Wintypes, Winprocs, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, db, qrprntr, QR2Const;
{$endif}

type
  TQRExprBuilder = class(TForm)
    OK: TButton;
    Cancel: TButton;
    CurrentExpr: TLabel;
    Undo: TButton;
    Clear: TButton;
    Element: TLabel;
    Bevel1: TBevel;
    ConstantGB: TGroupBox;
    aConstant: TEdit;
    ConstantType: TComboBox;
    AddNumeric: TButton;
    DataFieldGB: TGroupBox;
    DataSet: TComboBox;
    AddDatafield: TButton;
    FunctionGB: TGroupBox;
    FunctionName: TLabel;
    AddFunction: TButton;
    FunctionDescript: TLabel;
    OperatorsGB: TGroupBox;
    AddPlus: TButton;
    AddMinus: TButton;
    AddMul: TButton;
    AddEqual: TButton;
    AddParentese: TButton;
    AddSmaller: TButton;
    AddLarger: TButton;
    Button1: TButton;
    Button2: TButton;
    AddNotEqual: TButton;
    AddNot: TButton;
    AddAnd: TButton;
    AddOr: TButton;
    DataField: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    AddDiv: TButton;
    FunctionType: TComboBox;
    Label3: TLabel;
    AvailableFunc: TListBox;
    Label4: TLabel;
    procedure AddNumericClick(Sender: TObject);
    procedure AddPlusClick(Sender: TObject);
    procedure AddMinusClick(Sender: TObject);
    procedure AddMulClick(Sender: TObject);
    procedure AddDivClick(Sender: TObject);
    procedure NumericConstantKeyPress(Sender: TObject; var Key: Char);
    procedure AddParenteseClick(Sender: TObject);
    procedure DataSetChange(Sender: TObject);
    procedure DataFieldPageEnter(Sender: TObject);
    procedure AddDatafieldClick(Sender: TObject);
    procedure ClearClick(Sender: TObject);
    procedure AddAndClick(Sender: TObject);
    procedure AddOrClick(Sender: TObject);
    procedure AddNotClick(Sender: TObject);
    procedure AddEqualClick(Sender: TObject);
    procedure AddSmallerClick(Sender: TObject);
    procedure AddLargerClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure AddNotEqualClick(Sender: TObject);
    procedure FunctionTypeClick(Sender: TObject);
    procedure AvailableFuncClick(Sender: TObject);
    procedure AddFunctionClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure UndoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    QRForm : TForm;
    UndoList : TStrings;
    procedure AddToElement(Value : string);
    procedure GetFunctionTypes(Value : integer);
    procedure SelectFunction(value : integer);
    procedure AddAFunction(const FuncName, Arguments : string);
  public
    { Public declarations }
  end;

function GetExpression(ACaption : string; var Value : string; DataSetForm : TForm) : boolean;

implementation

uses
  qrextra;
{$R *.DFM}

procedure TQRExprBuilder.AddToElement(Value : string);
begin
  UndoList.Insert(0,Element.Caption);
  Element.Caption:=Element.Caption+Value;
  Undo.Enabled:=true;
end;

procedure TQRExprBuilder.AddNumericClick(Sender: TObject);
begin
  if ConstantType.ItemIndex = 0 then
    AddToElement(aConstant.Text)
  else
    AddToElement(''''+aConstant.Text+'''');
  aConstant.Text:='';
end;

procedure TQRExprBuilder.AddPlusClick(Sender: TObject);
begin
  AddToElement(' + ');
end;

procedure TQRExprBuilder.AddMinusClick(Sender: TObject);
begin
  AddToElement(' - ');
end;

procedure TQRExprBuilder.AddMulClick(Sender: TObject);
begin
  AddToElement(' * ');
end;

procedure TQRExprBuilder.AddDivClick(Sender: TObject);
begin
  AddToElement(' / ');
end;

procedure TQRExprBuilder.NumericConstantKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key=#13 then
    AddNumericClick(Self)
end;

function GetExpression(ACaption : string; var Value : string; DataSetForm : TForm) : boolean;
begin
  with TQRExprBuilder.Create(Application) do
  try
    QRForm := DataSetForm;
    Element.Caption:=Value;
    CurrentExpr.Caption:=ACaption;
    ShowModal;
    if ModalResult=mrOk then
      Result:=true
    else
      Result:=false;
    Value:=Element.Caption;
  finally
    Free;
  end;
end;

procedure TQRExprBuilder.AddParenteseClick(Sender: TObject);
var
  AValue : string;
begin
  AValue := '';
  if GetExpression(Element.Caption + '(<' + LoadStr(SqrExpression) + '>)', AValue, QRForm) then
    Element.Caption:=Element.Caption+'('+AValue+')';
end;

procedure TQRExprBuilder.DataSetChange(Sender: TObject);
var
  I : integer;
begin
  DataField.Items.Clear;
  if DataSet.Items.Count > 0 then
    with TDataSet(DataSet.Items.Objects[DataSet.ItemIndex]) do
    begin
      for I := 0 to FieldCount - 1 do
        DataField.Items.Add(Fields[I].FieldName);
    end;
end;

procedure TQRExprBuilder.DataFieldPageEnter(Sender: TObject);
begin
  if DataSet.Items.Count=0 then
  begin
    DataSet.Items:=AllDataSets(QRForm,true);
    DataSet.ItemIndex:=0;
    DataSet.Invalidate;
    DataField.ItemIndex:=0;
    DataField.ItemIndex := 0;
  end;
end;

procedure TQRExprBuilder.AddDatafieldClick(Sender: TObject);
begin
  if (DataField.ItemIndex >= 0) and
     (DataField.ItemIndex <= DataField.Items.Count - 1) then
     if (DataSet.Text<>'') then
       AddToElement(DataSet.Text+'.'+DataField.Items[DataField.ItemIndex]);
end;

procedure TQRExprBuilder.ClearClick(Sender: TObject);
begin
  Element.Caption:='';
end;

procedure TQRExprBuilder.AddAndClick(Sender: TObject);
begin
  AddToElement(' AND '); {<-- do not resource }
end;

procedure TQRExprBuilder.AddOrClick(Sender: TObject);
begin
  AddToElement(' OR '); {<-- do not resource }
end;

procedure TQRExprBuilder.AddNotClick(Sender: TObject);
begin
  AddToElement(' NOT '); {<-- do not resource }
end;

procedure TQRExprBuilder.AddEqualClick(Sender: TObject);
begin
  AddToElement(' = ');
end;

procedure TQRExprBuilder.AddSmallerClick(Sender: TObject);
begin
  AddToElement(' < ');
end;

procedure TQRExprBuilder.AddLargerClick(Sender: TObject);
begin
  AddToElement(' > ');
end;

procedure TQRExprBuilder.Button2Click(Sender: TObject);
begin
  AddToElement(' <= ');
end;

procedure TQRExprBuilder.Button1Click(Sender: TObject);
begin
  AddToElement(' >= ');
end;

procedure TQRExprBuilder.AddNotEqualClick(Sender: TObject);
begin
  AddToElement(' <> ');
end;

procedure TQRexprBuilder.GetFunctionTypes(Value : integer);
var
  I : integer;
begin
  AvailableFunc.Items.Clear;
  for I:=0 to QRFunctionLibrary.EntryList.Count-1 do
  begin
    with TQRLibraryEntry(QRFunctionLibrary.Entry[I]) do
    begin
      if (Value=0) or (StrToInt(Copy(Data,1,1))=Value) then
        AvailableFunc.Items.AddObject(Name,TQRLibraryEntry(QRFunctionLibrary.Entry[I]));
    end;
  end;
  SelectFunction(0);
end;

procedure TQRExprBuilder.FunctionTypeClick(Sender: TObject);
begin
  GetFunctionTypes(FunctionType.ItemIndex);
end;

procedure TQRExprBuilder.SelectFunction(Value : integer);
var
  AText : string;
begin
  if (Value < AvailableFunc.Items.Count) then
    AText:=TQRLibraryEntry(AvailableFunc.Items.Objects[Value]).Description
  else
    FunctionDescript.Caption:='';
  FunctionName.Caption:=copy(AText,1, AnsiPos('|',AText)-1);
  FunctionDescript.Caption:=copy(AText,AnsiPos('|',AText)+1,Length(AText));
end;

procedure TQRExprBuilder.AvailableFuncClick(Sender: TObject);
begin
  SelectFunction(AvailableFunc.ItemIndex);
end;

procedure TQRExprBuilder.AddAFunction(const FuncName, Arguments : string);
var
  I : integer;
  ArgType : string;
  AllArguments : string;
  AArgument : string;
begin
  if Length(Arguments) > 1 then
  begin
    for I := 2 to Length(Arguments) do
    begin
      ArgType := Copy(Arguments,I,1);
      AArgument := '';
      if GetExpression(FuncName + '(' + AllArguments + '<Expr>', AArgument, QRForm) then
      begin
        AllArguments := AllArguments + AArgument;
        if I < Length(Arguments) then
          AllArguments := AllArguments + ', ';
      end else
        Exit;
    end;
    AddToElement(FuncName + '(' + AllArguments + ')');
  end else
    AddToElement(FuncName);
end;

procedure TQRExprBuilder.AddFunctionClick(Sender: TObject);
begin
  if (AvailableFunc.ItemIndex >= 0) and
     (AvailableFunc.ItemIndex <= AvailableFunc.Items.Count - 1) then
       with TQRLibraryEntry(AvailableFunc.Items.Objects[AvailableFunc.ItemIndex]) do
    AddAFunction(Name, Data);
end;

procedure TQRExprBuilder.FormCreate(Sender: TObject);
begin
  UndoList:=TStringList.Create;
  GetFunctionTypes(0);
  FunctionType.ItemIndex := 0;
  ConstantType.ItemIndex := 0;
end;

procedure TQRExprBuilder.FormDestroy(Sender: TObject);
begin
  UndoList.Free;
end;

procedure TQRExprBuilder.UndoClick(Sender: TObject);
begin
  if UndoList.Count>0 then
  begin
    Element.Caption:=UndoList[0];
    UndoList.Delete(0);
  end;
  Undo.Enabled:=UndoList.Count>0;
end;

procedure TQRExprBuilder.FormActivate(Sender: TObject);
begin
  if QRForm <> nil then
  begin
    DataSet.Items := AllDataSets(QRForm, true);
    DataSet.ItemIndex := 0;
    DataSet.OnChange(Self);
  end
end;

end.
