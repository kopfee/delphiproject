unit example01main;

// Code Example 01 of using XDOM 2.2.1
// Delphi 3 Implementation
//
// You need XDOM 2.2.1 or above to use this source code.
// The latest version of XDOM can be found at "http://www.philo.de/xml/".
//
// Copyright (c) 2000 by Dieter Köhler
// ("http://www.philo.de/homepage.htm")
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

interface

uses
  XDOM,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Tabs;

type
  TMainpage = class(TForm)
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    SpeedButton1: TSpeedButton;
    XmlToDomParser1: TXmlToDomParser;
    DomImplementation1: TDomImplementation;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label1: TLabel;
    TabSet1: TTabSet;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure XmlToDomParser1ExternalSubset(Sender: TObject;
      const PublicId, SystemId: WideString; var extSubset: WideString);
    procedure TabSet1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Mainpage: TMainpage;

implementation

{$R *.DFM}

procedure TMainpage.SpeedButton1Click(Sender: TObject);
var
  UpTime: integer;
  Doc: TdomDocument;
  index: integer;
begin
  OpenDialog1.InitialDir:= ExtractFileDir(Label1.caption);
  if OpenDialog1.Execute then begin

    Memo1.Clear;
    Memo1.Update;
    Label8.caption:= '';
    Label10.caption:= '';

    if not FileExists (OpenDialog1.FileName) then begin
      Label1.caption:= 'File not found!';
      Label3.caption:= '';
      exit;
    end;

    with XmlToDomParser1 do begin
      UpTime:= GetTickCount;
      try
        Doc:= FileToDom(OpenDialog1.FileName);
        Label3.caption:= IntToStr(GetTickCount-UpTime);
        index:= TabSet1.Tabs.Add(ExtractFileName(Doc.Filename));
        TabSet1.TabIndex:= index;
      except
        Label3.caption:= '';
        Label1.caption:= ErrorStrings.text;
      end; {try ... except ...}
    end; {with ...}

    Memo1.Update;
    TabSet1.Update;
  end; {if OpenDialog1.Execute ...}
end;

procedure TMainpage.XmlToDomParser1ExternalSubset(Sender: TObject;
  const PublicId, SystemId: WideString; var extSubset: WideString);
var
  path: TFilename;
  fileAsStringlist: TStringlist;
begin
  // Quick and dirty: This works only with ASCII DTD's in the
  // same directory as the document file.
  extSubset:= '';
  Label8.caption:= PublicId;
  Label10.caption:= SystemId;
  if systemId <> '' then begin
    fileAsStringlist:= TStringlist.create;
    try
      path := concat(ExtractFileDir(OpenDialog1.FileName),'\',SystemID);
      fileAsStringlist.LoadFromFile(path);
      extSubset:= fileAsStringlist.Text;
    finally
      fileAsStringlist.free;
    end;
  end;
end;

procedure TMainpage.TabSet1Click(Sender: TObject);
var
  doc: TdomDocument;
begin
  with Memo1 do begin
    clear;
    Update;
  end;
  if TabSet1.TabIndex > -1 then begin
    SpeedButton2.Enabled:= true;
    doc:= (XmlToDomParser1.DOMImpl.documents.Item(TabSet1.TabIndex) as TdomDocument);
    Label1.caption:= doc.Filename;
    with Memo1 do begin
      Text:= Doc.CodeAsString;
      Update;
    end;
  end else Label1.caption:= '';
end;


procedure TMainpage.SpeedButton2Click(Sender: TObject);
var
  doc: TdomDocument;
begin
  if TabSet1.TabIndex > -1 then begin
    with TabSet1 do begin
      doc:= (XmlToDomParser1.DOMImpl.documents.Item(TabIndex) as TdomDocument);
      XmlToDomParser1.DOMImpl.FreeDocument(doc);
      Tabs.Delete(TabIndex);
      if Tabs.Count = 0 then SpeedButton2.Enabled:= false;
    end;
  end;
end;

end.
