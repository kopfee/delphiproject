unit UHistory;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, ImgList, ComCtrls, ToolWin, StdCtrls, Contnrs, RPDesignInfo,
  UToolForm;

type
  TfmHistory = class(TToolForm)
    lsStates: TListBox;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ImageList: TImageList;
    ActionList: TActionList;
    acSaveCurrent: TAction;
    acRestore: TAction;
    acDelete: TAction;
    acClear: TAction;
    ToolButton4: TToolButton;
    procedure   acSaveCurrentExecute(Sender: TObject);
    procedure   FormCreate(Sender: TObject);
    procedure   FormDestroy(Sender: TObject);
    procedure   acClearExecute(Sender: TObject);
    procedure   acDeleteExecute(Sender: TObject);
    procedure   acRestoreExecute(Sender: TObject);
    procedure   ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
  private
    { Private declarations }
    FStateData : TObjectList;
    FHistoryCouting : integer;
  public
    { Public declarations }
    procedure   ClearStates;
    procedure   AfterFileOperation; override;
  end;

var
  fmHistory: TfmHistory;

implementation

uses UMain;

{$R *.DFM}

procedure TfmHistory.FormCreate(Sender: TObject);
begin
  inherited;
  FStateData := TObjectList.Create;
  lsStates.Items.Clear;
  FHistoryCouting := 1;
end;

procedure TfmHistory.FormDestroy(Sender: TObject);
begin
  inherited;
  FStateData.Free;
end;

procedure TfmHistory.ClearStates;
begin
  FHistoryCouting := 1;
  //FStateMenus.Clear;
  FStateData.Clear;
  lsStates.Items.Clear;
end;

procedure TfmHistory.acSaveCurrentExecute(Sender: TObject);
var
  Notes : string;
  MS : TMemoryStream;
begin
  Notes := IntToStr(FHistoryCouting);
  if InputQuery('Save design state','Notes',Notes) then
  begin
    lsStates.Items.Add(Notes);
    MS := TMemoryStream.Create;
    FStateData.Add(MS);
    ReportDesigner.StopDesignning(False);
    ReportInfo.SaveToStream(MS);
    ReportDesigner.StartDesignning;
    //BuildHistoryMenu;
    Inc(FHistoryCouting);
  end;
end;

procedure TfmHistory.acClearExecute(Sender: TObject);
begin
  ClearStates;
end;

procedure TfmHistory.acDeleteExecute(Sender: TObject);
begin
  if lsStates.ItemIndex>=0 then
  begin
    FStateData.Delete(lsStates.ItemIndex);
    lsStates.Items.Delete(lsStates.ItemIndex);
  end;
end;

procedure TfmHistory.acRestoreExecute(Sender: TObject);
var
  Index : Integer;
  MS : TMemoryStream;
begin
  Index := lsStates.ItemIndex;
  if (Index>=0) and (Index<FStateData.Count) then
  begin
    MS := TMemoryStream(FStateData[Index]);
    MS.Position := 0;
    ReportDesigner.StopDesignning;
    try
      ReportInfo.LoadFromStream(MS);
      ReportDesigner.UpdateDesignArea;
    finally
      ReportDesigner.StartDesignning;
    end;
  end;
end;

procedure TfmHistory.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  acDelete.Enabled := lsStates.ItemIndex>=0;
  acRestore.Enabled := acDelete.Enabled;
  acClear.Enabled := FStateData.Count>0;
end;

procedure TfmHistory.AfterFileOperation;
begin
  inherited;
  fmHistory.ClearStates;
end;

end.
