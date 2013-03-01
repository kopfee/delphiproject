unit CoolCtrlDSN;

// for Cool Controls Design time useage

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs,StdCtrls,ComCtrls,
  Buttons,ImgList,ComWriUtils,
  CoolCtrls;

procedure Register;

implementation

uses TypInfo,dsgnintf,
     LabelLookCfgDLG, BtnLookCfgDLG,
     ExtDialogs;

type
  TLabelOutlookEditor = class(TComponentEditor)
  private

  protected

  public
    function  GetVerbCount: Integer; override;
    function  GetVerb(Index: Integer): string;override;
    procedure ExecuteVerb(Index: Integer); override;
  published

  end;

  TButtonOutlookEditor = class(TComponentEditor)
  private

  protected

  public
    function  GetVerbCount: Integer; override;
    function  GetVerb(Index: Integer): string;override;
    procedure ExecuteVerb(Index: Integer); override;
  published

  end;

  TPenProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function  GetAttributes: TPropertyAttributes; override;
  end;

{ TLabelOutlookEditor }

procedure TLabelOutlookEditor.ExecuteVerb(Index: Integer);
var
  dlg : TdlgCfgLabelLook;
begin
  if index=0 then
  begin
    dlg := TdlgCfgLabelLook.Create(Application);
    try
      if dlg.Execute(TLabelOutlook(Component)) then
        Designer.Modified;
    finally
      dlg.free;
    end;
  end;
end;

function TLabelOutlookEditor.GetVerb(Index: Integer): string;
begin
  if index=0 then
    result := 'Customize...';
end;

function TLabelOutlookEditor.GetVerbCount: Integer;
begin
  result := 1;
end;

{ TPenProperty }

procedure TPenProperty.Edit;
var
  PenDialog : TPenDialog;
begin
  PenDialog := TPenDialog.Create(Application);
  try
    PenDialog.Title := 'Config The Pen';
    PenDialog.Pen := TPen(GetOrdValue);
    if PenDialog.Execute then
    begin
      SetOrdValue(Longint(PenDialog.Pen));
      Designer.Modified;
    end;
  finally
    PenDialog.free;
  end;
end;

function TPenProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paSubProperties, paDialog, paReadOnly];
end;

{ TButtonOutlookEditor }

procedure TButtonOutlookEditor.ExecuteVerb(Index: Integer);
var
  dlg : TdlgCfgBtnLook;
begin
  if index=0 then
  begin
    dlg := TdlgCfgBtnLook.Create(Application);
    try
      if dlg.Execute(TButtonOutlook(Component)) then
        Designer.Modified;
    finally
      dlg.free;
    end;
  end;
end;

function TButtonOutlookEditor.GetVerb(Index: Integer): string;
begin
  if index=0 then
    result := 'Customize...';
end;

function TButtonOutlookEditor.GetVerbCount: Integer;
begin
  result := 1;
end;

procedure Register;
begin
  RegisterComponentEditor(
    TLabelOutlook,TLabelOutlookEditor);
  RegisterComponentEditor(
    TButtonOutlook,TButtonOutlookEditor);
  RegisterPropertyEditor(PTypeInfo(TPen.ClassInfo),
    nil,'',TPenProperty);
end;

end.
