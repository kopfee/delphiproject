unit PMemoEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stdctrls, dbtables, extctrls, RxCtrls, dbctrls, db, SelectDlg, PLabelPanel
  ,buttons,Mask;

type
  TPMemoEdit = class(TCustomMaskEdit)
  private
    { Private declarations }
    FBackText: string;
    FCanExtend: Boolean;
    FCurrentCNT: string;
    FDatabaseName: string;
    FEnPreFix: Boolean;
    FExtending: boolean;
    FFieldName: string;
    FForeignFieldName: string;
    FFormatIsOk: Boolean;
    FQuery: TQuery;
    FRefrenTableName: string;
    FFullLength: integer;
    FTableName: string;
  protected
    { Protected declarations }

    procedure BackText;
    procedure Change; override;
    procedure DoExit;override;
    procedure DoExtend;
    procedure KeyPress(var Key: Char);override;
    procedure SetDataBaseName(Value: string);
    procedure SetForeignFieldName(Value: string);
    procedure SetFieldName(Value: string);
    procedure SetFullLength(Value: integer);
    procedure SetTableName(Value: string);
    procedure SetForeignTableName(Value: string);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    function CheckSame: Boolean;
    function CheckExist: Boolean;
  published
    { Published declarations }
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property CanExtend: Boolean read FCanExtend write FCanExtend;
    property CharCase;
    property CurrentCNT:string read FCurrentCNT write FCurrentCNT;
    property Color;
    property Ctl3D;
    property DatabaseName: string read FDatabaseName write SetDatabaseName;
    property DragCursor;
    property DragMode;
    property Enabled;
    property EditMask;
    property EnPreFix: Boolean read FEnPreFix write FEnPreFix;
    property Font;
    property FieldName: string read FFieldName write SetFieldName;
    property ForeignFieldName: string read FForeignFieldName write SetForeignFieldName;
    property FormatIsOk: Boolean read FFormatIsOk write FFormatIsOk;
    property RefrenTableName: string read FRefrenTableName write SetForeignTableName;
    property FullLength:integer read FFullLength write SetFullLength default 12;
    property ImeMode;
    property ImeName;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TableName: string read FTableName write SetTableName;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

procedure Register;

implementation

constructor TPMemoEdit.Create(AOwner:TComponent);
begin
     inherited Create(AOwner);
     FQuery := TQuery.Create (Self);
     FullLength := 12;
     FExtending := False;
     FCanExtend := True;
     Font.Size := 9;
     Font.Name := 'ËÎÌו';
     ParentFont := False;
     //Text := '0';
     FFormatIsOk:= True;
end;

destructor TPMemoEdit.Destroy;
begin
     FQuery.Free;
     inherited Destroy;
end;

function TPMemoEdit.CheckSame: Boolean;
var str: string;
begin
     str := format('select * from %s where %s = ''%s'' ',[FTableName,FFieldName,Text]);
     FQuery.Close;
     FQuery.SQL.Clear;
     FQuery.SQL.Add(str);
     FQuery.Open;
     Result := (FQuery.RecordCount <> 0);
end;

function TPMemoEdit.CheckExist: Boolean;
var str: string;
begin
     str := format('select * from %s where %s = ''%s'' ',[FRefrenTableName,FForeignFieldName,Text]);
     FQuery.Close;
     FQuery.SQL.Clear;
     FQuery.SQL.Add(str);
     FQuery.Open;
     Result := (FQuery.RecordCount <> 0);
end;

procedure TPMemoEdit.SetFullLength(Value: integer);
begin
     if (Value>0) and (Value>=Length(FCurrentCNT)) then
     begin
          FFullLength := Value;
          MaxLength := Value;
          FExtending := True;
          Text := '';
          FExtending := False;
     end;
end;

procedure TPMemoEdit.BackText;
begin
     if FBackText <> Text then
        FBackText := Text;
end;

procedure TPMemoEdit.DoExtend;
var i:integer;
    CurLen,TextLen:integer;
    tmpText: string;
begin
     if not FCanExtend then exit;
     CurLen := Length(CurrentCNT);
     TextLen := Length(FBackText);
     tmpText := CurrentCNT;
     if (TextLen >= FullLength-CurLen) then
        tmpText := tmpText + Copy(FBackText,TextLen-(FullLength-CurLen)+1,FullLength-CurLen)
     else
     begin
          for i := 1 to FullLength-CurLen-TextLen do
          tmpText := tmpText + '0';
          tmpText := tmpText + FBackText;
     end;
     FExtending := True;
     Text := tmpText;
     FExtending := False;
end;

procedure TPMemoEdit.Change;
begin
     if not FExtending then
        inherited Change;
end;

procedure TPMemoEdit.KeyPress(var Key: Char);
begin
     inherited KeyPress(Key);
     if Key = #13 then
     begin
          BackText;
          if  (Text <> '' )and (FEnPreFix <> False)then
              DoExtend;
     end;
end;

procedure TPMemoEdit.DoExit;
begin
     if self.ClassType = TPMemoEdit then
        BackText
     else
         text := FBackText;
     if  (Text <> '' )and (FEnPreFix <> False)then
          DoExtend;
     inherited DoExit;
end;

procedure TPMemoEdit.SetDataBaseName(Value: string);
begin
      FDatabaseName := Value;
      if Value = '' then
      begin
           FTableName := '';
           FRefrenTableName := '';
           FieldName := '';
           FForeignFieldName := '';
      end;
end;

procedure TPMemoEdit.SetForeignFieldName(Value: string);
begin
     FForeignFieldName := Value;
end;

procedure TPMemoEdit.SetFieldName(Value: string);
begin
     FFieldName := Value;
end;

procedure TPMemoEdit.SetTableName(Value: string);
begin
     FTableName := Value;
end;

procedure TPMemoEdit.SetForeignTableName(Value: string);
begin
     FRefrenTableName := Value;
end;


procedure Register;
begin
     RegisterComponents('PosControl2', [TPMemoEdit]);
end;

end.
