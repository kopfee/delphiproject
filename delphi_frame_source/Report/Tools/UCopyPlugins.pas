unit UCopyPlugins;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UPlugin, ImgList, ActnList;

type
  TRDSCopyPlugIns = class(TRDSPlugIn)
    ImageList: TImageList;
    acEditCopy: TAction;
    acEditPaste: TAction;
    procedure   acEditCopyExecute(Sender: TObject);
    procedure   acEditPasteExecute(Sender: TObject);
    procedure   ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
  private
    procedure ReadComponent(Component: TComponent);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RDSCopyPlugIns: TRDSCopyPlugIns;

implementation

uses UReportInspector, CompUtils, RPCtrls;

{$R *.DFM}

procedure TRDSCopyPlugIns.acEditCopyExecute(Sender: TObject);
var
  List : TList;
  S : string;
begin
  S := Sender.ClassName;
  OutputDebugString(Pchar(S));
  if (ReportInspector.Selected is TComponent)
    and (ReportInspector.Selected<>ReportInspector.Root)
    and (ReportInspector.Selected<>ReportInspector.Report) then
  begin
    List := TList.Create;
    List.Add(ReportInspector.Selected);
    try
      CopyComponents(TComponent(ReportInspector.Root),List);
    finally
      List.Free;
    end;
  end;
end;

procedure TRDSCopyPlugIns.acEditPasteExecute(Sender: TObject);
var
  Handler : TReadEventHandler;
begin
  Handler := TReadEventHandler.Create;
  try
    Handler.Owner := TComponent(ReportInspector.Root);
    if ReportInspector.Selected is TWinControl then
      Handler.Parent := TComponent(ReportInspector.Selected) else
      Handler.Parent := ReportInspector.Report;
    PasteComponents(Handler,ReadComponent);
    ReportInspector.RefreshTools;
  finally
    Handler.Free;
  end;
end;

procedure TRDSCopyPlugIns.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  inherited;
  Handled:=True;
  acEditCopy.Enabled := (ReportInspector.Selected is TComponent)
    and (ReportInspector.Selected<>ReportInspector.Root)
    and (ReportInspector.Selected<>ReportInspector.Report);
end;

procedure TRDSCopyPlugIns.ReadComponent(Component: TComponent);
begin
  ReportInspector.AddObject(Component);
  if Component is TRDCustomBand then
  begin
    if TRDCustomBand(Component).ParentBand<>nil then
      TRDCustomBand(Component).BandIndex := TRDCustomBand(Component).ParentBand.Children.Count;
  end;
end;


end.
