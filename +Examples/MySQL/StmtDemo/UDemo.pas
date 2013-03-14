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

 This Demo based on two Demo functions for demonstration of mysql_stmt_execute()
 and mysql_stmt_fetch() distributed in the manual for mysql. 
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, ComCtrls, mysql;


type
  TForm1 = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    HostEdit: TEdit;
    UserEdit: TEdit;
    PasswordEdit: TEdit;
    DatabaseEdit: TEdit;
    LoginButton: TButton;
    FillButton: TButton;
    QueryButton: TButton;
    Memo: TMemo;
    StatusBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LoginButtonClick(Sender: TObject);
    procedure FillButtonClick(Sender: TObject);
    procedure QueryButtonClick(Sender: TObject);
  private
    LibHandle: PMYSQL;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{$WARNINGS OFF}

procedure TForm1.FillButtonClick(Sender: TObject);
const
  STRING_SIZE = 50;
  DROP_SAMPLE_TABLE = 'DROP TABLE IF EXISTS test_table';
  CREATE_SAMPLE_TABLE = 'CREATE TABLE test_table(col1 INT, ' +
                        'col2 VARCHAR(40),' +
                        'col3 SMALLINT,' +
                        'col4 TIMESTAMP)';
  INSERT_SAMPLE = 'INSERT INTO test_table(col1,col2,col3) VALUES(?,?,?)';
var
  stmt: PMYSQL_STMT;
  bind: PMYSQL_BIND;
  affected_rows: my_ulonglong;
  param_count: Integer;
  small_data: SmallInt;
  int_data: Integer;
  str_data: array [0..STRING_SIZE-1] of AnsiChar;
  str_length: DWord;
  is_null: my_bool;
begin
  Memo.Lines.Add('------------- Fill Sample Table ------------------');
  if (mysql_query(LibHandle, DROP_SAMPLE_TABLE)<>0)
  then begin
    Memo.Lines.Add('DROP TABLE failed');
    Memo.Lines.Add(mysql_error(LibHandle));
    exit;
  end;
  Memo.Lines.Add('CREATE TABLE');
  if (mysql_query(LibHandle, CREATE_SAMPLE_TABLE)<>0)
  then begin
    Memo.Lines.Add('CREATE TABLE failed');
    Memo.Lines.Add(mysql_error(LibHandle));
    exit;
  end;
  Memo.Lines.Add('CREATE TABLE done');

  Memo.Lines.Add('mysql_stmt_init()');
  stmt := mysql_stmt_init(LibHandle);
  if (stmt=nil)
  then begin
    Memo.Lines.Add('mysql_stmt_init(), out of memory');
    exit;
  end;
  Memo.Lines.Add('mysql_stmt_init() done');

  Memo.Lines.Add('mysql_stmt_prepare()');
  if (mysql_stmt_prepare(stmt, INSERT_SAMPLE, Length(INSERT_SAMPLE))<>0)
  then begin
    Memo.Lines.Add('mysql_stmt_prepare(), INSERT failed');
    Memo.Lines.Add(mysql_stmt_error(stmt));
  end;
  Memo.Lines.Add('mysql_stmt_prepare() done');

  Memo.Lines.Add('mysql_stmt_param_count()');
  param_count := mysql_stmt_param_count(stmt);
  Memo.Lines.Add(Format('total parameters in INSERT: %d', [param_count]));
  if (param_count <> 3)
  then begin
    Memo.Lines.Add('invalid parameter count returned by MySQL');
    exit;
  end;

  bind := mysql_bind_init(3); //** Different to org. Demo: Alloc 3 MYSQL_BIND **
  try
    //** Different to org. Demo - Set MYSQL_BIND[0]: INTEGER PARAM
    mysql_bind_set_param(bind, 0, MYSQL_TYPE_LONG, @int_data, 0, nil, nil);

    //** Different to org. Demo - Set MYSQL_BIND[1]: STRING PARAM
    mysql_bind_set_param(bind, 1, MYSQL_TYPE_STRING, @str_data, STRING_SIZE, @str_length, nil);

    //** Different to org. Demo - Set MYSQL_BIND[2]: SMALLINT PARAM
    mysql_bind_set_param(bind, 2, MYSQL_TYPE_SHORT, @small_data, 0, nil, @is_null);

    Memo.Lines.Add('mysql_stmt_bind_param()');
    if mysql_stmt_bind_param(stmt, bind)
    then begin
      Memo.Lines.Add('mysql_stmt_bind_param() failed');
      Memo.Lines.Add(mysql_stmt_error(stmt));
      exit;
    end;
    Memo.Lines.Add('mysql_stmt_bind_param() done');

    //insert (10, 'MySQL', NULL)
    int_data := 10; //* Integer */
    StrLCopy(str_data, 'MySQL', STRING_SIZE); //* String */
    str_length := strlen(str_data);
    //* INSERT SMALLINT-Daten as NULL */
    is_null := True;
    Memo.Lines.Add('mysql_stmt_execute()');
    if (mysql_stmt_execute(stmt)<>0)
    then begin
      Memo.Lines.Add('mysql_stmt_execute() failed');
      Memo.Lines.Add(mysql_stmt_error(stmt));
      exit;
    end;
    Memo.Lines.Add('mysql_stmt_execute() done');
    affected_rows := mysql_stmt_affected_rows(stmt);
    Memo.Lines.Add(Format('total affected rows(insert 1): %u', [affected_rows]));
    if (affected_rows <> 1)
    then begin
      Memo.Lines.Add('invalid affected rows by MySQL');
      exit;
    end;

    //insert (1000, 'The most popular Open Source database', 1000)
    int_data := 1000;
    StrLCopy(str_data, 'The most popular Open Source database', STRING_SIZE);
    str_length := strlen(str_data);
    small_data := 1000; //* smallint */
    is_null := False;   //* Reset */
    Memo.Lines.Add('mysql_stmt_execute()');
    if (mysql_stmt_execute(stmt)<>0)
    then begin
      Memo.Lines.Add('mysql_stmt_execute() failed');
      Memo.Lines.Add(mysql_stmt_error(stmt));
      exit;
    end;
    Memo.Lines.Add('mysql_stmt_execute() done');
    affected_rows := mysql_stmt_affected_rows(stmt);
    Memo.Lines.Add(Format('total affected rows(insert 2): %u', [affected_rows]));
    if (affected_rows <> 1)
    then begin
      Memo.Lines.Add('invalid affected rows by MySQL');
      exit;
    end;
  finally
    FreeMem(bind);
  end;
  if mysql_stmt_close(stmt)
  then begin
    Memo.Lines.Add('failed while closing the statement');
    Memo.Lines.Add(mysql_stmt_error(stmt));
    exit;
  end;
end;

procedure TForm1.QueryButtonClick(Sender: TObject);
const
  STRING_SIZE = 50;
  SELECT_SAMPLE = 'SELECT col1, col2, col3, col4 FROM test_table';
var
  stmt: PMYSQL_STMT;
  bind: PMYSQL_BIND;
  prepare_meta_result: PMYSQL_RES;
  data_length: array [0..3] of DWORD;
  is_null: array [0..3] of my_bool;
  param_count, column_count, row_count: Integer;
  small_data: SmallInt;
  int_data: Integer;
  str_data: array [0..STRING_SIZE-1] of AnsiChar;
  ts: TMYSQL_TIME;
begin
  Memo.Lines.Add('------------- Query Sample Table -----------------');
  Memo.Lines.Add('mysql_stmt_init()');
  stmt := mysql_stmt_init(LibHandle);
  if (stmt=nil)
  then begin
    Memo.Lines.Add('mysql_stmt_init(), out of memory');
    exit;
  end;
  Memo.Lines.Add('mysql_stmt_init() done');

  Memo.Lines.Add('mysql_stmt_prepare()');
  if (mysql_stmt_prepare(stmt, SELECT_SAMPLE, Length(SELECT_SAMPLE))<>0)
  then begin
    Memo.Lines.Add('mysql_stmt_prepare(), SELECT failed');
    Memo.Lines.Add(mysql_stmt_error(stmt));
  end;
  Memo.Lines.Add('mysql_stmt_prepare() done');

  Memo.Lines.Add('mysql_stmt_param_count()');
  param_count := mysql_stmt_param_count(stmt);
  Memo.Lines.Add(Format('total parameters in SELECT: %d', [param_count]));
  if (param_count <> 0)
  then begin
    Memo.Lines.Add('invalid parameter count returned by MySQL');
    exit;
  end;
  prepare_meta_result := mysql_stmt_result_metadata(stmt);
  if (prepare_meta_result=nil)
  then begin
    Memo.Lines.Add('mysql_stmt_result_metadata(), returned no meta information');
    Memo.Lines.Add(mysql_stmt_error(stmt));
  end;
  Memo.Lines.Add('mysql_stmt_result_metadata() done');
  column_count := mysql_num_fields(prepare_meta_result);
  try
    Memo.Lines.Add(Format('total columns in SELECT statement: %d', [column_count]));
    if (column_count <> 4)
    then begin
      Memo.Lines.Add('invalid column count returned by MySQL');
      exit;
    end;
    if (mysql_stmt_execute(stmt)<>0)
    then begin
      Memo.Lines.Add('mysql_stmt_execute() failed');
      Memo.Lines.Add(mysql_stmt_error(stmt));
      exit;
    end;

    bind := mysql_bind_init(4); //** Different to org. Demo: Alloc 4 MYSQL_BIND **
    try
      //** Different to org. Demo - Set MYSQL_BIND[0]: INTEGER COLUMN
      mysql_bind_set_param(bind, 0, MYSQL_TYPE_LONG, @int_data, 0, @data_length[0], @is_null[0]);
      //** Different to org. Demo - Set MYSQL_BIND[1]: STRING COLUMN
      mysql_bind_set_param(bind, 1, MYSQL_TYPE_STRING, @str_data, STRING_SIZE, @data_length[1], @is_null[1]);
      //** Different to org. Demo - Set MYSQL_BIND[2]: SMALLINT COLUMN
      mysql_bind_set_param(bind, 2, MYSQL_TYPE_SHORT, @small_data, 0, @data_length[2], @is_null[2]);
      //** Different to org. Demo - Set MYSQL_BIND[3]: TIMESTAMP COLUMN
      mysql_bind_set_param(bind, 3, MYSQL_TYPE_TIMESTAMP, @ts, 0, @data_length[3], @is_null[3]);
      Memo.Lines.Add('mysql_stmt_bind_result()');
      if mysql_stmt_bind_result(stmt, bind)
      then begin
        Memo.Lines.Add('mysql_stmt_bind_result() failed');
        Memo.Lines.Add(mysql_stmt_error(stmt));
        exit;
      end;
      Memo.Lines.Add('mysql_stmt_bind_result() done');
      Memo.Lines.Add('mysql_stmt_store_result()');
      if (mysql_stmt_store_result(stmt)<>0)
      then begin
        Memo.Lines.Add('mysql_stmt_bind_result() failed');
        Memo.Lines.Add(mysql_stmt_error(stmt));
        exit;
      end;
      Memo.Lines.Add('mysql_stmt_store_result() done');
      Memo.Lines.Add('Fetching results ...');
      row_count := 0;
      while (mysql_stmt_fetch(stmt)=0) do
      begin
        inc(row_count);
        Memo.Lines.Add(Format(' row %d', [row_count]));
        if (is_null[0])
        then
          Memo.Lines.Add('   column1 (integer):   NULL')
        else
          Memo.Lines.Add(Format('   column1 (integer):   %d (%d)', [int_data, data_length[0]]));
        if (is_null[1])
        then
          Memo.Lines.Add('   column2 (string):    NULL')
        else
          Memo.Lines.Add(Format('   column2 (string):    %s (%d)', [str_data, data_length[1]]));
        if (is_null[2])
        then
          Memo.Lines.Add('   column3 (smallint):  NULL')
        else
          Memo.Lines.Add(Format('   column3 (smallint):  %d (%d)', [small_data, data_length[2]]));
        if (is_null[3])
        then
          Memo.Lines.Add('   column4 (timestamp): NULL')
        else
          Memo.Lines.Add(Format('   column4 (timestamp): %4.4d-%2.2d-%2.2d %2.2d:%2.2d:%2.2d (%d)',
                                [ts.year, ts.month, ts.day,
                                 ts.hour, ts.minute, ts.second,
                                 data_length[3]]));
      end;
      Memo.Lines.Add(Format('total rows fetched: %d', [row_count]));
      if (row_count <> 2)
      then begin
        Memo.Lines.Add('MySQL failed to return all rows');
        exit;
      end;
    finally
      FreeMem(bind);
    end;
  finally
    mysql_free_result(prepare_meta_result);
  end;
  if mysql_stmt_close(stmt)
  then begin
    Memo.Lines.Add('failed while closing the statement');
    Memo.Lines.Add(mysql_stmt_error(stmt));
    exit;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  libmysql_fast_load(nil);
  StatusBar.Panels[0].Text := 'Client ' + mysql_get_client_info;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if libmysql_status=LIBMYSQL_READY
  then
    mysql_close(LibHandle);
  libmysql_free;
end;

procedure TForm1.LoginButtonClick(Sender: TObject);
begin
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
                         PAnsiChar(AnsiString(DatabaseEdit.Text)),
                         0, nil, 0)=nil)
  then
    raise Exception.Create(mysql_error(LibHandle));
  LoginButton.Enabled := False;
  FillButton.Enabled := True;
  QueryButton.Enabled := True;
  Caption := HostEdit.Text + ' ' + mysql_get_server_info(LibHandle);
  StatusBar.Panels[1].Text := mysql_character_set_name(LibHandle);
end;

end.
