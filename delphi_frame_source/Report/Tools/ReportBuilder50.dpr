program ReportBuilder50;

uses
  Forms,
  UMain in 'UMain.pas' {ReportDesigner},
  RTObjInspector in '..\..\MyLib\RTObjInspector.pas' {ObjectInspector: TFrame},
  UReportInspector in 'UReportInspector.pas' {ReportInspector: TFrame},
  UPlugin in 'UPlugin.pas' {RDSPlugIn: TDataModule},
  UBasicPlugins in 'UBasicPlugins.pas' {RDSBasicPlugIns: TDataModule},
  UAdjustCtrls in 'UAdjustCtrls.pas' {dlgAdjustCtrls},
  ULinkCtrls in 'ULinkCtrls.pas' {dlgLinkCtrls},
  ULinkColumns in 'ULinkColumns.pas' {dlgLinkColumns},
  UCopyChildren in 'UCopyChildren.pas' {dlgCopyChildren},
  UHistory in 'UHistory.pas' {fmHistory},
  UDataBindings in 'UDataBindings.pas' {fmDataBindings},
  UToolForm in 'UToolForm.pas' {ToolForm},
  UCopyPlugins in 'UCopyPlugins.pas' {RDSCopyPlugIns: TDataModule},
  ZPEdits in '..\..\Import\zproplst\ZPEdits.pas',
  UTools in 'UTools.pas',
  USelection in 'USelection.pas' {fmSelection},
  UImages in 'UImages.pas' {dmImages: TDataModule},
  UQuickLinkCtrls in 'UQuickLinkCtrls.pas' {fmQuickLinkCtrls},
  UAdjustCtrlFrame in 'UAdjustCtrlFrame.pas' {faAdjustCtrls: TFrame},
  UQuickAdjustCtrls in 'UQuickAdjustCtrls.pas' {fmQuickAdjustCtrls};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TdmImages, dmImages);
  Application.CreateForm(TRDSBasicPlugIns, RDSBasicPlugIns);
  Application.CreateForm(TRDSCopyPlugIns, RDSCopyPlugIns);
  Application.CreateForm(TReportDesigner, ReportDesigner);
  Application.CreateForm(TdlgAdjustCtrls, dlgAdjustCtrls);
  Application.CreateForm(TdlgLinkCtrls, dlgLinkCtrls);
  Application.CreateForm(TfmSelection, fmSelection);
  Application.CreateForm(TfmQuickAdjustCtrls, fmQuickAdjustCtrls);
  Application.CreateForm(TfmQuickLinkCtrls, fmQuickLinkCtrls);
  Application.CreateForm(TfmDataBindings, fmDataBindings);
  Application.CreateForm(TfmHistory, fmHistory);
  Application.Run;
end.
