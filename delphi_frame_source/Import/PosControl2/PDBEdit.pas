unit PDBEdit;

{
  Create By LXM
  Modified By HYL
}
interface

uses
  Windows,  Messages, SysUtils, Classes, Graphics, Controls, Forms,     Dialogs,
  stdctrls, dbtables, extctrls, RxCtrls, dbctrls,  db,       SelectDlg, PLabelPanel
  ,buttons, LookupControls;

type
  TPDBEdit = class(TPLookupControl)
  private
    { Private declarations }
    FEdit: TDBEdit;
    //FDataLink: TDataLink;
    FFieldLink: TFieldDataLink;
    FPartialKey: Boolean;
    //FParentFont: Boolean;
    //FSpace: integer;
    {procedure SetCaptionWidth(const Value: integer);
    procedure SetSpace(const Value: integer);
    function  GetCaptionWidth: integer;
    procedure UpdateCtrlSizes;}

    {function GetEditFont:TFont;
    function GetEditWidth:integer;}
    function GetDataField: String;
    function GetDataSource: TDataSource;
    function GetEditPasswordChar:Char;
    function GetRdOnly:Boolean;
    function GetReadOnly: Boolean;
    procedure SetDataSource(Value: TDataSource);
    procedure SetDataField(Value: String);
    {procedure SetEditFont(Value: TFont);
    procedure SetEditWidth(Value: integer);}
    procedure SetEditPasswordChar(Value:Char);
    procedure SetRdOnly(Value: Boolean);
    procedure SetReadOnly(Value: Boolean);
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    {function GetLabelFont: TFont;
    procedure SetLabelFont(const Value: TFont);
    procedure SetAlignment(const Value: TAlignment);
    function GetAlignment: TAlignment;}
  protected
    { Protected declarations }
    function  GetText:string;override;
    procedure SetText(Value : string);override;
    //procedure ControlChange(Sender: TObject);override;
    {procedure ControlClick(Sender: TObject);override;
    procedure ControlDblClick(Sender: TObject); override;
    procedure ControlEnter(Sender: TObject);override;
    procedure ControlExit(Sender: TObject);override;}
    //procedure EditKeyPress(Sender: TObject; var Key: Char); override;

    //procedure DataChange(Sender: TObject; Field: TField);
    procedure SetActive(Value: Boolean);override;
    //procedure SetParentFont(Value: Boolean);override;
    //procedure Paint;override;

    procedure   CreateEditCtrl; override;
  public
     { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy;override;
    //procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
    property    CheckResult;
    //procedure   SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  published
    property Active;
    property Caption;
    property DataField: string read GetDataField write SetDataField;
    property DataSource :TDataSource read GetDataSource write SetDataSource;
    //property EditWidth:integer read GetEditWidth write SetEditWidth;
    //property EditFont:TFont read GetEditFont write SetEditFont;
    property EditPasswordChar: Char read GetEditPasswordChar write SetEditPasswordChar;
    property Filter;
    property LabelStyle;
    property ListFieldControl;
    //property ParentFont : Boolean read FParentFont write SetParentFont;
    property PartialKey:Boolean read FPartialKey write FPartialKey;
    property RdOnly: Boolean read GetRdOnly write SetRdOnly;
    property ReadOnly: Boolean read GetReadOnly Write SetReadOnly;
    property TabOrder;
    property TabStop;

    property OnChange;
    property OnEnter ;
    property OnExit  ;
    property OnClick;
    property OnDblClick;

    {//new add by HYL
    property  Space : integer read FSpace write SetSpace default 0;
    property  CaptionWidth : integer read GetCaptionWidth write SetCaptionWidth;
    property  LabelFont : TFont read GetLabelFont Write SetLabelFont;
    property  Alignment : TAlignment read GetAlignment write SetAlignment;}
  end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents('PosControl', [TPDBEdit]);
end;

function TPDBEdit.GetRdOnly:Boolean;
begin
     Result := FEdit.ReadOnly;
end;

procedure TPDBEdit.SetRdOnly(Value: Boolean);
begin
     FEdit.ReadOnly := Value;
     if Value then
        FEdit.Color := clSilver
     else
         FEdit.Color := clWhite;
end;

(*
function TPDBEdit.GetEditWidth:integer;
begin
     Result := FEdit.Width;
end;

procedure TPDBEdit.SetEditWidth(Value: integer);
begin
  {   FEdit.Width := Value;
     FEdit.Left := Width-Value;
     FLabel.Width := FEdit.Left;}
  CaptionWidth := Width-FSpace-Value;
end;

function TPDBEdit.GetEditFont:TFont;
begin
     Result := FEdit.Font;
end;

procedure TPDBEdit.SetEditFont(Value: TFont);
begin
     FEdit.Font.Assign(Value);
     //FLabel.Font.Assign(Value);
     FLabel.Height := FEdit.Height;
     Height := FEdit.Height;
     //SetLabelStyle(LabelStyle);
end;
*)
{
procedure TPDBEdit.Paint;
begin
     FLabel.Height := Height;
     FEdit.Height := Height;
     FLabel.Width := Width-FEdit.Width;
     FEdit.Left := FLabel.Width;
     SetLabelStyle(LabelStyle);
     inherited Paint;
end;
}
procedure TPDBEdit.SetActive(Value: Boolean);
begin
     if csLoading in ComponentState then
        FActive := Value
     else
     if Value <> FActive then
     begin
          if Value then
             OpenQuery;
          FActive := Value;
     end;
end;

procedure TPDBEdit.SetText(Value : string);
begin
     if FEdit.Text <> Value then
     begin
        FEdit.Text := Value;
        DataSource.Edit;
        DataSource.DataSet.FieldByName( FEdit.Field.FieldName).AsString := FEdit.Text;
        controlchange(self);
     end;
end;

function TPDBEdit.GetText: string;
begin
     Result := FEdit.Text;
end;

constructor TPDBEdit.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);

     //FDataLink := TDataLink.Create;
     FFieldLink :=  TFieldDataLink.Create;
     FFieldLink.OnDataChange := DataChange;
     FEdit.DataSource := DataSource;

     {FEdit := TDBEdit.Create(Self);
     FEdit.Parent := Self;
     FEdit.Visible := True;
     FEdit.DataSource := DataSource;
     FEdit.Font.Size := 9;
     FEdit.Font.Name := 'ËÎÌו';
     FEdit.OnEnter := ControlEnter;
     FEdit.OnExit := ControlExit;
     FEdit.OnClick := ControlClick;
     FEdit.OnDblClick := ControlDblClick;
     FEdit.OnKeyPress := EditKeyPress;
     }
     //ParentFont := False;

     FFieldLink.Control := FEdit;

     {FLabel.FocusControl := FEdit;

     Height := 24;
     FLabel.Height := Height;
     FEdit.Height := Height;

     FLabel.Width := 50;
     FEdit.Width := 100;
     Width := FLabel.Width + FEdit.Width ;
     FEdit.Left := FLabel.Width;
     FEdit.top:=0;
     FSpace:=0;}
end;

destructor TPDBEdit.Destroy ;
begin
     {FEdit.OnChange := nil;
     FEdit.OnEnter := nil;
     FEdit.OnExit := nil;
     FEdit.Free; }

     //FDataLink.Free ;
     FFieldLink.OnDataChange := nil;
     FFieldLink.Free;
     inherited Destroy;
end;

(*
procedure TPDBEdit.ControlChange(Sender: TObject);
begin
     inherited ControlChange(Sender);
     if Assigned(FOnChange) then
        FOnChange(Self);
end;


procedure TPDBEdit.ControlEnter(Sender: TObject);
begin
     inherited ControlEnter(Sender);
     if Assigned(FOnEnter) then
        FOnEnter(Self);
end;

procedure TPDBEdit.ControlClick(Sender: TObject);
begin
     inherited ControlEnter(Sender);
     if Assigned(FOnClick) then
        FOnClick(Self);
end;

procedure TPDBEdit.ControlDblClick(Sender: TObject);
begin
  if Assigned(FOnDblClick) then
     FOnDblClick(Self);
end;

procedure TPDBEdit.ControlExit(Sender: TObject);
begin
     ControlChange(Self);
     inherited ControlExit(Sender);
     if Assigned(FOnExit) then
        FOnExit(Self);
end;
*)
{
procedure TPDBEdit.EditKeyPress(Sender: TObject; var Key: Char);
begin
     inherited  EditKeyPress(Sender,Key);
     if Key = #13 then
        ControlChange(Self);
end; }

function TPDBEdit.GetDataSource: TDataSource;
begin
  Result := FFieldLink.DataSource ;
end;

procedure TPDBEdit.SetDataSource(Value: TDataSource);
begin
     if Value <> nil then
        Value.FreeNotification(Self);
     FFieldLink.DataSource := Value;   
     if FEdit.DataSource <> Value then
     begin
          FEdit.DataSource := Value;
          {FDataLink.DataSource := Value;
          FDataLink.DataSource.OnDataChange := DataChange;}
     end;
end;

function TPDBEdit.GetDataField: String;
begin
     Result :=  FFieldLink.FieldName ;
end;

procedure TPDBEdit.SetDataField(Value: String);
begin
     FFieldLink.FieldName := Value;
     if FEdit.datafield <> Value then
        FEdit.DataField := Value;
end;
{
procedure TPDBEdit.DataChange(Sender: TObject; Field: TField);
begin
     inherited;
     ControlChange(Self);
end; }

function TPDBEdit.GetEditPasswordChar:Char;
begin
  Result := FEdit.PasswordChar;
end;

procedure TPDBEdit.SetEditPasswordChar(Value:Char);
begin
  FEdit.PasswordChar:= Value;
end;

{
procedure TPDBEdit.SetParentFont(Value: Boolean);
begin
     inherited;
     FEdit.ParentFont := Value;
     Flabel.ParentFont := Value;
     FParentFont := Value;
end; }

procedure TPDBEdit.CMFocusChanged(var Message: TCMFocusChanged);
begin
    if Message.Sender.name = self.Name  then
      FEdit.SetFocus ;
end;

function TPDBEdit.GetReadOnly: Boolean;
begin
     Result := FEdit.ReadOnly ;
end;

procedure TPDBEdit.SetReadOnly(Value: Boolean);
begin
  FEdit.ReadOnly := Value;
end;

{
procedure TPDBEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) and (Acomponent = FSubFieldControl) then
        FSubFieldControl := nil;
end;
}
(*
procedure TPDBEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
     if AHeight < 20 then
        AHeight := 20;
     if AHeight >50 then
        AHeight := 50;
     inherited;

    UpdateCtrlSizes;
  //SetLabelStyle(LabelStyle);
end;


procedure TPDBEdit.SetCaptionWidth(const Value: integer);
begin
  if (FLabel.Width<>Value) and (Value>=0) then
  begin
    FLabel.Width := Value;
    UpdateCtrlSizes;
  end;
end;

procedure TPDBEdit.SetSpace(const Value: integer);
begin
  if (FSpace<>Value) and (Value>=0) then
  begin
    FSpace := Value;
    UpdateCtrlSizes;
  end;
end;

function TPDBEdit.GetCaptionWidth: integer;
begin
  result := FLabel.Width;
end;

procedure TPDBEdit.UpdateCtrlSizes;
begin
  FEdit.Height := Height;
  FLabel.Height := Height;
  FEdit.Width := Width-FLabel.Width-FSpace;
  FEdit.Left := FLabel.Width+FSpace;
end;

function TPDBEdit.GetLabelFont: TFont;
begin
  result := FLabel.Font;
end;

procedure TPDBEdit.SetLabelFont(const Value: TFont);
begin
  FLabel.Font := value;
end;

function TPDBEdit.GetAlignment: TAlignment;
begin
  result := FLabel.Alignment;
end;

procedure TPDBEdit.SetAlignment(const Value: TAlignment);
begin
  FLabel.Alignment := value;
end;
*)

procedure TPDBEdit.CreateEditCtrl;
begin
  FEdit := TDBEdit.Create(Self);
  FEdit.OnChange := ControlChange;
  FEditCtrl:=FEdit;
  Fhelp.visible:=false;
end;

end.
