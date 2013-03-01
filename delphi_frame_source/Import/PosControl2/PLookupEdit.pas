unit PLookupEdit;

interface

uses
  Windows,  Messages, SysUtils, Classes, Graphics, Controls, Forms,     Dialogs,
  stdctrls, dbtables, extctrls, RxCtrls, dbctrls,  db,       SelectDlg, PLabelPanel
  ,buttons, LookupControls;

type
  TPLookupEdit = class(TPLookupControl)
  private
    { Private declarations }
    FEdit: TEdit;
    {FKeyFieldCaption: string;
    FListFieldCaption: string;}
    FPartialKey: Boolean;
    //FParentFont: Boolean;
  protected
    { Protected declarations }
    function FindCurrent(var LabelText: string):Boolean;override;
    {function GetEditFont:TFont;
    function GetEditWidth:integer;}
    function GetRdOnly:Boolean; override;
    function GetText : string; override;

    //procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    {procedure ControlChange(Sender: TObject);override;
    procedure ControlClick(Sender: TObject);override;
    procedure ControlEnter(Sender: TObject);override;
    procedure ControlExit(Sender: TObject);override;
    procedure ControlDblClick(Sender: TObject); override;
    procedure EditKeyPress(Sender: TObject; var Key: Char); override;}
    procedure SetActive(Value: Boolean);override;
    {procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetEditFont(Value: TFont);
    procedure SetEditWidth(Value: integer);}
    procedure SetLookField(Value: string);override;
    procedure SetLookSubField(Value: string);override;
    //procedure SetParentFont(Value: Boolean);override;
    procedure SetRdOnly(Value: Boolean);
    procedure SetText(Value : string);override;
    //procedure Paint;override;

    procedure   CreateEditCtrl; override;
  public
     { Public declarations }
    constructor Create(AOwner: TComponent); override;
    //destructor  Destroy;override;
    {procedure   HideHelpButton;
    procedure   ShowHelpButton;}
    //procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
    property    CheckResult;
  published
    property Active;
    property Caption;
    property DatabaseName;
    //property EditFont:TFont read GetEditFont write SetEditFont;
    //property EditWidth:integer read GetEditWidth write SetEditWidth;
    property Filter;
    property KeyField;
    //property KeyFieldCaption:string read FKeyFieldCaption write FKeyFieldCaption;
    property LabelStyle;
    property ListField;
    //property ListFieldCaption:string read FListFieldCaption write FListFieldCaption;
    property ListFieldControl;
    property PartialKey:Boolean read FPartialKey write FPartialKey;
    //property ParentFont : Boolean read FParentFont write SetParentFont;
    property RdOnly: Boolean read GetRdOnly write SetRdOnly;
    property TabOrder;
    property TableName;
    property TabStop;
    property KeyFieldCaption;
    property ListFieldCaption;

    {property OnChange;
    property OnEnter ;
    property OnExit  ;
    property OnClick;
    property OnDblClick;}
  end;

procedure Register;

implementation

function TPLookupEdit.GetRdOnly:Boolean;
begin
     Result := FEdit.ReadOnly;
end;

procedure TPLookupEdit.SetRdOnly(Value: Boolean);
begin
     FEdit.ReadOnly := Value;
     if Value then
        FEdit.Color := clSilver
     else
         FEdit.Color := clWhite;
end;

{
function TPLookupEdit.GetEditWidth:integer;
begin
     Result := FEdit.Width;
end;

procedure TPLookupEdit.SetEditWidth(Value: integer);
begin
     FEdit.Width := Value;
     FEdit.Left := FLabel.Width;
     FHelp.Left := FLabel.Width + FEdit.Width + 2;
     Width := FLabel.Width + FEdit.Width + FHelp.Width ;
end;
}
{
function TPLookupEdit.GetEditFont:TFont;
begin
     Result := FEdit.Font;
end;

procedure TPLookupEdit.SetEditFont(Value: TFont);
begin
     FEdit.Font.Assign(Value);
     FLabel.Font.Assign(Value);
     FLabel.Height := FEdit.Height;
     Height := FEdit.Height;
     SetLabelStyle(LabelStyle);
end;

procedure TPLookupEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
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


procedure TPLookupEdit.Paint;
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

procedure TPLookupEdit.SetActive(Value: Boolean);
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

procedure TPLookupEdit.SetLookField(Value: string);
begin
     if FKeyField <> Value then
        FKeyField := Value;
end;

procedure TPLookupEdit.SetLookSubField(Value: string);
begin
     if FListField <> Value then
        FListField := Value;
end;

function TPLookupEdit.FindCurrent(var LabelText: string):Boolean;
var tmpQuery: TQuery;
begin
     Result := False;
     LabelText := '';
     if PartialKey and (FQuery.FieldByName(FKeyField).DataType in [ftString]) then
     begin
     try
        tmpQuery := TQuery.Create(Self);
        tmpQuery.DatabaseName := FDatabaseName;
        tmpQuery.SQL.Add('Select * from '+FTableName);
        tmpQuery.SQL.Add(' where '+FKeyField+' LIKE :Param1');
        tmpQuery.ParamByName('Param1').AsString := FEdit.Text+'%';
        tmpQuery.Filter := Filter;
        tmpQuery.Filtered := True;
        tmpQuery.Open;

        if tmpQuery.RecordCount < 1 then
        begin
             Result := False;
             LabelText := '';
        end
        else
            if tmpQuery.RecordCount =1 then
            begin
                 tmpQuery.First;
                 Result := True;
                 if FListField <> '' then
                    LabelText := tmpQuery.FieldByName(FListField).AsString
                 else
                     LabelText := '';
            end
            else
            begin
                 Result := True;
                 LabelText := '';
            end;
            tmpQuery.Free;
     except
           on Exception do
           begin
                Result := False;
                LabelText := '';
                tmpQuery.Free;
                Exit;
           end;
     end;
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

constructor TPLookupEdit.Create(AOwner: TComponent);
var  tmpBitmap: TBitmap;
begin
     inherited Create(AOwner);

     {FEdit := TEdit.Create(Self);
     FEdit.Parent := Self;
     FEdit.Visible := True;
     FEdit.Enabled := True;
     FEdit.Font.Size := 9;
     FEdit.Font.Name := '宋体';
     FEdit.ParentFont := False;
     FEdit.OnEnter := ControlEnter;
     FEdit.OnExit := ControlExit;
     FEdit.OnDblClick := ControlDblClick;
     FEdit.OnClick := ControlClick;
     FEdit.OnChange := ControlChange;
     FEdit.OnKeyPress := EditKeyPress;}

     {FHelp := TBitBtn.Create (Self);
     FHelp.parent := Self;
     FHelp.Enabled := True;}
     FHelp.OnClick := FEdit.OnDblClick ;
     {
     FLabel.FocusControl := FEdit;

     Height := 24;
     FLabel.Height := Height;
     FEdit.Height := Height;
     FHelp.Height := Height;

     FLabel.Width := 50;
     FEdit.Width := 96;
     FHelp.Width := 24;
     Width := FLabel.Width + FEdit.Width + FHelp.Width + 2;

     FEdit.Left := FLabel.Width;
     FHelp.Left := FLabel.Width + FEdit.Width + 2;
     FHelp.left := fhelp.left;

     TabStop := True;
     ParentFont := False;
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
            showmessage('不能装载help.bmp');
         end;
end;

{
destructor TPLookupEdit.Destroy ;
begin
     FEdit.Free;
     FHelp.Free;
     inherited Destroy;
end;
}
{
procedure TPLookupEdit.ControlChange(Sender: TObject);
begin
     inherited ControlChange(Sender);
     if Assigned(FOnChange) then
        FOnChange(Self);
end;

procedure TPLookupEdit.ControlEnter(Sender: TObject);
begin
     inherited ControlEnter(Sender);
     if Assigned(FOnEnter) then
        FOnEnter(Self);
end;

procedure TPLookupEdit.ControlClick(Sender: TObject);
begin
     inherited ControlEnter(Sender);
     if Assigned(FOnClick) then
        FOnClick(Self);
end;

procedure TPLookupEdit.ControlDblClick(Sender: TObject);
var SltDlg: TfrmSelectDlg;
begin
     if Assigned(FOnDblClick) then
        FOnDblClick(Self);

  inherited ControlDblClick(Sender);
     if (not RdOnly) and (not FQuery.IsEmpty) then
     begin
          SltDlg := TfrmSelectDlg.Create(Self);
          with SltDlg do
          begin
               SelectDataSource.DataSet := FQuery;

               grdSelect.Columns.Clear;
               if FListField <> '' then
               begin
                    grdSelect.Columns.Add;
                    grdSelect.Columns.Items[0].FieldName := FKeyField;

                    //deal with select grid's columns's items's title caption
                    if FKeyFieldCaption = '' then
                       grdSelect.Columns.Items[0].Title.Caption := grdSelect.Columns.Items[0].FieldName
                    else
                        grdSelect.Columns.Items[0].Title.Caption := FKeyFieldCaption;

                    grdSelect.Columns.Items[0].Title.Font.Size := 10;
                    grdSelect.Columns.Items[0].Width := (Width - 40) div 2;

                    grdSelect.Columns.Add;
                    grdSelect.Columns.Items[1].FieldName := FListField;
                    if FListFieldCaption = '' then
                       grdSelect.Columns.Items[1].Title.Caption := grdSelect.Columns.Items[1].FieldName
                    else
                        grdSelect.Columns.Items[1].Title.Caption := FListFieldCaption;
                    grdSelect.Columns.Items[1].Title.Font.Size := 10;
                    grdSelect.Columns.Items[1].Width := (Width -40) div 2;

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
                    grdSelect.Columns.Items[0].Title.Font.Size := 10;

                    if FKeyFieldCaption = '' then
                       SltDlg.FindKey.Items.Add(grdSelect.Columns.Items[0].FieldName)
                    else
                        SltDlg.FindKey.Items.Add(FKeyFieldCaption);
               end;
          end;

          SltDlg.FindKey.ItemIndex := 0;

          if SltDlg.ShowModal=mrOK then
          begin
               FEdit.Text := FQuery.FieldByName(FKeyField).AsString;
               ControlChange(Self);
          end;
          SltDlg.Free;
     end;
end;

procedure TPLookupEdit.EditKeyPress(Sender: TObject; var Key: Char);
begin
  inherited EditKeyPress(Sender,Key);
  if Key = #13 then
    ControlChange(Self);
end;


procedure TPLookupEdit.ControlExit(Sender: TObject);
begin
     ControlChange(Self);

     inherited ControlExit(Sender);
     if Assigned(FOnExit) then
        FOnExit(Self);
end; }

procedure TPLookupEdit.SetText(Value : string);
begin
     if FEdit.Text <> Value then
     begin
        FEdit.Text := Value;
        controlchange(self);
     end;
end;

function TPLookupEdit.GetText : string;
begin
     Result := FEdit.Text;
end;

{
procedure TPLookupEdit.SetParentFont(Value: Boolean);
begin
     inherited;
     FEdit.ParentFont := Value;
     Flabel.ParentFont := Value;
     FParentFont := Value;
end;}
{
procedure TPLookupEdit.CMFocusChanged(var Message: TCMFocusChanged);
begin
    if Message.Sender.name = self.Name  then
      FEdit.SetFocus ;
end;
}
{
procedure TPLookupEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
     if (Operation = opRemove) and (Acomponent = FSubFieldControl) then
        FSubFieldControl := nil;
end; }

{
procedure TPLookupEdit.HideHelpButton;
begin
  //   FHelp.Visible := False;
  HelpVisible:=false;
end;

procedure TPLookupEdit.ShowHelpButton;
begin
  //   FHelp.Visible := True;
  HelpVisible:=true;
end;}

procedure TPLookupEdit.CreateEditCtrl;
begin
  FEdit := TEdit.Create(Self);
  FEdit.OnChange := ControlChange;
  FEditCtrl:=FEdit;
end;

procedure Register;
begin
  RegisterComponents('PosControl', [TPLookupEdit]);
end;

end.
