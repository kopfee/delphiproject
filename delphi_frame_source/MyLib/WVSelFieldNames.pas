unit WVSelFieldNames;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, CheckLst, ExtCtrls, WorkViews;

type
  TdlgSelectFieldNames = class(TForm)
    Panel1: TPanel;
    lsFieldNames: TCheckListBox;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
    function Execute(WorkView : TWorkView; var FieldNames:string) : Boolean;
  end;

function SelectFieldNames(WorkView : TWorkView; var FieldNames:string) : Boolean;

resourcestring
  SDisplayFormat  = '%s[%s]';

implementation

{$R *.DFM}

function SelectFieldNames(WorkView : TWorkView; var FieldNames:string) : Boolean;
var
  dlgSelectFieldNames: TdlgSelectFieldNames;
begin
  dlgSelectFieldNames := TdlgSelectFieldNames.Create(Application);
  try
    Result := dlgSelectFieldNames.Execute(WorkView,FieldNames);
  finally
    dlgSelectFieldNames.Free;
  end;
end;

{ TdlgSelectFieldNames }

function TdlgSelectFieldNames.Execute(WorkView: TWorkView;
  var FieldNames: string): Boolean;
var
  I : Integer;
  FieldName : string;
begin
  // 产生字段名称列表
  lsFieldNames.Items.BeginUpdate;
  lsFieldNames.Items.Clear;
  for I:=0 to WorkView.FieldCount-1 do
  begin
    FieldName := Uppercase(WorkView.Fields[I].Name);
    lsFieldNames.Items.Add(Format(SDisplayFormat,[WorkView.Fields[I].Name,WorkView.Fields[I].Caption]));
    lsFieldNames.Checked[I] := Pos(SeperateFieldChar+FieldName+SeperateFieldChar,FieldNames)>0;
  end;
  lsFieldNames.Items.EndUpdate;
  Result := ShowModal = mrOk;
  if Result then
  begin
    FieldNames := SeperateFieldChar;
    for I:=0 to WorkView.FieldCount-1 do
    begin
      if lsFieldNames.Checked[I] then
        FieldNames := FieldNames + WorkView.Fields[I].Name + SeperateFieldChar;
    end;
  end;
end;

end.
