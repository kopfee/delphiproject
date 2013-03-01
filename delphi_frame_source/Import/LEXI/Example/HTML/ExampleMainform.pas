{
  ExampleMainform.pas

  Written by Frank Plagge
  Copyright (c) 1998 by Frank Plagge, Elsterweg 39, 38446 Wolfsburg, Germany
  All rights reserved

  Please send comments to plagge@positiv.escape.de

  V 1.01 - Jan 3rd, 1998
           first implementation, never trust a version 1.00 :-)

  *****************************************************************************
  Permission to use, copy,  modify, and distribute this software and its
  documentation without fee for any purpose is hereby granted, provided that
  the above copyright notice appears on all copies and that both that copyright
  notice and this permission notice appear in all supporting documentation.

  NO REPRESENTATIONS ARE MADE ABOUT THE SUITABILITY OF THIS SOFTWARE FOR ANY
  PURPOSE. IT IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTY.
  NEITHER FRANK PLAGGE OR ANY OTHER PERSON SHALL BE LIABLE FOR ANY DAMAGES
  SUFFERED BY THE USE OF THIS SOFTWARE.
  *****************************************************************************

   description:
   this is an example program for the usage of the TLXScanner component. it is
   possible to open and analyze a source file. the results are shown in the
   editor window
}

unit ExampleMainform;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ToolWin, ComCtrls, StdCtrls, Scanner, Menus, LXScanner;

type
  TExampleForm = class(TForm)
    MainMenu: TMainMenu;
    Example1: TMenuItem;
    mnLoad: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    RichEdit: TRichEdit;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    OpenDialog: TOpenDialog;
    Scanner: TLXScanner;
    sbRestart: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    mnRestart: TMenuItem;
    N2: TMenuItem;
    Info1: TMenuItem;
    procedure mnLoadClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbRestartClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure mnRestartClick(Sender: TObject);
    procedure Info1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    SrcStream: TMemoryStream;
    RestartPossible: Boolean;
    procedure Analyse( Restart: Boolean );
  public
    { Public-Deklarationen }
  end;

var
  ExampleForm: TExampleForm;

implementation

uses AboutDialog;

{$R *.DFM}

// this is the main method
procedure TExampleForm.mnLoadClick(Sender: TObject);
var ThisStream: TFileStream; // stream to analyse
begin
  OpenDialog.Filename := '';                  // delete the filename
  if OpenDialog.Execute then begin            // if the dialog is closed with Ok button
    RichEdit.Lines.Clear;                     // clear the edit component
    Scanner.ClearTokenList;
    // create a new file stream, read from this stream others my read too
    ThisStream := TFileStream.Create( OpenDialog.Filename, fmOpenRead);
    SrcStream.Clear;                                    // deallocate memory
    SrcStream.CopyFrom( ThisStream, ThisStream.Size );  // copy from new source
    ThisStream.Free;                                    // free the file stream
    Analyse( false );                                   // start the analysis
  end;
end;

procedure TExampleForm.Analyse( Restart: Boolean );
var i:          Integer; // counter for the number of read token
    ThisToken:  TLXToken;  // working token
    ThisLine:   string;  // line for the editor
    RowStr:     string;  // row of a token as string
    ColStr:     string;  // column of a token as string
    TokenStr:   string;  // type of token as string
begin
  if Restart then begin
    Scanner.ClearTokenList;                // clear the token list
    Scanner.Restart;                       // restart the fomerly interrupted analysis
  end else begin
    Scanner.Analyze( SrcStream );          // analyze the file, that's all!!
  end;
  sbRestart.Enabled := false;               // disabled the restart button
  for i := 1 to Scanner.Count do begin      // for all available token
    Application.ProcessMessages;
    ThisToken := Scanner.Token[i-1];        // get the token at counter index
    ColStr := IntToStr(ThisToken.Column);   // convert the row to a string
    while Length(ColStr) < 5 do             // format the string to length 5
      ColStr := ' ' + ColStr;
    RowStr := IntToStr(ThisToken.Row);      // convert the column to a string
    while Length(RowStr) < 5 do             // format the string to length 5
      RowStr := ' ' + RowStr;
    case ThisToken.Token of                 // convert the token type to string
      ttComment     : TokenStr := 'comment     ';
      ttEof         : TokenStr := 'end of file ';
      ttError       : TokenStr := 'error       ';
      ttHexDecimal  : TokenStr := 'hex number  ';
      ttIdentifier  : TokenStr := 'identifier  ';
      ttInteger     : TokenStr := 'integer     ';
      ttKeyword     : TokenStr := 'keyword     ';
      ttReal        : TokenStr := 'real        ';
      ttSpecialChar : TokenStr := 'special char';
      ttString      : TokenStr := 'string      ';
    end;
    ThisLine := ColStr + ' ' + RowStr + ' ' + TokenStr + ' ' + ThisToken.Text;
    RichEdit.Lines.Add( ThisLine );         // add the line to the editor component
  end;
  sbRestart.Enabled := RestartPossible;     // disabled the restart button
end;

// every time the eyes are using the programm too. a speedbutton is alway nice.
procedure TExampleForm.SpeedButton1Click(Sender: TObject);
begin
  mnLoadClick(Sender);
end;

procedure TExampleForm.FormCreate(Sender: TObject);
begin
  SrcStream := TMemoryStream.Create;
end;

procedure TExampleForm.FormDestroy(Sender: TObject);
begin
  SrcStream.Destroy;
end;

procedure TExampleForm.sbRestartClick(Sender: TObject);
begin
  Analyse( true );
end;

procedure TExampleForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TExampleForm.SpeedButton3Click(Sender: TObject);
begin
  Close;
end;

procedure TExampleForm.mnRestartClick(Sender: TObject);
begin
  Analyse( true );
end;

procedure TExampleForm.Info1Click(Sender: TObject);
begin
  AboutForm.ShowModal( Scanner.Version );
end;

end.

