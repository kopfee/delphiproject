{ :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: QuickReport 2.0 for Delphi 1.0/2.0/3.0                  ::
  ::                                                         ::
  :: QREPORT.PAS - QuickReport registration unit             ::
  ::                                                         ::
  :: Copyright (c) 1997 QuSoft AS                            ::
  :: All Rights Reserved                                     ::
  ::                                                         ::
  :: web: http://www.qusoft.no   mail: support@qusoft.no     ::
  ::                             fax: +47 22 41 74 91        ::
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: }

{$ifndef ver100}
{$define proversion}
{$endif}

unit qreport;                      

interface

uses QuickRpt;

procedure Register;

function GetDesignVerb(Index: Integer): string;
function GetDesignVerbCount: Integer;
procedure ExecuteDesignVerb(Index: Integer; Report: TQuickRep);

implementation
{$ifdef win32}
uses sysutils, windows, typinfo, classes, dsgnintf, controls, stdctrls, forms, qrprntr,
     db, QRCtrls, Dialogs, QRAbout, QR2Const
    {$ifdef ver100}, exptintf{$endif};
{$else}
uses sysutils, wintypes, typinfo, winprocs, classes, dsgnintf, controls, stdctrls, forms, db,
     QRPrntr, QRCtrls, Dialogs, QRAbout, QR2Const;
{$endif}

type
  { TQRFloatProperty - Floating point property editor with 2 fixed decimal places}
  TQRFloatProperty = class(TFloatProperty)
  protected
    function GetValue : String; override;
  end;

  { TQRMasterProperty - property editor for the Master property, showing
    TQuickRep and TQRController components only }
  TQRMasterProperty = class(TComponentProperty)
  public
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  { TQRCaptionProperty - just a copy of TCaptionProperty }
  TQRCaptionProperty = class(TCaptionProperty);

  { TQRGraphicsEditor - Component editor for TQRImage, copied from
    PICEDIT.PAS for Delphi 3.0 compatibility }

  TQRGraphicEditor = class(TDefaultEditor)
  public
    procedure EditProperty(PropertyEditor: TPropertyEditor;
      var Continue, FreeEditor: Boolean); override;
  end;

{ TDataFieldProperty }
type
  TQRDBStringProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValueList(List: TStrings); virtual; abstract;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

function TQRDBStringProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

procedure TQRDBStringProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Values: TStringList;
begin
  Values := TStringList.Create;
  try
    GetValueList(Values);
    for I := 0 to Values.Count - 1 do Proc(Values[I]);
  finally
    Values.Free;
  end;
end;

type
  TQRDataFieldProperty = class(TQRDBStringProperty)
  public
    function GetDataSetPropName: string; virtual;
    procedure GetValueList(List: TStrings); override;
  end;

function TQRDataFieldProperty.GetDataSetPropName: string;
begin
  Result := 'DataSet'; {<-- do not resource}
end;

procedure TQRDataFieldProperty.GetValueList(List: TStrings);
var
  Instance: TComponent;
  PropInfo: PPropInfo;
  DataSet: TDataSet;
begin
  Instance := TComponent(GetComponent(0));
  PropInfo := TypInfo.GetPropInfo(Instance.ClassInfo, GetDataSetPropName);
  if (PropInfo <> nil) and (PropInfo^.PropType^.Kind = tkClass) then
  begin
    DataSet := TObject(GetOrdProp(Instance, PropInfo)) as TDataSet;
    if (DataSet <> nil) then
      DataSet.GetFieldNames(List);
  end;
end;

{ TQRFloatProperty }

function TQRFloatProperty.GetValue : String;
begin
  result:=FloatToStrF(GetFloatValue, ffFixed,18,2);
end;

{ TQRMasterProperty }

procedure TQRMasterProperty.GetValues(Proc: TGetStrProc);
{$ifdef VER100}
var
  I: Integer;
  Root: TComponent;
  Component: TComponent;
begin
  Root := TFormDesigner(Designer).GetRoot;
  if Root is TQuickRep then Proc(Root.Name);
  for I := 0 to Root.ComponentCount - 1 do
  begin
    Component := Root.Components[I];
    if ((Component is TQuickRep) or (Component is TQRController) or
       (Component is TQRControllerBand)) and
       (Component.Name <> '') then
      Proc(Component.Name);
  end;
end;
{$else}
var
  I: Integer;
  Component: TComponent;
begin
  for I := 0 to Designer.Form.ComponentCount - 1 do
  begin
    Component := Designer.Form.Components[I];
    if ((Component is TQuickRep) or (Component is TQRController) or
       (Component is TQRControllerBand)) and
       (Component.Name <> '') then
      Proc(Component.Name);
  end;
end;
{$endif}

{ TQRGraphicsEditor }

procedure TQRGraphicEditor.EditProperty(PropertyEditor: TPropertyEditor;
  var Continue, FreeEditor: Boolean);
var
  PropName: string;
begin
  PropName := PropertyEditor.GetName;
  if (CompareText(PropName, 'PICTURE') = 0) then
  begin
    PropertyEditor.Edit;
    Continue := False;
  end;
end;

{ TQRExprPropEditor }
type
  TQRExprProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

function TQRExprProperty.GetAttributes : TPropertyAttributes;
begin
  Result:=inherited GetAttributes + [paDialog];
end;

procedure TQRExprProperty.Edit;
var
  AValue : string;
begin
  AValue:=Value;
  if GetExpression('',AValue,TForm(TComponent(GetComponent(0)).Owner)) then
    Value:=AValue
end;

function GetDesignVerb(Index: Integer): string;
begin
  case Index of
    0 : result:=cQRName;
    1 : result:=LoadStr(SqrCopyright);
    2 : result:='-';
    3 : result:=LoadStr(SqrAboutQR);
    4 : result:=LoadStr(SqrReportSettings);
    5 : result:=LoadStr(SqrPreview);
    6 : result:='-';
    7 : result:=LoadStr(SqrZoomIn);
    8 : result:=LoadStr(SqrZoomOut);
  end;
end;

function GetDesignVerbCount: Integer;
begin
  Result := 9;
end;

procedure EditReport(Report: TQuickRep);
begin
  with TQRCompEd.Create(Application) do
  try
    QuickRep:=Report;
    ShowModal;
  finally
    free;
  end;
end;

procedure ShowAboutBox;
begin
  with TQRAboutBox.Create(Application) do
  try
    ShowModal;
  finally
    free;
  end;
end;

procedure MarkModified(Report: TQuickRep);
var
  Component: TComponent;
begin
  Component := Report;
  while Component <> nil do
    if Component is TForm then
    begin
      if TForm(Component).Designer <> nil then
        TForm(Component).Designer.Modified;
      Break;
    end
    else Component := Component.Owner;
end;

procedure ExecuteDesignVerb(Index: Integer; Report: TQuickRep);
begin
  case Index of
    3 : ShowAboutBox;
    4 : EditReport(Report);
    5 : Report.Preview;
    7 : Report.Zoom:=Report.Zoom+20;
    8 : Report.Zoom:=Report.Zoom-20;
  end;
  if Index in [4, 7, 8] then MarkModified(Report);
end;

{ TQReportDesignModeMenu }

type
  TQReportDesignModeMenu = Class(TComponentEditor)
  protected
    FReport : TQuickRep;
  public
    constructor Create(AComponent: TComponent; ADesigner: TFormDesigner); override;
    procedure Edit; override;
    procedure ExecuteVerb(Index: integer); override;
    function GetVerb(Index: integer): string; override;
    function GetVerbCount : integer; override;
  end;

constructor TQReportDesignModeMenu.Create(AComponent: TComponent; ADesigner: TFormDesigner);
begin
  inherited Create(AComponent, ADesigner);
  FReport:=TQuickRep(aComponent);
end;

procedure TQReportDesignModeMenu.Edit;
begin
  EditReport(FReport);
end;

function TQReportDesignModeMenu.GetVerb(Index: integer): string;
begin
  case Index of
    0 : result := cQRName;
    1 : result := LoadStr(SqrCopyright);
    2 : result := '-';
    3 : result := LoadStr(SqrAboutQR);
    4 : result := LoadStr(SqrReportSettings);
    5 : result := LoadStr(SqrPreview);
    6 : result := '-';
    7 : result := LoadStr(SqrZoomIn);
    8 : result := LoadStr(SqrZoomOut);
    9 : result := '-';
    10 : result := LoadStr(SqrRotateBands);
    11 : result := LoadStr(SqrHideBands);
    12 : result := LoadStr(SqrResetBands);
  end
end;

function TQReportDesignModeMenu.GetVerbCount : integer;
begin
  Result:=13;
end;

procedure TQReportDesignModeMenu.ExecuteVerb(Index: integer);
begin
  case Index of
    0, 1, 3 : ShowAboutBox;
    4 : EditReport(FReport);
    5 : FReport.Preview;
    7 : FReport.Zoom := FReport.Zoom + 20;
    8 : FReport.Zoom := FReport.Zoom - 20;
    10 : FReport.RotateBands := FReport.RotateBands + 1;
    11 : FReport.HideBands := true;
    12 : begin
           FReport.RotateBands := 0;
           FReport.HideBands := false;
         end;
  end;
  if Index in [4, 7, 8] then MarkModified(FReport);
end;

{ TQRGroupDesignModeMenu }

type
  TQRGroupDesignModeMenu = Class(TComponentEditor)
  protected
    FGroup : TQRGroup;
  public
    constructor Create(AComponent: TComponent; ADesigner: TFormDesigner); override;
    procedure ExecuteVerb(Index: integer); override;
    function GetVerb(Index: integer): string; override;
    function GetVerbCount : integer; override;
  end;

constructor TQRGroupDesignModeMenu.Create(AComponent: TComponent; ADesigner: TFormDesigner);
begin
  inherited Create(AComponent, ADesigner);
  FGroup:=TQRGroup(aComponent);
end;

function TQRGroupDesignModeMenu.GetVerb(Index: integer): string;
begin
  case Index of
    0 : result := cQRName;
    1 : result := LoadStr(SqrCopyright);
    2 : result := '-';
    3 : result := LoadStr(SqrMoveGroupUp);
  end;
end;

function TQRGroupDesignModeMenu.GetVerbCount : integer;
begin
  Result:=4;
end;

procedure TQRGroupDesignModeMenu.ExecuteVerb(Index: integer);
var
  aOwner : TComponent;
  aParent : TWinControl;
  CompList : TList;
  I : integer;
  CurGroup : integer;
begin
  AOwner := FGroup.Owner;
  AParent := FGroup.Parent;
  CompList := nil;
  try
    CompList := TList.Create;
    for I := 0 to AOwner.ComponentCount - 1 do
      if (AOwner.Components[I] is TQRGroup) and
        (TQRGroup(AOwner.Components[I]).Master = FGroup.Master) then
        CompList.Add(AOwner.Components[I]);
    if CompList.Count > 1 then
    begin
      CurGroup := CompList.IndexOf(FGroup);
      case Index of
        3 : if CurGroup > 0 then CompList.Move(CurGroup, 0);
      end;
      for I := 0 to CompList.Count - 1 do
      begin
        AOwner.RemoveComponent(CompList[I]);
        TQRGroup(CompList[I]).Parent := nil;
      end;
      for I := 0 to CompList.Count - 1 do
      begin
        AOwner.InsertComponent(CompList[I]);
        TQRGroup(CompList[I]).Parent := AParent;
        TQRGroup(CompList[I]).Master := TQRGroup(CompList[I]).Master;
      end;
    end;
  finally
    CompList.Free;
  end;
end;

{ TQRSubDetailDesignModeMenu }

type
  TQRSubDetailDesignModeMenu = Class(TComponentEditor)
  protected
    FSubDetail : TQRSubDetail;
  public
    constructor Create(AComponent: TComponent; ADesigner: TFormDesigner); override;
    procedure ExecuteVerb(Index: integer); override;
    function GetVerb(Index: integer): string; override;
    function GetVerbCount : integer; override;
  end;

constructor TQRSubDetailDesignModeMenu.Create(AComponent: TComponent; ADesigner: TFormDesigner);
begin
  inherited Create(AComponent, ADesigner);
  FSubDetail:=TQRSubDetail(aComponent);
end;

function TQRSubDetailDesignModeMenu.GetVerb(Index: integer): string;
begin
  case Index of
    0 : result := cQRName;
    1 : result := LoadStr(SqrCopyright);
    2 : result := '-';
    3 : result := LoadStr(SqrMoveSubdetailUp);
  end;
end;

function TQRSubDetailDesignModeMenu.GetVerbCount : integer;
begin
  Result:=4;
end;

procedure TQRSubDetailDesignModeMenu.ExecuteVerb(Index: integer);
var
  aOwner : TComponent;
  aParent : TWinControl;
  CompList : TList;
  I : integer;
  CurSub : integer;
begin
  AOwner := FSubDetail.Owner;
  AParent := FSubDetail.Parent;
  if AParent is TQuickRep then
  begin
    CompList := TList.Create;
    try
      for I := 0 to AOwner.ComponentCount - 1 do
        if (AOwner.Components[I] is TQRSubDetail) and
          (TQRSubDetail(AOwner.Components[I]).Master = FSubDetail.Master) then
          CompList.Add(AOwner.Components[I]);
      if CompList.Count > 1 then
      begin
        CurSub := CompList.IndexOf(FSubDetail);
        if CurSub > - 1 then
        case Index of
          3 : if CurSub > 0 then CompList.Move(CurSub, 0);
        end;
        for I := 0 to CompList.Count - 1 do
        begin
          AOwner.RemoveComponent(CompList[I]);
          TQRSubDetail(CompList[I]).Parent := nil;
        end;
        for I := 0 to CompList.Count - 1 do
        begin
          AOwner.InsertComponent(CompList[I]);
          TQRSubDetail(CompList[I]).Parent := AParent;
          TQRSubDetail(CompList[I]).Master := TQRSubDetail(CompList[I]).Master;
        end;
      end;
    finally
      CompList.Free;
    end;
  end;
end;

{ Register components and property editors }

procedure Register;
begin
{$ifdef win32}
  RegisterComponents('QReport',[TQuickRep, TQRSubDetail, TQRBand, TQRChildBand, TQRGroup,
    TQRLabel, TQRDBText, TQRExpr, TQRSysData, TQRMemo, TQRRichText, TQRDBRichText, TQRShape,
    TQRImage, TQRDBImage, TQRCompositeReport, TQRPreview{$ifdef proversion}, TQREditor{$endif}]);
  RegisterPropertyEditor(TypeInfo(string), TQRDBRichText, 'DataField', TQRDataFieldProperty);
{$else}
  RegisterComponents('QReport',[TQuickRep, TQRSubDetail, TQRBand, TQRChildBand, TQRGroup,
    TQRLabel, TQRDBText, TQRExpr, TQRSysData, TQRMemo, TQRShape, TQRImage,
    TQRDBImage, TQRCompositeReport, TQRPreview{$ifdef proversion}, TQREditor{$endif}]);
{$endif}
  RegisterPropertyEditor(TypeInfo(extended), TQRPage, '', TQRFloatProperty);
  RegisterPropertyEditor(TypeInfo(extended), TQRBandSize, '', TQRFloatProperty);
  RegisterPropertyEditor(TypeInfo(extended), TQRPrintableSize, '', TQRFloatProperty);
  RegisterPropertyEditor(TypeInfo(string), TQRCustomLabel, 'Caption', TQRCaptionProperty); {<-- do not resource }
  RegisterPropertyEditor(TypeInfo(TComponent), TQRExpr, 'Master', TQRMasterProperty);      {<-- do not resource }
  RegisterPropertyEditor(TypeInfo(TComponent), TQRGroup, 'Master', TQRMasterProperty);     {<-- do not resource }
  RegisterPropertyEditor(TypeInfo(TComponent), TQRSubDetail, 'Master', TQRMasterProperty); {<-- do not resource }
  RegisterPropertyEditor(TypeInfo(string), TQRDBText, 'DataField', TQRDataFieldProperty);  {<-- do not resource }
  RegisterPropertyEditor(TypeInfo(string), TQRDBImage, 'DataField', TQRDataFieldProperty); {<-- do not resource }
  RegisterPropertyEditor(TypeInfo(string), TQRExpr, 'Expression', TQRExprProperty);        {<-- do not resource }
  RegisterPropertyEditor(TypeInfo(string), TQRGroup, 'Expression', TQRExprProperty);       {<-- do not resource }
  RegisterComponentEditor(TQuickRep,TQReportDesignModeMenu);
  RegisterComponentEditor(TQRImage, TQRGraphicEditor);
  RegisterComponentEditor(TQRGroup, TQRGroupDesignModeMenu);
  RegisterComponentEditor(TQRSubDetail, TQRSubDetailDesignModeMenu);
  RegisterClasses([TQuickReport, TQRDetailLink, TQRDBCalc]);
{$ifdef ver100}
 RegisterNonActiveX([TQuickRep, TQRSubDetail, TQRChildBand, TQRGroup,
    TQRDBText, TQRExpr, TQRSysData, TQRMemo, TQRDBRichText, TQRShape, TQRImage,
    TQRDBImage, TQRCompositeReport, TQRPreview{$ifdef proversion}, TQREditor{$endif},
    TQRBasePanel, TQRCustomBand, TQRCustomLabel, TQRCustomRichText, TQRBand,
    TQRControllerBand, TQRLabel, TQRPrintable, TQRRichText], axrIncludeDescendants);
    RegisterLibraryExpert(TQuickReportExpert.Create);
{$endif}
end;

end.
