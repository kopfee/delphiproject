unit UCustInfoQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DB, ADODB,IniFiles, DBCtrls, DBGridEh, Mask,
  DBCtrlsEh, DBLookupEh, Grids, DBGrids,jpeg;

type
  TfrmCustInfoQuery = class(TForm)
    pnl1: TPanel;
    pnl2: TPanel;
    lbl1: TLabel;
    lbl2: TLabel;
    edtStuempNo: TEdit;
    edtName: TEdit;
    lbl3: TLabel;
    btnQuery: TButton;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    lbl10: TLabel;
    qryQuery: TADOQuery;
    cbbArea: TDBLookupComboboxEh;
    dsQuery: TDataSource;
    qryArea: TADOQuery;
    dsArea: TDataSource;
    lblCustNo: TLabel;
    lblstuempNo: TLabel;
    lblCustName: TLabel;
    lblCardNo: TLabel;
    lblCustType: TLabel;
    lblDept: TLabel;
    lblSpec: TLabel;
    pnlPhoto: TPanel;
    imgPhoto: TImage;
    lbl11: TLabel;
    edtCardNo: TEdit;
    btnClear: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCustInfoQuery: TfrmCustInfoQuery;

implementation

uses uCommon, Udm;

{$R *.dfm}

procedure TfrmCustInfoQuery.FormCreate(Sender: TObject);
begin
  apppath := ExtractFilePath(Application.ExeName);
  getphotoconfigs;

end;

procedure TfrmCustInfoQuery.btnQueryClick(Sender: TObject);
var
  queryIni:TIniFile;
  sqlStr:string;
  Fjpg: TJpegImage;
begin
  queryIni := nil;
  Fjpg:=nil;
  imgPhoto.Picture.Graphic:=nil;
  if FileExists(apppath+'photoquery.ini') = false then
  begin
    Application.MessageBox('系统配置文件已经被破坏，请与系统管理员联系！',
      '系统错误！', mb_ok + mb_iconerror);
    Application.Terminate;
  end;
  try
    queryIni := TIniFile.Create(apppath+'photoquery.ini');
    sqlStr := queryIni.ReadString('photoquery','photoquerysql','');
  finally
    queryIni.Destroy;
  end;

  if trim(edtStuEmpNo.Text)<>'' then
    sqlStr:=sqlStr+' and cust.'+stuempNo+'='+#39+trim(edtStuEmpNo.Text)+#39;
  if trim(edtName.Text)<>'' then
    sqlStr:=sqlStr+' and cust.'+custName+' ='+#39+trim(edtname.Text)+#39;
  if cbbArea.Text<>'' then
    sqlStr:=sqlStr+' and cust.'+custArea+'='+inttostr(cbbArea.KeyValue);
  if trim(edtCardNo.Text)<>'' then
    sqlStr := sqlStr + ' and cust.'+custCardId+'='+#39+trim(edtCardNo.Text)+#39;
  qryQuery.Close;
  qryQuery.SQL.Clear;
  qryQuery.SQL.Add(sqlStr);
  qryQuery.Prepared;
  //qryQuery.SQL.SaveToFile('11111.txt');
  qryQuery.Open;
  if (qryQuery.IsEmpty) then
  begin
    ShowMessage('没有你指定条件的数据，请重新选择统计条件！');
    Exit;
  end;
  if ((qryQuery.RecordCount>1)) then
  begin
    ShowMessage('你查询出的记录不只一条，请使用身份证号或学/工号查询！');
    Exit;
  end;
  try
    Fjpg := TJpegImage.Create;
    lblCustNo.Caption:=qryQuery.fieldbyname(custId).AsString;
    lblCustName.Caption:=qryQuery.fieldbyname(custName).AsString;
    lblStuEmpNo.Caption:=qryQuery.fieldbyname(stuempNo).AsString;

      
    lblCustType.Caption:=getTypeName(qryQuery.fieldbyname(custType).AsString);
    lblDept.Caption:=getDeptName(qryQuery.fieldbyname(custDeptNo).AsString);
    lblSpec.Caption:=getSName(qryQuery.fieldbyname(custSpecNo).AsString);

    lblCardNo.Caption:=qryQuery.fieldbyname(custCardId).AsString;

    //queryPhoto(qryQuery.fieldbyname(custId).AsString);

    Fjpg := getPhotoInfo(qryQuery.fieldbyname(custId).AsString);
    if Fjpg=nil then
      pnlphoto.Caption := '没有照片'
    else
      imgPhoto.Picture.Graphic:=Fjpg;

  finally
    fjpg.Destroy;
  end;
end;

procedure TfrmCustInfoQuery.FormShow(Sender: TObject);
var
  deptSql:string;
  specSql:string;
  typeSql:string;
  areaSql:string;
begin
  getFillQuerySql(deptSql,specSql,typeSql,areaSql);

  qryArea.Close;
  qryArea.SQL.Clear;
  qryArea.SQL.Add(areaSql);
  qryArea.Open;
  cbbArea.ListField:=areaName;
  cbbArea.KeyField:=areaNo;

end;

procedure TfrmCustInfoQuery.btnClearClick(Sender: TObject);
var
  i:Integer;
begin
  edtCardNo.Text := '';
  edtStuempNo.Text := '';
  edtName.Text := '';
  imgPhoto.Picture.Graphic := nil;
  for i := 0 to pnl2.ControlCount-1 do
  begin
    if pnl2.Controls[i] is TLabel then
      if pnl2.Controls[i].Tag=9 then
        TLabel(pnl2.Controls[i]).Caption := '';
  end;
end;

end.
