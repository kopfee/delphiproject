unit LookupControls;

{
  Create By LXM
  Modified By HYL
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stdctrls, dbtables, extctrls, RxCtrls, dbctrls, db, SelectDlg, PLabelPanel
  ,buttons;

type

  EOperationInvalid = class(Exception);

  TLabelStyle = (Normal,Notnil,Conditional,NotnilAndConditional);

 { TPLookupControl }

  TPLookupControl = class(TCustomControl)
  private
    FSpace: integer;
    FOnKeyPress: TKeyPressEvent;
    FKeyFieldCaption: string;
    FListFieldCaption: string;
    { Private declarations }
    procedure SetCaptionWidth(const Value: integer);
    procedure SetSpace(const Value: integer);
    function  GetCaptionWidth: integer;
    procedure SetEditFont(Value: TFont);
    procedure SetEditWidth(Value: integer);
    procedure SetAlignment(const Value: TAlignment);
    function  GetAlignment: TAlignment;
    function  GetEditFont: TFont;
    function  GetEditWidth: integer;
    function  GetHelpVisible: boolean;
    procedure SetHelpVisible(const Value: boolean);
    procedure WMSetFocus(var Message:TMessage); message WM_SetFocus;
    procedure UpdateCtrlSizes;
    procedure SetSubFieldControl(const Value: TControl);
    procedure UpdateListFieldDisplay;
  protected
    { Protected declarations }
    FActive: Boolean;
    FCheckResult : Boolean;
    FDatabaseName: string;
    FFilter: string;
    FHelp : TBitBtn;//TPLookupControlBitBtn;
    FKeyField: string;
    FLabel: TRxLabel;
    FLabelStyle: TLabelStyle;
    FListField: string;
    FOnChange: TNotifyEvent;
    FOnClick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FOnEnter : TNotifyEvent;
    FOnExit  : TNotifyEvent;
    FParentFont : Boolean;
    FQuery: TQuery;
    FSubFieldControl: TControl;
    FTableName: string;

    FEditCtrl : TWinControl;
    function  FindCurrent(var LabelText: string):Boolean;virtual;abstract;
    function  GetCaption:TCaption;
    function  GetLabelFont: TFont;
    function  GetText:string;virtual;abstract;
    procedure ControlChange(Sender: TObject);virtual;
    procedure ControlEnter(Sender: TObject);virtual;
    procedure ControlExit(Sender: TObject);virtual;
    procedure ControlClick(Sender: TObject);virtual;
    procedure ControlDblClick(Sender: TObject); virtual;
    procedure EditKeyPress(Sender: TObject; var Key: Char); virtual;

    procedure DataChange(Sender: TObject);virtual;
    procedure BtnHelpClick(Sender: TObject);virtual;

    procedure Loaded;override;
    procedure OpenQuery;
    procedure SetActive(Value: Boolean);virtual;abstract;
    procedure SetCaption(Value: TCaption);
    procedure SetDatabaseName(Value: string);virtual;
    procedure SetFilter(Value: string);virtual;
    procedure SetLabelFont(Value: TFont);
    procedure SetLabelStyle(Value: TLabelStyle);
    procedure SetLookField(Value: string);virtual;abstract;
    procedure SetLookSubField(Value: string);virtual;abstract;
    procedure SetText(Value : string);virtual;abstract;

    property LabelStyle: TLabelStyle read FLabelStyle write SetLabelStyle ;
    procedure SetParentFont(Value: Boolean);virtual;
    procedure SetTableName(Value: string);
    property Active: Boolean read FActive write SetActive;
    property Caption:TCaption read GetCaption write SetCaption;
    property CheckResult : Boolean read FCheckResult write FCheckResult;
    property KeyField: string read FKeyField write SetLookField;
    property ListField: string read FListField write SetLookSubField;
    property ListFieldControl: TControl read FSubFieldControl write SetSubFieldControl;
    property Filter: string read FFilter write SetFilter;

    property OnKeyPress: TKeyPressEvent read FOnKeyPress write FOnKeyPress;
    property ParentFont : Boolean read FParentFont write SetParentFont;

    procedure   SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;

    procedure   CreateEditCtrl; virtual;abstract;
    property    HelpVisible : boolean read GetHelpVisible Write SetHelpVisible default true;
    property    EditCtrl : TWinControl read FEditCtrl;
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure   DoHelp; virtual;
    function    GetRdOnly: Boolean; virtual;abstract;
    property    KeyFieldCaption : string read FKeyFieldCaption write FKeyFieldCaption;
    property    ListFieldCaption : string read FListFieldCaption write FListFieldCaption;
    function    GetMaxLength: integer; virtual;
    procedure   SetMaxLength(const Value: integer); virtual;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy;override;
    property    DatabaseName: string read FDatabaseName write SetDatabaseName;
    property    TableName: string read FTableName write SetTableName;
    property    Text: string read GetText write SetText;

    procedure   HideHelpButton;
    procedure   ShowHelpButton;
  published
    { Published declarations }
    property  Enabled;
    property OnChange: TNotifyEvent read FOnChange write FOnchange ;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnEnter: TNotifyEvent read FOnEnter write FOnEnter ;
    property OnExit: TNotifyEvent read FOnExit write FOnExit;

    property  LabelFont: TFont read GetLabelFont write SetLabelFont;
    property  Space : integer read FSpace write SetSpace default 0;
    property  CaptionWidth : integer read GetCaptionWidth write SetCaptionWidth;
    property  EditWidth:integer read GetEditWidth write SetEditWidth;
    property  EditFont:TFont read GetEditFont write SetEditFont;
    property  Alignment : TAlignment read GetAlignment write SetAlignment;
    property  MaxLength : integer read GetMaxLength Write SetMaxLength;
  end;

implementation

type
  TControlAccess=class(TControl);
  TWinControlAccess = Class(TWinControl);

constructor TPLookupControl.Create (AOwner: TComponent);
begin
  inherited Create(AOwner);
  //Label
  FLabel := TRxLabel.Create(Self);
  FLabel.Parent := Self;
  FLabel.ShadowSize := 0;
  FLabel.Layout := tlCenter;
  FLabel.AutoSize := False;
  FLabel.Visible := True;
  FLabel.Font.Name := '宋体';
  FLabel.Font.Size := 11;
  FLabel.ParentFont := False;
  LabelStyle := Normal;

  FQuery := TQuery.Create(Self);
  FQuery.Filtered := True;

  //Help Button
  FHelp := TBitBtn.Create(self);
  FHelp.Parent := self;
  FHelp.TabStop := False;
  FHelp.OnClick := BtnHelpClick;
  FHelp.OnExit := ControlExit;
  //Edit Ctrl
  CreateEditCtrl;
  FEditCtrl.Parent := self;
  with TWinControlAccess(FEditCtrl) do
  begin
    Font.Name := '宋体';
    Font.Size := 9;
    OnEnter := ControlEnter;
    OnExit := ControlExit;
    OnClick := ControlClick;
    OnDblClick := ControlDblClick;
    OnKeyPress := EditKeyPress;
  end;

  //set size and pos
  FSpace := 0;
  FLabel.SetBounds(0,0,50,24);
  FEditCtrl.SetBounds(50,0,130,24);
  FHelp.SetBounds(50+130,0,24,24);

  {width := ;
  Height := 24;}
  SetBounds(0,0,50+130+24,24);

  FLabel.FocusControl := FEditCtrl;
end;

destructor TPLookupControl.Destroy;
begin
  FEditCtrl.free;
  FHelp.free;
  FQuery.Free;
  FLabel.Free;
  inherited Destroy;
end;

procedure TPLookupControl.Loaded;
begin
     inherited Loaded;
     if Active then
     begin
          FQuery.Filter := FFilter;
          OpenQuery;
     end;
end;

function TPLookupControl.GetLabelFont: TFont;
begin
     Result := FLabel.Font;
end;

procedure TPLookupControl.SetLabelFont(Value: TFont);
begin
     FLabel.Font := Value;
end;

function TPLookupControl.GetCaption:TCaption;
begin
     Result := FLabel.Caption;
end;

procedure TPLookupControl.SetCaption(Value: TCaption);
begin
     FLabel.Caption := Value;
end;

procedure TPLookupControl.SetDatabaseName(Value: string);
begin
     if csLoading in ComponentState then
        FDatabaseName := Value
     else
         if Active then
         begin
              raise EOperationInvalid.Create('当Active=True时不能改变DataBaseName的值。');
              exit;
         end
         else
             FDatabaseName := Value;
end;

procedure TPLookupControl.SetParentFont(Value : Boolean);
begin
  //Result := FEdit.Font;
end;

procedure TPLookupControl.DataChange(Sender: TObject);
begin
  ControlChange(self);
  UpdateListFieldDisplay;
end;

procedure TPLookupControl.SetTableName(Value: string);
begin
     if csLoading in ComponentState then
        FTableName := Value
     else
         if Active then
         begin
              raise EOperationInvalid.Create('Can''t change TableName while Active is True.');
              exit;
         end
         else
             FTableName := Value;
end;

procedure TPLookupControl.SetLabelStyle (Value: TLabelStyle);
begin
     FLabelStyle := Value;
     case Value of
     Normal: begin
             FLabel.Font.Color := clBlack;
             FLabel.Font.Style := [];
           end;
     Notnil: begin
             FLabel.Font.Color := clTeal;
             FLabel.Font.Style := [];
           end;
     Conditional: begin
             FLabel.Font.Color := clBlack;
             FLabel.Font.Style := [fsUnderline];
           end;
     NotnilAndConditional: begin
             FLabel.Font.Color := clTeal;
             FLabel.Font.Style := [fsUnderline];
           end;
     end;
end;
{
procedure TPLookupControl.OpenQuery;
var temp: string;
begin
     FQuery.Close;
     if FQuery.DatabaseName <> FDatabaseName then
     FQuery.DatabaseName := FDatabaseName;
     FQuery.SQL.Clear;

     if (self.ClassName = 'TPDBStaffEdit') then
//        temp := Format('Select * from %s where %s = ''%s'' ',[FTableName,FKeyField,''])
         temp := 'Select * from '+FTableName
     else
     if (FKeyField <> '') and (Text <> '') then
        temp := Format('Select * from %s where %s = ''%s'' ',[FTableName,FKeyField,Text])
     else
         temp := 'Select * from '+FTableName ;

     FQuery.SQL.Add(temp);
     FQuery.Open;
end; }

procedure TPLookupControl.OpenQuery;
var
  temp: string;
begin
     FQuery.Close;
     if FQuery.DatabaseName <> FDatabaseName then
     FQuery.DatabaseName := FDatabaseName;
     FQuery.SQL.Clear;

     temp := 'Select * from '+FTableName ;

     FQuery.SQL.Add(temp);
     FQuery.Open;
end;

procedure TPLookupControl.SetFilter(Value: string);
begin
     if FFilter <> Value then
     begin
          FFilter := Value;
          FQuery.Filter := Value;
     end;
end;

procedure TPLookupControl.ControlChange(Sender: TObject);
begin
  //UpdateListFieldDisplay;
  if Assigned(FOnChange) then
    FOnChange(Self);
  if (GetText='') and (FSubFieldControl<>nil) then
    TControlAccess(FSubFieldControl).text := '';
end;

procedure TPLookupControl.ControlClick(Sender: TObject);
begin
  //   inherited;
  if Assigned(FOnClick) then
        FOnClick(Self);
end;

procedure TPLookupControl.ControlEnter(Sender: TObject);
begin
   if Active then
      if not FQuery.Active then
        OpenQuery;
   if Assigned(FOnEnter) then
     FOnEnter(Self);
end;

procedure TPLookupControl.ControlExit(Sender: TObject);
var LabelText: string;
begin
     if (Screen.ActiveControl=FHelp) or (Screen.ActiveControl=FEditCtrl) then exit;
     if FActive then
     begin
          if not FindCurrent(LabelText) then
          begin
               FCheckResult := False;
          end
          else
          begin
               FCheckResult := True;
          end;
     end;
     if Assigned(FOnExit) then
        FOnExit(Self);
end;

procedure TPLookupControl.ControlDblClick(Sender: TObject);
begin
  if Assigned(FOnDblClick) then
     FOnDblClick(Self);
  if HelpVisible then
    DoHelp;   
end;

procedure TPLookupControl.EditKeyPress(Sender: TObject; var Key: Char);
begin
  IF assigned(FOnKeyPress) then
    FOnKeyPress(sender,key);
    
  if Key = #13 then
    UpdateListFieldDisplay;
end;

(*******  New ********)

function TPLookupControl.GetAlignment: TAlignment;
begin
  result := FLabel.Alignment;
end;

procedure TPLookupControl.SetAlignment(const Value: TAlignment);
begin
  FLabel.Alignment := value;
end;

function TPLookupControl.GetCaptionWidth: integer;
begin
  result := FLabel.Width;
end;

procedure TPLookupControl.SetCaptionWidth(const Value: integer);
begin
  if (FLabel.Width<>Value) and (Value>=0) then
  begin
    FLabel.Width := Value;
    UpdateCtrlSizes;
  end;
end;

function TPLookupControl.GetEditFont: TFont;
begin
  result := TWinControlAccess(EditCtrl).Font;
end;

procedure TPLookupControl.SetEditFont(Value: TFont);
begin
  TWinControlAccess(EditCtrl).Font.Assign(Value);
end;

function TPLookupControl.GetEditWidth: integer;
begin
  Result := FEditCtrl.Width;
end;

procedure TPLookupControl.SetEditWidth(Value: integer);
begin
  if FHelp.Visible then
    SetCaptionWidth(Width-Value-FSpace-FHelp.width)
  else
    SetCaptionWidth(Width-Value-FSpace);
end;

procedure TPLookupControl.SetSpace(const Value: integer);
begin
  if (FSpace<>Value) and (Value>=0) then
  begin
    FSpace := Value;
    UpdateCtrlSizes;
  end;
end;

procedure TPLookupControl.UpdateCtrlSizes;
begin
  FEditCtrl.Height := Height;
  FLabel.Height := Height;
  FHelp.Height := Height;

  if FHelp.Visible then
  begin
    FEditCtrl.Width := Width-FLabel.Width-FSpace-FHelp.Width;
    FHelp.left := FLabel.Width+FSpace+FEditCtrl.Width;
  end
  else
  begin
    FEditCtrl.Width := Width-FLabel.Width-FSpace;
  end;
  FEditCtrl.Left := FLabel.Width+FSpace;
end;

procedure TPLookupControl.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  UpdateCtrlSizes;
end;

function TPLookupControl.GetHelpVisible: boolean;
begin
  result := FHelp.Visible;
end;

procedure TPLookupControl.SetHelpVisible(const Value: boolean);
begin
  if FHelp.Visible <>value then
  begin
    FHelp.Visible := value;
    UpdateCtrlSizes;
  end;
end;


procedure TPLookupControl.HideHelpButton;
begin
  HelpVisible:=false;
end;

procedure TPLookupControl.ShowHelpButton;
begin
  HelpVisible:=true;
end;

procedure TPLookupControl.WMSetFocus(var Message: TMessage);
begin
  inherited;
  if FEditCtrl.CanFocus then FEditCtrl.SetFocus;
end;

procedure TPLookupControl.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (Operation = opRemove) and (Acomponent = FSubFieldControl) then
    FSubFieldControl := nil;
end;

procedure TPLookupControl.SetSubFieldControl(const Value: TControl);
begin
  if FSubFieldControl <> Value then
  begin
    FSubFieldControl := Value;
    if FSubFieldControl<>nil then
      FSubFieldControl.FreeNotification(self);
  end;
end;

procedure TPLookupControl.UpdateListFieldDisplay;
var
  LabelText: string;
begin
  if Assigned(FSubFieldControl) and FActive then
     begin
          LabelText := '';
          if FindCurrent(LabelText) then
          begin
             {  if FSubFieldControl is TPLabelPanel then
                  (FSubFieldControl as TPLabelPanel).Caption := LabelText ;}
             TControlAccess(FSubFieldControl).text := LabelText;
               FCheckResult := True;
          end
          else
          begin
             {  if FSubFieldControl is TPLabelPanel then
                  (FSubFieldControl as TPLabelPanel).Caption := '';}
             TControlAccess(FSubFieldControl).text := '';
               FCheckResult := False;
          end;
     end;
end;

procedure TPLookupControl.DoHelp;
var
  SltDlg: TfrmSelectDlg;
begin
  if (not GetRdOnly) {and (not FQuery.IsEmpty)} then
  begin
       SltDlg := TfrmSelectDlg.Create(Self);
       try
         with SltDlg do
         begin
            SelectDataSource.DataSet := FQuery;
            grdSelect.Columns.Clear;
            grdSelect.Columns.Add;//添加第一列
            grdSelect.Columns.Items[0].FieldName := FKeyField;
            if FKeyFieldCaption = '' then
              grdSelect.Columns.Items[0].Title.Caption := grdSelect.Columns.Items[0].FieldName
            else
              grdSelect.Columns.Items[0].Title.Caption := FKeyFieldCaption;

            if FKeyFieldCaption = '' then
              SltDlg.FindKey.Items.Add(grdSelect.Columns.Items[0].FieldName)
            else
              SltDlg.FindKey.Items.Add(FKeyFieldCaption);

            if FListField <> '' then
            begin
              grdSelect.Columns.Items[0].Title.Font.Size := 10;
              grdSelect.Columns.Items[0].Width := (Width - 40) div 2;

              grdSelect.Columns.Add;  //添加第二列
              grdSelect.Columns.Items[1].FieldName := FListField;
              if FListFieldCaption = '' then
                grdSelect.Columns.Items[1].Title.Caption := grdSelect.Columns.Items[1].FieldName
              else
                grdSelect.Columns.Items[1].Title.Caption := FListFieldCaption;
              grdSelect.Columns.Items[1].Title.Font.Size := 10;
              grdSelect.Columns.Items[1].Width := (Width - 40) div 2;


              if FListFieldCaption = '' then
                SltDlg.FindKey.Items.Add(grdSelect.Columns.Items[1].FieldName)
              else
                SltDlg.FindKey.Items.Add(FListFieldCaption);
            end
            else
            begin
              grdSelect.columns.Items[0].Width := grdSelect.Width-10;
              grdSelect.Columns.Items[0].Title.Font.Size := 40;
            end;

            FindKey.ItemIndex := 0;
        end;

        if SltDlg.Execute(KeyField,getText) then
        begin
        {    FEdit.DataSource.DataSet.Edit;
            FEdit.Text := FQuery.FieldByName(KeyField).AsString;
            ControlChange(Self); }
          SetText(FQuery.FieldByName(KeyField).AsString);
        end;
        UpdateListFieldDisplay;
      finally
        SltDlg.Free;
        //OpenQuery;
      end;
  end;
  if FEditCtrl.CanFocus then FEditCtrl.SetFocus; 
end;

procedure TPLookupControl.BtnHelpClick(Sender: TObject);
begin
  DoHelp;
end;

type
  TEditAccess=class(TCustomEdit);
  TComboBoxAccess=class(TCustomComboBox);

function TPLookupControl.GetMaxLength: integer;
begin
  if FEditCtrl is TCustomEdit then
    result:=TEditAccess(FEditCtrl).MaxLength
  else if FEditCtrl is  TCustomComboBox then
    result:=TComboBoxAccess(FEditCtrl).MaxLength
  else result:=0;
end;

procedure TPLookupControl.SetMaxLength(const Value: integer);
begin
  if FEditCtrl is TCustomEdit then
    TEditAccess(FEditCtrl).MaxLength:=value
  else if FEditCtrl is  TCustomComboBox then
    TComboBoxAccess(FEditCtrl).MaxLength:=value;
end;

end.
