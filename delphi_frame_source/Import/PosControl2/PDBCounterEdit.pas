unit PDBCounterEdit;

interface

uses
  Windows,  Messages, SysUtils, Classes, Graphics, Controls, Forms,     Dialogs,
  stdctrls, dbtables, extctrls, RxCtrls, dbctrls,  db,       SelectDlg, PLabelPanel
  ,buttons, LookupControls;

type
  TPDBCounterEdit = class(TPLookupControl)
  private
    { Private declarations }
    FEdit: TDBEdit;
    //FDataLink: TDataLink;
    FFieldLink: TFieldDataLink;
    FFormat: string;
    {FKeyFieldCaption: string;
    FListFieldCaption: string;}
    FPartialKey: Boolean;
    //FParentFont: Boolean;
    FCheckResult: Boolean;
  protected
    { Protected declarations }
    function FindCurrent(var LabelText: string):Boolean;override;
    function GetDataSource: TDataSource;
    function GetDataField: String;
    {function GetEditFont: TFont;
    function GetEditWidth: integer;}
    function GetRdOnly: Boolean; override;
    function GetReadOnly: Boolean;
    function GetText: string; override;

    //procedure BtnHelpClick(Sender: TObject);
    procedure CheckFormat;
    //procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure ControlChange(Sender: TObject);override;
    {procedure ControlClick(Sender: TObject);override;
    procedure ControlDblClick(Sender: TObject); override;
    procedure ControlEnter(Sender: TObject);override;
    procedure ControlExit(Sender: TObject);override;
    procedure DataChange(Sender: TObject; Field: TField);
    procedure EditKeyPress(Sender: TObject; var Key: Char);override;}
//    procedure OpenQuery;override;
    //procedure Paint;override;
    procedure SetActive(Value: Boolean);override;
    //procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetDatabaseName(Value: string);override;
    procedure SetDataSource(Value: TDataSource);
    procedure SetDataField(Value: String);
    {procedure SetEditFont(Value: TFont);
    procedure SetEditWidth(Value: integer);}
    procedure SetLookField(Value: string);override;
    procedure SetLookSubField(Value: string);override;
    //procedure SetParentFont(Value: Boolean);override;
    procedure SetRdOnly(Value: Boolean);
    procedure SetReadOnly(Value: Boolean);
    procedure SetText(Value : string);override;

    procedure   CreateEditCtrl; override;
  public
     { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy;override;
    property    CheckResult;
    {procedure HideHelpButton;
    procedure ShowHelpButton;}
    //procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
  published
    property Active;
    property Caption;
    property DatabaseName;
    property DataField: string read GetDataField write SetDataField;
    property DataSource:TDataSource read GetDataSource write SetDataSource;
    {property EditWidth:integer read GetEditWidth write SetEditWidth;
    property EditFont:TFont read GetEditFont write SetEditFont;}
    property Filter;
    property FormatIsOk: Boolean read FCheckResult write FCheckResult;
    property LabelStyle;
    property ListFieldControl;
    property RdOnly: Boolean read GetRdOnly write SetRdOnly;
    property ReadOnly: Boolean read GetReadOnly Write SetReadOnly;
    //property ParentFont: Boolean read FParentFont write SetParentFont;
    property PartialKey:Boolean read FPartialKey write FPartialKey;
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

procedure Register;
begin
  RegisterComponents('PosControl', [TPDBCounterEdit]);
end;

{
procedure TPDBCounterEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
     if AHeight < 20 then
        AHeight := 20;
     if AHeight >50 then
        AHeight := 50;
     inherited;
     FEdit.Height := AHeight;
     FLabel.Height := AHeight;
     FHelp.Height := AHeight;
     FEdit.Width := FEdit.Width + FHelp.Width -FHelp.Height;
     FHelp.Width := FHelp.Height;
     FLabel.Width := AWidth-FEdit.Width -FHelp.Width - 2;
     FEdit.Left := FLabel.Width;
     FHelp.Left := FLabel.Width + FEdit.Width + 2;
end;
}
function TPDBCounterEdit.GetRdOnly:Boolean;
begin
     Result := FEdit.ReadOnly;
end;

procedure TPDBCounterEdit.SetRdOnly(Value: Boolean);
begin
     FEdit.ReadOnly := Value;
     if Value then
        FEdit.Color := clSilver
     else
         FEdit.Color := clWhite;
end;

{
function TPDBCounterEdit.GetEditWidth:integer;
begin
     Result := FEdit.Width;
end;

procedure TPDBCounterEdit.SetEditWidth(Value: integer);
begin
     FEdit.Width := Value;
     FEdit.Left := Width-Value;
     FLabel.Width := FEdit.Left;
end;

function TPDBCounterEdit.GetEditFont:TFont;
begin
     Result := FEdit.Font;
end;

procedure TPDBCounterEdit.SetEditFont(Value: TFont);
begin
     FEdit.Font.Assign(Value);
     FLabel.Font.Assign(Value);
     FLabel.Height := FEdit.Height;
     Height := FEdit.Height;
     SetLabelStyle(LabelStyle);
end;
}

procedure TPDBCounterEdit.SetDatabaseName(Value: string);
begin
     inherited;
     if csLoading in ComponentState then
     begin
          FDatabaseName := Value;
          TableName := 'tbCounter';//设置表名
          KeyField := 'Cnt_no';
          ListField := 'cname';
          KeyFieldCaption := '部门号';
          ListFieldCaption := '名称';
     end
     else
     if Active then
     begin
          raise EOperationInvalid.Create('Can''t change TableName while Active is True.');
          exit;
     end
     else
     begin
          FDatabaseName := Value;
          TableName := 'tbCounter';//设置表名
          KeyField := 'Cnt_no';
          ListField := 'cname';
	 end;
end;

{
procedure TPDBCounterEdit.Paint;
begin
     FLabel.Height := Height;
     FEdit.Height := Height;
     FLabel.Width := Width-FEdit.Width -FHelp.Width - 2;

     FEdit.Left := FLabel.Width;
     FHelp.Left := FLabel.Width + FEdit.Width + 2;
     SetLabelStyle(LabelStyle);
     inherited Paint;
end;
}

procedure TPDBCounterEdit.SetActive(Value: Boolean);
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

procedure TPDBCounterEdit.SetText(Value : string);
begin
     if FEdit.Text <> Value then
     begin
        FEdit.Text := Value;
        DataSource.Edit;
        DataSource.DataSet.FieldByName( FEdit.Field.FieldName).AsString := FEdit.Text;
        controlchange(self);
     end;
end;

function TPDBCounterEdit.GetText: string;
begin
     Result := FEdit.Text;
end;

procedure TPDBCounterEdit.SetLookField(Value: string);
begin
     if FKeyField <> Value then
        FKeyField := Value;
end;

procedure TPDBCounterEdit.SetLookSubField(Value: string);
begin
     if FListField <> Value then
        FListField := Value;
end;

function TPDBCounterEdit.FindCurrent(var LabelText: string):Boolean;
var tmpQuery: TQuery;
begin
     Result := False;

     if FEdit.Text = '' then Exit;

     LabelText := '';
     if PartialKey and (FQuery.FieldByName(FKeyField).DataType in [ftString]) then
     begin
     try
        //在这里加检查合法性
        tmpQuery := TQuery.Create(Self);
        tmpQuery.DatabaseName := FDatabaseName;
        tmpQuery.SQL.Add('Select * from '+FTableName);
        {tmpQuery.SQL.Add(' where '+FKeyField+' LIKE :Param1');
        tmpQuery.ParamByName('Param1').AsString := FEdit.Text+'%';}
        tmpQuery.SQL.Add(format(' where %s LIKE ''%s'' ',[FKeyField,FEdit.Text+'%']));

        tmpQuery.Filter := Filter;
        tmpQuery.Filtered := True;
        tmpQuery.Open;

        if tmpQuery.eof  then
        begin
             Result := False;
             LabelText := '';
        end
        else
            {if tmpQuery.RecordCount =1 then
            begin
                 tmpQuery.First;
                 Result := True;
                 if FListField <> '' then
                 begin
                      LabelText := tmpQuery.FieldByName(FListField).AsString;
                      FEdit.Field.Value := LabelText;
                 end
                 else
                     LabelText := '';
            end
            else
            begin
                 Result := True;
                 LabelText := '';
            end;}
        begin
          Result := True;
          if FListField <> '' then
          begin
            LabelText := tmpQuery.FieldByName(FListField).AsString;
            FEdit.Field.Value := LabelText;
          end
        end;
     except
           on Exception do
           begin
                Result := False;
                LabelText := '';
                tmpQuery.Free;
                Exit;
           end;
     end;
     tmpQuery.Free;
     end
     else
     begin
     try
        if FQuery.Locate(FKeyField, FEdit.Text,[]) then
        begin
             Result := True;
             if FListField <> '' then
                LabelText := FQuery.FieldByName(FListField).AsString
             else
                 LabelText := '';
             Exit;
        end;
    except
          on Exception do;
    end;
    end;
end;


constructor TPDBCounterEdit.Create(AOwner: TComponent);
var  tmpBitmap: TBitmap;
begin
     inherited Create(AOwner);

     //FDataLink := TDataLink.Create;
     FFieldLink :=  TFieldDataLink.Create;
     FFieldLink.OnDataChange := DataChange;

     FFormat := '232222';
     {FEdit := TDBEdit.Create(Self);
     FEdit.Parent := Self;
     FEdit.Visible := True;
     FEdit.Font.Size := 9;
     FEdit.Font.Name := '宋体';}
     FEdit.DataSource := DataSource;
     {FEdit.OnEnter := ControlEnter;
     FEdit.OnExit := ControlExit;
     FEdit.OnClick := ControlClick;
     FEdit.OnDblClick := ControlDblClick;
     FEdit.OnKeyPress := EditKeyPress;
     FEdit.OnChange := ControlChange;

     FHelp := TBitBtn.Create (Self);
     FHelp.parent := Self;
     FHelp.Enabled := True;}
     //FHelp.OnClick := BtnHelpClick;
     {FHelp.TabStop := False;

     FLabel.FocusControl := FEdit;

     TabStop := True;
     ParentFont := False;

     Height := 24;
     FLabel.Height := Height;
     FEdit.Height := Height;
     FHelp.Height := Height;

     FLabel.Width := 50;
     FEdit.Width := 96;
     FHelp.Width := 20;
     Width := FLabel.Width + FEdit.Width + FHelp.Width + 2;

     FEdit.Left := FLabel.Width;
     FHelp.Left := FLabel.Width + FEdit.Width + 2;
     FHelp.left := fhelp.left;
     }
     if not (csDesigning in ComponentState) then
     begin
          tmpBitmap := TBitmap.Create;
          try
             tmpBitmap.LoadFromResourceName(HInstance,'Lookuphelp');
          except
          end;
          FHelp.Glyph := tmpBitmap;
          tmpBitmap.Free;
     end
     else
         try
            FHelp.Glyph.LoadFromFile('help.bmp');
         except
//            showmessage('不能装载help.bmp');
         end;

end;

destructor TPDBCounterEdit.Destroy ;
begin
     {FEdit.OnChange := nil;
     FEdit.OnEnter := nil;
     FEdit.OnExit := nil;
     FEdit.Free;
     FHelp.Free;
     FFieldLink.OnDataChange := nil;}
     //FDataLink.Free ;
     FFieldLink.Free;
     inherited Destroy;
end;

procedure TPDBCounterEdit.ControlChange(Sender: TObject);
begin
  CheckFormat;
  inherited ControlChange(Sender);
  {
     if FEdit.Text <> '' then
        inherited ControlChange(Sender);
     CheckFormat;
     if Assigned(FOnChange) then
        FOnChange(Self); }
end;

{
procedure TPDBCounterEdit.ControlEnter(Sender: TObject);
begin
     inherited ControlEnter(Sender);
     if Assigned(FOnEnter) then
        FOnEnter(Self);
end;

procedure TPDBCounterEdit.ControlClick(Sender: TObject);
begin
     inherited ControlEnter(Sender);
     {if Assigned(FOnClick) then
        FOnClick(Self);
end;

procedure TPDBCounterEdit.ControlDblClick(Sender: TObject);
var SltDlg: TfrmSelectDlg;
begin
  if Assigned(FOnDblClick) then
     FOnDblClick(Self);
  if (not RdOnly) and (not FQuery.IsEmpty) then
  begin
       SltDlg := TfrmSelectDlg.Create(Self);
       with SltDlg do
       begin
            SelectDataSource.DataSet := FQuery;
            grdSelect.Columns.Clear;
            if FListField <> '' then
            begin
                 grdSelect.Columns.Add;//添加第一列
                 grdSelect.Columns.Items[0].FieldName := FKeyField;
                 if FKeyFieldCaption = '' then
                    grdSelect.Columns.Items[0].Title.Caption := grdSelect.Columns.Items[0].FieldName
                 else
                     grdSelect.Columns.Items[0].Title.Caption := FKeyFieldCaption;
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

                 if FKeyFieldCaption = '' then
                    SltDlg.FindKey.Items.Add(grdSelect.Columns.Items[0].FieldName)
                 else
                     SltDlg.FindKey.Items.Add(FKeyFieldCaption);

                 if FListFieldCaption = '' then
                    SltDlg.FindKey.Items.Add(grdSelect.Columns.Items[1].FieldName)
                 else
                     SltDlg.FindKey.Items.Add(FListFieldCaption);
            end
            else
            begin
                 grdSelect.Columns.Add;
                 grdSelect.Columns.Items[0].FieldName := FKeyField;

                 if FKeyFieldCaption = '' then
                    grdSelect.Columns.Items[0].Title.Caption := grdSelect.Columns.Items[0].FieldName
                 else
                 grdSelect.Columns.Items[0].Title.Caption := FKeyFieldCaption;

                 grdSelect.columns.Items[0].Width := grdSelect.Width-10;
                 grdSelect.Columns.Items[0].Title.Font.Size := 40;

                 if FKeyFieldCaption = '' then
                   SltDlg.FindKey.Items.Add(grdSelect.Columns.Items[0].FieldName)
                 else
                   SltDlg.FindKey.Items.Add(FKeyFieldCaption);
            end;
       end;

       SltDlg.FindKey.ItemIndex := 0;

       if SltDlg.ShowModal=mrOK then
       begin
            FEdit.DataSource.DataSet.Edit;
            FEdit.Text := FQuery.FieldByName(KeyField).AsString;
            ControlChange(Self);
       end;
       SltDlg.Free;
       OpenQuery;
  end;
end;

procedure TPDBCounterEdit.EditKeyPress(Sender: TObject; var Key: Char);
begin
     inherited  ;
     if Key = #13 then
        ControlChange(Self);
end;

procedure TPDBCounterEdit.BtnHelpClick(Sender: TObject);
begin
     FEdit.SetFocus;
     ControlDblClick(self);
end;

procedure TPDBCounterEdit.ControlExit(Sender: TObject);
begin
     if FEdit.Text <> '' then
        ControlChange(Self)
     else
     begin
          if FSubFieldControl is TPLabelPanel then
             (FSubFieldControl as TPLabelPanel).Caption := '';
          FCheckResult := False;
     end;
     inherited ControlExit(Sender);
     if Assigned(FOnExit) then
        FOnExit(Self);
end;
}
function TPDBCounterEdit.GetDataSource: TDataSource;
begin
     Result := FFieldLink.DataSource ;
end;

procedure TPDBCounterEdit.SetDataSource(Value: TDataSource);
begin
     //FDataLink.DataSource := Value;
     //FDataLink.DataSource.OnDataChange := DataChange;
     FFieldLink.DataSource := Value;
     if Value <> nil then
        Value.FreeNotification(Self);
     if FEdit.DataSource <> Value then
     begin
          FEdit.DataSource := Value;
     end;
end;

{
procedure TPDBCounterEdit.SetParentFont(Value: Boolean);
begin
     inherited;
     FEdit.ParentFont := Value;
     Flabel.ParentFont := Value;
     FParentFont := Value;
end; }

function TPDBCounterEdit.GetDataField: String;
begin
     Result :=  FFieldLink.FieldName ;
end;

procedure TPDBCounterEdit.SetDataField(Value: String);
begin
     FFieldLink.FieldName := Value;
     if FEdit.datafield <> Value then
        FEdit.DataField := Value;
end;
{
procedure TPDBCounterEdit.DataChange(Sender: TObject; Field: TField);
begin
     inherited;
     ControlChange(Self);
end; }

{
procedure TPDBCounterEdit.HideHelpButton;
begin
     FHelp.Visible := False;
end;

procedure TPDBCounterEdit.ShowHelpButton;
begin
     FHelp.Visible := True;
end;

procedure TPDBCounterEdit.CMFocusChanged(var Message: TCMFocusChanged);
begin
    if Message.Sender.name = self.Name  then
      FEdit.SetFocus ;
end;
}
function TPDBCounterEdit.GetReadOnly: Boolean;
begin
     Result := FEdit.ReadOnly ;
end;

procedure TPDBCounterEdit.SetReadOnly(Value: Boolean);
begin
     FEdit.ReadOnly := Value;
end;
(*
procedure TPDBCounterEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
     if (Operation = opRemove) and (Acomponent = FSubFieldControl) then
        FSubFieldControl := nil;
end;
*)
procedure TPDBCounterEdit.CheckFormat;
var i,len: integer;
begin
     FCheckResult := False;
     len := 0;
     for i :=  1 to strlen(pchar(FFormat)) do
     begin
          try
             len := len + strtoint(FFormat[i]);
          except
                Exit;
          end;
          if strlen(pchar(FEdit.Text)) = len then
               break
     end;

     if i > strlen(pchar(FFormat)) then Exit;

     FCheckResult := True;
end;


procedure TPDBCounterEdit.CreateEditCtrl;
begin
  FEdit := TDBEdit.Create(Self);
  FEdit.OnChange := ControlChange;
  FEditCtrl:=FEdit;
end;

end.

