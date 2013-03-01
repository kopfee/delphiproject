unit Entity;

// Entity-Translator
// Version 1.0 vom 01.08.1999
// http://www.philo.de/xml/entity
//
// Copyright 1999 by
//   Dieter Köhler
//   email: service@philo.de
//   homepage: http://www.philo.de/homepage.htm
//
// Diese Delphi-Unit darf sowohl privat als auch kommerziell völlig
// frei benutzt werden.  Es besteht keine Garantie für die
// Funktionsfähigkeit und Stabilität des Codes.  Die Benutzung erfolgt
// vollständig auf eigene Gefahr.  Bei Weitergabe des Quellcodes darf
// dieser Urheberrechtshinweis nicht entfernt werden.
//
// This Delphi unit is completely free for personal or commercial use.
// The code is supplied with no guarantees on performance or stability
// and must be used at your own risk.  This copyright notice must not be
// deleted from this source code.

interface

uses
  dsgnintf, sysutils, classes
  {$ifdef VER130}, typinfo {$endif} // In D5 EPropertyError is located in TypInfo.pas
  ;

type
  TCharToEntityTranslator = class (TComponent)
  private
    FDictionary: TStrings;
    FNames: TStrings;
    FValues: TStrings;
    FFilename: TFileName;
    function GetFile: TFileName; virtual;
    function ReplaceString(const value: string): string; virtual;
    procedure SetFile(const Filename: TFileName); virtual;
    function IsWhiteSpace(const S: Char): boolean; virtual;
  public
    constructor Create(aOwner: TComponent); override;
    destructor  Destroy; override;
    function Translate(const source: string): string; virtual;
    function ReplaceWhiteSpace(const Source: string;
                               const ReplaceChar: Char): string; virtual;
    function ReplaceChar(const Source: string;
                         const FindChar,
                               ReplaceChar: Char): string; virtual;
    function ReplaceCharByString(const Source: string;
                                 const FindChar: Char;
                                 const ReplaceStr: string): string;
  published
    property DictionaryFile: TFileName read GetFile write SetFile;
  end;

type
  TEntityToCharTranslator = class (TCharToEntityTranslator)
  private
    FLeftDelimiter: char;
    FRightDelimiter: char;
    function GetLeftDelimiter: Char; virtual;
    procedure SetLeftDelimiter(const value: Char); virtual;
    function GetRightDelimiter: Char; virtual;
    procedure SetRightDelimiter(const value: Char); virtual;
  public
    constructor Create(aOwner: TComponent); override;
    function translate(const source: string): string; override;
  published
    property LeftDelimiter: Char read GetLeftDelimiter write SetLeftDelimiter default '&';
    property RightDelimiter: Char read GetRightDelimiter write SetRightDelimiter default ';';
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('XML',[TCharToEntityTranslator,TEntityToCharTranslator]);
end;




//++++++++++++++++++++++ TCharToEntityTranslator +++++++++++++++++++++++

constructor TCharToEntityTranslator.Create(aOwner: TComponent);
begin
  Inherited Create(aOwner);
  FDictionary:= TStringList.create;
  FNames:= TStringList.create;
  FValues:= TStringList.create;
end;

destructor  TCharToEntityTranslator.Destroy;
begin
  FDictionary.free;
  FNames.free;
  FValues.free;
  Inherited destroy;
end;

function TCharToEntityTranslator.GetFile: TFileName;
begin
  Result:= FFilename;
end;

function TCharToEntityTranslator.ReplaceString(const value: string): string;
var
  i: integer;
begin
  Result:= value;
  for i:= 0 to FNames.count-1 do
    if AnsiCompareStr(value,FNames[i]) = 0 then begin
      Result:= FValues[i];
      break;
    end;
end;

procedure TCharToEntityTranslator.SetFile(const Filename: TFileName);
var
  i,p: longint;
begin
  if Filename <> FFilename then
  begin
    FFilename:= Filename;
    try
      FDictionary.LoadFromFile(Filename);
      FNames.clear;
      FValues.clear;
      for i:= 0 to FDictionary.count-1 do begin
        p:= Pos('=',FDictionary[i]);
        if p > 0 then begin
          FNames.add(copy(FDictionary[i],1,p-1));
          FValues.add(copy(FDictionary[i],p+1,length(FDictionary[i])-p));
        end;
      end; {for i:= 0 ...}
    except
      On EFOpenError do
      begin
        FDictionary.clear;
      end;
    end;
  end;
end;

function TCharToEntityTranslator.IsWhiteSpace(const S: Char): boolean;
begin
  Case ord(S) of
    $09,$0A,$0D,$20:
    result:= true;
  else
    result:= false;
  end;
end;

function TCharToEntityTranslator.translate(const source: string): string;
var
  i: longint;
begin
  Result:= '';
  for i:= 1 to length(source) do
    Result:= concat(Result,ReplaceString(source[i]));
end;

function TCharToEntityTranslator.ReplaceWhiteSpace(const Source: string;
                                                   const ReplaceChar: Char): string;
var
  i: integer;
begin
  Result:= Source;
  for i:= 1 to length(Result) do
    if IsWhiteSpace(Result[i])
      then Result:= concat(copy(Result,1,i-1),ReplaceChar,copy(Result,i+1,length(Result)-i));
end;

function TCharToEntityTranslator.ReplaceChar(const Source: string;
                                             const FindChar,
                                                   ReplaceChar: Char): string;
var
  i: integer;
begin
  Result:= Source;
  for i:= 1 to length(Result) do
    if Result[i] = FindChar
      then Result:= concat(copy(Result,1,i-1),ReplaceChar,copy(Result,i+1,length(Result)-i));
end;

function TCharToEntityTranslator.ReplaceCharByString(const Source: string;
                                                     const FindChar: Char;
                                                     const ReplaceStr: string): string;
var
  i: integer;
begin
  Result:= Source;
  for i:= 1 to length(Result) do
    if Result[i] = FindChar
      then Result:= concat(copy(Result,1,i-1),ReplaceStr,copy(Result,i+1,length(Result)-i));
end;



//++++++++++++++++++++ TEntityToCharTranslator +++++++++++++++++++++++++

constructor TEntityToCharTranslator.Create(aOwner: TComponent);
begin
  Inherited Create(aOwner);
  LeftDelimiter:= '&';
  RightDelimiter:= ';';
end;

function  TEntityToCharTranslator.GetLeftDelimiter: Char;
begin
  Result:= FLeftDelimiter;
end;

procedure TEntityToCharTranslator.SetLeftDelimiter(const value: Char);
begin
  if Length(value)<> 1
    then raise EPropertyError.create('Invalid value for left delimiter.')
    else FLeftDelimiter:= value;
end;

function  TEntityToCharTranslator.GetRightDelimiter: Char;
begin
  Result:= FRightDelimiter;
end;

procedure TEntityToCharTranslator.SetRightDelimiter(const value: Char);
begin
  if Length(value)<> 1
    then raise EPropertyError.create('Invalid value for right delimiter.')
    else FRightDelimiter:= value;
end;

function TEntityToCharTranslator.translate(const source: string): string;
var
  EntityAnfang,EntityEnde: longint;
  S: string;
begin
  Result:= '';
  S:= source;
  while length(S)>0 do  {Solange S nicht abgearbeitet wurde, wiederhole:}
  begin
    if copy(S,1,1) = FLeftDelimiter then {beginnt S mit einer Entity?}
    begin
      EntityEnde := pos(RightDelimiter,S);
      if EntityEnde = 0 then {Falls Entity unvollständig, ...}
      begin
        Result:= concat(Result,S); {... S als Teil-String verzeichnen}
        S:='';        {S ist nun leer}
      end
      else {if EntityEnde = 0} {Falls Entity vollständig, ...}
      begin
        {... nur die Entity als Teil-String verzeichnen:}
        Result:= concat(Result,ReplaceString(copy(S,1,EntityEnde)));
        {S um die Entity verkürzen:}
        S:= copy(S,EntityEnde+1,length(S));
      end; {if EntityEnde = 0}
    end
    else {if copy(s,1,1) = Left} {Keine Entity am Anfang der Zeile:}
    begin
      {Feststellen, wo die nächste Entity beginnt:}
      EntityAnfang := pos(FLeftDelimiter,S);
      {Gibt es noch mindestens eine Entity in S? ...}
      if EntityAnfang = 0 then
      begin                        {... Nein}
        Result:= concat(Result,S); {S verzeichnen}
        S:='';                     {S ist nun leer}
      end
      else {if EntityAnfang = 0}   {... Ja}
      begin
        {Teilstring vor der Entity verzeichnen:}
        Result:= concat(Result,copy(S,1,EntityAnfang-1));
        {S entsprechend kürzen:}
        S:= copy(S,EntityAnfang,length(S));
      end; {if EntityAnfang = 0}
    end; {if copy(S,1,1) = Left}
  end; {while length(S)>0}
end;

end.
