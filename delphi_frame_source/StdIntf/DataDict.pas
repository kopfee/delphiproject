unit DataDict;

interface

uses windows,sysUtils,classes,bdaimp,contnrs,DBAIntf;

type
  TDataDictionary = class
  private
    FDictionaries : TObjectList;
    FDictIDs : TList;
    FLock: TRTLCriticalSection;
    FInInit : boolean;
  protected

  public
    constructor Create;
    Destructor  Destroy;override;
    procedure   beginInit;
    procedure   endInit;
    procedure   lock;
    procedure   unlock;
    procedure   addDictionary(dictID : integer; dataAccess : IDBAccess); overload;
    // notes: dict(: THDataset) is released by TDataDictionary
    procedure   addDictionary(dictID : integer; dict : THDataset); overload;
    // getDictionary will take abs(dictID)
    function    getDictionary(dictID : integer) : THDataset;
    // event handler for THBasicField
    // getDisplayTextFromDict use abs(THBasicField.tag) as dictID
    // if THBasicField.tag<0 and field is char, do special
    procedure   getDisplayTextFromDict(Field:THBasicField; var Text:widestring);
  end;

implementation

uses safeCode,LogFile;

{ TDataDictionary }

constructor TDataDictionary.Create;
begin
  inherited;
  FDictionaries := TObjectList.create;
  FDictIDs := TList.create;
  InitializeCriticalSection(FLock);
  FInInit := false;
end;

destructor TDataDictionary.Destroy;
begin
  FDictIDs.free;
  FDictionaries.free;
  DeleteCriticalSection(FLock);
  inherited;
end;

procedure TDataDictionary.addDictionary(dictID: integer;
  dataAccess: IDBAccess);
var
  dataset : THDataset;
begin
  checkTrue(FInInit,'not in init state');
  dataset := THDataset.Create(dataAccess);
  dataset.addAllExistFields;
  dataset.Open(-1);
  FDictIDs.add(Pointer(dictID));
  FDictionaries.add(dataset);
end;

procedure TDataDictionary.addDictionary(dictID: integer; dict: THDataset);
begin
  checkTrue(FInInit,'not in init state');
  FDictIDs.add(Pointer(dictID));
  FDictionaries.add(dict);
end;


function TDataDictionary.getDictionary(dictID: integer): THDataset;
var
  i : integer;
begin
  lock;
  try
    checkTrue(not FInInit,'in init state');
    i :=  FDictIDs.IndexOf(pointer(abs(dictID)));
    if i>=0 then
      result := THDataset(FDictionaries[i]) else
      result := nil;
  finally
    unlock;
  end;
end;

procedure TDataDictionary.lock;
begin
  EnterCriticalSection(FLock);
end;

procedure TDataDictionary.unlock;
begin
  LeaveCriticalSection(FLock);
end;

procedure TDataDictionary.beginInit;
begin
  lock;
  FDictIDs.Clear;
  FDictionaries.Clear;
  FInInit := true;
end;

procedure TDataDictionary.endInit;
begin
  FInInit := false;
  unlock;
end;

procedure TDataDictionary.getDisplayTextFromDict(Field: THBasicField;
  var Text: widestring);
var
  dict : THDataset;
  {strValue : string;}
  Value : Variant;
  c : char;
  s,fn : string;
  i : integer;
begin
  if (Field<>nil) and not Field.isNull then
  begin
    dict := getDictionary(abs(field.tag));
    if dict<>nil then
    begin
      dict.lock;
      try
        {if field.fieldDef.FieldType=ftChar then
        begin
          strValue := field.Value;
          strValue := TrimRight(strValue);
          Value := strValue;
        end else}
        if (field.fieldDef.FieldType=ftChar) and (field.fieldDef.FieldSize>1) and (field.tag<0)
          and (dict.fields[0].fieldDef.FieldType=ftChar) {and (dict.fields[0].fieldDef.FieldSize=1)} then
        begin
          // Àà±ð´Ü
          s:=field.asString;
          Text := '';
          fn:=dict.fields[0].fieldName;
          for i:=1 to length(s) do
          begin
            c:=s[i];
            if dict.find(fn,c,[]) then
            begin
              Text := Text+dict.fields[1].asString;
              //writeLog('found '+c+' in dictionary '+IntToStr(field.tag));
            end{ else
              writeLog('cannot find '+c+' in dictionary '+IntToStr(field.tag));}
          end;
        end else
        begin
          Value := field.Value;
          if dict.find(dict.fields[0].fieldName,Value,[]) then
            Text := dict.fields[1].asString else
            Text := '';
        end;

      finally
        dict.unlock;
      end;
    end;
  end else
    Text := '';
end;

end.
