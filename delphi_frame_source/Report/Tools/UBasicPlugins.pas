unit UBasicPlugins;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UPlugin, ActnList;

type
  TRDSBasicPlugIns = class(TRDSPlugIn)
    acAdjustCtrls: TAction;
    acLinkCtrls: TAction;
    acLinkColumns: TAction;
    acCopyChildren: TAction;
    acAddToSelection: TAction;
    acDeleteFromSelection: TAction;
    acClearSelection: TAction;
    acSelectChildren: TAction;
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure acAdjustCtrlsExecute(Sender: TObject);
    procedure acLinkCtrlsExecute(Sender: TObject);
    procedure acLinkColumnsExecute(Sender: TObject);
    procedure acCopyChildrenExecute(Sender: TObject);
    procedure acAddToSelectionExecute(Sender: TObject);
    procedure acDeleteFromSelectionExecute(Sender: TObject);
    procedure acClearSelectionExecute(Sender: TObject);
    procedure acSelectChildrenExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RDSBasicPlugIns: TRDSBasicPlugIns;

implementation

uses UReportInspector, RPCtrls, UAdjustCtrls, ULinkCtrls, ULinkColumns,
  UCopyChildren, UTools;

{$R *.DFM}

procedure TRDSBasicPlugIns.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  inherited;
  Assert(ReportInspector<>nil);
  Handled := True;
  acAdjustCtrls.Enabled := (ReportInspector.Selected is TRDSimpleBand);
  acLinkCtrls.Enabled := acAdjustCtrls.Enabled;
  acCopyChildren.Enabled := (ReportInspector.Selected is TWinControl);
end;

procedure TRDSBasicPlugIns.acAdjustCtrlsExecute(Sender: TObject);
begin
  inherited;
  Assert(ReportInspector<>nil);
  Assert(ReportInspector.Selected is TRDSimpleBand);
  Assert(dlgAdjustCtrls<>nil);
  if dlgAdjustCtrls.Execute(TRDSimpleBand(ReportInspector.Selected)) then
  begin
    ReportInspector.Modified;
  end;
end;

procedure TRDSBasicPlugIns.acLinkCtrlsExecute(Sender: TObject);
begin
  inherited;
  Assert(ReportInspector<>nil);
  Assert(ReportInspector.Selected is TRDSimpleBand);
  Assert(dlgLinkCtrls<>nil);
  if dlgLinkCtrls.Execute(TRDSimpleBand(ReportInspector.Selected)) then
  begin
    ReportInspector.Modified;
  end;
end;

procedure TRDSBasicPlugIns.acLinkColumnsExecute(Sender: TObject);
begin
  Assert(ReportInspector<>nil);
  Assert(ReportInspector.Report<>nil);
  if LinkColumns(ReportInspector.Report) then
    ReportInspector.Modified;
end;

procedure TRDSBasicPlugIns.acCopyChildrenExecute(Sender: TObject);
begin
  Assert(ReportInspector<>nil);
  Assert(ReportInspector.Report<>nil);
  if ReportInspector.Selected is TWinControl then
    CopyChildren(TWinControl(ReportInspector.Selected));
end;

procedure TRDSBasicPlugIns.acAddToSelectionExecute(Sender: TObject);
begin
  inherited;
  if DesignSelection<>nil then
    DesignSelection.AddSelected;
end;

procedure TRDSBasicPlugIns.acDeleteFromSelectionExecute(Sender: TObject);
begin
  inherited;
  if DesignSelection<>nil then
    DesignSelection.RemoveSelected;
end;

procedure TRDSBasicPlugIns.acClearSelectionExecute(Sender: TObject);
begin
  inherited;
  if DesignSelection<>nil then
    DesignSelection.ClearSelection;
end;

procedure TRDSBasicPlugIns.acSelectChildrenExecute(Sender: TObject);
var
  I : Integer;
  Band : TWinControl;
begin
  inherited;
  if (DesignSelection<>nil) and (ReportInspector.Selected is TRDSimpleBand) then
  begin
    Band := TWinControl(ReportInspector.Selected);
    for I:=0 to Band.ControlCount-1 do
    begin
      DesignSelection.AddSelectedComponent(Band.Controls[I]);
    end;
  end;
end;

end.
