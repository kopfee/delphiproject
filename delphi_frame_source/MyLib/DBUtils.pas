unit DBUtils;

interface

uses Db, DBTables,Bde,DBConsts, BDEConst,DBCommon;

function CreateParamDesc(SP : TStoredProc; DefaultInput : boolean = false): boolean;

implementation

function CreateParamDesc(SP : TStoredProc; DefaultInput : boolean = false):boolean;
var
  Desc: SPParamDesc;
  Cursor: HDBICur;
  Buffer: DBISPNAME;
  ParamName: string;
  ParamDataType: TFieldType;
  db : TDatabase;
  r : integer;
begin
  AnsiToNative(sp.DBLocale, sp.StoredProcName, Buffer, SizeOf(Buffer)-1);
  db := sp.OpenDatabase;
  if db=nil then
  begin
    result:=false;
    exit;
  end;
  r := DbiOpenSPParamList(db.Handle, Buffer, False, sp.OverLoad, Cursor);
  result := r=0;
  if  result then
  try
    SP.Params.Clear;
    while DbiGetNextRecord(Cursor, dbiNOLOCK, @Desc, nil) = 0 do
      with Desc do
      begin
        NativeToAnsi(sp.DBLocale, szName, ParamName);
        if (TParamType(eParamType) = ptResult) and (ParamName = '') then
          ParamName := SResultName;
        if uFldType < MAXLOGFLDTYPES then ParamDataType := DataTypeMap[uFldType]
        else ParamDataType := ftUnknown;
        if (uFldType = fldFLOAT) and (uSubType = fldstMONEY) then
          ParamDataType := ftCurrency;
        with TParam(sp.Params.Add) do
        begin
          ParamType := TParamType(eParamType);
          DataType := ParamDataType;
          Name := ParamName;
          if DefaultInput and (ParamType=ptUnknown) then
            ParamType := ptInput;
        end;
      end;
    //SetServerParams;
  finally
    DbiCloseCursor(Cursor);
  end;
end;

end.
