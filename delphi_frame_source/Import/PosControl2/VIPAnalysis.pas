unit VIPAnalysis;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,
  BASE1,
  Secu_Interface, globalparams, TeEngine, Series, TeeProcs, Chart, DBChart,
  Grids, DBGrids, Mask;

type
  TVIPAnalysisForm = class(TBase1Form)
    PanelTitle: TPanel;
    Image1: TImage;
    BitBtnClose: TBitBtn;
    Label1: TLabel;
    startdate: TMaskEdit;
    Label2: TLabel;
    enddate: TMaskEdit;
    RadioGroup1: TRadioGroup;
    DBGridDt: TDBGrid;
    DBChart1: TDBChart;
    Series1: TPieSeries;
    Series2: TPieSeries;
    BitBtn10: TBitBtn;
    BitBtn13: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BitBtnCloseClick(Sender: TObject);
  private
    { Private declarations }
    MdSecuGradeInfo: TMdSecuGrade;
  public
    { Public declarations }
    procedure enter(InstID: Integer; Mid: Integer; Info: string);override;
  end;

var
  VIPAnalysisForm: TVIPAnalysisForm;

implementation

{$R *.DFM}
//=================================================================
procedure TVIPAnalysisForm.enter(InstID: Integer; Mid: Integer; Info: string);
begin  {调用本FORM的config}
if (GP_HIDEFORMTITLE) then
  begin
    Caption:=PanelTitle.Caption;
    PanelTitle.Hide;
  end
else
  begin
    Caption:='';
    PanelTitle.Visible:=true;
  end;
//取得当前用户在本模块的权限信息。
//GetCurrentMdGrade(Mid, MdSecuGradeInfo);
//如果计算表明当前用户在本模块没有安全权限信息的话... ...
//if not(MdSecuGradeInfo.recordexist) then ... ...
//对本模块的按钮进行自动配置。
//ButtonConfigure(Mid, Base2Form);}
//向中央数据库登记本进程的当前位置或状况。
//DenotePosition('进入模块xxx');
//调用本模块的Config

showmodal;

//向中央数据库登记本进程的当前位置或状况。
//DenotePosition('进入主界面');
end;
//-----------------------------------------------------------------
procedure TVIPAnalysisForm.FormCreate(Sender: TObject);
begin
  inherited;
  MdSecuGradeInfo:=TMdSecuGrade.Create;

//把模块号写入Form抬头
  {Caption:=Caption+'--'+ModuleName;}
end;
//-----------------------------------------------------------------
procedure TVIPAnalysisForm.FormDestroy(Sender: TObject);
begin
  inherited;
  MdSecuGradeInfo.Free;
end;
//-----------------------------------------------------------------
procedure TVIPAnalysisForm.BitBtnCloseClick(Sender: TObject);
begin
  inherited;
  Close;  // FORM.
end;






end.
