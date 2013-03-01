unit PDBLookupCombox;

interface

uses
  Windows,   Messages, SysUtils, Classes, Graphics, Controls, Forms,     Dialogs,
  stdctrls,  dbtables, extctrls, RxCtrls, dbctrls,  db,       SelectDlg, PLabelPanel,
  buttons,   LookupControls;

type
  TPDBLookupCombox = class(TPLookupControl)
  private
    { Private declarations }
    FCompanyList: TStrings;
    FComboBox: TDBComboBox;
    //FDataLink: TDataLink;
    FFieldLink: TFieldDataLink;
    //FParentFont: Boolean;
  protected
    { Protected declarations }
    function FindCurrent(var LabelText: string):Boolean;override;
    {function GetComboBoxFont:TFont;
    function GetComboBoxWidth:integer;}
    function GetDataField:string;
    function GetDataSource:TDataSource;
    function GetRdOnly:Boolean; override;
    function GetReadOnly: Boolean;
    function GetText:string;override;

    //procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure ControlChange(Sender: TObject);override;
    procedure ControlEnter(Sender: TObject);override;
    procedure ControlExit(Sender: TObject);override;
    procedure FillComboBox;
    procedure Loaded;override;
    //procedure Paint;override;
    //procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetActive(Value: Boolean);override;
    {procedure SetComboBoxFont(Value: TFont);
    procedure SetComboBoxWidth(Value: integer);}
    procedure SetDataField(Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetFilter(Value: string);override;
//    procedure SetHeight(Value: integer);
    procedure SetLookField(Value: string);override;
    procedure SetLookSubField(Value: string);override;
    procedure SetRdOnly(Value: Boolean);
    procedure SetReadOnly(Value: Boolean);
    //procedure SetParentFont(Value: Boolean);override;
    procedure SetText(Value : string);override;
    procedure   CreateEditCtrl; override;
  public
     { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
  published
    property Active;
    property CheckResult ;
    property Caption;
    property DatabaseName;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    //property ComboBoxWidth:integer read GetComboBoxWidth write SetComboBoxWidth;
    //property ComboBoxFont:TFont read GetComboBoxFont write SetComboBoxFont;
//    property Height: integer read GetHeight Write SetHeight;
    property Filter;
    property LabelStyle;
    property ListField;
    property ListFieldControl;
    property KeyField;
    //property ParentFont : Boolean read FParentFont write SetParentFont;
    property RdOnly: Boolean read GetRdOnly write SetRdOnly;
    property ReadOnly: Boolean read GetReadOnly Write SetReadOnly;
    property TabOrder;
    property TableName;
    property TabStop;

    property OnChange;
    property OnEnter ;
    property OnExit  ;
  end;

procedure Register;

implementation

function TPDBLookupCombox.GetRdOnly:Boolean;
begin
     Result := FComboBox.ReadOnly;
end;

procedure TPDBLookupCombox.SetRdOnly(Value: Boolean);
begin
     FComboBox.ReadOnly := Value;
     if Value then
        FComboBox.Color := clSilver
     else
         FComboBox.Color := clWhite;
end;
{
function TPDBLookupCombox.GetComboBoxWidth:integer;
begin
     Result := FComboBox.Width;
end;

procedure TPDBLookupCombox.SetComboBoxWidth(Value: integer);
begin
     FComboBox.Width := Value;
     FComboBox.Left := Width-Value;
     FLabel.Width := FComboBox.Left;
end;

function TPDBLookupCombox.GetComboBoxFont:TFont;
begin
     Result := FComboBox.Font;
end;

procedure TPDBLookupCombox.SetComboBoxFont(Value: TFont);
begin
     FComboBox.Font.Assign(Value);
     FLabel.Font.Assign(Value);
     FLabel.Height := FComboBox.Height;
     Height := FComboBox.Height;
     SetLabelStyle(LabelStyle);
end; }

procedure TPDBLookupCombox.FillComboBox;
begin
     FComboBox.Items.Clear;
     FCompanyList.Clear;
     if not FQuery.IsEmpty then
     begin
          FQuery.First;
          while not FQuery.EOF do
          begin
               FComboBox.Items.Add(FQuery.FieldByName(FListField).AsString);
               if FListField <> '' then
                  FCompanyList.Add(FQuery.FieldByName(FKeyField).AsString)
               else
                   FCompanyList.Add('');
               FQuery.Next;
          end;
    end;
end;
{
procedure TPDBLookupCombox.Paint;
begin
     FLabel.Height := FComboBox.Height;
     Height := FComboBox.Height;
     FComboBox.Left := Width-FComboBox.Width;
     FLabel.Width := FComboBox.Left;
     SetLabelStyle(LabelStyle);
     inherited Paint;
end; }

procedure TPDBLookupCombox.Loaded;
begin
     inherited Loaded;
     if Active then
        FillComboBox;

end;

procedure TPDBLookupCombox.SetActive(Value: Boolean);
begin
     if csLoading in ComponentState then
        FActive := Value
     else
         if Value <> FActive then
         begin
              if Value then
              begin
                   OpenQuery;
                   FillComboBox;
              end
              else
              begin
                   FComboBox.Items.Clear;
                   FCompanyList.Clear;
              end;
              FActive := Value;
         end;
end;

procedure TPDBLookupCombox.SetText(Value : string);
begin
     if FComboBox.Text <> Value then
     begin
        FComboBox.Text := Value;
        DataSource.Edit;
        DataSource.DataSet.FieldByName( FComboBox.Field.FieldName).AsString := FComboBox.Text;
        controlchange(self);
     end;
end;

function TPDBLookupCombox.GetText: string;
begin
     Result := FComboBox.Text;
end;

procedure TPDBLookupCombox.SetLookField(Value: string);
begin
     if FKeyField <> Value then
     begin
          FKeyField := Value;
          if (not (csLoading in ComponentState)) and FActive then
             FillComboBox;
     end;
end;

procedure TPDBLookupCombox.SetLookSubField(Value: string);
begin
     if FListField <> Value then
     begin
          FListField := Value;
          if (not (csLoading in ComponentState)) and FActive then
             FillComboBox;
     end;
end;

procedure TPDBLookupCombox.SetFilter(Value: string);
begin
     if FFilter <> Value then
     begin
          inherited SetFilter(Value);
          FillComboBox;
     end;
end;

{
procedure TPDBLookupCombox.DataChange(Sender: TObject; Field: TField);
begin
     inherited;
     ControlChange(self);
end;
}
function TPDBLookupCombox.FindCurrent(var LabelText: string):Boolean;
var idx: integer;
begin
     idx := FComboBox.Items.IndexOf(Text);
     if idx >= 0 then
     begin
          Result := True;
          LabelText := text;
     end
     else
     begin
          idx := FCompanylist.indexof(text);
          if idx >= 0 then
          begin
               Result := True;
               LabelText := FComboBox.Items.Strings[idx];//FCompanyList.Strings[idx];
          end
          else
          begin
               Result := False;
               LabelText := '';
          end;

     end;
end;

procedure TPDBLookupCombox.ControlChange(Sender: TObject);
begin
    { if FComboBox.Text <> '' then inherited ControlChange(Sender)
     else
     begin
      if FSubFieldControl is TPLabelPanel then
        (FSubFieldControl as TPLabelPanel).Caption := '' ;
	  FCheckResult := False;
     end;
     if Assigned(FOnChange) then
        FOnChange(Self); }
   inherited ControlChange(Sender);
end;

procedure TPDBLookupCombox.ControlEnter(Sender: TObject);
begin
   {  if Active then
     begin
          inherited ControlEnter(Sender);
          FillComboBox;
     end;
     if Assigned(FOnEnter) then
        FOnEnter(Self); }
  if Active then FillComboBox;
  inherited ControlEnter(Sender);
end;

procedure TPDBLookupCombox.ControlExit(Sender: TObject);
var idx: integer;
begin
     idx := FComboBox.Items.IndexOf(Text);
     if idx >= 0 then
     begin
          Text := FCompanyList[idx];
          (FSubFieldControl as TPLabelPanel).Caption := FComboBox.Items.Strings[idx];
     end
     else
     begin
          idx := FCompanyList.IndexOf(Text);
          if idx >= 0 then
          begin
               Text := FCompanyList[idx];
               (FSubFieldControl as TPLabelPanel).Caption := FComboBox.Items.Strings[idx]
          end;
     end;
     inherited ControlExit(Sender);
     {if Assigned(FOnExit) then
        FOnExit(Self); }
end;

constructor TPDBLookupCombox.Create (AOwner: TComponent);
begin
     inherited Create(AOwner);

     //FDataLink := TDataLink.Create;
     FFieldLink :=  TFieldDataLink.Create;
     FFieldLink.OnDataChange := DataChange;
     //FComboBox := TDBComboBox.Create(Self);
     FComboBox.DataSource := DataSource;
     {FComboBox.Font.Size := 9;
     FComboBox.font.Name := 'ËÎÌו';
     FComboBox.OnChange := ControlChange;
     {FComboBox.OnEnter := ControlEnter;
     FComboBox.OnExit := ControlExit;
     FComboBox.Parent := Self;
     FComboBox.Visible := True;

     FFieldLink.Control := FComboBox;

     FLabel.FocusControl := FComboBox;

     Height := 20;
     FComboBox.Height := 20;
     FLabel.Height := FComboBox.Height;

     FLabel.Width := 60;
     FComboBox.Width :=120;
     FComboBox.Left:=60;
     Width := FLabel.Width+FComboBox.Width;

     TabStop := True;
     ParentFont := False;}

     FCompanyList := TStringList.Create;
end;

destructor TPDBLookupCombox.Destroy;
begin
     {FComboBox.OnChange := nil;
     FComboBox.OnEnter := nil;
     FComboBox.OnExit := nil;
     FComboBox.Free;}

     //FDataLink.Free ;
     FFieldLink.Free ;

     FCompanyList.Free;
     inherited Destroy;
end;

function TPDBLookupCombox.GetDataField:string;
begin
     Result := FFieldLink.FieldName;
end;

procedure TPDBLookupCombox.SetDataField(Value: string);
begin
     FFieldLink.FieldName := Value;
     if FComboBox.DataField <> Value then
        FComboBox.DataField := Value;
end;

function TPDBLookupCombox.GetDataSource:TDataSource;
begin
     Result := FFieldLink.DataSource;
end;

procedure TPDBLookupCombox.SetDataSource(Value: TDataSource);
begin
     //FDataLink.DataSource := Value;
     //FDataLink.DataSource.OnDataChange := DataChange;
  FFieldLink.DataSource := Value;
  FComboBox.DataSource := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
end;

{
procedure TPDBLookupCombox.SetParentFont(Value: Boolean);
begin
     inherited;
     FComboBox.ParentFont := Value;
     Flabel.ParentFont := Value;
     FParentFont := Value;
end;
}
function TPDBLookupCombox.GetReadOnly: Boolean;
begin
     Result := FComboBox.ReadOnly ;
end;

procedure TPDBLookupCombox.SetReadOnly(Value: Boolean);
begin
     FComboBox.ReadOnly := Value;
end;
{
procedure TPDBLookupCombox.CMFocusChanged(var Message: TCMFocusChanged);
begin
    if Message.Sender.name = self.Name  then
      FComboBox.SetFocus ;
end; }
{
procedure TPDBLookupCombox.Notification(AComponent: TComponent; Operation: TOperation);
begin
     if (Operation = opRemove) and (Acomponent = FSubFieldControl) then
        FSubFieldControl := nil;
end; }

{
procedure TPDBLookupCombox.SetHeight(Value: integer);
begin
     FComboBox.Height := Value;
     FLabel.Height := Value;
end;

function TPDBLookupCombox.GetHeight;
begin
     Result := FComboBox.Height;
end;
}
procedure Register;
begin
     RegisterComponents('PosControl', [TPDBLookupCombox]);
end;

procedure TPDBLookupCombox.CreateEditCtrl;
begin
  FComboBox := TDBComboBox.Create(Self);
  FComboBox.OnChange := ControlChange;
  FEditCtrl := FComboBox;
  FHelp.visible := false;
end;

end.
