unit UCustOpenAcc2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, WVCtrls, Mask, WorkViews, WVCmdReq, WVCommands;

type
  TfmCustOpenAcc = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    btnOk: TButton;
    Button2: TButton;
    Edit1: TWVEdit;
    Edit3: TWVEdit;
    Edit4: TWVEdit;
    Edit5: TWVEdit;
    Edit7: TWVEdit;
    Edit10: TWVEdit;
    Edit11: TWVEdit;
    Edit12: TWVEdit;
    Edit13: TWVEdit;
    Edit14: TWVEdit;
    Edit6: TWVEdit;
    Edit15: TWVEdit;
    ComboBox1: TWVComboBox;
    ComboBox2: TWVComboBox;
    ComboBox3: TWVComboBox;
    WorkView1: TWorkView;
    WVFieldDomain1: TWVFieldDomain;
    WVFieldDomain5: TWVFieldDomain;
    Label14: TLabel;
    WVLabel1: TWVLabel;
    WVRequest1: TWVRequest;
    WVRequest2: TWVRequest;
    procedure btnOkClick(Sender: TObject);
    procedure WVFieldDomain5CheckValid(WorkField: TWVField);
    procedure FormCreate(Sender: TObject);
    procedure WorkView1FieldsMonitors0ValidChanged(Sender: TWVFieldMonitor;
      Valid: Boolean);
    procedure WVRequest2AfterExec(Request: TWVRequest;
      Command: TWVCommand);
    procedure CheckCustNo(WorkField: TWVField);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmCustOpenAcc: TfmCustOpenAcc;

implementation

uses UContext2, DataTypes;

{$R *.DFM}

procedure TfmCustOpenAcc.btnOkClick(Sender: TObject);
var
  Data : TKSDataObject;
begin
  WVRequest1.SendCommand;
  Data := WorkView1.FieldByName('返回标志').Data;
  if Data.AsInteger=0 then
  begin
    ShowMessage('成功');
    WorkView1.Reset;
  end else
  begin
    ShowMessage('失败');
  end;
end;

procedure TfmCustOpenAcc.WVFieldDomain5CheckValid(WorkField: TWVField);
var
  CheckedFieldName : string;
  CheckedField : TWVField;
begin
  CheckedFieldName := WorkField.MonitorValueChangedFields;
  CheckedFieldName := StringReplace(CheckedFieldName,'|','',[rfReplaceAll]);
  CheckedField := WorkField.WorkView.FieldByName(CheckedFieldName);
  if CheckedField<>nil then
    WorkField.Valid := CheckedField.Valid and (WorkField.Data.AsString = CheckedField.Data.AsString);
end;

procedure TfmCustOpenAcc.FormCreate(Sender: TObject);
begin
  WVRequest1.Context := dmContext.Context;
  WVRequest2.Context := dmContext.Context;
end;

procedure TfmCustOpenAcc.WorkView1FieldsMonitors0ValidChanged(
  Sender: TWVFieldMonitor; Valid: Boolean);
begin
  btnOk.Enabled := Valid;
end;

procedure TfmCustOpenAcc.WVRequest2AfterExec(Request: TWVRequest;
  Command: TWVCommand);
begin
  WorkView1.FieldByName('客户号').Valid := Command.ParamData('存在').AsString='0';
end;

procedure TfmCustOpenAcc.CheckCustNo(
  WorkField: TWVField);
begin
  if WVRequest2.Context<>nil then
    if not WorkField.Data.IsEmpty then
    begin
      WVRequest2.SendCommand;
      Exit;
    end;
  WorkField.Valid := False;
end;

end.
