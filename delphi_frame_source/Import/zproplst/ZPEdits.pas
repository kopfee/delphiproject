
{*******************************************************}
{       TStrings property editor                        }
{       Author: Gennadie Zuev                           }
{	E-mail: zuev@micex.ru                           }
{	Web: http://unicorn.micex.ru/users/gena         }
{                                                       }
{       Copyright (c) 1999 Gennadie Zuev     	        }
{                                                       }
{*******************************************************}

unit ZPEdits;

interface

uses
  DsgnIntf;

type
  THexadecimal = type Integer;

  THexProperty = class(TOrdinalProperty)
  public
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

  TMultiLineStr = type string;

  TMultiLineStrProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TStringsProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

implementation

uses
  SysUtils, Forms, StdCtrls, Controls, ExtCtrls, Classes, Messages, TypInfo;

{ THexProperty }

function THexProperty.GetValue: string;
begin
  Result := '$' + IntToHex(Cardinal(GetOrdValue), 1);
end;

procedure THexProperty.SetValue(const Value: string);
var
  L: Cardinal;
begin
  if Pos('$', Value) <> 0 then L := StrToInt(Value)
    else L := StrToInt('$' + Value);
  SetOrdValue(L);
end;

type
  TStrEditForm = class(TForm)
  private
    OkBtn,
    CancelBtn: TButton;
    procedure WMSize(var Message: TMessage); message WM_SIZE;
    procedure MemoKeyPress(Sender: TObject; var Key: Char); 
  public
    Memo: TMemo;
    Panel: TPanel;
    constructor Create(AOwner: TComponent); override;
    procedure Execute(PE: TPropertyEditor);
  end;

{ TStrEditForm }

constructor TStrEditForm.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner);
  BorderStyle := bsSizeToolWin;
  Position := poScreenCenter;

  Panel := TPanel.Create(Self);
  with Panel do
  begin
    Parent := Self;
    Align := alBottom;
    BevelOuter := bvNone;
    Height := 30;
  end;

  OkBtn := TButton.Create(Panel);
  with OkBtn do
  begin
    Parent := Panel;
    Caption := 'Ok';
    ModalResult := mrOk;
    Default := True;
    Top := 4;
  end;

  CancelBtn := TButton.Create(Panel);
  with CancelBtn do
  begin
    Parent := Panel;
    Caption := 'Cancel';
    ModalResult := mrCancel;
    Cancel := True;
    Top := 4;
  end;

  Memo := TMemo.Create(Self);
  with Memo do
  begin
    Parent := Self;
    Align := alClient;
    ScrollBars := ssVertical;
//    WordWrap := False;
    WantTabs := True;
    OnKeyPress := MemoKeyPress;
  end;
end;

type
  THEditor = class(TPropertyEditor) end;

procedure TStrEditForm.MemoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    Close;
  end;
  inherited;
end;

procedure TStrEditForm.Execute(PE: TPropertyEditor);
var
  S: TStrings;
  IsObj: Boolean;
begin
  Caption := Format('Editing "%s" property', [PE.GetName]);
  IsObj := PE.GetPropType.Kind = tkClass;
  S := nil;
  if IsObj then
  begin
    S := TObject(THEditor(PE).GetOrdValue) as TStrings;
    if Assigned(S) then Memo.Lines.Assign(S);
  end
  else
  begin
    Memo.MaxLength := PE.GetEditLimit;
    Memo.Text := THEditor(PE).GetStrValue;
  end;
  ActiveControl := Memo;

  if inherited ShowModal = mrOk then
    if IsObj and Assigned(S) then
      S.Assign(Memo.Lines)
    else
      THEditor(PE).SetStrValue(Memo.Text);
end;

procedure TStrEditForm.WMSize(var Message: TMessage);
var
  CliWidth: Integer;
begin
  inherited;
  CliWidth := ClientWidth;
  with CancelBtn do
    Left := CliWidth - Width - 2;
  with OkBtn do
    Left := CliWidth - (Width shl 1) - 6;
end;

var
  StrEditForm: TStrEditForm;

procedure EditStrings(PE: TPropertyEditor);
begin
  if not Assigned(StrEditForm) then
    StrEditForm := TStrEditForm.Create(Application);
  StrEditForm.Execute(PE);
end;

{ TMultiLineStrProperty }

procedure TMultiLineStrProperty.Edit;
begin
  EditStrings(Self);
end;

function TMultiLineStrProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog, paReadoNly];
end;

{ TStringsProperty }

procedure TStringsProperty.Edit;
begin
  EditStrings(Self);
end;

function TStringsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paDialog, paReadOnly];
end;

initialization

  RegisterPropertyEditor(TypeInfo(THexadecimal), nil, '', THexProperty);
  RegisterPropertyEditor(TypeInfo(TMultiLineStr), nil, '', TMultiLineStrProperty);
  RegisterPropertyEditor(TypeInfo(TStrings), nil, '', TStringsProperty);

end.
