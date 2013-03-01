unit PKindEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stdctrls, dbtables, extctrls, RxCtrls, dbctrls, db, SelectDlg, PLabelPanel,
  MaxMin,LookupControls;

type
  TPKindEdit = class(TCustomControl)
  private
    { Private declarations }
    FCancut: boolean;
    FCheck: Boolean;
    FDatabaseName: string;
    FDisplayLevel: integer;
    FEdit: TEdit;
    FKindGrade: integer;
    FLabel: TRxLabel;
    FLabelStyle: TLabelStyle;
    FLookField: string;
    FLookFieldCaption: string;
    FLookSubField: string;
    FLookSubFieldCaption: string;
    //FParentFont: Boolean;
    FQuery: TQuery;
    FRealLevel: integer;
    FSubFieldControl: TPLabelPanel;
    FTableName: string;

  protected
    { Protected declarations }
    function FindCurrent(var LabelText: string):Boolean;
    function GetCaption:TCaption;
    function GetEditFont:TFont;
    function GetEditWidth:integer;
    function GetLabelFont: TFont;
    function GetRdOnly:Boolean;
    function GetText:string;

    procedure ControlExit(Sender: TObject);
    procedure ControlDblClick(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure Paint;override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetCaption(Value: TCaption);
    procedure SetDisplayLevel(Value:integer);
    procedure SetEditFont(Value: TFont);
    procedure SetEditWidth(Value: integer);
    procedure SetKindGrade(Value:integer);
    procedure SetLabelFont(Value: TFont);
    procedure SetLabelStyle(Value: TLabelStyle);
    //procedure SetParentFont(Value: Boolean);
    procedure SetRdOnly(Value: Boolean);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    property Text:string read GetText;
  published
    { Published declarations }
    property Caption:TCaption read GetCaption write SetCaption;
    property Cancut:boolean read FCancut write FCancut;
    property Check: Boolean read FCheck write FCheck;
    property DatabaseName: string read FDatabaseName write FDatabaseName;
    property DisplayLevel:integer read FDisplayLevel write SetDisplayLevel stored False;
    property EditFont:TFont read GetEditFont write SetEditFont;
    property EditWidth:integer read GetEditWidth write SetEditWidth;
    property KindGrade:integer read FKindGrade write SetKindGrade default 1;
    property LabelFont: TFont read GetLabelFont write SetLabelFont;
    property LabelStyle: TLabelStyle read FLabelStyle write SetLabelStyle default Normal;
    property LookFieldCaption:string read FLookFieldCaption write FLookFieldCaption;
    property LookSubFieldCaption:string read FLookSubFieldCaption write FLookSubFieldCaption;
    //property ParentFont : Boolean read FParentFont write SetParentFont;
    property RdOnly: Boolean read GetRdOnly write SetRdOnly;
    property SubFieldControl: TPLabelPanel read FSubFieldControl write FSubFieldControl;
  end;

procedure Register;

implementation

function TPKindEdit.GetLabelFont: TFont;
begin
     Result := FLabel.Font;
end;

procedure TPKindEdit.SetLabelFont(Value: TFont);
begin
     FLabel.Font := Value;
end;

function TPKindEdit.GetCaption:TCaption;
begin
     Result := FLabel.Caption;
end;

procedure TPKindEdit.SetCaption(Value: TCaption);
begin
     FLabel.Caption := Value;
end;

procedure TPKindEdit.SetLabelStyle (Value: TLabelStyle);
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

function TPKindEdit.GetEditWidth:integer;
begin
     Result := FEdit.Width;
end;

procedure TPKindEdit.SetEditWidth(Value: integer);
begin
     FEdit.Width := Value;
     FEdit.Left := Width-Value;
     FLabel.Width := FEdit.Left;
end;

function TPKindEdit.GetEditFont:TFont;
begin
     Result := FEdit.Font;
end;

procedure TPKindEdit.SetEditFont(Value: TFont);
begin
     FEdit.Font.Assign(Value);
     FLabel.Height := FEdit.Height;
     Height := FEdit.Height;
end;

function TPKindEdit.GetRdOnly:Boolean;
begin
     Result := FEdit.ReadOnly;
end;

procedure TPKindEdit.SetRdOnly(Value: Boolean);
begin
     FEdit.ReadOnly := Value;
     if Value then
        FEdit.Color := clSilver
     else
         FEdit.Color := clWhite;
end;

procedure TPKindEdit.Paint;
begin
     FLabel.Height := Height;
     FEdit.Height := Height;
     FLabel.Width := Width-FEdit.Width;
     FEdit.Left := FLabel.Width;
     SetLabelStyle(LabelStyle);
     inherited Paint;
end;

constructor TPKindEdit.Create (AOwner: TComponent);
begin
     inherited Create(AOwner);

     FLabel := TRxLabel.Create(Self);
     FLabel.Parent := Self;
     FLabel.ShadowSize := 0;
     FLabel.Layout := tlCenter;
     FLabel.AutoSize := False;
     FLabel.Visible := True;
     FLabel.Font.Size := 11;
     FLabel.Font.Name := '宋体';
     FLabel.ParentFont := False;

     FEdit := TEdit.Create(Self);
     FEdit.Parent := Self;
     FEdit.Visible := True;
     FEdit.OnExit := ControlExit;
     FEdit.Font.Size := 9;
     FEdit.Font.Name := '宋体';
     FEdit.ParentFont := False;
     FEdit.OnDblClick := ControlDblClick;
     FEdit.OnKeyPress := EditKeyPress;

     FLabel.FocusControl := FEdit;

     Height := 24;
     FLabel.Height := Height;
     FEdit.Height := Height;

     Width := 200;
     FEdit.Width := 140;
     FLabel.Width := Width-FEdit.Width;
     FEdit.Left := FLabel.Width;

     FQuery := TQuery.Create(Self);

     LabelStyle := Normal;

     FTableName := 'tbKind';
     FLookField := 'KIND';
     FLookSubField := 'C_NAME';

     KindGrade := 1;
     DisplayLevel := 34;
     ParentFont := False;
end;

{
procedure TPKindEdit.SetParentFont(Value: Boolean);
begin
     inherited;
     FEdit.ParentFont := Value;
     Flabel.ParentFont := Value;
     FParentFont := Value;
end; }

destructor TPKindEdit.Destroy;
begin
     FEdit.Free;
     FQuery.Free;
     FLabel.Free;
     inherited Destroy;
end;

procedure TPKindEdit.SetDisplayLevel(Value: integer);
begin
     FDisplayLevel := Value;
     FEdit.MaxLength := Min(FKindGrade,FDisplayLevel)*2;
     FRealLevel := Min(FKindGrade,FDisplayLevel);
end;

procedure TPKindEdit.EditKeyPress(Sender: TObject; var Key: Char);
var LabelText: string;
    fgError : boolean;
    TextLen : integer;
begin
     if Key = #13 then
     begin
          fgError := False;
          LabelText := '';
          TextLen := Length(FEdit.Text);

          if Check then
          begin
               if (not Cancut) and (TextLen<>FRealLevel*2) then
                  fgError := True
               else
                   if (TextLen=0) or ((TextLen mod 2)<>0) then
                      fgError := True
                   else
                       if not FindCurrent(LabelText) then
                          fgError := True;
          end
          else
          begin
               if (not Cancut) and (TextLen<>FRealLevel*2) then
                  fgError := True
               else
                   if (TextLen=0) or ((TextLen mod 2)<>0) then
                      fgError := True;
               FindCurrent(LabelText);
          end;

          if fgError then
          begin
               Application.MessageBox('输入不合法！','错误',MB_OK);
          end;

          if FSubFieldControl <> nil then
             (FSubFieldControl as TPLabelPanel).Caption := LabelText;

     end;
end;

procedure TPKindEdit.ControlExit;
var LabelText: string;
    fgError: boolean;
    TextLen: integer;
begin
     fgError := False;
     LabelText := '';
     TextLen := Length(FEdit.Text);

     if Check then
     begin
          if (not Cancut) and (TextLen<>FRealLevel*2) then
             fgError := True
          else
              if (TextLen=0) or ((TextLen mod 2)<>0) then
                 fgError := True
              else if not FindCurrent(LabelText) then
                   fgError := True;
     end
     else
     begin
          if (not Cancut) and (TextLen<>FRealLevel*2) then
             fgError := True
          else
              if (TextLen=0) or ((TextLen mod 2)<>0) then
                 fgError := True;
          FindCurrent(LabelText);
     end;

     if fgError then
     begin
          Application.MessageBox('输入不合法！','错误',MB_OK);
          FEdit.SetFocus;
     end;

     if FSubFieldControl <> nil then
        (FSubFieldControl as TPLabelPanel).Caption := LabelText;
end;

function TPKindEdit.GetText:string;
begin
     Result := FEdit.Text;
end;

function TPKindEdit.FindCurrent(var LabelText: string):Boolean;
var TextLen: integer;
begin
     FQuery.DatabaseName := FDatabaseName;
     FQuery.SQL.Clear;
     FQuery.SQL.Add('Select * from '+FTableName);
     FQuery.Open;

     if not FQuery.Locate(FLookField, FEdit.Text,[]) then
     begin
          Result := False;
          LabelText := '';
     end
     else
     begin
          Result := True;
          LabelText := FQuery.FieldByName(FLookSubField).AsString;
     end;

     FQuery.Close;
end;

procedure TPKindEdit.SetKindGrade(Value:integer);
begin
     FKindGrade := Value;
     FEdit.MaxLength := Min(FKindGrade,FDisplayLevel)*2;
     FRealLevel := Min(FKindGrade,FDisplayLevel);
end;

procedure TPKindEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
     if AHeight < 20 then
        AHeight := 20;
     if AHeight >50 then
        AHeight := 50;
     inherited;
     FEdit.Height := AHeight;
     FLabel.Height := AHeight;
end;

procedure TPKindEdit.ControlDblClick(Sender: TObject);
var SltDlg: TfrmSelectDlg;
begin
     FQuery.DatabaseName := FDatabaseName;
     FQuery.SQL.Clear;
     FQuery.SQL.Add('Select * from '+FTableName);
     FQuery.Open;

     if (not RdOnly) and (not FQuery.IsEmpty) then
     begin
          SltDlg := TfrmSelectDlg.Create(Self);
          with SltDlg do
          begin
               SelectDataSource.DataSet := FQuery;
               grdSelect.Columns.Clear;
               grdSelect.Columns.Add;
               grdSelect.Columns.Items[0].FieldName := FLookField;
               grdSelect.Columns.Items[0].Title.Caption := FLookFieldCaption;
               grdSelect.Columns.Items[0].Title.Font.Size := 10;
               grdSelect.Columns.Add;
               grdSelect.Columns.Items[1].FieldName := FLookSubField;
               grdSelect.Columns.Items[1].Title.Caption := FLookSubFieldCaption;
               grdSelect.Columns.Items[1].Title.Font.Size := 10;
          end;

          if SltDlg.ShowModal=mrOK then
          begin
               FEdit.Text := FQuery.FieldByName(FLookField).AsString;
               if FSubFieldControl<>nil then
                  (FSubFieldControl as TPLabelPanel).Caption := FQuery.FieldByName(FLookSubField).AsString;
          end;

          SltDlg.Free;
     end;

     FQuery.Close;
end;

procedure Register;
begin
     RegisterComponents('PosControl2', [TPKindEdit]);
end;

end.
