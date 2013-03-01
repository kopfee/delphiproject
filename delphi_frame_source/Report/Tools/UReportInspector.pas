unit UReportInspector;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ActnList, Menus, ImgList, ComCtrls,
  RTObjInspector, ZPropLst, ObjStructViews, UPlugin, RPCtrls;

const
  SSeperator = ' : ';

type
  TReportInspector = class(TObjectInspector)
    ImageList: TImageList;
    procedure   StructViewDeleteObject(View: TObjStructViews; Obj: TObject;
                  var DeleteIt: Boolean);
    procedure   PropertiesModified(Sender: TObject);
    procedure   StructViewUpdateObject(View: TObjStructViews; Obj: TObject;
                  Node: TTreeNode);
    procedure   StructViewCanDeleteObject(View: TObjStructViews;
                  Obj: TObject; var DeleteIt: Boolean);
    procedure   StructViewGetCaption(View: TObjStructViews; Obj: TObject;
                  var ACaption: String);
    procedure   StructViewModified(Sender: TObject);
    procedure   PropertiesFilterProp(Sender: TZPropList;
                  var Editor: PZEditor);
  private
    { Private declarations }
    FReport: TRDReport;
    FPropNames : TStringList;
    procedure   InitPropNames;
  protected
    procedure   SelectedChanged; override;
    procedure   Loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    property    Report : TRDReport read FReport write FReport;
    procedure   Modified;
    procedure   InstallPlugIns;
    procedure   InstallPlugin(PlugIn : TRDSPlugIn);
    procedure   InstallActionList(ActionList : TActionList);
    function    DoGetDesignObjectName(Obj : TObject; const DefaultName : string='') : string;
    procedure   RefreshTools;
  end;

var
  ReportInspector: TReportInspector;

implementation

uses UMain, LogFile, RPDesignInfo, UTools;

{$R *.DFM}

function  DoGetDesignObjectName(Obj : TObject; const DefaultName : string='') : string;
begin
  if ReportInspector<>nil then
    Result := ReportInspector.DoGetDesignObjectName(Obj,DefaultName) else
    Result := '';
end;


{ TReportInspector }

constructor TReportInspector.Create(AOwner: TComponent);
begin
  inherited;
  InitPropNames;
end;

destructor TReportInspector.Destroy;
begin
  FPropNames.Free;
  inherited;
end;


procedure TReportInspector.SelectedChanged;
begin
  inherited;
  if Selected is TControl then
  begin
    ReportDesigner.Selected := TControl(Selected);
    //if (Selected is TRDReport) or () then
  end;
end;

procedure TReportInspector.StructViewDeleteObject(View: TObjStructViews;
  Obj: TObject; var DeleteIt: Boolean);
begin
  inherited;
  DeleteIt := DeleteIt and not (Obj is TReportInfo) and not (Obj is TRDReport);
  if DeleteIt then
  begin
    DeleteIt := MessageDlg('Are you sure to delete it?', mtConfirmation, [mbYes, mbNo, mbCancel], 0)=mrYes;
  end;
end;

procedure TReportInspector.PropertiesModified(Sender: TObject);
begin
  inherited;
  Modified;
  ReportDesigner.Changed(Selected);
end;

procedure TReportInspector.StructViewUpdateObject(View: TObjStructViews;
  Obj: TObject; Node: TTreeNode);
begin
  inherited;
  Node.ImageIndex := -1;
  Node.SelectedIndex := 0;
end;

procedure TReportInspector.InstallPlugIns;
var
  i : integer;
  Comp : TComponent;
begin
  for i:=0 to Application.ComponentCount-1 do
  begin
    Comp := Application.Components[i];
    if Comp is TRDSPlugIn then
    begin
      InstallPlugin(TRDSPlugIn(Comp));
    end;
  end;
end;

procedure TReportInspector.Modified;
begin
  ReportDesigner.Modified := True;
  StructView.UpdateSelected;
end;

procedure TReportInspector.InstallPlugin(PlugIn: TRDSPlugIn);
begin
  InstallActionList(Plugin.ActionList);
end;

procedure TReportInspector.InstallActionList(ActionList: TActionList);
var
  MenuItem : TMenuItem;
  i : integer;
  Start : Integer;
begin
  // add images
  Start := ImageList.Count;
  if ActionList.Images<>nil then
  begin
    ImageList.AddImages(ActionList.Images);
    ActionList.Images := ImageList;
  end;

  // add menus
  for i:=0 to ActionList.ActionCount-1 do
  begin
    // update image index
    if (ActionList.Actions[i]) is TAction then
      with TAction(ActionList.Actions[i]) do
        if ImageIndex>=0 then
          ImageIndex:=Start+ImageIndex;
    // add menu
    MenuItem := TMenuItem.Create(Self);
    MenuItem.Action := ActionList.Actions[i];
    WriteLog(Format('%s : %d',[MenuItem.Caption,MenuItem.ImageIndex]));
    StructView.PopupMenu.Items.Add(MenuItem);
  end;
end;


procedure TReportInspector.Loaded;
begin
  inherited;
  //StructView.PopupMenu.Images := StructView.Images;
  StructView.AddItemAction.ImageIndex := 1;
  StructView.DeleteAction.ImageIndex := 2;
  InstallActionList(ReportDesigner.alNewBand);
  InstallPlugIns;
  WriteLog(Format('Images = %d',[ImageList.Count]));
end;

procedure TReportInspector.StructViewCanDeleteObject(View: TObjStructViews;
  Obj: TObject; var DeleteIt: Boolean);
begin
  inherited;
  DeleteIt := DeleteIt and not (Selected is TRDReport) and not (Selected is TReportInfo);
end;

procedure TReportInspector.StructViewGetCaption(View: TObjStructViews;
  Obj: TObject; var ACaption: String);
begin
  inherited;
  ACaption := DoGetDesignObjectName(Obj,ACaption);
end;

procedure TReportInspector.StructViewModified(Sender: TObject);
begin
  inherited;
  Modified;
end;

procedure TReportInspector.PropertiesFilterProp(Sender: TZPropList;
  var Editor: PZEditor);
var
  S : string;
begin
  inherited;
  // filter out name property for TRDReport and TReportInfo
  if ((Selected is TRDReport) or (Selected is TReportInfo)) and (Editor.peName='Name') then
  begin
    Dispose(Editor);
    Editor := nil;
  end
  else
  begin
    // change property name
    S := FPropNames.Values[Editor.peName];
    if S<>'' then
      Editor.peName:=S;
  end;
end;

procedure TReportInspector.InitPropNames;
var
  FileName : string;
begin
  FPropNames := TStringList.Create;
  FileName := Application.ExeName;
  FileName := ChangeFileExt(FileName,'.pro');
  if FileExists(FileName) then
    try
      FPropNames.LoadFromFile(FileName);
    except

    end;
end;

function TReportInspector.DoGetDesignObjectName(Obj: TObject;
  const DefaultName: string): string;
{
var
  ClassNameCaption : string;
  AClassName : string;
begin
  if Obj is TControl then
    Result := GetCtrlName(TControl(Obj),DefaultName) else
    Result := DefaultName;
  AClassName := Obj.ClassName;
  if Obj is TCollection then
    AClassName := 'TCollection.'+TCollection(Obj).ItemClass.ClassName;
  ClassNameCaption := FPropNames.Values[AClassName];
  if ClassNameCaption<>'' then
  begin
    if SameText(Result,Obj.ClassName) then
      Result := ClassNameCaption else
      Result := Result + ':' + ClassNameCaption;
  end;
end;
}
var
  ClassNameCaption : string;
  AClassName : string;
  GotCtrlName : Boolean;
  GotClassName : Boolean;
  DefaultEmpty : Boolean;
  CtrlName : string;
begin
  // 获得控件名称（根据Name、FieldName、Caption、BandName等等）
  if Obj is TControl then
  begin
    CtrlName := GetCtrlName(TControl(Obj),''{DefaultName});
    GotCtrlName := not SameText(CtrlName,Obj.ClassName);
  end else
    GotCtrlName := False;

  //Result := DefaultName;

  // 获取对象类名
  AClassName := Obj.ClassName;
  if Obj is TCollection then
    AClassName := 'TCollection.'+TCollection(Obj).ItemClass.ClassName;
  ClassNameCaption := FPropNames.Values[AClassName];
  GotClassName := ClassNameCaption<>'';

  DefaultEmpty := (DefaultName='')
    or SameText(DefaultName,Obj.ClassName)
    or SameText(DefaultName,ClassNameCaption);

  if GotCtrlName then
  begin
    if GotClassName then
      Result := CtrlName + SSeperator + ClassNameCaption else
      Result := CtrlName + SSeperator + Obj.ClassName;
  end
  else
  begin
    if GotClassName then
      if DefaultEmpty or (Obj is TCollection) then
        Result := ClassNameCaption
      else
        Result := DefaultName + SSeperator + ClassNameCaption
    else
      if DefaultEmpty then
        Result := Obj.ClassName
      else
        Result := DefaultName;
  end;
end;

procedure TReportInspector.RefreshTools;
begin
  ReportDesigner.RefreshTools;
end;

initialization
  GetDesignObjectNameFunc := DoGetDesignObjectName;
end.
