unit ExportToExcel;
{ 关于 Excel ODBC Datasource
  1. 使用Create Table ABC(C1 char,C2 char)以后，创建两个表ABC,ABC$(系统表)
     C1,C2的长度是255
  2. 使用Drop Table ABC以后，ABC消失，ABC$保留
  3. Create Table ABC(C1 char,C2 char,C3 char)不成功，因为ABC$滞留，造成列数不匹配！
     只能使用 Create Table ABC3(C1 char,C2 char,C3 char)
  4. 实际文件名保存在注册表  HKEY_LOCAL_MACHINE\Software\ODBC\ODBC.INI, name=DBQ
}
interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
  Db, DBTables ;
type
  TExcelExportResult = (erSuccess,erParamError,erOpenError,erCreateError,erInsertError,erCopyFileError,erCopyTemplate);

  { TExcelExporter Copy data from [source] to a excel file [filename]

    1.TExcelExporter open the database named as ExcelDBAlias.
    2.ExcelDBAlias is also the System ODBC Excel datasource.
    3.TExcelExporter create a new table named as FTablename in ExcelDBAlias.
    4.insert data from Source to FTablename
    5.Copy the real Excel File(The File Name is gotten from Registry) to export file named as FileName

    Notes: if UseTemplateFile , will copy the template file to the real Excel File before open the datasource.
    The template file is locate by the real Excel File, has the same name, and a extention '*.bak'
  }
  TExcelExporter = class(TComponent)
  private
    FExcelDBAlias: string;
    FFileName: string;
    FSource: TDataset;
    FQuery : TQuery;
    FSheetName: string;
    FDBFileName : string;
    FTableName : string;
    FUseTemplateFile: boolean;
    FExportLabel: boolean;
    procedure   SetSource(const Value: TDataset);
    procedure   ExecSQL(const SQLText:string);
    procedure   CreateTable;
    procedure   CopyData;
    procedure   ReadODBCConfig;
    procedure   DropTable(const ATableName:string);
    procedure   DropOldExportTable;
  protected
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    ExportResult : TExcelExportResult;
    property    TableName : string read FTableName ;
    constructor Create(AOwner : TComponent); override;
    function    Execute : boolean;
  published
    property    ExcelDBAlias : string read FExcelDBAlias write FExcelDBAlias;
    property    FileName : string read FFileName write FFileName;
    property    Source : TDataset read FSource write SetSource;
    property    SheetName : string read FSheetName write FSheetName;
    property    UseTemplateFile : boolean read FUseTemplateFile write FUseTemplateFile;
    property    ExportLabel : boolean read FExportLabel write FExportLabel;
  end;

const
  ODBCEntry = 'Software\ODBC\ODBC.INI\';
  TemplateFileExt = '.bak';

implementation

uses Registry,SafeCode;

function GetStrConst(const Value:string): string;
begin

end;

{ TExcelExporter }

constructor TExcelExporter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSheetName := 'EXPORT';
end;

procedure TExcelExporter.ExecSQL(const SQLText:string);
begin
    FQuery.SQL.Clear;
    FQuery.SQL.Add(SQLText);
    FQuery.ExecSQL;
end;

function TExcelExporter.Execute: boolean;
var
  DB : TDatabase;
begin
  ReadODBCConfig;
  if (ExcelDBAlias='') or (Source=nil) or (FileName='')
    or (FSheetName='') or (not FileExists(FDBFileName)) then
  begin
    // Param Error;
    ExportResult := erParamError;
    result := false;
  end
  else
  begin
    DB := TDatabase.Create(self);
    FQuery := TQuery.Create(self);
    try
      // connect database
      DB.AliasName := ExcelDBAlias;
      DB.DatabaseName := ExcelDBAlias;
      DB.Params.Add('user name=');
      DB.Params.Add('password=');
      DB.LoginPrompt := false;
      try
        if UseTemplateFile then
        begin
          //Copy Template File
          ExportResult := erCopyTemplate;
          CheckTrue(windows.copyFile(pchar(changeFileExt(FDBFileName,TemplateFileExt)),
                pchar(FDBFileName),false),'Error : copyFile');
        end;
        ExportResult := erOpenError;
        DB.Open;
        FQuery.DatabaseName:=ExcelDBAlias;
        //Assert(FQuery.Database=DB);
        // create table
        ExportResult := erCreateError;
        CreateTable;
        // Copy Data
        ExportResult := erInsertError;
        CopyData;
        // Copy File
        ExportResult := erCopyFileError;
        DB.Close;
        CheckTrue(windows.CopyFile(pchar(FDBFileName),pchar(FileName),false),'Error : copyFile');
        ExportResult := erSuccess;
      except

      end;
    finally
      result := ExportResult=erSuccess;
      FQuery.free;
      DB.free;
    end;
  end;
end;

procedure TExcelExporter.CreateTable;
var
  SQLText : string;
  i : integer;
begin
  FTableName := SheetName + IntToStr(Source.Fields.count);
  // drop the table before create
  {DropTable(FTableName);}
  DropOldExportTable;
  // Create table
  SQLText := 'Create Table '+FTableName+'('+Source.Fields[0].FieldName+' char';
  for i:=1 to Source.Fields.count-1 do
  begin
    SQLText := SQLText+','+Source.Fields[i].FieldName+' char';
  end;
  SQLText := SQLText+')';
  ExecSQL(SQLText);
end;

procedure TExcelExporter.CopyData;
var
  SQLText : string;
  i : integer;
begin
  with Source do
  begin
    try
      if ExportLabel then
      begin
        // Export Label
        SQLText := 'Insert into '+FTableName+' values('''+Fields[0].DisplayLabel+'''';
        for i:=1 to Fields.count-1 do
          SQLText := SQLText+','''+Fields[i].DisplayLabel+'''';
        SQLText := SQLText+')';
        self.ExecSQL(SQLText);
      end;
      // Export data
      DisableControls;
      First;
      while not Eof do
      begin
        // Export one row
        //SQLText := 'Insert into '+FTableName+' values('''+Fields[0].AsString+'''';
        SQLText := 'Insert into '+FTableName+' values('+QuotedStr(Fields[0].AsString);
        for i:=1 to Fields.count-1 do
          //SQLText := SQLText+','''+Fields[i].AsString+'''';
          SQLText := SQLText+','+QuotedStr(Fields[i].AsString);
        SQLText := SQLText+')';
        self.ExecSQL(SQLText);
        next;
      end;
    finally
      EnableControls;
    end;
  end;
end;


procedure TExcelExporter.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (AComponent=FSource) and (Operation=opRemove) then
    FSource := nil;
end;

procedure TExcelExporter.SetSource(const Value: TDataset);
begin
  if FSource <> Value then
  begin
    FSource := Value;
    if FSource<>nil then FSource.FreeNotification(self);
  end;
end;

procedure TExcelExporter.ReadODBCConfig;
var
  Reg : TRegistry;
  RegEntry : string;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    RegEntry := ODBCEntry+ExcelDBAlias;
    Reg.OpenKey(RegEntry,false);
    FDBFileName := Reg.ReadString('DBQ');
  finally
    Reg.free;
  end;
end;


procedure TExcelExporter.DropTable(const ATableName: string);
begin
  try
    ExecSQL('Drop Table '+ATableName);
  except
  end;
end;

procedure TExcelExporter.DropOldExportTable;
var
  TableList : TStringList;
  i : integer;
begin
  TableList := TStringList.Create;
  try
    Session.GetTableNames(ExcelDBAlias,'',false,false,TableList);
    for i:=0 to TableList.count-1 do
    begin
      {$ifdef debug }
      outputDebugString(pchar('drop table TableList[i]'));
      {$endif}
      DropTable(TableList[i]);
    end;
  finally
    TableList.free;
  end;
end;

end.
