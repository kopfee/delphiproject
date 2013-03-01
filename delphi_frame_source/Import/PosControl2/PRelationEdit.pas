unit PRelationEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stdctrls, dbtables, extctrls, RxCtrls, dbctrls, db, SelectDlg, PLabelPanel,
  MaxMin,LookupControls;
type
  TPRelationEdit = class(TCustomControl)
  private
    { Private declarations }
    FCancut: boolean;
    FCheck: Boolean;
    FCheckResult: Boolean;
    FCurrentCNT: string;
    FDatabaseName: string;
    FDisplayLevel: integer;
    FEdit: TEdit;
    FFixedEdit: TEdit;
    FGradeLens: Array[1..7] of integer;
    FIsLeaf: boolean;
    FLabel: TRxLabel;
    FLabelStyle: TLabelStyle;
    FLookField: string;
    FLookFieldCaption: string;
    FLookSubField: string;
    FLookSubFieldCaption: string;
    FSubFieldControl: TPLabelPanel;
    FTableName: string;
    FQuery: TQuery;
    FPanel: TPanel;
  protected
    { Protected declarations }
    function CheckFormat:boolean;
    function FindCurrent(var LabelText: string):Boolean;
    function GetCaption:TCaption;
    function GetEditFont:TFont;
    function GetEditWidth:integer;
    function GetGradeLens(index:integer):integer;
    function GetRdOnly:Boolean;
    function GetText:string;

    procedure ControlExit(Sender: TObject);
    procedure ControlDblClick(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure Paint;override;
    procedure SetCaption(Value: TCaption);
    procedure SetCurrentCNT(Value: string);
    procedure SetDisplayLevel(Value: integer);
    procedure SetEditFont(Value: TFont);
    procedure SetEditWidth(Value: integer);
    procedure SetLabelStyle(Value: TLabelStyle);
    procedure SetLookField(Value: string);
    procedure SetLookSubField(Value: string);
    procedure SetRdOnly(Value: Boolean);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    property GradeLens[index:integer]:integer read GetGradeLens;
    property CheckResult: Boolean read FCheckResult write FCheckResult;
    property Text:string read GetText;
  published
    { Published declarations }
    property Caption:TCaption read GetCaption write SetCaption;
    property Check: Boolean read FCheck write FCheck;
    property Cancut:boolean read FCancut write FCancut;
    property CurrentCNT:string read FCurrentCNT write SetCurrentCNT;
    property DatabaseName: string read FDatabaseName write FDatabaseName;
    property DisplayLevel:integer read FDisplayLevel write SetDisplayLevel default 1;
    property EditFont:TFont read GetEditFont write SetEditFont;
    property EditWidth:integer read GetEditWidth write SetEditWidth;
    property IsLeaf:boolean read FIsLeaf write FIsLeaf;
    property LabelStyle: TLabelStyle read FLabelStyle write SetLabelStyle default Normal;
    property LookField: string read FLookField write SetLookField;
    property LookFieldCaption:string read FLookFieldCaption write FLookFieldCaption;
    property LookSubField: string read FLookSubField write SetLookSubField;
    property LookSubFieldCaption:string read FLookSubFieldCaption write FLookSubFieldCaption;
    property RdOnly: Boolean read GetRdOnly write SetRdOnly;
    property SubFieldControl: TPLabelPanel read FSubFieldControl write FSubFieldControl;
    property TableName: string read FTableName write FTableName;
  end;

procedure Register;

implementation


constructor TPRelationEdit.Create (AOwner: TComponent);
begin
     inherited Create(AOwner);

     FLabel := TRxLabel.Create(Self);
     FLabel.Parent := Self;
     FLabel.ShadowSize := 0;
     FLabel.Layout := tlCenter;
     FLabel.AutoSize := False;
     FLabel.Visible := True;
     FLabel.Font.Size := 11;
     FLabel.Font.Name := 'ËÎÌו';
     FLabel.ParentFont := False;

     FPanel := TPanel.Create(Self);
     FPanel.Parent := Self;
     FPanel.BevelInner := bvNone;
     FPanel.BevelOuter := bvNone;
     FPanel.BevelWidth := 1;
     FPanel.BorderStyle := bsSingle;
     FPanel.BorderWidth := 0;
     FPanel.Visible := True;
     FPanel.Enabled := True;
     FPanel.Font.Size := 11;
     FPanel.Font.Name := 'ËÎÌו';
     FPanel.ParentFont := False;

     FFixedEdit := TEdit.Create(Self);
     FFixedEdit.Parent := FPanel;
     FFixedEdit.Visible := True;
     FFixedEdit.BorderStyle := bsNone;
     FFixedEdit.Enabled := False;

     FEdit := TEdit.Create(Self);
     FEdit.Parent := FPanel;
     FEdit.Visible := True;
     FEdit.BorderStyle := bsNone;

     FEdit.OnExit := ControlExit;
     FEdit.OnDblClick := ControlDblClick;
     FEdit.OnKeyPress := EditKeyPress;

     FLabel.FocusControl := FEdit;

     Height := 20;
     FPanel.Height := Height;
     FLabel.Height := Height;
     FFixedEdit.Height := FPanel.Height-4;
     FEdit.Height := FPanel.Height-4;

     FFixedEdit.Top := 1;
     FEdit.Top := 1;

     Width := 200;
     FPanel.Width := 140;
     FLabel.Width := Width-FEdit.Width;
     FFixedEdit.Width := 0;
     FEdit.Width := FPanel.Width-4;

     FPanel.Left := FLabel.Width;
     FFixedEdit.Left := 1;
     FEdit.Left := 1;

     FQuery := TQuery.Create(Self);

     LabelStyle := Normal;
     DisplayLevel := 1;

     FGradeLens[1]:=4;
     FGradeLens[2]:=7;
     FGradeLens[3]:=10;
     FGradeLens[4]:=13;
     FGradeLens[5]:=13;
     FGradeLens[6]:=13;
     FGradeLens[7]:=13;
end;

destructor TPRelationEdit.Destroy;
begin
     FEdit.Free;
     FFixedEdit.Free;
     FPanel.Free;
     FQuery.Free;
     FLabel.Free;
     inherited Destroy;
end;

procedure TPRelationEdit.Paint;
begin
     FPanel.Height := Height;
     FLabel.Height := Height;
     FFixedEdit.Height := FPanel.Height-4;
     FEdit.Height := FPanel.Height-4;
     FLabel.Width := Width-FPanel.Width;
     FPanel.Left := FLabel.Width;
     SetLabelStyle(LabelStyle);
     inherited Paint;
end;

function TPRelationEdit.GetEditWidth:integer;
begin
     Result := FPanel.Width;
end;

procedure TPRelationEdit.SetEditWidth(Value: integer);
begin
     FPanel.Width := Value;
     FPanel.Left := Width-Value;
     FLabel.Width := FPanel.Left;
     FEdit.Width := FPanel.Width-4-FFixedEdit.Width;
end;

function TPRelationEdit.GetEditFont:TFont;
begin
     Result := FEdit.Font;
end;

procedure TPRelationEdit.SetEditFont(Value: TFont);
begin
     FEdit.Font.Assign(Value);
     FFixedEdit.Font.Assign(Value);
end;

function TPRelationEdit.GetCaption:TCaption;
begin
     Result := FLabel.Caption;
end;

procedure TPRelationEdit.SetCaption(Value: TCaption);
begin
     FLabel.Caption := Value;
end;

procedure TPRelationEdit.SetLabelStyle (Value: TLabelStyle);
begin
     FLabelStyle := Value;
     case Value of
     Conditional: begin
             FLabel.Font.Color := clBlack;
             FLabel.Font.Style := [fsUnderline];
           end;
     Normal: begin
             FLabel.Font.Color := clBlack;
             FLabel.Font.Style := [];
           end;
     NotnilAndConditional: begin
             FLabel.Font.Color := clTeal;
             FLabel.Font.Style := [fsUnderline];
           end;
     Notnil: begin
             FLabel.Font.Color := clTeal;
             FLabel.Font.Style := [];
           end;
     end;
end;

function TPRelationEdit.GetRdOnly:Boolean;
begin
     Result := FEdit.ReadOnly;
end;

procedure TPRelationEdit.SetRdOnly(Value: Boolean);
begin
     FEdit.ReadOnly := Value;
     if Value then
     begin
          FFixedEdit.Color := clSilver;
          FEdit.Color := clSilver;
     end
     else
     begin
          FFixedEdit.Color := clWhite;
          FEdit.Color := clWhite;
     end;
end;

procedure TPRelationEdit.SetLookField(Value: string);
begin
     if FLookField <> Value then
        FLookField := Value;
end;

procedure TPRelationEdit.SetLookSubField(Value: string);
begin
     if FLookSubField <> Value then
        FLookSubField := Value;
end;

function TPRelationEdit.GetGradeLens(index:integer):integer;
begin
     if (index<=7) and (index>=1) then
        Result := FGradeLens[index]
     else
         Result := 0;
end;

procedure TPRelationEdit.SetCurrentCNT(Value: string);
var CNTLength,CNTWidth : integer;
begin
     FCurrentCNT := Value;
     CNTLength := Length(Value);
     Canvas.Font.Assign(FFixedEdit.Font);
     CNTWidth := Canvas.TextWidth(Value);
     FFixedEdit.Text := Value;
     FEdit.Text := '';
     FFixedEdit.Width := CNTWidth;
     FEdit.Width := FPanel.Width-4-FFixedEdit.Width;
     FEdit.Left := FFixedEdit.Width + 1;
     if CNTLength >= FGradeLens[DisplayLevel] then
     begin
          FEdit.Enabled := False;
     end
     else
     begin
          FEdit.Enabled := True;
          FEdit.MaxLength := FGradeLens[DisplayLevel]-CNTLength;
     end;
end;

procedure TPRelationEdit.SetDisplayLevel(Value: integer);
var CNTLength : integer;
begin
     FDisplayLevel := Value;
     FEdit.Text := '';
     if CNTLength >= FGradeLens[DisplayLevel] then
     begin
          FEdit.Enabled := False;
     end
     else
     begin
          FEdit.Enabled := True;
          FEdit.MaxLength := FGradeLens[DisplayLevel]-CNTLength;
     end;
end;

function TPRelationEdit.GetText:string;
begin
     Result := FCurrentCNT+FEdit.Text;
end;

procedure TPRelationEdit.EditKeyPress(Sender: TObject; var Key: Char);
var LabelText : string;
    fgError : Boolean;
begin
     if Key = #13 then
     begin
          fgError := False;
          LabelText := '';
          if Check then
          begin
               if not CheckFormat then
                  fgError := True
               else
                   if not FindCurrent(LabelText) then
                      fgError := True;
          end
          else
          begin
               if not CheckFormat then
                  fgError := True;
               FindCurrent(LabelText);
          end;

          FCheckResult := fgError;
          if FSubFieldControl <> nil then
             (FSubFieldControl as TPLabelPanel).Caption := LabelText;
     end;
end;

procedure TPRelationEdit.ControlExit;
var LabelText : string;
    fgError : Boolean;
begin
     fgError := False;
     LabelText := '';

     if Check then
     begin
          if not CheckFormat then
             fgError := True
          else
              if not FindCurrent(LabelText) then
                 fgError := True;
     end
     else
     begin
          if not CheckFormat then
             fgError := True;
          FindCurrent(LabelText);
     end;

     FCheckResult := fgError;
     if FSubFieldControl <> nil then
        (FSubFieldControl as TPLabelPanel).Caption := LabelText;
end;

procedure TPRelationEdit.ControlDblClick(Sender: TObject);
var SltDlg: TfrmSelectDlg;
begin
     FQuery.DatabaseName := FDatabaseName;
     FQuery.SQL.Clear;
     FQuery.SQL.Add('Select * from '+FTableName);
     FQuery.Open;
     FQuery.FilterOptions := [];
     FQuery.Filter := FLookField+'='''+CurrentCNT+'*''';
     FQuery.Filtered := True;

     if (not RdOnly) and (not FQuery.IsEmpty) then
     begin
          SltDlg := TfrmSelectDlg.Create(Self);
          with SltDlg do
          begin
               SelectDataSource.DataSet := FQuery;
               grdSelect.Columns.Clear;
               if FLookSubField <> '' then
               begin
                    grdSelect.Columns.Add;
                    grdSelect.Columns.Items[0].FieldName := FLookField;
                    grdSelect.Columns.Items[0].Title.Caption := FLookFieldCaption;
                    grdSelect.Columns.Items[0].Title.Font.Size := 10;
                    grdSelect.Columns.Add;
                    grdSelect.Columns.Items[1].FieldName := FLookSubField;
                    grdSelect.Columns.Items[1].Title.Caption := FLookSubFieldCaption;
                    grdSelect.Columns.Items[1].Title.Font.Size := 10;
               end
               else
               begin
                    grdSelect.Columns.Add;
                    grdSelect.Columns.Items[0].FieldName := FLookField;
                    grdSelect.Columns.Items[0].Title.Caption := FLookFieldCaption;
                    grdSelect.columns.Items[0].Width := grdSelect.Width-10;
                    grdSelect.Columns.Items[0].Title.Font.Size := 10;
               end;
          end;

          if SltDlg.ShowModal=mrOK then
          begin
               FEdit.Text := Copy(FQuery.FieldByName(FLookField).AsString, Length(CurrentCNT)+1, Max(Length(FQuery.FieldByName(FLookField).AsString)-Length(CurrentCNT),0));
               if (FSubFieldControl<>nil) and (FLookSubField<>'') then
                  (FSubFieldControl as TPLabelPanel).Caption := FQuery.FieldByName(FLookSubField).AsString;
          end;

          SltDlg.Free;
     end;
     FQuery.Filtered := False;
     FQuery.Close;
end;

function TPRelationEdit.CheckFormat:boolean;
var TextLen,i: integer;
    tmpText: string;
    flag : boolean;
begin
     tmpText := FFixedEdit.Text + FEdit.Text;
     TextLen := Length(tmpText);
     Result := True;
     if (not Cancut) and (TextLen<>FGradeLens[DisplayLevel]) then
        Result := False;

     flag := False;
     for i := 1 to DisplayLevel do
          if TextLen=FGradeLens[i] then flag := True;
     if not flag then
        Result := False;
end;

function TPRelationEdit.FindCurrent(var LabelText: string):Boolean;
var tmpText: string;
begin
     tmpText := FFixedEdit.Text + FEdit.Text;

     FQuery.DatabaseName := FDatabaseName;
     FQuery.SQL.Clear;
     FQuery.SQL.Add('Select * from '+FTableName);
     FQuery.Open;

     if not FQuery.Locate(FLookField, tmpText,[]) then
     begin
          Result := False;
          LabelText := '';
     end
     else
     begin
          if FIsLeaf then
          if not FQuery.FieldByName('tag').AsBoolean then
          begin
               Result := False;
               LabelText := '';
               FQuery.Close;
               Exit;
          end;
          Result := True;
          if FLookSubField<>'' then
             LabelText := FQuery.FieldByName(FLookSubField).AsString
          else
              LabelText := '';
     end;
     FQuery.Close;
end;


procedure Register;
begin
     RegisterComponents('PosControl2', [TPRelationEdit]);
end;

end.

