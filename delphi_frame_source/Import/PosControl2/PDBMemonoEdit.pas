unit PDBMemonoEdit;

interface

uses
  Windows,  Messages, SysUtils, Classes, Graphics, Controls, Forms,     Dialogs,
  stdctrls, dbtables, extctrls, RxCtrls, dbctrls,  db,       SelectDlg, PLabelPanel
  ,buttons, LookupControls,PDBCustomMemonoEdit;

type
  TPDBMemonoEdit = class(TPLookupControl)
  private
    { Private declarations }
    //FDataLink: TDataLink;
    FEdit: TPDBCustomMemonoEdit;
    FFieldLink: TFieldDataLink;
    FPartialKey: Boolean;
    //FParentFont: Boolean;
  protected
    { Protected declarations }
    {function GetEditFont:TFont;
    function GetEditWidth:integer;}
    function GetDataField: String;
    function GetDataSource: TDataSource;
    function GetEnPreFix: Boolean;
    function GetRdOnly:Boolean; override;
    function GetReadOnly: Boolean;
    function GetText:string;override;

    //procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    {procedure ControlChange(Sender: TObject);override;
    procedure ControlClick(Sender: TObject);override;
    procedure ControlDblClick(Sender: TObject); override;
    procedure ControlEnter(Sender: TObject);override;
    procedure ControlExit(Sender: TObject);override;
    procedure DataChange(Sender: TObject; Field: TField);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;}
    procedure SetDataField(Value: String);
    procedure SetDataSource(Value: TDataSource);
    //procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure SetActive(Value: Boolean);override;
    {procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetEditFont(Value: TFont);
    procedure SetEditWidth(Value: integer);}
    procedure SetEnPreFix(Value: Boolean);
    //procedure SetParentFont(Value: Boolean);override;
    procedure SetRdOnly(Value: Boolean);
    procedure SetReadOnly(Value: Boolean);
    //procedure Paint;override;
    procedure SetText(Value : string);override;
    procedure   CreateEditCtrl; override;
  public
     { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    property CheckResult;
    procedure HideHelpButton;
    procedure ShowHelpButton;
  published
    property Active;
    property Caption;
    property DataField: string read GetDataField write SetDataField;
    property DataSource :TDataSource read GetDataSource write SetDataSource;
    {property EditFont:TFont read GetEditFont write SetEditFont;
    property EditWidth:integer read GetEditWidth write SetEditWidth;}
    property EnPreFix: Boolean read GetEnPreFix write SetEnPreFix;
    property Filter;
    property LabelStyle;
    property ListFieldControl;
    //property ParentFont : Boolean read FParentFont write SetParentFont;
    property PartialKey:Boolean read FPartialKey write FPartialKey;
    property ReadOnly: Boolean read GetReadOnly Write SetReadOnly;
    property RdOnly: Boolean read GetRdOnly write SetRdOnly;
    property TabOrder;
    property TabStop;

    {property OnChange;
    property OnEnter ;
    property OnExit  ;
    property OnClick;
    property OnDblClick;}
  end;

procedure Register;

implementation

function TPDBMemonoEdit.GetRdOnly:Boolean;
begin
     Result := FEdit.ReadOnly;
end;

procedure TPDBMemonoEdit.SetRdOnly(Value: Boolean);
begin
     FEdit.ReadOnly := Value;
     if Value then
        FEdit.Color := clSilver
     else
         FEdit.Color := clWhite;
end;

{
function TPDBMemonoEdit.GetEditWidth:integer;
begin
     Result := FEdit.Width;
end;

procedure TPDBMemonoEdit.SetEditWidth(Value: integer);
begin
     FEdit.Width := Value;
     FEdit.Left := Width-Value;
     FLabel.Width := FEdit.Left;
end;

function TPDBMemonoEdit.GetEditFont:TFont;
begin
     Result := FEdit.Font;
end;

procedure TPDBMemonoEdit.SetEditFont(Value: TFont);
begin
     FEdit.Font.Assign(Value);
     FLabel.Font.Assign(Value);
     FLabel.Height := FEdit.Height;
     Height := FEdit.Height;
     SetLabelStyle(LabelStyle);
end;

procedure TPDBMemonoEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
     if AHeight < 20 then
        AHeight := 20;
     if AHeight >50 then
        AHeight := 50;
     inherited;
     FEdit.Height := AHeight;
     FLabel.Height := AHeight;
end;

procedure TPDBMemonoEdit.Paint;
begin
     FLabel.Height := Height;
     FEdit.Height := Height;
     FLabel.Width := Width-FEdit.Width;
     FEdit.Left := FLabel.Width;
     SetLabelStyle(LabelStyle);
     inherited Paint;
end;
}
procedure TPDBMemonoEdit.SetActive(Value: Boolean);
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

procedure TPDBMemonoEdit.SetText(Value : string);
begin
     if FEdit.Text <> Value then
     begin
        FEdit.Text := Value;
        DataSource.Edit;
        DataSource.DataSet.FieldByName( FEdit.Field.FieldName).AsString := FEdit.Text;
        controlchange(self);
     end;
end;

function TPDBMemonoEdit.GetText: string;
begin
     Result := FEdit.Text;
end;
{
procedure TPDBMemonoEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
     if (Operation = opRemove) and (Acomponent = FSubFieldControl) then
        FSubFieldControl := nil;
end; }

constructor TPDBMemonoEdit.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);

     //FDataLink := TDataLink.Create;
     FFieldLink :=  TFieldDataLink.Create;
     FFieldLink.OnDataChange := DataChange;

     {FEdit := TPDBCustomMemonoEdit.Create(Self);
     FEdit.Parent := Self;
     FEdit.Visible := True;}
     FEdit.DataSource := DataSource;
     {FEdit.Font.Size := 9;
     FEdit.Font.Name := 'ËÎÌו';
     FEdit.OnEnter := ControlEnter;
     FEdit.OnExit := ControlExit;
     FEdit.OnClick := ControlClick;
     FEdit.OnDblClick := ControlDblClick;
     FEdit.OnKeyPress := EditKeyPress;

     FFieldLink.Control := FEdit;

     FLabel.FocusControl := FEdit;

     LabelStyle := Normal;

     Height := 20;
     FLabel.Height := Height;
     FEdit.Height := Height;

     FLabel.Width := 50;
     FEdit.Width := 100;
     Width := FLabel.Width + FEdit.Width ;
     FEdit.Left := FLabel.Width;

     ParentFont := False;
     }
end;

destructor TPDBMemonoEdit.Destroy ;
begin
     {FEdit.OnChange := nil;
     FEdit.OnEnter := nil;
     FEdit.OnExit := nil;
     FEdit.Free;}

     //FDataLink.Free ;
     FFieldLink.OnDataChange := nil;
     FFieldLink.Free;
     inherited Destroy;
end;
{
procedure TPDBMemonoEdit.ControlChange(Sender: TObject);
begin
     inherited ControlChange(Sender);
     if Assigned(FOnChange) then
        FOnChange(Self);
end;

procedure TPDBMemonoEdit.ControlEnter(Sender: TObject);
begin
     inherited ControlEnter(Sender);
     if Assigned(FOnEnter) then
        FOnEnter(Self);
end;

procedure TPDBMemonoEdit.ControlClick(Sender: TObject);
begin
     inherited ControlEnter(Sender);
     if Assigned(FOnClick) then
        FOnClick(Self);
end;

procedure TPDBMemonoEdit.ControlDblClick(Sender: TObject);
begin
  if Assigned(FOnDblClick) then
     FOnDblClick(Self);
end;

procedure TPDBMemonoEdit.EditKeyPress(Sender: TObject; var Key: Char);
begin
     inherited  ;
     if Key = #13 then
        ControlChange(Self);
end;

procedure TPDBMemonoEdit.ControlExit(Sender: TObject);
begin
     ControlChange(Self);
     inherited ControlExit(Sender);
     if Assigned(FOnExit) then
        FOnExit(Self);
end; }


function TPDBMemonoEdit.GetDataSource: TDataSource;
begin
     Result := FFieldLink.DataSource ;
end;

procedure TPDBMemonoEdit.SetDataSource(Value: TDataSource);
begin
     if Value <> nil then
        Value.FreeNotification(Self);
     {if FDataLink.DataSource <> Value then
     begin
        FDataLink.DataSource := Value;
        FEdit.DataSource := Value;
        FDataLink.DataSource.OnDataChange := DataChange;
     end;}
     FFieldLink.DataSource := Value;
     FEdit.DataSource := Value;
end;

function TPDBMemonoEdit.GetDataField: String;
begin
     Result :=  FFieldLink.FieldName ;
end;

procedure TPDBMemonoEdit.SetDataField(Value: String);
begin
     FFieldLink.FieldName := Value;
     if FEdit.datafield <> Value then
        FEdit.DataField := Value;
end;
{
procedure TPDBMemonoEdit.DataChange(Sender: TObject; Field: TField);
begin
     inherited;
     ControlChange(Self);
end; }
{
procedure TPDBMemonoEdit.CMFocusChanged(var Message: TCMFocusChanged);
begin
    if Message.Sender.name = self.Name  then
      FEdit.SetFocus ;
end;}

function TPDBMemonoEdit.GetEnPreFix: Boolean;
begin
     Result := FEdit.EnPreFix;
end;

procedure TPDBMemonoEdit.SetEnPreFix(Value: Boolean);
begin
     FEdit.EnPreFix := Value;
end;

procedure TPDBMemonoEdit.HideHelpButton;
begin
     FHelp.Visible := False;
end;

procedure TPDBMemonoEdit.ShowHelpButton;
begin
     FHelp.Visible := True;
end;
{
procedure TPDBMemonoEdit.SetParentFont(Value: Boolean);
begin
     inherited;
     FEdit.ParentFont := Value;
     Flabel.ParentFont := Value;
     FParentFont := Value;
end;
}
function TPDBMemonoEdit.GetReadOnly: Boolean;
begin
     Result := FEdit.ReadOnly ;
end;

procedure TPDBMemonoEdit.SetReadOnly(Value: Boolean);
begin
     FEdit.ReadOnly := Value;
end;

procedure Register;
begin
     RegisterComponents('PosControl', [TPDBMemonoEdit]);
end;

procedure TPDBMemonoEdit.CreateEditCtrl;
begin
  FEdit := TPDBCustomMemonoEdit.Create(Self);
  FEdit.OnChange:=ControlChange;
  FEditCtrl:=FEdit;
  FHelp.Visible:=false;
end;

end.
