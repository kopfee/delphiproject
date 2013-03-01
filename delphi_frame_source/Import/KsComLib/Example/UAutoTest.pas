unit UAutoTest;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, BDAImpEx, KCDataAccess, DBAIntf, StdCtrls, Grids, DBGrids, ExtCtrls,
  DBCtrls, ComCtrls, Spin;

type
  TForm1 = class(TForm)
    KCDatabase: TKCDatabase;
    KCDataset: TKCDataset;
    DataSource1: TDataSource;
    OpenDialog1: TOpenDialog;
    pcPages: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    btnTest: TButton;
    edIP: TEdit;
    edPort: TEdit;
    edDestNo: TEdit;
    edFuncNo: TEdit;
    btnConnect: TButton;
    btnOpenConfig: TButton;
    mmInfo: TMemo;
    Label5: TLabel;
    lbReturn: TLabel;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    ckIsCallback: TCheckBox;
    Label6: TLabel;
    edDelaySeconds: TSpinEdit;
    Label7: TLabel;
    edPrior: TEdit;
    btnTest100: TButton;
    btnRecNo: TButton;
    ckTestError: TCheckBox;
    procedure btnTestClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnOpenConfigClick(Sender: TObject);
    procedure KCDatabaseWait(Sender: TObject; var ContinueWait: Boolean);
    procedure KCDatabaseBeforeReceive(Sender: TObject);
    procedure KCDatabaseAfterReceive(Sender: TObject);
    procedure ckIsCallbackClick(Sender: TObject);
    procedure btnTest100Click(Sender: TObject);
    procedure btnRecNoClick(Sender: TObject);
    procedure ckTestErrorClick(Sender: TObject);
  private
    { Private declarations }
    procedure OpenConfig(const FileName:string);
    procedure ClearInfo;
    procedure AddInfo(const S:string);
    procedure ShowData;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses LogFile, IniFiles, KCDataPack, ProgressShowing;

{$R *.DFM}

const
  ServerSec = 'Server';
  InputSec = 'Input';


procedure TForm1.btnConnectClick(Sender: TObject);
begin
  KCDatabase.Connected := False;
  btnTest.Enabled := False;
  KCDatabase.Connected := True;
  btnTest.Enabled := True;
end;

procedure TForm1.btnTestClick(Sender: TObject);
begin
  KCDataset.Close;
  try
    KCDataset.Open;
  except
    on EDBNoDataset do ;
  end;
  lbReturn.Caption := IntToStr(KCDataset.ReturnCode);
  pcPages.ActivePageIndex := 1;
end;

procedure TForm1.btnOpenConfigClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    ClearInfo;
    OpenConfig(OpenDialog1.FileName);
    ShowData;
    btnConnect.Enabled := True;
  end;
end;


procedure TForm1.OpenConfig(const FileName: string);
var
  IniFile : TIniFile;
  Count, I : Integer;
  Sec : string;
  ParamName : string;
  ParamValue : string;
  ParamIndex : Integer;
  Param : THRPCParam;
begin
  IniFile := TIniFile.Create(FileName);
  try
    // server
    KCDatabase.GatewayIP := IniFile.ReadString(ServerSec,'IP',KCDatabase.GatewayIP);
    KCDatabase.GatewayPort := IniFile.ReadInteger(ServerSec,'Port',KCDatabase.GatewayPort);
    KCDatabase.DestNo := IniFile.ReadInteger(ServerSec,'DestNo',KCDatabase.DestNo);
    KCDatabase.FuncNo := IniFile.ReadInteger(ServerSec,'FuncNo',KCDatabase.FuncNo);
    KCDatabase.Priority := IniFile.ReadInteger(ServerSec,'Priority',KCDatabase.Priority);

    KCDataset.RequestType := IniFile.ReadInteger(InputSec,'RequestType',KCDataset.RequestType);
    KCDataset.Params.Clear;
    Count := IniFile.ReadInteger(InputSec,'Count',0);
    for I:=1 to Count do
    begin
      Sec := 'I'+IntToStr(I);
      ParamName := IniFile.ReadString(Sec,'Name','');
      ParamValue := IniFile.ReadString(Sec,'Value','');
      ParamIndex := KCFindParam(ParamName);
      if ParamIndex<0 then
        AddInfo('Error , cannot bind param:'+ParamName)
      else if KCDataset.Params.paramByName(ParamName)<>nil then
        AddInfo('Error , duplicated param:'+ParamName)
      else
      begin
        Param := KCDataset.Params.Add;
        Param.Name := ParamName;
        case KCPackDataTypes[ParamIndex] of
          kcChar,kcVarChar,kcBit :  begin
                      Param.DataType := ftChar;
                      Param.AsString := ParamValue;
                    end;
          KCInteger:begin
                      Param.DataType := ftInteger;
                      Param.AsInteger := StrToInt(ParamValue);
                    end;
          KCFloat:  begin
                      Param.DataType := ftFloat;
                      Param.AsFloat := StrToFloat(ParamValue);
                    end;
        end;
      end;
    end;
    //KCDatabase.Connected := True;
  finally
    IniFile.Free;
  end;
end;

procedure TForm1.AddInfo(const S: string);
begin
  mmInfo.Lines.Add(S);
end;

procedure TForm1.ClearInfo;
begin
  mmInfo.Lines.Clear;
end;

procedure TForm1.ShowData;
var
  I : Integer;
begin
  edIP.Text := KCDatabase.GatewayIP;
  edPort.Text := IntToStr(KCDatabase.GatewayPort);
  edDestNo.Text := IntToStr(KCDatabase.DestNo);
  edFuncNo.Text := IntToStr(KCDatabase.FuncNo);
  edPrior.Text := IntToStr(KCDatabase.Priority);
  AddInfo('Request='+IntToStr(KCDataset.RequestType));
  for I:=0 to KCDataset.Params.Count-1 do
  begin
    AddInfo(KCDataset.Params[I].Name+'='+KCDataset.Params[I].AsString);
  end;
end;

procedure TForm1.KCDatabaseWait(Sender: TObject;
  var ContinueWait: Boolean);
begin
  UpdateProgress;
  if IsProgressCanceled then
    ContinueWait := False;
end;

procedure TForm1.KCDatabaseBeforeReceive(Sender: TObject);
begin
  ShowProgress('正在访问数据源...',True,'','',edDelaySeconds.Value);
end;

procedure TForm1.KCDatabaseAfterReceive(Sender: TObject);
begin
  CloseProgress;
end;

procedure TForm1.ckIsCallbackClick(Sender: TObject);
begin
  KCDatabase.IsCallback := ckIsCallback.Checked;
end;

procedure TForm1.btnTest100Click(Sender: TObject);
var
  I : Integer;
  Count,ErrorCount : Integer;
  Saved : Boolean;
  SavedLogCatalogs : TLogCatalogs;
  Time1,Time2 : Integer;
  SavedTimeOut : Integer;
begin
  Time1 := GetTickCount;
  SavedLogCatalogs := LogCatalogs;
  LogCatalogs := [];
  Saved := KCDatabase.IsCallback;
  KCDatabase.IsCallback := False;
  SavedTimeOut := KCDatabase.TimeOut;
  KCDatabase.TimeOut := 10*1000;
  Count := 0;
  ErrorCount := 0;
  for I:=1 to 100 do
  begin
    KCDataset.Close;
    try
      KCDataset.Open;
      Inc(Count);
    except
      Inc(ErrorCount);
    end;
  end;
  KCDatabase.IsCallback := Saved;
  KCDatabase.TimeOut := SavedTimeOut;
  LogCatalogs := SavedLogCatalogs;
  Time2 := GetTickCount;

  ShowMessage(Format('Count=%d,ErrorCount=%d,Time=%d',[Count,ErrorCount,(Time2-Time1) div 1000]));
end;

procedure TForm1.btnRecNoClick(Sender: TObject);
var
  RecNo : Integer;
begin
  if KCDataset.Active then
  begin
    RecNo := KCDataset.RecNo;
    ShowMessage(Format('RecNo=%d',[RecNo]));
    KCDataset.RecNo := RecNo;
  end;
end;

procedure TForm1.ckTestErrorClick(Sender: TObject);
begin
  {$ifdef TestPackError }
  TestPackError := ckTestError.Checked;
  {$endif}
end;

initialization
  if not FindCmdLineSwitch('nolog',['-','\','/'],False) then
    OpenLogFile('',False,True);
  isOutputDebugString := False;
  Exclude(LogCatalogs,lcKCPackDetail);
  //Exclude(LogCatalogs,lcKCPack);
  WriteLog('Size Of Cookie='+IntToStr(SizeOf(TSTCookie)));
  InstallDefaultProgressShower;

end.
