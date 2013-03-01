unit KCEditors;

{$I KSConditions.INC }

interface

uses Windows, Sysutils, Classes, TypUtils, DesignUtils
  {$ifdef VCL60_UP }
    ,DesignIntf, DesignEditors
  {$else}
    ,dsgnintf
  {$endif}
;

type
  TWVFieldNameProperty3 = class(TStringProperty)
  private

  public
    function    GetAttributes: TPropertyAttributes; override;
    procedure   GetValues(Proc: TGetStrProc); override;
  end;

  TWVParamNameProperty2 = class(TStringProperty)
  private

  public
    function    GetAttributes: TPropertyAttributes; override;
    procedure   GetValues(Proc: TGetStrProc); override;
  end;

  TKCWVProcessorEditor = class(TUseDefaultPropertyEditor)
  protected
    procedure   Init; override;
    procedure   AddBindings(Bindings : TCollection; const Title:string);
  public
    procedure   ExecuteVerb(Index: Integer); override;
    function    GetVerb(Index: Integer): string; override;
    function    GetVerbCount: Integer; override;
  end;

resourcestring
  SProcInputBindings = 'Edit Input Bindings';
  SProcOutputBindings = 'Edit Output Bindings';
  SAddProcInputBindings = 'Add Input Bindings';
  SAddProcOutputBindings = 'Add Output Bindings';

implementation

uses KCDataPack, KCWVProcBinds, WVCommands, WVCmdTypeInfo, WVMemoDlg, KSStrUtils;

{ TWVFieldNameProperty3 }

function TWVFieldNameProperty3.GetAttributes: TPropertyAttributes;
begin
  result := (inherited GetAttributes) + [paValueList, paSortList];
end;

procedure TWVFieldNameProperty3.GetValues(Proc: TGetStrProc);
var
  I : Integer;
begin
  for I:=0 to PARAMBITS-1 do
  begin
    if KCPackDataNames[I]<>'' then
      Proc(KCPackDataNames[I]);
  end;
  Proc(SReturn);
  Proc(SDataset);
end;

{ TWVParamNameProperty2 }

function TWVParamNameProperty2.GetAttributes: TPropertyAttributes;
begin
  result := (inherited GetAttributes) + [paValueList];
end;

procedure TWVParamNameProperty2.GetValues(Proc: TGetStrProc);
var
  ID : TWVCommandID;
  Version : TWVCommandVersion;
  Binding : TKCParamBinding;
begin
  Binding := TKCParamBinding(GetComponent(0));
  if Binding is TKCParamBinding then
  begin
    ID := Binding.Processor.ID;
    Version := Binding.Processor.Version;
    FillCommandParamNames(ID,Version,Proc);
  end;
end;

{ TKCWVProcessorEditor }

procedure TKCWVProcessorEditor.AddBindings(Bindings : TCollection; const Title:string);
var
  Dialog : TdlgMemo;
  I : Integer;
  Binding : TKCParamBinding;
  ParamName,FieldName : string;
  Parts : TStringList;
begin
  Dialog := TdlgMemo.Create(nil);
  Parts := TStringList.Create;
  try
    if Dialog.Execute(Title) then
    begin
      for I:=0 to Dialog.Memo.Count-1 do
      begin
        seperateStrByBlank(Dialog.Memo[I],Parts);
        if Parts.Count>0 then
        begin
          Binding := TKCParamBinding(Bindings.Add);
          ParamName := Parts[0];
          if Parts.Count>1 then
            FieldName := Parts[1];
          Binding.ParamName := ParamName;
          Binding.FieldName := FieldName;
        end;
      end;
    end;
  finally
    Parts.Free;
    Dialog.Free;
  end;
end;

procedure TKCWVProcessorEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0 : begin
          FPropName := 'InputBindings';
          inherited;
        end;
    1 : begin
          FPropName := 'OutputBindings';
          inherited;
        end;
    2 : AddBindings(TKCWVCustomProcessor(Component).InputBindings,SAddProcInputBindings);
    3 : AddBindings(TKCWVCustomProcessor(Component).OutputBindings,SAddProcOutputBindings);
  else inherited;
  end;
end;

function TKCWVProcessorEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0 : Result := SProcInputBindings;
    1 : Result := SProcOutputBindings;
    2 : Result := SAddProcInputBindings;
    3 : Result := SAddProcOutputBindings;
  else
    Result := inherited GetVerb(Index);
  end;
end;

function TKCWVProcessorEditor.GetVerbCount: Integer;
begin
  Result := 4;
end;

procedure TKCWVProcessorEditor.Init;
begin
  inherited;
  //FPropName := 'Params';
end;

end.
