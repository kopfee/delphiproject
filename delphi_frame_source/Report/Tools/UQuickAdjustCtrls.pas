unit UQuickAdjustCtrls;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UToolForm, StdCtrls, Buttons, UAdjustCtrlFrame;

type
  TfmQuickAdjustCtrls = class(TToolForm)
    AdjustCtrlsFrame: TfaAdjustCtrls;
    btnApply: TBitBtn;
    btnClear: TBitBtn;
    btnReadCtrlParams: TBitBtn;
    procedure btnApplyClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnReadCtrlParamsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmQuickAdjustCtrls: TfmQuickAdjustCtrls;

implementation

{$R *.DFM}

uses UTools, UReportInspector, RPCtrls;

procedure TfmQuickAdjustCtrls.btnApplyClick(Sender: TObject);
begin
  inherited;
  AdjustCtrlsFrame.UpdateSelectedCtrls(DesignSelection);
end;

procedure TfmQuickAdjustCtrls.btnClearClick(Sender: TObject);
begin
  inherited;
  AdjustCtrlsFrame.ClearCheckBox;
end;

procedure TfmQuickAdjustCtrls.btnReadCtrlParamsClick(Sender: TObject);
begin
  inherited;
  if ReportInspector.Selected is TRDCustomControl then
    AdjustCtrlsFrame.ReadCtrlParams(TRDCustomControl(ReportInspector.Selected));
end;

end.
