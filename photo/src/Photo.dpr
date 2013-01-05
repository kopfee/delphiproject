program Photo;

uses
    Forms,
    SysUtils,
    mainUnit in 'mainUnit.pas' {frmMain},
    uCardPrintTemp_W in 'uCardPrintTemp_W.pas' {frmCardPrintTemp_W},
    Udm in 'Udm.pas' {frmdm: TDataModule},
    AES in 'AES.pas',
    ElAES in 'ElAES.pas',
    uCommon in 'uCommon.pas',
    uImport in 'uImport.pas' {frmImport},
    phtIfRepalce in 'phtIfRepalce.pas' {frmIfRepalce},
    uExport in 'uExport.pas' {frmExport},
    uAddCustInfo in 'uAddCustInfo.pas' {frmAddCustInfo},
    uPhotoStat in 'uPhotoStat.pas' {frmPhotoStat},
    uAbout in 'uAbout.pas' {frmAbout},
    uLimit in 'uLimit.pas' {frmLimit},
    Ulogin in 'Ulogin.pas' {loginForm},
    uPatchMakeCard in 'uPatchMakeCard.pas' {frmPatchMakeCard},
    //PSCAMLIB in 'PSCAMLIB.PAS',
    uModifyPwd in 'uModifyPwd.pas' {frmModifyPwd},
    uCustImport in 'uCustImport.pas' {frmCustImport},
    uGetPhotoSet in 'uGetPhotoSet.pas' {frmGetPhotoSet},
    uPhotoQuery in 'uPhotoQuery.pas' {frmPhotoQuery},
    uCardPrintTemp in 'uCardPrintTemp.pas' {frmCardPrintTemp},
    TConfiguratorUnit in 'TConfiguratorUnit',
    TConsoleUnit in 'TConsoleUnit',
    uConst in 'uConst.pas',
    uRunOnce in 'uRunOnce.pas';

{$R *.res}

begin
    Application.Initialize;
    TConfiguratorUnit.doPropertiesConfiguration(ExtractFilePath(Application.ExeName) + '..\config\log4delphi.properties');
    Application.Title := '校园通系统--制卡中心';
    if not AppHasRun(Application.Handle) then begin
        Application.CreateForm(TfrmMain, frmMain);
        Application.CreateForm(Tfrmdm, frmdm);
        Application.CreateForm(TfrmIfRepalce, frmIfRepalce);
        Application.CreateForm(TloginForm, loginForm);
        Application.CreateForm(TfrmPhotoQuery, frmPhotoQuery);
        Application.CreateForm(TTConsole, TConsole);
        Application.CreateForm(TfrmCardPrintTemp, frmCardPrintTemp);
    end;
    Application.Run;
end.

