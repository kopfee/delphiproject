unit GridEx;

// %GridEx : 包含对StringGrid的扩展

(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IniFiles,Grids;

  //DT_NOPREFIX or DT_WORDBREAK or DT_EDITCONTROL

type
  TStringGridEx = class;
  TGridDataEvent = procedure (Sender : TStringGridEx;
      IniFile : TIniFile) of object;

  // %TStringGridEx : 对StringGrid的扩展。
  // #功能：可以指定固定行列的字体；文字折行；保存到文件
  TStringGridEx = class(TStringGrid)
  private
  { Private declarations }
    FWordWrap: boolean;
    FFixRowFont: TFont;
    FTopLeftFont: TFont;
    FFixColFont: TFont;
    FOnLoadFromFile: TGridDataEvent;
    FOnSaveToFile: TGridDataEvent;
    procedure SetFixColFont(const Value: TFont);
    procedure SetFixRowFont(const Value: TFont);
    procedure SetTopLeftFont(const Value: TFont);
    procedure SetWordWrap(const Value: boolean);
    procedure FontChanged(sender : TObject);
    function GetFixHorLine: boolean;
    function GetFixVerLine: boolean;
    function GetHorLine: boolean;
    function GetVerLine: boolean;
    procedure SetFixHorLine(const Value: boolean);
    procedure SetFixVerLine(const Value: boolean);
    procedure SetHorLine(const Value: boolean);
    procedure SetVerLine(const Value: boolean);
    procedure SetFixFont(const Value: TFont);
  protected
    { Protected declarations }
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
      AState: TGridDrawState); override;
    {procedure CalcSizingState(X, Y: Integer; var State: TGridState;
      var Index: Longint; var SizingPos, SizingOfs: Integer;
      var FixedInfo: TGridDrawInfo); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;}
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor  destroy; override;
    procedure   LoadFromFile(const FileName:string);
    procedure   SaveToFile(const FileName:string);
    procedure   DeleteColumn(ACol: Longint); override;
    procedure   DeleteRow(ARow: Longint); override;
    property 		VerLine : boolean read GetVerLine write SetVerLine;
    property 		HorLine : boolean read GetHorLine write SetHorLine;
    property 		FixVerLine : boolean read GetFixVerLine write SetFixVerLine;
    property 		FixHorLine : boolean read GetFixHorLine write SetFixHorLine;
  published
    { Published declarations }
    property  FixFont : TFont
                read FFixColFont write SetFixFont stored false;
    property  FixColFont : TFont
                read FFixColFont write SetFixColFont;
    property  FixRowFont : TFont
                read FFixRowFont write SetFixRowFont;
    property  TopLeftFont : TFont
                read FTopLeftFont write SetTopLeftFont;
    property  WordWrap : boolean
                read FWordWrap write SetWordWrap default true;
    property  OnLoadFromFile : TGridDataEvent
                read FOnLoadFromFile write FOnLoadFromFile;
    property  OnSaveToFile : TGridDataEvent
                read FOnSaveToFile write FOnSaveToFile;
  end;

implementation

uses ExtUtils,SafeCode,StorageUtils;

{ TStringGridEx }

constructor TStringGridEx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFixRowFont := TFont.Create;
  FFixColFont := TFont.Create;
  FTopLeftFont := TFont.Create;
  FFixRowFont.OnChange := FontChanged;
  FFixColFont.OnChange := FontChanged;
  FTopLeftFont.OnChange := FontChanged;
  FWordWrap := true;
end;

procedure TStringGridEx.DeleteColumn(ACol: Integer);
begin
  CheckRange(ACol,FixedCols,ColCount-1);
  inherited DeleteColumn(ACol);
end;

procedure TStringGridEx.DeleteRow(ARow: Integer);
begin
  CheckRange(ARow,FixedRows,RowCount-1);
  inherited DeleteRow(ARow);
end;

destructor TStringGridEx.destroy;
begin
  FFixRowFont.free;
  FFixColFont.free;
  FTopLeftFont.free;
  inherited destroy;
end;

procedure TStringGridEx.DrawCell(ACol, ARow: Integer; ARect: TRect;
  AState: TGridDrawState);
var
  r : TRect;
  //Hold: Integer;
  SaveDefaultDrawing : boolean;
  Flags : integer;
begin
  if DefaultDrawing then
  begin
    // dec rect
    r := Arect;
    inc(r.top,2);
    inc(r.left,2);

    // set font
    if (ACol<FixedCols) and (ARow<FixedRows) then
      Canvas.font := FTopLeftFont
    else if (ACol<FixedCols) then
      Canvas.font := FFixColFont
    else if (ARow<FixedRows) then
      Canvas.font := FFixRowFont
    else
    begin
      Canvas.font := font;
      if (gdSelected in AState) and
        (not (gdFocused in AState) or
        ([goDrawFocusSelected, goRowSelect] * Options <> [])) then
      Canvas.font.color := not Canvas.font.color;
    end;

    // set text flags
    if wordWrap THEN
      flags := DT_NOPREFIX or DT_WORDBREAK or DT_EDITCONTROL
    else
      flags := DT_NOPREFIX;

    windows.DrawText(canvas.handle,
      pchar(Cells[ACol, ARow]),
      -1,
      r,
      flags);
  end;
  // call inherited draw
  SaveDefaultDrawing := DefaultDrawing;
  DefaultDrawing := false;
  try
    inherited DrawCell(ACol, ARow,ARect,AState);
  finally
    DefaultDrawing := SaveDefaultDrawing;
  end;
end;

procedure TStringGridEx.FontChanged(sender: TObject);
begin
  invalidate;
end;

function TStringGridEx.GetFixHorLine: boolean;
begin
  result := goFixedHorzLine in options;
end;

function TStringGridEx.GetFixVerLine: boolean;
begin
  result := goFixedVertLine in options;
end;

function TStringGridEx.GetHorLine: boolean;
begin
  result := goHorzLine in options;
end;

function TStringGridEx.GetVerLine: boolean;
begin
  result := goVertLine in options;
end;

procedure TStringGridEx.SetFixHorLine(const Value: boolean);
begin
  if value then
      options := options + [goFixedHorzLine]
    else
			options := options - [goFixedHorzLine];
end;

procedure TStringGridEx.SetFixVerLine(const Value: boolean);
begin
  if value then
      options := options + [goFixedVertLine]
    else
			options := options - [goFixedVertLine];
end;

procedure TStringGridEx.SetHorLine(const Value: boolean);
begin
  if value then
      options := options + [goHorzLine]
    else
			options := options - [goHorzLine];
end;

procedure TStringGridEx.SetVerLine(const Value: boolean);
begin
  if value then
      options := options + [goVertLine]
    else
			options := options - [goVertLine];
end;

const
  HeaderSec = 'Header';
  WidthsSec = 'Widths';
  HeightsSec = 'Heights';
  ColKey = 'Col';
  RowKey = 'Row';
  FixColKey = 'FixCol';
  FixRowKey = 'FixRow';
  DefaultRows = 3;
  DefaultCols = 3;
  DefaultFixRows = 1;
  DefaultFixCols = 1;
  DefaultWidth = 150;
  DefaultHeight = 25;

  ColorKey = 'Color';
  FixColorKey = 'FixColor';
  Ctrl3DKey = 'Ctrl3DKey';
  FontKey = 'Font.';
  FixFontKey = 'FixFont.';
  DefaultColor = clInfoBK;
  DefaultFixColor = clAqua;
  DefaultCtrl3D = false;

  VerLineKey = 'VerLine';
  HorLineKey= 'HorLine';
	FixVerLineKey= 'FixVerLine';
	FixHorLineKey= 'FixVerLine';
  DefaultShowLine = true;

procedure TStringGridEx.LoadFromFile(const FileName: string);
var
  IniFile : TIniFile;
  ACol,ARow : integer;
begin
  //CheckFileExist(FileName);
  IniFile := TIniFile.Create(FileName);
  try
    IniFile.UpdateFile;
    if Assigned(FOnLoadFromFile) then
      FOnLoadFromFile(self,IniFile);
    FixedCols := 0;
    FixedRows := 0;
    // get rows,cols ...
    RowCount := IniFile.ReadInteger(HeaderSec,RowKey,DefaultRows);
    ColCount := IniFile.ReadInteger(HeaderSec,ColKey,DefaultCols);
    FixedRows := IniFile.ReadInteger(HeaderSec,FixRowKey,DefaultFixRows);
    FixedCols := IniFile.ReadInteger(HeaderSec,FixColKey,DefaultFixCols);
    // get widths,heights
    for ACol:=0 to ColCount-1 do
      ColWidths[ACol] := IniFile.ReadInteger(
        WidthsSec,IntToStr(ACol),DefaultWidth);

    for ARow:=0 to RowCount-1 do
      RowHeights[ARow] := IniFile.ReadInteger(
        HeightsSec,IntToStr(ARow),DefaultHeight);
    // get text
    for ARow:=0 to RowCount-1 do
      for ACol:=0 to ColCount-1 do
        Cells[ACol,ARow] := IniFile.ReadString(
          IntToStr(ARow),IntToStr(ACol),'');
    // get appearance
    Color := IniFile.ReadInteger(HeaderSec,ColorKey,DefaultColor);
	  FixedColor := IniFile.ReadInteger(HeaderSec,FixColorKey,DefaultFixColor);
    Ctl3D := IniFile.ReadBool(HeaderSec,Ctrl3DKey,DefaultCtrl3D);
    ReadFontFromIni(IniFile,HeaderSec,FontKey,Font);

		ReadFontFromIni(IniFile,HeaderSec,FixFontKey,FixRowFont);
    FixFont := FixRowFont;
    {ReadFontFromIni(IniFile,HeaderSec,FixFontKey,FixColFont);
    FixRowFont:=FixColFont;
    TopLeftFont:=FixColFont;}

    VerLine := IniFile.ReadBool(HeaderSec,VerLineKey,DefaultShowLine);
		HorLine := IniFile.ReadBool(HeaderSec,HorLineKey,DefaultShowLine);
		FixVerLine := IniFile.ReadBool(HeaderSec,FixVerLineKey,DefaultShowLine);
		FixHorLine := IniFile.ReadBool(HeaderSec,FixHorLineKey,DefaultShowLine);
  finally
    IniFile.free;
  end;
end;

procedure TStringGridEx.SaveToFile(const FileName: string);
var
  IniFile : TIniFile;
  ACol,ARow : integer;
begin
  IniFile := TIniFile.Create(FileName);
  with IniFile do
  try
    if Assigned(FOnSaveToFile) then
      FOnSaveToFile(self,IniFile);
    // save rows,cols ...
    WriteInteger(HeaderSec,RowKey,RowCount);
    WriteInteger(HeaderSec,ColKey,ColCount);
    WriteInteger(HeaderSec,FixRowKey,FixedRows);
    WriteInteger(HeaderSec,FixColKey,FixedCols);
    // save widths,heights
    for ACol:=0 to ColCount-1 do
      WriteInteger(
        WidthsSec,IntToStr(ACol),ColWidths[ACol]);

    for ARow:=0 to RowCount-1 do
      WriteInteger(
        HeightsSec,IntToStr(ARow),RowHeights[ARow]);
    // save text
    for ARow:=0 to RowCount-1 do
      for ACol:=0 to ColCount-1 do
        WriteString(
          IntToStr(ARow),IntToStr(ACol),Cells[ACol,ARow]);
    // save appearance
    IniFile.WriteInteger(HeaderSec,ColorKey,Color);
	  IniFile.WriteInteger(HeaderSec,FixColorKey,FixedColor);
    IniFile.WriteBool(HeaderSec,Ctrl3DKey,Ctl3D);
    WriteFontToIni(IniFile,HeaderSec,FontKey,Font);
		WriteFontToIni(IniFile,HeaderSec,FixFontKey,FixFont);
    //WriteFontToIni(IniFile,HeaderSec,FixFontKey,FixColFont);

    IniFile.WriteBool(HeaderSec,VerLineKey,VerLine);
		IniFile.WriteBool(HeaderSec,HorLineKey,HorLine);
		IniFile.WriteBool(HeaderSec,FixVerLineKey,FixVerLine);
		IniFile.WriteBool(HeaderSec,FixHorLineKey,FixHorLine);

    IniFile.UpdateFile;
  finally
    IniFile.free;
  end;
end;

procedure TStringGridEx.SetFixColFont(const Value: TFont);
begin
  FFixColFont.Assign(Value);
end;

procedure TStringGridEx.SetFixRowFont(const Value: TFont);
begin
  FFixRowFont.Assign(Value);
end;

procedure TStringGridEx.SetTopLeftFont(const Value: TFont);
begin
  FTopLeftFont.Assign(Value);
end;

procedure TStringGridEx.SetWordWrap(const Value: boolean);
begin
  if FWordWrap <> Value then
  begin
    FWordWrap := Value;
    invalidate;
  end;
end;

(*
procedure TStringGridEx.CalcSizingState(X, Y: Integer;
  var State: TGridState; var Index, SizingPos, SizingOfs: Integer;
  var FixedInfo: TGridDrawInfo);
begin
  FixedInfo.Horz.FixedCellCount := 1;
  FixedInfo.Horz.FixedBoundary := 1;
  FixedInfo.Horz.FirstGridCell := 0;
  {//inc(FixedInfo.Horz.GridCellCount);
  FixedInfo.Vert.FixedCellCount := 0;
  //FixedInfo.Vert.FixedBoundary := 1;
  FixedInfo.Vert.FirstGridCell := 1;
  //inc(FixedInfo.Vert.GridCellCount);}
  OutputDebugString(pchar(
    format('%d %d %d %d',[
      FixedInfo.Horz.FixedCellCount,
      FixedInfo.Horz.FixedBoundary,
      FixedInfo.Horz.FirstGridCell,
      FixedInfo.Horz.GridCellCount])
    ));
  inherited CalcSizingState(X, Y,State,Index,
    SizingPos, SizingOfs,FixedInfo);
end;
 *)

 {
procedure TStringGridEx.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  TheState :  TGridState;
  Index : integer;
begin
  TheState := FGridState;
  Index := FSizingIndex;
end;
}

procedure TStringGridEx.SetFixFont(const Value: TFont);
begin
  FFixColFont.Assign(Value);
  FFixRowFont.Assign(Value);
  FTopLeftFont.Assign(Value);
end;

end.
