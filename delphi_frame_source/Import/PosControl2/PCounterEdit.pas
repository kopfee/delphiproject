unit PCounterEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,dbtables;

type
  TPcounterEdit = class(TCustomEdit)
  private
    { Private declarations }
    FCheckResult: Boolean;
    FIsInDataBase: Boolean;
    FDatabaseName: string;
    FFormat: string;
    FNeedCheck: Boolean;
    FQuery: TQuery;
    FTableName: string;
    FEmptyValid: boolean;
  protected
    { Protected declarations }
    function  GetCheckResult: Boolean;
    procedure Change; override;
    procedure CheckFormat;
    procedure OpenQuery;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    function CheckExist: Boolean;
    property FormatIsOk: Boolean read GetCheckResult ;
    property IsInDataBase: Boolean read FIsInDataBase write FIsInDataBase;
  published
    { Published declarations }
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property CharCase;
    property Color;
    property Ctl3D;
    property DatabaseName: string read FDatabaseName write FDatabaseName;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property OEMConvert;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
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

    property TextFormat: string read FFormat write FFormat stored false;
    property  EmptyValid : boolean read FEmptyValid write FEmptyValid default true;
  end;

procedure Register;

implementation

uses configsupport;

function TPcounterEdit.GetCheckResult: Boolean;
begin
     CheckFormat;
     Result := FCheckResult;
end;

procedure TPcounterEdit.Change;
begin
     inherited;
     CheckFormat;
end;

Function TPcounterEdit.CheckExist: Boolean;
begin
     OpenQuery;
     FIsInDataBase := False;
     try
        if FQuery.Locate('cnt_no', Text,[]) then
           FIsInDataBase := True;
     except
     end;
end;

{
procedure TPcounterEdit.CheckFormat;
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
          if strlen(pchar(Text)) = len then
               break
     end;

     if i > strlen(pchar(FFormat)) then exit;

     FCheckResult := True;
end; }

procedure TPcounterEdit.CheckFormat;
var
  i,Formatlen,Textlen,len: integer;
begin
  if Text='' then
  begin
    FCheckResult := EmptyValid;
    exit;
  end;

  TextLen := length(Text);
  FormatLen := length(FFormat);

  FCheckResult := False;
  len := 0;
  for i :=  1 to FormatLen do
  begin
    try
      len := len + strtoint(FFormat[i]);
    except
      Exit;
    end;
    if TextLen = len then
    begin
      FCheckResult := True;
      break;
    end
    else if TextLen < len then Break;
  end;
end;


constructor TPcounterEdit.Create (AOwner: TComponent);
begin
     inherited Create(AOwner);
     FQuery := TQuery.Create(Self);
     FCheckResult := False;
     FIsInDataBase := False;
//     以后要改回
     if (csDesigning	 in componentstate ) then
          FFormat := '23222'
     else
         FFormat := sysconfig.OriginValues['ORGANICSTRUC'];
     FTableName := 'tbCounter';
     Font.Size := 9;
     Font.Name := '宋体';
     ParentFont := False;

     FEmptyValid := true;
end;

destructor TPcounterEdit.Destroy;
begin
     FQuery.Free;
     inherited Destroy;
end;

procedure TPcounterEdit.OpenQuery;
var temp : string;
begin
     FQuery.Close;
     if FQuery.DatabaseName <> FDatabaseName then
        FQuery.DatabaseName := FDatabaseName;
     FQuery.SQL.Clear;
     temp := 'Select * from '+FTableName;
      FQuery.SQL.Add(temp);
      try
         FQuery.Open;
      except
            FCheckResult := False;
            FIsInDataBase := False;
            abort;
      end;
end;

procedure Register;
begin
     RegisterComponents('PosControl2', [TPCounterEdit]);
end;

end.

