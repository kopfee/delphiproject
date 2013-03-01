unit UMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Design, ExtCtrls, RPCtrls, Design2, ComCtrls, ToolWin, Menus,
  FORecord, ActnList, ImgList, RTObjInspector, UReportInspector, RPDesignInfo,
  UToolForm;

resourcestring
  AppTitle = 'Report Designer';

const
  StartTop = 20;
  BottomMargin = 20;
  RightMargin = 20;

type
  TReportDesigner = class(TForm)
    sbDesignArea: TScrollBox;
    DesignerPane: TDesigner2;
    MainMenu: TMainMenu;
    miFile: TMenuItem;
    N1: TMenuItem;
    miExit: TMenuItem;
    ToolBar: TToolBar;
    miSave: TMenuItem;
    miOpen: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    alFile: TActionList;
    ImageList1: TImageList;
    FileClose1: TKSFileClose;
    FileNew1: TKSFileNew;
    FileOpen1: TKSFileOpen;
    FileSave1: TKSFileSave;
    FileSaveAs1: TKSFileSaveAs;
    FileOpenRecord: TFileOpenRecord;
    alNewBand: TActionList;
    acNewSimpleBand: TAction;
    miNew: TMenuItem;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    btnSelect: TToolButton;
    btnLabel: TToolButton;
    btnShape: TToolButton;
    btnPicture: TToolButton;
    acNewGroupBand: TAction;
    acNewRepeatBand: TAction;
    miSaveAs: TMenuItem;
    ToolButton5: TToolButton;
    ReportInspector: TReportInspector;
    Splitter1: TSplitter;
    StatusBar: TStatusBar;
    ImageList2: TImageList;
    miView: TMenuItem;
    miFullDesignArea: TMenuItem;
    N2: TMenuItem;
    miOldMethod: TMenuItem;
    procedure   DesignerPaneCanMoveCtrl(Designer: TCustomDesigner;
      Ctrl: TControl; var CanMoved: Boolean);
    procedure   FormCreate(Sender: TObject);
    procedure   FileOpenRecordFileClose(Sender: TObject);
    procedure   acNewSimpleBandExecute(Sender: TObject);
    procedure   alNewBandUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure   FileOpenRecordFileSave(FORecord: TFileOpenRecord;
      const FileName: String);
    procedure   FileOpenRecordFileOpen(FORecord: TFileOpenRecord;
      const FileName: String);
    procedure   FileOpenRecordFileNew(Sender: TObject);
    procedure   DesignerPaneDesignCtrlChanged(DesignCtrl: TControl);
    procedure   FormDestroy(Sender: TObject);
    procedure   DesignerPaneCtrlSizeMove(Sender: TObject);
    procedure   SelectedTool(Sender: TObject);
    procedure   DesignerPanePlaceNewCtrl(PlaceOn: TWinControl; x,
      y: Integer);
    procedure   acNewGroupBandExecute(Sender: TObject);
    procedure   acNewRepeatBandExecute(Sender: TObject);
    procedure   FileOpenRecordStatusChanged(Sender: TObject);
    procedure   DesignerPaneDelete(DeleteCtrl: TControl);
    procedure   FileOpenRecordAfterFileOperate(Sender: TObject);
    procedure   FormActivate(Sender: TObject);
    procedure   miFullDesignAreaClick(Sender: TObject);
    procedure   miOldMethodClick(Sender: TObject);
    procedure   DesignerPaneCanSizeCtrl(Designer: TCustomDesigner;
      Ctrl: TControl; var CanSized: Boolean);
  private
    { Private declarations }
    FReportInfo : TReportInfo;
    FToolForms : TList;
    FStartY : Integer;
    function    GetDesignning: Boolean;
    procedure   SetDesignning(const Value: Boolean);
    procedure   Init;
    function    GetSelected: TControl;
    procedure   SetSelected(const Value: TControl);
    function    CanNewBand : Boolean;
    function    GetGroupBand : TRDCustomGroupBand;
    procedure   AddCtrl(Ctrl : TControl);
    procedure   UpdateToolStatus;
    function    GetModified: Boolean;
    procedure   SetModified(const Value: Boolean);
    procedure   ShowToolForm(Sender : TObject);
    procedure   BeforeLoad;
    procedure   AfterLoad;
    procedure   AfterFileOperation;
    {procedure   BuildHistoryMenu;
    procedure   DoLoadState(Sender : TObject);}
  protected
    procedure   ValidateRename(AComponent: TComponent;
      const CurName, NewName: string); override;
  public
    { Public declarations }
    procedure   StartDesignning;
    procedure   StopDesignning(ChangeRoot : Boolean=True);
    procedure   InstallToolForm(ToolForm : TToolForm);
    procedure   Changed(Obj : TObject);
    procedure   AddObject(Obj : TObject);
    procedure   UpdateDesignArea;
    procedure   RefreshTools;

    property    ReportInfo : TReportInfo read FReportInfo;
    property    Designning : Boolean read GetDesignning write SetDesignning;
    property    Selected : TControl read GetSelected write SetSelected;
    property    Modified : Boolean read GetModified write SetModified;
  end;

var
  ReportDesigner: TReportDesigner;

implementation

uses JPEG, CompUtils, RPDefines;

{$R *.DFM}

procedure TReportDesigner.FormCreate(Sender: TObject);
begin
  Init;
end;

procedure TReportDesigner.Init;
var
  FileFilters, DefaultExt: string;
begin
  Application.Title := AppTitle;
  FileOpenRecord.UpdateFormCaption;

  FToolForms := TList.Create;
  FReportInfo := TReportInfo.Create(Self);
  ReportFileStores.GetFileInfo(FileFilters, DefaultExt);
  OpenDialog.Filter := FileFilters;
  OpenDialog.DefaultExt := DefaultExt;
  SaveDialog.Filter := FileFilters;
  SaveDialog.DefaultExt := DefaultExt;
  OnCloseQuery := FileOpenRecord.FormCloseQuery;
  UReportInspector.ReportInspector := ReportInspector;
  DesignerPane.PopupMenu := ReportInspector.StructView.PopupMenu;

  //ReportInspector.StructView.TreeView.RightClickSelect := True;
  StartDesignning;

  FStartY := StartTop;
end;

procedure TReportDesigner.FormDestroy(Sender: TObject);
begin
  FToolForms.Free;
  StopDesignning;
end;

procedure TReportDesigner.DesignerPaneCanMoveCtrl(
  Designer: TCustomDesigner; Ctrl: TControl; var CanMoved: Boolean);
begin
  CanMoved := not (Ctrl is TRDReport);
end;

function TReportDesigner.GetDesignning: Boolean;
begin
  Result := DesignerPane.Designed;
end;

procedure TReportDesigner.SetDesignning(const Value: Boolean);
begin
  DesignerPane.Designed := Value;
end;

procedure TReportDesigner.StartDesignning;
begin
  if ReportInfo.Report<>nil then
  begin
    with ReportInfo.Report do
    begin
      SetBounds(0,0,Width,Height);
      DesignerPane.SetBounds(0,0,Width,Height);
      Parent := DesignerPane;
    end;
    //ReportInspector.Root := ReportInfo.Report;
    ReportInspector.Root := ReportInfo;
    ReportInspector.Report := ReportInfo.Report;
    Designning := true;
  end
  else
    Designning := false;
end;

procedure TReportDesigner.StopDesignning(ChangeRoot : Boolean=True);
begin
  Designning := false;
  ReportInspector.Selected := nil;
  if ChangeRoot then
    ReportInspector.Root := nil;
  if ReportInfo.Report<>nil then
  begin
    //ReportInfo.Report.Parent := ReportInfo;
    ReportInfo.Report.Parent := nil;
  end
end;

procedure TReportDesigner.FileOpenRecordFileClose(Sender: TObject);
begin
  Close;
end;

function TReportDesigner.GetSelected: TControl;
begin
  Result := DesignerPane.DesignCtrl;
end;

procedure TReportDesigner.SetSelected(const Value: TControl);
begin
  DesignerPane.DesignCtrl := Value;
  if Value<>nil then
    sbDesignArea.ScrollInView(Value);
end;

function TReportDesigner.CanNewBand: Boolean;
begin
  Result := ReportInspector.Selected is TRDCustomGroupBand;
end;

function TReportDesigner.GetGroupBand: TRDCustomGroupBand;
begin
  Assert(Selected is TRDCustomGroupBand);
  Result := TRDCustomGroupBand(Selected);
end;

procedure TReportDesigner.alNewBandUpdate(Action: TBasicAction;
  var Handled: Boolean);
var
  B : Boolean;
begin
  Handled := true;

  B := CanNewBand;
  acNewSimpleBand.Enabled := B;
  acNewGroupBand.Enabled := B;
  acNewRepeatBand.Enabled := B;
end;

procedure TReportDesigner.FileOpenRecordFileSave(FORecord: TFileOpenRecord;
  const FileName: String);
begin
  StopDesignning(False);
  ReportInfo.SaveToFile(FileName);
  StartDesignning;
end;

procedure TReportDesigner.FileOpenRecordFileOpen(FORecord: TFileOpenRecord;
  const FileName: String);
begin
  StopDesignning;
  BeforeLoad;
  ReportInfo.LoadFromFile(FileName);
  AfterLoad;
  StartDesignning;
end;

procedure TReportDesigner.FileOpenRecordFileNew(Sender: TObject);
begin
  StopDesignning;
  BeforeLoad;
  ReportInfo.New;
  AfterLoad;
  StartDesignning;
end;

procedure TReportDesigner.DesignerPaneDesignCtrlChanged(
  DesignCtrl: TControl);
begin
  ReportInspector.Selected := DesignCtrl;
end;

procedure TReportDesigner.DesignerPaneCtrlSizeMove(Sender: TObject);
begin
  if DesignerPane.DesignCtrl is TRDReport then
    UpdateDesignArea;
  Modified := true;
end;

procedure TReportDesigner.AddCtrl(Ctrl: TControl);
begin
  Modified := True;
  ReportInspector.AddObject(Ctrl);
  Selected := Ctrl;
  AddObject(Ctrl);
end;

procedure TReportDesigner.SelectedTool(Sender: TObject);
begin
  UpdateToolStatus;
end;

procedure TReportDesigner.DesignerPanePlaceNewCtrl(PlaceOn: TWinControl; x,
  y: Integer);
var
  SimpleBand : TRDSimpleBand;
  Ctrl : TControl;
begin
  if PlaceOn is TRDSimpleBand then
  begin
    SimpleBand := TRDSimpleBand(PlaceOn);
    if btnLabel.Down then
      Ctrl := ReportInfo.NewLabel
    else if btnShape.Down then
      Ctrl := ReportInfo.NewShape
    else if btnPicture.Down then
      Ctrl := ReportInfo.NewPicture
    else Ctrl := nil;
    if Ctrl<>nil then
    begin
      Ctrl.SetBounds(x,y,Ctrl.Width,Ctrl.Height);
      Ctrl.Parent := SimpleBand;
      AddCtrl(Ctrl);
    end;
    btnSelect.Down := True;
  end;
  UpdateToolStatus;
end;

procedure TReportDesigner.UpdateToolStatus;
begin
  DesignerPane.PlaceNewCtrl := not btnSelect.Down;
end;

procedure TReportDesigner.acNewSimpleBandExecute(Sender: TObject);
var
  Ctrl : TControl;
begin
  if CanNewBand then
  begin
    Ctrl := ReportInfo.NewSimpleBand;
    Ctrl.Parent := GetGroupBand;
    AddCtrl(Ctrl);
  end;
end;

procedure TReportDesigner.acNewGroupBandExecute(Sender: TObject);
var
  Ctrl : TControl;
begin
  if CanNewBand then
  begin
    Ctrl := ReportInfo.NewGroupBand;
    Ctrl.Parent := GetGroupBand;
    AddCtrl(Ctrl);
  end;
end;

procedure TReportDesigner.acNewRepeatBandExecute(Sender: TObject);
var
  Ctrl : TControl;
begin
  if CanNewBand then
  begin
    Ctrl := ReportInfo.NewRepeatBand;
    Ctrl.Parent := GetGroupBand;
    AddCtrl(Ctrl);
  end;
end;

procedure TReportDesigner.FileOpenRecordStatusChanged(Sender: TObject);
begin
  if FileOpenRecord.Modified then
    StatusBar.Panels[0].Text := 'Modified' else
  begin
    StatusBar.Panels[0].Text := '';
    ReportInspector.Properties.ClearModified;
  end;
end;

function TReportDesigner.GetModified: Boolean;
begin
  Result := FileOpenRecord.Modified;
end;

procedure TReportDesigner.SetModified(const Value: Boolean);
begin
  FileOpenRecord.Modified := Value;
end;

procedure TReportDesigner.DesignerPaneDelete(DeleteCtrl: TControl);
begin
  Selected := DeleteCtrl;
  ReportInspector.StructView.DeleteAction.Execute;
end;

procedure TReportDesigner.UpdateDesignArea;
var
  PaperWidth, PaperHeight, LeftMargin, TopMargin: Integer;
  Temp : Integer;
begin
  Assert(ReportInfo.Report<>nil);
  PaperWidth := ScreenTransform.Physics2DeviceX(ReportInfo.Report.PaperWidth);
  PaperHeight := ScreenTransform.Physics2DeviceY(ReportInfo.Report.PaperHeight);
  LeftMargin := ScreenTransform.Physics2DeviceX(ReportInfo.Report.Margin.Left);
  TopMargin := ScreenTransform.Physics2DeviceY(ReportInfo.Report.Margin.Top);
  sbDesignArea.HorzScrollBar.Position:=0;
  sbDesignArea.VertScrollBar.Position:=0;
  if ReportInfo.Report.Orientation=poLandscape then
  begin
    Temp := PaperWidth;
    PaperWidth := PaperHeight;
    PaperHeight := Temp;
  end;
  DesignerPane.SetBounds(0,0,PaperWidth,PaperHeight);
  ReportInfo.Report.SetBounds(LeftMargin,TopMargin,ReportInfo.Report.Width,ReportInfo.Report.Height);
end;

procedure TReportDesigner.FileOpenRecordAfterFileOperate(Sender: TObject);
begin
  UpdateDesignArea;
  AfterFileOperation;
end;

procedure TReportDesigner.FormActivate(Sender: TObject);
begin
  UpdateDesignArea;
end;

procedure TReportDesigner.miFullDesignAreaClick(Sender: TObject);
var
  B : Boolean;
begin
  B := not miFullDesignArea.Checked;
  miFullDesignArea.Checked := B;
  //ToolBar.Visible := not B;
  StatusBar.Visible := not B;
  ReportInspector.Visible := not B;
end;
{
procedure TReportDesigner.BuildHistoryMenu;
var
  i : integer;
  MenuItem : TMenuItem;
begin
  FStateMenus.Clear;
  for i:=0 to FStateData.Count-1 do
  begin
    MenuItem := TMenuItem.Create(Self);
    FStateMenus.Add(MenuItem);
    MenuItem.Caption := FStates[i];
    MenuItem.Tag := I;
    MenuItem.OnClick := DoLoadState;
    miHistory.Add(MenuItem);
  end;
end;
}

procedure TReportDesigner.InstallToolForm(ToolForm: TToolForm);
var
  MenuItem : TMenuItem;
  X , Y : Integer;
begin
  ToolForm.ReportInfo := ReportInfo;
  FToolForms.Add(ToolForm);
  Y := FStartY;
  Inc(FStartY,ToolForm.Height);
  if FStartY+BottomMargin>Screen.Height then
    FStartY := StartTop;
  X := Screen.Width - RightMargin -  ToolForm.Width;
  ToolForm.SetBounds(X,Y,ToolForm.Width,ToolForm.Height);
  MenuItem := TMenuItem.Create(Self);
  MenuItem.Caption := ToolForm.Caption;
  MenuItem.ShortCut := TextToShortCut(ToolForm.Hint);
  MenuItem.Tag := FToolForms.Count-1;
  MenuItem.OnClick := ShowToolForm;
  miView.Add(MenuItem);
end;

procedure TReportDesigner.ShowToolForm(Sender: TObject);
begin
  Assert(Sender is TMenuItem);
  TForm(FToolForms[TMenuItem(Sender).Tag]).Show;
end;

procedure TReportDesigner.AfterLoad;
var
  i : integer;
begin
  ReportInfo.Name := '';
  for i:=0 to FToolForms.Count-1 do
    TToolForm(FToolForms[i]).AfterLoad;
end;

procedure TReportDesigner.BeforeLoad;
var
  i : integer;
begin
  for i:=0 to FToolForms.Count-1 do
    TToolForm(FToolForms[i]).BeforeLoad;
end;

procedure TReportDesigner.AfterFileOperation;
var
  i : integer;
begin
  for i:=0 to FToolForms.Count-1 do
    TToolForm(FToolForms[i]).AfterFileOperation;
end;

procedure TReportDesigner.Changed(Obj: TObject);
var
  i : integer;
begin
  for i:=0 to FToolForms.Count-1 do
    TToolForm(FToolForms[i]).Changed(Obj);
end;


procedure TReportDesigner.AddObject(Obj: TObject);
var
  i : integer;
begin
  if FToolForms<>nil then
    for i:=0 to FToolForms.Count-1 do
      TToolForm(FToolForms[i]).Add(Obj);
end;


procedure TReportDesigner.ValidateRename(AComponent: TComponent;
  const CurName, NewName: string);
begin
  inherited;
  {
  if (AComponent is TReportInfo) and (CurName<>NewName) and (NewName<>'') then
    Abort;
  }
end;

procedure TReportDesigner.RefreshTools;
var
  I : integer;
begin
  if FToolForms<>nil then
    for I:=0 to FToolForms.Count-1 do
      TToolForm(FToolForms[I]).RefreshObjects;
end;

procedure TReportDesigner.miOldMethodClick(Sender: TObject);
begin
  miOldMethod.Checked := not miOldMethod.Checked;
  ScreenTransform.InitFromScreen(miOldMethod.Checked);
  ReportInfo.Report.PaperSizeChanged;
  UpdateDesignArea;
end;

procedure TReportDesigner.DesignerPaneCanSizeCtrl(
  Designer: TCustomDesigner; Ctrl: TControl; var CanSized: Boolean);
begin
  CanSized := not (Ctrl is TRDReport);
end;

end.
