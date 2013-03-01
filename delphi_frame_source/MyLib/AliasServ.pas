unit AliasServ;

interface

uses SysUtils,Classes,DB,ComWriUtils;

const
	AliasHeader : char = '#';
  PathSeperator : char = '\';

type
  TAliasServer = class(TStringMap)
  private

  protected

  public
    procedure 	LoadFromStrings(AStrings : TStrings);
    procedure 	LoadFromFile(const FileName : string); dynamic;
    procedure 	LoadFromDataSet(DataSet : TDataSet; NameField,ValueField : TField); dynamic;
  published

  end;

  TFileProcMethod = procedure (const filename : string) of object;

  TPathServer = class(TComponent)
  private
    FSearchPaths : TStringList;
    FAliasServer: TAliasServer;
    FNextPathServer: TPathServer;
    FMatchedPath: string;
    FMatchedAlias: string;
    procedure SetSearchPaths(const Value: TStrings);
    procedure SetNextPathServer(const Value: TPathServer);
    function 	GetSearchPaths: TStrings;
  protected

  public
    constructor Create(AOwner : TComponent); override;
    destructor 	destroy; override;
    property		AliasServer : TAliasServer read FAliasServer;
    procedure 	SafeFileProc(FP : TFileProcMethod; const Filename:string);
    { return value is whether file exists
    	RealFilename VALUE:
      	1. FileName have An alias, MatchedAlias=AliasName
        	1) Alias Value is not empty : RealFilename = AliasValue + RestFileName
          2) Alias Value is empty :	RealFilename = RestFileName
        below , MatchedAlias=''
        2. FileName have full path, RealFilename = FileName
        3. FileName have no path, Search file in SearchPaths
        	1) if found, RealFileName = pathname + filename
          2) if not found, RealFileName = filename
    }
    function 		GetRealFileName(const FileName:string; var RealFilename : string):boolean;
    // if not found , return empty string
    function		GetAliasValue(const AliasName : string):string;
    // Add AliasValues to a TStrings
    procedure		GetAliasValues(const AliasName : string; Values : TStrings);
    {   Search File in SearchPaths and NextPathServers' SearchPaths
    		RelativeFileName do not have a absolute path, it is to say,
    	RelativeFileName do not start with Driver letter or PathSeperator.
	      if found return file path, otherwise return RelativeFileName.
     }
    function		SearchFile(const RelativeFileName:string):string;

    {  Search File in given paths.
    	 return whether find.
       if found, FullName is the full name of the file,
     path is the path added before RelativeFileName,
     otherwise not change FullName and path
    }
    function		SearchFileInPaths(const RelativeFileName:string;Paths : TStrings;
    	var FullName,Path : string):boolean;

    property		MatchedAlias : string read FMatchedAlias;
    property		MatchedPath  : string read FMatchedPath;
  published
    property		SearchPaths : TStrings  read GetSearchPaths write SetSearchPaths;
    // when self not find a file, use NextPathServer
    property		NextPathServer : TPathServer read FNextPathServer write SetNextPathServer;
  end;

implementation

{ TAliasServer }

procedure TAliasServer.LoadFromDataSet(DataSet: TDataSet; NameField,
  ValueField: TField);
begin
  assert(Assigned(DataSet)
  	and Assigned(NameField)
    and Assigned(ValueField));
  clear;
  DataSet.First;
  while not DataSet.eof do
  begin
    Add(NameField.AsString,ValueField.AsString);
    dataSet.next;
  end;
end;

procedure TAliasServer.LoadFromFile(const FileName: string);
var
  Strings : TStringList;
begin
  Strings := TStringList.Create;
  try
	  Strings.LoadFromFile(Filename);
    LoadFromStrings(Strings);
  finally
    Strings.free;
  end;
end;

procedure TAliasServer.LoadFromStrings(AStrings: TStrings);
var
  i : integer;
  p : integer;
  AString : string;
begin
  clear;
  for i:=0 to AStrings.count-1 do
  begin
    AString := AStrings[i];
    p := pos('=',AString);
    if p>1 then
    begin
      Add(copy(AString,1,p-1),copy(AString,p+1,length(AString)-p));
    end;
  end;
end;

{ TPathServer }

constructor TPathServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAliasServer := TAliasServer.Create;
  FSearchPaths := TStringList.Create;
  RegisterRefProp(self,'NextPathServer');
end;

destructor TPathServer.destroy;
begin
  FSearchPaths.free;
  FAliasServer.free;
  inherited destroy;
end;

function TPathServer.GetRealFileName(const FileName: string;
  var RealFilename: string): boolean;
var
  AliasName,FullName,Path  : string;
  index : integer;
  RelativeFileName : string;
  AliasValues : TStringList;
begin
  if FileName<>'' then
  begin
    if FileName[1]=AliasHeader then
    begin
    // this contains a alias
      index := pos(PathSeperator,FileName);
      if (index<=2) or (index=length(Filename)) then
      	result:=false
      else
      begin
        // not copy Alias Header and PathSeperator
        AliasName := copy(FileName,2,index-2);
        FMatchedAlias := AliasName;
        // not copy PathSeperator and next
        RelativeFileName := copy(FileName,index+1,length(FileName)-index );
        // get Alias values in AliasValues
        AliasValues := TStringList.Create;
        try
	        GetAliasValues(AliasName,AliasValues);
          // search file in AliasValues
  	      result:=SearchFileInPaths(RelativeFileName,AliasValues,FullName,Path);
          if result then
          begin
            RealFileName := FullName;
            FMatchedPath := Path;
          end
          else
          begin
            RealFileName := RelativeFileName;
            FMatchedPath := '';
          end;
        finally
          AliasValues.free;
        end;
      end;
    end
    else
    begin
    // filename have no alias
      FMatchedAlias := '';
      if (ExtractFileDrive(FileName)<>'') or
      	(FileName[1]=PathSeperator) then
      begin
        // file have full path
        FMatchedPath := '';
        RealFileName := FileName;
        result := FileExists(RealFileName);
      end
      else
      begin
        RelativeFileName := FileName;
        // file name is relative
        RealFileName := SearchFile(RelativeFileName);
        result := FileExists(RealFileName);
      end;
    end;
  end
  // file name is empty
  else result:=false;
end;

procedure TPathServer.SafeFileProc(FP: TFileProcMethod; const Filename:string);
var
  realFileName : string;
begin
  if Assigned(FP) and
  	GetRealFileName(FileName,realFileName) then
  try
    FP(realFileName);
  except
    // log exception
  end;
end;

function TPathServer.GetAliasValue(const AliasName: string): string;
begin
  if not AliasServer.GetValueByName(AliasName,result)	then
  begin
    if Assigned(NextPathServer) then
    	result := NextPathServer.GetAliasValue(AliasName)
    else result:='';
  end;
end;


function TPathServer.SearchFile(const RelativeFileName: string): string;
var
  Fullname,FilePath : string;
begin
  if SearchFileInPaths(RelativeFileName,SearchPaths,Fullname,FilePath) then
  begin
  // found file in self search paths
    FMatchedPath := FilePath;
    result := FullName;
  end
  else
  // not found file in self search paths
  if Assigned(NextPathServer) then
  begin
  // then call NextPathServer
    result := NextPathServer.SearchFile(RelativeFileName);
    FMatchedPath := NextPathServer.MatchedPath;
  end
  else
  begin
  // if no NextPathServer, file not found
    result := RelativeFileName;
    FMatchedPath := '';
  end;
end;

procedure TPathServer.SetNextPathServer(const Value: TPathServer);
begin
  if FNextPathServer <> Value then
  begin
    FNextPathServer := Value;
    ReferTo(value);
  end;
end;

procedure TPathServer.SetSearchPaths(const Value: TStrings);
begin
  FSearchPaths.Assign(Value);
end;

function TPathServer.GetSearchPaths: TStrings;
begin
  result := FSearchPaths;
end;


procedure TPathServer.GetAliasValues(const AliasName: string;
  Values: TStrings);
begin
  AliasServer.GetValuesByName(AliasName,values);
  if Assigned(FNextPathServer) then
  	FNextPathServer.GetAliasValues(AliasName,values);
end;

function TPathServer.SearchFileInPaths(const RelativeFileName: string;
  Paths: TStrings; var FullName, Path: string): boolean;
var
  i : integer;
  FilePath : string;
begin
  for i:=0 to Paths.count-1 do
  begin
    FilePath := Paths[i]+PathSeperator+RelativeFileName;
    if FileExists(FilePath) then
    begin
      result:=true;
      Path := Paths[i];
      FullName := FilePath;
      exit;
    end;
  end;
  result := false;
end;

end.
