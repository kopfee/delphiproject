unit StorageUtils;

// %StorageUtils : 使用IniFile的工具

(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, IniFiles;

// Prefix like 'Font.', 'FixFont.'
procedure ReadFontFromIni(
	IniFile : TIniFile;
  const Section,Prefix : string;
  Font : TFont);

// Prefix like 'Font.', 'FixFont.'
procedure WriteFontToIni(
	IniFile : TIniFile;
  const Section,Prefix : string;
  Font : TFont);

implementation

//uses ExtUtils;
type
	PInteger = ^integer;

procedure ReadFontFromIni(
	IniFile : TIniFile;
  const Section,Prefix : string;
  Font : TFont);
var
	AStyle : TFontStyles;
begin
  with IniFile,Font do
  begin
    Charset := ReadInteger(Section,Prefix+'Charset',DEFAULT_CHARSET);
    Name := ReadString(Section,Prefix+'Name','MS Sans Serif');
    Color := TColor(ReadInteger(Section,Prefix+'Color',clBlack));
    Height := ReadInteger(Section,Prefix+'Height',-13);
    //Style := TFontStyles(ReadInteger(Section,Prefix+'Style',0));
    //Integer(TSmallSet(Style)) := (ReadInteger(Section,Prefix+'Style',0));
    PInteger(@AStyle)^ :=  ReadInteger(Section,Prefix+'Style',0);
    Style := AStyle;
  end;
end;

procedure WriteFontToIni(
	IniFile : TIniFile;
  const Section,Prefix : string;
  Font : TFont);
var
	AStyle : TFontStyles;
begin
  with IniFile,Font do
  begin
    WriteInteger(Section,Prefix+'Charset',Charset);
    WriteString(Section,Prefix+'Name',Name);
    WriteInteger(Section,Prefix+'Color',Color);
    WriteInteger(Section,Prefix+'Height',Height);
    AStyle := Style;
    WriteInteger(Section,Prefix+'Style',pinteger(@AStyle)^);
  end;
end;

end.
