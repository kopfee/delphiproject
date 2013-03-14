unit UThread;
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
  Classes;

type
  TFieldDescriptor = record
    Fieldname: String;
    FieldType: String;
    FieldLength: Integer;
    FieldFlag: String;
  end;
  TFieldDescriptorList = array of TFieldDescriptor;

{ This thread get the list of all fields of the table }

type
  TMySqlReader = class (TThread)
  private
    FHost, FUser, FPassword: String;
    FDatabase: String;
    FTable: String;
    FFieldDescriptorList: TFieldDescriptorList;
    FmyMessage: String;
  protected
    procedure Execute; override;
  public
    constructor Create(const Host, User, Password, Database, Table: String;
                       OnReady: TNotifyEvent);
    property FieldDescriptorList: TFieldDescriptorList read FFieldDescriptorList;
    property ErrorMessage: String read FmyMessage;
  end;

implementation

uses
  SysUtils, mysql;
  
{$WARNINGS OFF}

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

function GetFieldFlagString1(flag: longword): String;
begin
//  UpdateField(mySQL_Field);
  Result := '';
  if IS_NUM_FLAG(flag)
  then begin
    if (flag and UNSIGNED_FLAG) <> 0
    then
      Result := ' UNSIGNED';
    if (flag and AUTO_INCREMENT_FLAG) <> 0
    then
      Result := Result + ' INC';
  end
  else begin
    if (flag and ENUM_FLAG)<>0
    then
      Result := ' ENUM'
    else
    if (flag and SET_FLAG)<>0
    then
      Result := ' SET'
    else
    if (flag and BLOB_FLAG)<>0
    then
      Result := ' BLOB';
  end;
  if IS_NOT_NULL(flag)
  then
    Result := Result + ' NOT NULL';
  if IS_PRI_KEY(flag)
  then
    Result := Result + ' PRI_KEY';
  if flag and MULTIPLE_KEY_FLAG<>0
  then
    Result := Result + ' KEY';
end;

function GetFieldFlagString(flag: longword): String;
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
  if IS_NUM_FLAG(flag)
  then begin
    Append(Result, 'NUM');
    if (flag and UNSIGNED_FLAG) <> 0
    then
      Append(Result, 'UNSIGNED');
    if (flag and AUTO_INCREMENT_FLAG) <> 0
    then
      Append(Result, 'AUTO_INCREMENT');
  end
  else begin
    if (flag and ENUM_FLAG)<>0
    then
      Append(Result, 'ENUM');
    if (flag and SET_FLAG)<>0
    then
      Append(Result, 'SET');
    if (flag and BLOB_FLAG)<>0
    then
      Append(Result, 'BLOB');
  end;
  if (flag and NOT_NULL_FLAG)<>0
  then
    Append(Result, 'NOT_NULL');
  if (flag and PRI_KEY_FLAG)<>0
  then
    Append(Result, 'PRI_KEY');
  if (flag and UNIQUE_KEY_FLAG)<>0
  then
    Append(Result, 'UNIQUE_KEY');
  if (flag and MULTIPLE_KEY_FLAG)<>0
  then
    Append(Result, 'MULTIPLE_KEY');
  if (flag and ZEROFILL_FLAG)<>0
  then
    Append(Result, 'ZEROFILL');
  if (flag and BINARY_FLAG)<>0
  then
    Append(Result, 'BINARY');
  if (flag and NO_DEFAULT_VALUE_FLAG)<>0
  then
    Append(Result, 'NO_DEFAULT_VALUE');
  if (flag and TIMESTAMP_FLAG)<>0
  then
    Append(Result, 'TIMESTAMP');
end;

{ TMySqlReader }

constructor TMySqlReader.Create(const Host, User, Password, Database, Table: String;
                                OnReady: TNotifyEvent);
begin
  inherited Create(True);
  FHost := Host;
  FUser := User;
  FPassword := Password;
  FDatabase := Database;
  FTable := Table;
  OnTerminate := OnReady;
  FreeOnTerminate := True;
  Resume;
end;

procedure TMySqlReader.Execute;
var
  Handle: PMYSQL;
  i, field_count: Integer;
  mySQL_Res: PMYSQL_RES;
  mySQL_Field: PMYSQL_FIELD;
  sql: AnsiString;
  Done: Boolean;
begin
  try
    Handle := mysql_init(nil);
    try
      Done := false;
      if (mysql_real_connect(Handle,
                             PAnsiChar(AnsiString(FHost)),
                             PAnsiChar(AnsiString(FUser)),
                             PAnsiChar(AnsiString(FPassword)),
                             PAnsiChar(AnsiString(FDatabase)), 0, nil, 0)=Handle)
      then begin
        sql := AnsiString('select * from ' + QuoteName(FTable) + ' where 0');
        if mysql_real_query(Handle, PAnsiChar(sql), Length(sql))=0
        then begin
          //Get Data
          mySQL_Res := mysql_store_result(Handle);
          if mySQL_Res<>nil
          then begin
            //Get Fieldnames
            try
              field_count := mysql_num_fields(mySQL_Res);
              SetLength(FFieldDescriptorList, field_count);
              for i := 0 to field_count - 1 do
              begin
                mySQL_Field := mysql_fetch_field(mySQL_Res);
                if mySQL_Field<>nil
                then begin
                  FFieldDescriptorList[i].Fieldname := mysql_field_name(mySQL_Field);
                  FFieldDescriptorList[i].FieldType := GetFieldTypeString(mySQL_Field);
                  FFieldDescriptorList[i].FieldLength := mysql_field_length(mySQL_Field);
                  FFieldDescriptorList[i].FieldFlag := GetFieldFlagString(mysql_field_flag(mySQL_Field));
                end;
              end;
              Done := True;
            finally
              mysql_free_result(mySQL_Res);
            end;
          end;
        end;
      end;
      if not Done
      then
        raise Exception.Create(mysql_error(Handle));
    finally
      mysql_close(Handle);
      mysql_thread_end;
    end;
  except
    on Error: Exception do
      FmyMessage := Error.Message;
  end;
end;

end.
