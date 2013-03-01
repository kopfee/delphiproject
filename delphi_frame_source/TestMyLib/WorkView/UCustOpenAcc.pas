unit UCustOpenAcc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, WVCtrls, Mask, WorkViews, WVCmdReq;

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
    Button1: TButton;
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
    WVFieldDomain4: TWVFieldDomain;
    WVFieldDomain5: TWVFieldDomain;
    Label14: TLabel;
    WVLabel1: TWVLabel;
    WVRequest1: TWVRequest;
    procedure Button1Click(Sender: TObject);
    procedure WVFieldDomain5CheckValid(WorkField: TWVField);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FTimeStamp : Integer;
    procedure Reset;
  public
    { Public declarations }
  end;

var
  fmCustOpenAcc: TfmCustOpenAcc;

implementation

uses UContext;

{$R *.DFM}

procedure TfmCustOpenAcc.Button1Click(Sender: TObject);
begin
  WVRequest1.SendCommand;

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
  Reset;
end;

procedure TfmCustOpenAcc.Button2Click(Sender: TObject);
begin
  if FTimeStamp=WorkView1.TimeStamp then
    Close else
    Reset;
end;

procedure TfmCustOpenAcc.Reset;
begin
  WorkView1.Reset;
  FTimeStamp := WorkView1.TimeStamp;
  SelectFirst;
end;

end.
