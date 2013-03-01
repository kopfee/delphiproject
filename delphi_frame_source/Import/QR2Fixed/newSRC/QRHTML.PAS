{ :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: QuickReport 2.0 for Delphi 1.0/2.0/3.0                  ::
  ::                                                         ::
  :: QRHTML.PAS -  HTML export filter                        ::
  ::                                                         ::
  :: Copyright (c) 1997 QuSoft AS                            ::
  :: All Rights Reserved                                     ::
  ::                                                         ::
  :: web: http://www.qusoft.no   mail: support@qusoft.no     ::
  ::                             fax: +47 22 41 74 91        ::
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: }

unit qrHtml;

interface

{$R-}
{$T-} { We don't want this type checking! }
{$B-} { QuickReport source assumes boolean expression short-circuit  }

{$ifdef win32}
uses windows, sysutils, classes, controls, stdctrls, extctrls,graphics, buttons,
     forms, dialogs, printers, db, qrprntr, quickrpt, qrctrls;
{$else}
uses wintypes, winprocs, sysutils, classes, controls, stdctrls, extctrls, graphics,
     buttons, forms, dialogs, printers, db, qrprntr, quickrpt, qrctrls;
{$endif}

const
  CORR_FACTOR : extended = 1.5;

type
  TColRole = (crNone, crHeader, crDetail);

  { Forward }
  TTextRec = class;

  { TTextCont - Container for TTextRec }
  TTextCont = class
  private
    pFirst : TTextRec;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Insert(x, y : extended; Font : TFont; BGColor : TColor;
                     Text : string);
    procedure CalcColumns(booGlobal : boolean);
    procedure ClearAll;
    function GetFirst : TTextRec;
  end;

  { TTextRec - contains info about one line of text output }
  TTextRec = class
  private
    extX, extY : extended;
    fntFont : TFont;
    clrBGColor : TColor;
    strText : string;
    intColRole : TColRole;  { Calculated }
    intColNo   : integer;   { Calculated }
    Next : TTextRec;
    Prev : TTextRec;
    NextSameLine : TTextRec;
  public
    constructor Create;
    destructor Destroy; override;
    procedure InsertAfter(pTextRec : TTextRec);
    procedure InsertSameLineAfter(pTextRec : TTextRec);
  end;

  { TQRHtmlExportFilter }
  TQRHtmlExportFilter = class(TQRExportFilter)
  private
    LineCount : integer;
    Lines : array[0..200] of string;
    aFile : text;
    XFactor,
    YFactor : extended;
    pContainer : TTextCont;
  protected
    function GetFilterName : string; override;
    function GetDescription : string; override;
    function GetExtension : string; override;
  public
    procedure Start(PaperWidth, PaperHeight : integer; Font : TFont); override;
    procedure EndPage; override;
    procedure Finish; override;
    procedure NewPage; override;
    procedure TextOut(X,Y : extended; Font : TFont; BGColor : TColor; Alignment : TAlignment; Text : string); override;
  end;


  { TQRCSVExportFilter }
  TQRCSVExportFilter = class(TQRExportFilter)
  private
    LineCount : integer;
    Lines : array[0..200] of string;
    aFile : text;
    XFactor,
    YFactor : extended;
    pContainer : TTextCont;
  protected
    function GetFilterName : string; override;
    function GetDescription : string; override;
    function GetExtension : string; override;
  public
    procedure Start(PaperWidth, PaperHeight : integer; Font : TFont); override;
    procedure EndPage; override;
    procedure Finish; override;
    procedure NewPage; override;
    procedure TextOut(X,Y : extended; Font : TFont; BGColor : TColor; Alignment : TAlignment; Text : string); override;
  end;

implementation

uses qr2const;

const
  cqrToolBarHeight = 100;
  cqrStatusBarHeight = 20;

  cQRFontSizeCount = 16;
  cQRFontSizes : array[1..cQRFontSizeCount] of integer =
      (8, 9, 10, 11, 12, 14, 16, 18, 20, 22, 24, 26, 28, 36, 48, 72);

{ Utility routines }

function dup(aChar : Char; Count : integer) : string;
var
  I : integer;
begin
  result:='';
  for I:=1 to Count do result:=result+aChar;
end;

{ class TTextCont - container for TTextRec }

constructor TTextCont.Create;
begin
  inherited Create;
  pFirst := nil;
end;

destructor TTextCont.Destroy;
begin
  inherited Destroy;
end;

procedure TTextCont.Insert(X, Y : extended; Font : TFont; BGColor : TColor;
                     Text : string);
var
  pThis : TTextRec;
  pInsertAfter : TTextRec;
  pInsertAfterNext : TTextRec;
begin
  pThis := TTextRec.Create;
  with pThis do
  begin
    extX := X;
    extY := Y;
    strText := Text;
  end;
  if pFirst = nil then
    pFirst := pThis
  else
  begin
    { Find line of insertion }
    pInsertAfterNext := pFirst;
    pInsertAfter := NIL;
    while (pInsertAfterNext <> NIL) and (Abs(pInsertAfterNext.extY - Y) > CORR_FACTOR) do
    begin
      pInsertAfter := pInsertAfterNext;
      pInsertAfterNext := pInsertAfterNext.Next;
    end;

    if pInsertAfter = NIL then
    begin
      pThis.Next := pFirst;
      pFirst := pThis;
    end
    else
    begin
      if (pInsertAfterNext <> NIL) and (Abs(pInsertAfterNext.extY - Y) <= CORR_FACTOR) then
      begin
        if pInsertAfterNext.extX > X then
        begin
          pThis.Next := pInsertAfter.Next;
          pThis.Prev := pInsertAfter.Prev;
          pThis.NextSameLine := pInsertAfter;
        end
        else
        begin
          while (pInsertAfterNext <> NIL) and (pInsertAfterNext.extX < X) do
          begin
            pInsertAfter := pInsertAfterNext;
            pInsertAfterNext := pInsertAfterNext.NextSameLine;
          end;
          pInsertAfter.InsertSameLineAfter(pThis)
        end;
      end
      else
        pInsertAfter.InsertAfter(pThis);
    end;
  end;
end;

procedure TTextCont.ClearAll;
var
  pThis, pNextRec : TTextRec;
begin
  pThis := GetFirst;
  while pThis <> nil do
  begin
    pNextRec := pThis.Next;
    pThis.Free;
    pThis := pNextRec;
  end;
  pFirst := nil;
end;

function TTextCont.GetFirst : TTextRec;
begin
  Result := pFirst;
end;

{ Calculate columns. booGlobal = true if columns are to be global for the report }
procedure TTextCont.CalcColumns(booGlobal : boolean);
var
  pThis : TTextRec;
  pSameLine : TTextRec;
  intColumn : integer;
  intRole   : TColRole;
begin
  pThis := GetFirst;
  intColumn := 1;
  while (pThis <> NIL) do
  begin
    if (pThis.NextSameLine = NIL) then
    begin
      pThis.intColRole := crNone;
      pThis.intColNo   := 0;
    end
    else
    begin
      pSameLine := pThis;
      if (pThis.Prev = NIL) or (pThis.Prev.NextSameLine = NIL) then
        intRole := crHeader
      else
        intRole := crDetail;
      while pSameLine <> NIL do
      begin
        with pSameLine do
        begin
          intColRole := intRole;
          intColNo := intColumn;
        end;
        Inc(intColumn);
        pSameLine := pSameLine.NextSameLine;
      end;
    end;
    pThis := pThis.Next;
  end;
end;


{ class TTextRec - contains info about one line of text output }

constructor TTextRec.Create;
begin
  inherited Create;
  Next := nil;
  Prev := nil;
  intColRole := crNone;
  intColNo   := 0;
  NextSameLine := nil;
  fntFont := nil;
end;

destructor TTextRec.Destroy;
begin
  inherited Destroy;
end;

procedure TTextRec.InsertAfter(pTextRec : TTextRec);
begin
  pTextRec.Next := Self.Next;
  pTextRec.Prev := Self;
  Self.Next := pTextRec;
end;

procedure TTextRec.InsertSameLineAfter(pTextRec : TTextRec);
begin
  pTextRec.NextSameLine := Self.NextSameLine;
  Self.NextSameLine := pTextRec;
end;

{ TQRHtmlExportFilter }

function TQRHtmlExportFilter.GetDescription : string;
begin
  result:='Export to HTML format'; {LoadStr(SqrAsciiFilterDescription);}
end;

function TQRHtmlExportFilter.GetFilterName : string;
begin
  result:='HTML document';{LoadStr(SqrAsciiFilterName);}
end;

function TQRHtmlExportFilter.GetExtension : string;
begin
  result:='HTM';{LoadStr(SQrAsciiFilterExtension);}
end;

procedure TQRHtmlExportFilter.Start(PaperWidth, PaperHeight : integer; Font : TFont);
begin
  pContainer := TTextCont.Create;

  AssignFile(aFile,Filename);
  Rewrite(aFile);
  YFactor:=Font.Size*(254/72);
  XFactor:=Font.Size*(254/72);
  LineCount:=round(PaperHeight/YFactor);

  WriteLn(aFile, '<html>');
end;

procedure TQRHtmlExportFilter.EndPage;
var
  pTextRec : TTextRec;
  pLine    : TTextRec;
begin
  pContainer.CalcColumns(False);
  pTextRec := pContainer.GetFirst;
  while pTextRec <> nil do
  begin
    pLine := pTextRec;
    case pLine.intColRole of
      crNone   : if (pTextRec.Prev <> NIL) and (pTextRec.Prev.intColRole = crDetail) then
                   Write(aFile, '</TABLE>', pTextRec.strText, '<BR>')
                 else
                   Write(aFile, pTextRec.strText, '<BR>');
      crHeader : Write(aFile, '<TABLE BORDER=1 WIDTH=100%><TD>', pTextRec.strText);
      crDetail : Write(aFile, '<TR><TD>', pTextRec.strText);
    end;

    while (pLine.NextSameLine <> NIL) do
    begin
      pLine := pLine.NextSameLine;
      if pLine <> NIL then
        Write(aFile, '<TD>', pLine.strText);
    end;
    if (pTextRec.Next = NIL) and (pTextRec.intColRole <> crNone) then
      Write(aFile, '</TABLE>');
    WriteLn(aFile);
    pTextRec := pTextRec.Next;
  end;
  pContainer.ClearAll;
end;

procedure TQRHtmlExportFilter.Finish;
begin
  WriteLn(aFile, '</HTML>');
  CloseFile(aFile);
end;

procedure TQRHtmlExportFilter.NewPage;
var
  I : integer;
begin
  for I:=0 to 200 do
    Lines[I]:='';
end;

procedure TQRHtmlExportFilter.TextOut(X,Y : Extended; Font : TFont; BGColor : TColor; Alignment : TAlignment; Text : string);
var
  aLine : string;
begin
  X:=X/XFactor*1.5;
  Y:=Y/YFactor;
  aLine:=Lines[round(Y)];
  if length(aLine)<X then
    aLine:=aLine+dup(' ',round(X)-length(aLine));
  Delete(aLine,round(X),Length(Text));
  Insert(Text,aLine,round(X));
  Lines[round(Y)]:=aLine;

  pContainer.Insert(X, Y, Font, BGColor, Text);
end;


{ TQRCSVExportFilter }

function TQRCSVExportFilter.GetDescription : string;
begin
  result:='Export to CSV format'; {LoadStr(SqrAsciiFilterDescription);}
end;

function TQRCSVExportFilter.GetFilterName : string;
begin
  result:='CSV comma separated';{LoadStr(SqrAsciiFilterName);}
end;

function TQRCSVExportFilter.GetExtension : string;
begin
  result:='CSV';{LoadStr(SQrAsciiFilterExtension);}
end;

procedure TQRCSVExportFilter.Start(PaperWidth, PaperHeight : integer; Font : TFont);
begin
  pContainer := TTextCont.Create;

  AssignFile(aFile,Filename);
  Rewrite(aFile);
  YFactor:=Font.Size*(254/72);
  XFactor:=Font.Size*(254/72);
  LineCount:=round(PaperHeight/YFactor);
end;

procedure TQRCSVExportFilter.EndPage;
var
  pTextRec : TTextRec;
  pLine    : TTextRec;
begin
  pTextRec := pContainer.GetFirst;
  while pTextRec <> nil do
  begin
    pLine := pTextRec;
    Write(aFile, pTextRec.strText);
    while (pLine.NextSameLine <> NIL) do
    begin
      pLine := pLine.NextSameLine;
      if pLine <> NIL then
        Write(aFile, ';', pLine.strText);
    end;
    WriteLn(aFile);
    pTextRec := pTextRec.Next;
  end;
  pContainer.ClearAll;
end;

procedure TQRCSVExportFilter.Finish;
begin
  WriteLn(aFile, '</CSV>');
  CloseFile(aFile);
end;

procedure TQRCSVExportFilter.NewPage;
var
  I : integer;
begin
  for I:=0 to 200 do
    Lines[I]:='';
end;

procedure TQRCSVExportFilter.TextOut(X,Y : Extended; Font : TFont; BGColor : TColor; Alignment : TAlignment; Text : string);
var
  aLine : string;
begin
  X:=X/XFactor*1.5;
  Y:=Y/YFactor;
  aLine:=Lines[round(Y)];
  if length(aLine)<X then
    aLine:=aLine+dup(' ',round(X)-length(aLine));
  Delete(aLine,round(X),Length(Text));
  Insert(Text,aLine,round(X));
  Lines[round(Y)]:=aLine;
  pContainer.Insert(X, Y, Font, BGColor, Text);
end;


initialization
  QRExportFilterLibrary.AddFilter(TQRHtmlExportFilter);
  QRExportFilterLibrary.AddFilter(TQRCSVExportFilter);
end.

