unit UDemo;
{
 Copyright (C) 2009 Samuel Soldat <samuel.soldat@audio-data.de>

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ExtCtrls, ComCtrls, mysql;

type
  TForm1 = class(TForm)
    HostEdit: TEdit;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    UserEdit: TEdit;
    Label3: TLabel;
    PasswordEdit: TEdit;
    LoginButton: TButton;
    DatabaseListBox: TListBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    TableListBox: TListBox;
    Label7: TLabel;
    FieldListGrid: TStringGrid;
    StatusBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LoginButtonClick(Sender: TObject);
    procedure DatabaseListBoxClick(Sender: TObject);
    procedure TableListBoxClick(Sender: TObject);
    procedure OnThreadReady(Sender: TObject);
  private
    LibHandle: PMYSQL;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  UThread;

{$WARNINGS OFF}

procedure ClearGrid(Grid: TStringGrid);
var
  row, col: Integer;
begin
  for row := 1 to Grid.RowCount - 1 do
    for col := 0 to Grid.ColCount - 1 do
      Grid.Cells[col, row] := '';
end;

procedure TForm1.DatabaseListBoxClick(Sender: TObject);
var
  MyResult: Integer;
  mySQL_Res: PMYSQL_RES;
  MYSQL_ROW: PMYSQL_ROW;
begin
  TableListBox.Items.Clear;
  ClearGrid(FieldListGrid);
  TableListBox.Enabled := False;
  with DatabaseListBox do
    MyResult := mysql_select_db(LibHandle, PAnsiChar(AnsiString(Items[ItemIndex])));
  if MyResult<>0
  then
    raise Exception.Create(mysql_error(LibHandle));
  //Get Tablenames
  mySQL_Res := mysql_list_tables(LibHandle, nil);
  if mySQL_Res=nil
  then
    raise Exception.Create(mysql_error(LibHandle));
  try
    repeat
      MYSQL_ROW := mysql_fetch_row(mySQL_Res);
      if MYSQL_ROW<>nil
      then begin
        TableListBox.Items.Add(MYSQL_ROW^[0]);
      end;
    until MYSQL_ROW=nil;
  finally
    mysql_free_result(mySQL_Res);
  end;
  if TableListBox.Items.Count>0
  then begin
    TableListBox.Enabled := True;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  libmysql_fast_load(nil);
  StatusBar.Panels[0].Text := 'Client ' + mysql_get_client_info;
  FieldListGrid.Cells[0, 0] := 'Name';
  FieldListGrid.Cells[1, 0] := 'Type';
  FieldListGrid.Cells[2, 0] := 'Len';
  FieldListGrid.Cells[3, 0] := 'Flags';
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if libmysql_status=LIBMYSQL_READY
  then
    mysql_close(LibHandle);
  libmysql_free;
end;

procedure TForm1.LoginButtonClick(Sender: TObject);
var
  MYSQL_ROW: PMYSQL_ROW;
  mySQL_Res: PMYSQL_RES;
begin
  DatabaseListBox.Items.Clear;
  DatabaseListBox.Enabled := False;
  if LibHandle<>nil
  then begin
    mysql_close(LibHandle);
    LibHandle := nil;
  end;
  LibHandle := mysql_init(nil);
  if LibHandle=nil
  then
    raise Exception.Create('mysql_init failed');
  if (mysql_real_connect(LibHandle,
                         PAnsiChar(AnsiString(HostEdit.Text)),
                         PAnsiChar(AnsiString(UserEdit.Text)),
                         PAnsiChar(AnsiString(PasswordEdit.Text)),
                         nil, 0, nil, 0)=nil)
  then
    raise Exception.Create(mysql_error(LibHandle));
  Caption := HostEdit.Text + ' '  + mysql_get_server_info(LibHandle);
  StatusBar.Panels[1].Text := mysql_character_set_name(LibHandle);
  //Get Databasenames
  mySQL_Res := mysql_list_dbs(LibHandle, nil);
  if mySQL_Res=nil
  then
    raise Exception.Create(mysql_error(LibHandle));
  try
    repeat
      MYSQL_ROW := mysql_fetch_row(mySQL_Res);
      if MYSQL_ROW<>nil
      then begin
        DatabaseListBox.Items.Add(MYSQL_ROW^[0]);
      end;
    until MYSQL_ROW=nil;
  finally
    mysql_free_result(mySQL_Res);
  end;
  if DatabaseListBox.Items.Count>0
  then begin
    DatabaseListBox.Enabled := True;
  end;
end;

procedure TForm1.OnThreadReady(Sender: TObject);
var
  i: Integer;
begin
  if Sender is TMySqlReader
  then begin
    with TMySqlReader(Sender) do
    begin
      if ErrorMessage<>''
      then
        ShowMessage(ErrorMessage)
      else begin
        FieldListGrid.RowCount := Length(FieldDescriptorList)+1;
        for i := 0 to High(FieldDescriptorList) do
        begin
          FieldListGrid.Cells[0, i+1] := FieldDescriptorList[i].Fieldname;
          FieldListGrid.Cells[1, i+1] := FieldDescriptorList[i].FieldType;
          FieldListGrid.Cells[2, i+1] := IntToStr(FieldDescriptorList[i].FieldLength);
          FieldListGrid.Cells[3, i+1] := FieldDescriptorList[i].FieldFlag;
        end;
      end;
    end;
  end;
end;

procedure TForm1.TableListBoxClick(Sender: TObject);
var
  database: String;
  tablename: String;
begin
  ClearGrid(FieldListGrid);
  Statusbar.Panels[2].Text := '';
  with DatabaseListBox do
    database := Items[ItemIndex];
  with TableListBox do
    tablename := Items[ItemIndex];
  TMySqlReader.Create(HostEdit.Text, UserEdit.Text, PasswordEdit.Text,
                      database, tablename, OnThreadReady);
end;

end.
