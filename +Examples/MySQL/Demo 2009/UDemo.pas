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
    TableGrid: TDrawGrid;
    Label7: TLabel;
    FieldListGrid: TStringGrid;
    StatusBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LoginButtonClick(Sender: TObject);
    procedure DatabaseListBoxClick(Sender: TObject);
    procedure TableListBoxClick(Sender: TObject);
    procedure TableGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    LibHandle: PMYSQL;
    mySQL_Res: PMYSQL_RES;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

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
  MYSQL_ROW: PMYSQL_ROW;
begin
  if mySQL_Res<>nil
  then
    mysql_free_result(mySQL_Res);
  mySQL_Res := nil;
  TableListBox.Items.Clear;
  ClearGrid(FieldListGrid);
  TableListBox.Enabled := False;
  with DatabaseListBox do
    MyResult := mysql_select_db(LibHandle, PAnsiChar(AnsiString(Items[ItemIndex])));
  if MyResult<>0
  then
    raise Exception.Create(UnicodeString(mysql_error(LibHandle)));
  //Get Tablenames
  mySQL_Res := mysql_list_tables(LibHandle, nil);
  if mySQL_Res=nil
  then
    raise Exception.Create(UnicodeString(mysql_error(LibHandle)));
  try
    repeat
      MYSQL_ROW := mysql_fetch_row(mySQL_Res);
      if MYSQL_ROW<>nil
      then begin
        TableListBox.Items.Add(UnicodeString(MYSQL_ROW^[0]));
      end;
    until MYSQL_ROW=nil;
  finally
    mysql_free_result(mySQL_Res);
    mySQL_Res := nil;
  end;
  if TableListBox.Items.Count>0
  then begin
    TableListBox.Enabled := True;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  libmysql_fast_load(nil);
  StatusBar.Panels[0].Text := 'Client ' + UnicodeString(mysql_get_client_info);
  FieldListGrid.Cells[0, 0] := 'Name';
  FieldListGrid.Cells[1, 0] := 'Type';
  FieldListGrid.Cells[2, 0] := 'Len';
  FieldListGrid.Cells[3, 0] := 'Flags';
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if mySQL_Res<>nil
  then
    mysql_free_result(mySQL_Res);
  if libmysql_status=LIBMYSQL_READY
  then
    mysql_close(LibHandle);
  libmysql_free;
end;

procedure TForm1.LoginButtonClick(Sender: TObject);
var
  MYSQL_ROW: PMYSQL_ROW;
//  mysql_codepage: Word;
begin
  if mySQL_Res<>nil
  then
    mysql_free_result(mySQL_Res);
  mySQL_Res := nil;
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
{  StatusBar.Panels[1].Text := UnicodeString(mysql_character_set_name(LibHandle));
  mysql_codepage := mysql.CharsetNameToCodePage(StatusBar.Panels[1].Text);
  if mysql_codepage<>$FFFF
  then
    DefaultSystemCodePage := mysql_codepage;}
  if mysql_real_connect(LibHandle,
                        PAnsiChar(AnsiString(HostEdit.Text)),
                        PAnsiChar(AnsiString(UserEdit.Text)),
                        PAnsiChar(AnsiString(PasswordEdit.Text)),
                        nil, 0, nil, 0)=nil
  then
    raise Exception.Create(UnicodeString(mysql_error(LibHandle)));
  Caption := HostEdit.Text + ' '  + UnicodeString(mysql_get_server_info(LibHandle));
  StatusBar.Panels[1].Text := UnicodeString(mysql_character_set_name(LibHandle));
  //Get Databasenames
  mySQL_Res := mysql_list_dbs(LibHandle, nil);
  if mySQL_Res=nil
  then
    raise Exception.Create(UnicodeString(mysql_error(LibHandle)));
  try
    repeat
      MYSQL_ROW := mysql_fetch_row(mySQL_Res);
      if MYSQL_ROW<>nil
      then begin
        DatabaseListBox.Items.Add(UnicodeString(MYSQL_ROW^[0]));
      end;
    until MYSQL_ROW=nil;
  finally
    mysql_free_result(mySQL_Res);
    mySQL_Res := nil;
  end;
  if DatabaseListBox.Items.Count>0
  then begin
    DatabaseListBox.Enabled := True;
  end;
end;

function GetFieldTypeString(mySQL_Field: PMYSQL_FIELD): String;
const
  FieldtypeString1: array [MYSQL_TYPE_DECIMAL..MYSQL_TYPE_BIT] of String=(
   'NUMERIC', 'TINYINT', 'SMALLINT', 'INTEGER',
   'FLOAT', 'DOUBLE', 'T_NULL', 'TIMESTAMP',
   'BIGINT', 'MEDIUMINT', 'DATE', 'TIME',
   'DATETIME', 'YEAR', 'NEWDATE', 'VARCHAR',
   'BIT');
  FieldtypeString2: array [MYSQL_TYPE_NEWDECIMAL..MYSQL_TYPE_GEOMETRY] of String=(
    'NEWDECIMAL', 'ENUM', 'SET',
    'TINY_BLOB', 'MEDIUM_BLOB', 'LONG_BLOB', 'BLOB',
    'VAR_STRING', 'STRING', 'GEOMETRY');
begin
  if mysql_field_type(mySQL_Field) in [MYSQL_TYPE_DECIMAL..MYSQL_TYPE_BIT]
  then
    Result := FieldtypeString1[mysql_field_type(mySQL_Field)]
  else
  if mysql_field_type(mySQL_Field) in [MYSQL_TYPE_NEWDECIMAL..MYSQL_TYPE_GEOMETRY]
  then
    Result := FieldtypeString2[mysql_field_type(mySQL_Field)]
  else
    Result := 'unknown';
end;

function GetFieldFlagString(Flags: longword): String;
  procedure Append(var s: String; const FlagStr: String);
  begin
    if s=''
    then
      s := FlagStr
    else
      s := s + ',' + FlagStr;
  end;
begin
  Result := '';
  if IS_NUM_FLAG(Flags)
  then begin
    Append(Result, 'NUM');
    if (Flags and UNSIGNED_FLAG) <> 0
    then
      Append(Result, 'UNSIGNED');
    if (Flags and AUTO_INCREMENT_FLAG) <> 0
    then
      Append(Result, 'AUTO_INCREMENT');
  end
  else begin
    if (Flags and ENUM_FLAG)<>0
    then
      Append(Result, 'ENUM');
    if (Flags and SET_FLAG)<>0
    then
      Append(Result, 'SET');
    if (Flags and BLOB_FLAG)<>0
    then
      Append(Result, 'BLOB');
  end;
  if (Flags and NOT_NULL_FLAG)<>0
  then
    Append(Result, 'NOT_NULL');
  if (Flags and PRI_KEY_FLAG)<>0
  then
    Append(Result, 'PRI_KEY');
  if (Flags and UNIQUE_KEY_FLAG)<>0
  then
    Append(Result, 'UNIQUE_KEY');
  if (Flags and MULTIPLE_KEY_FLAG)<>0
  then
    Append(Result, 'MULTIPLE_KEY');
  if (Flags and ZEROFILL_FLAG)<>0
  then
    Append(Result, 'ZEROFILL');
  if (Flags and BINARY_FLAG)<>0
  then
    Append(Result, 'BINARY');
  if (Flags and NO_DEFAULT_VALUE_FLAG)<>0
  then
    Append(Result, 'NO_DEFAULT_VALUE');
  if (Flags and TIMESTAMP_FLAG)<>0
  then
    Append(Result, 'TIMESTAMP');
end;

procedure TForm1.TableListBoxClick(Sender: TObject);
var
  i, field_count, row_count: Integer;
  mySQL_Field: PMYSQL_FIELD;
  sql: String;
  my_sql: AnsiString;
  tablename: String;
  ticks: Cardinal;
begin
  ClearGrid(FieldListGrid);
  Statusbar.Panels[2].Text := '';
  with TableListBox do
    tablename := Items[ItemIndex];
  tablename := QuoteName(tablename);

  sql := 'select * from ' + tablename;
  my_sql := AnsiString(sql);
  ticks := GetTickCount;
  if mysql_real_query(LibHandle, PAnsiChar(my_sql), Length(my_sql))<>0
  then
    raise Exception.Create(UnicodeString(mysql_error(LibHandle)));
  //Get Data
  mySQL_Res := mysql_store_result(LibHandle);
  if mySQL_Res<>nil
  then begin
    //Get Fieldnames
    field_count := mysql_num_fields(mySQL_Res);
    FieldListGrid.RowCount := field_count+1;
    TableGrid.ColCount := field_count;
    for i := 0 to field_count - 1 do
    begin
      mySQL_Field := mysql_fetch_field(mySQL_Res);
      if mySQL_Field<>nil
      then begin
        FieldListGrid.Cells[0, i+1] := UnicodeString(mysql_field_name(mySQL_Field));
        FieldListGrid.Cells[1, i+1] := GetFieldTypeString(mySQL_Field);
        FieldListGrid.Cells[2, i+1] := IntToStr(mysql_field_length(mySQL_Field));
        FieldListGrid.Cells[3, i+1] := GetFieldFlagString(mysql_field_flag(mySQL_Field));
      end;
    end;
    row_count := mysql_num_rows(mySQL_Res);
    if row_count>0
    then begin
      TableGrid.RowCount := row_count + 1;
    end
    else begin
      TableGrid.RowCount := 2;
    end;
    Statusbar.Panels[2].Text := Format('Rowcount: %d - Time: %d ms', [row_count, (GetTickCount-ticks)]);
  end;
end;

procedure TForm1.TableGridDrawCell(Sender: TObject; ACol, ARow: Integer;
                                   Rect: TRect; State: TGridDrawState);
var
  MYSQL_ROW: PMYSQL_ROW;
  mySQL_Field: PMYSQL_FIELD;
begin
  if mySQL_Res<>nil
  then begin
    if (ARow=0)
    then begin
      mySQL_Field := mysql_fetch_field_direct(mySQL_Res, ACol);
      if mySQL_Field<>nil
      then begin
        TableGrid.Canvas.TextRect(Rect, Rect.Left+2, Rect.Top+2, UnicodeString(mysql_field_name(mySQL_Field)));
      end;
    end
    else
    if (ARow>0) and (ARow<=mysql_num_rows(mySQL_Res))
    then begin
      mysql_data_seek(mySQL_Res, ARow-1);
      MYSQL_ROW := mysql_fetch_row(mySQL_Res);
      if MYSQL_ROW<>nil
      then begin
        TableGrid.Canvas.TextRect(Rect, Rect.Left+2, Rect.Top+2, UnicodeString(MYSQL_ROW^[ACol]));
      end;
    end;
  end;
end;

end.
