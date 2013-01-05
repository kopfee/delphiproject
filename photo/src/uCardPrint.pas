unit uCardPrint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, QuickRpt, QRCtrls, jpeg,inifiles,ADODB,
  Printers;

type
  TfrmCardPrint = class(TForm)
    pnlTop: TPanel;
    lblStuempNo: TLabel;
    edtStuEmpNo: TEdit;
    btnQuery: TBitBtn;
    btnPrint: TBitBtn;
    Label11: TLabel;
    cbbArea: TComboBox;
    Label1: TLabel;
    edtCustNo: TEdit;
    lblIfCard: TLabel;
    qckrpPrint: TQuickRep;
    qrbndDetailBand1: TQRBand;
    imgPhoto: TQRImage;
    qrlblNo: TQRLabel;
    qrlblName: TQRLabel;
    qrlblDept: TQRLabel;
    qrlblSpec: TQRLabel;
    qrlblType: TQRLabel;
    btnExit: TBitBtn;
    qrlblidCard: TQRLabel;
    qrlblCardNo: TQRLabel;
    qrlblClassNo: TQRLabel;
    procedure btnPrintClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
  private
    { Private declarations }
    pageOrien:string;
    pageWidth:Real;
    pageHeight:Real;
    
    photoWidth:real;
    photoHeight:real;
    photoTop:real;
    photoLeft:real;

    fontSize : integer;
    fontName : String;
    fontBold : String;
    fontWidth : real;
    fontHeight : real;

    NoVisible : boolean;
    NoTop : real;
    NoLeft : real;

    nameVisible : boolean;
    nameTop : real;
    nameLeft : real;

    typeVisible : boolean;
    typeTop : real;
    typeLeft : real;

    deptVisible : boolean;
    deptTop : real;
    deptLeft : real;

    specVisible : boolean;
    specTop : real;
    specLeft : real;

    idCardVisible : Boolean;
    idCardTop : Real;
    idCardLeft : Real;

    cardNoVisible : Boolean;
    cardNoTop : Real;
    cardNoLeft : Real;

    classNoVisible : Boolean;
    classNoTop : Real;
    classNoLeft : Real;

    scutId:string;
    procedure readPositionInfo(posType:string);
    procedure setCardPosition(cardType:string);
    procedure queryBaseInfo(sstuempNo:string;sareaId:string;scustId:string);

    procedure updateMakeCardInfo;
  public
    { Public declarations }
    cardType : String;
  end;

var
  frmCardPrint: TfrmCardPrint;

implementation

uses uCommon, Udm;

{$R *.dfm}

procedure TfrmCardPrint.btnPrintClick(Sender: TObject);
begin
  qckrpPrint.Preview;
  updateMakeCardInfo;
  btnPrint.Enabled:=False;
end;

procedure TfrmCardPrint.readPositionInfo(posType:string);
var
  myFile : TiniFile;
begin
  myFile:=nil;
  try
    myFile := TiniFile.Create(ExtractFilePath(Application.ExeName)+'\photo.ini');

    pageOrien := myFile.ReadString('pageorientation','orientation','P');

    pageWidth := myFile.ReadFloat('printpage','width',0);
    pageHeight := myFile.ReadFloat('printpage','height',0);

    photoWidth := myFile.ReadFloat('photo','width',0);
    photoHeight := myFile.ReadFloat('photo','height',0);
    photoTop := myFile.ReadFloat('photo','top',0);
    photoLeft := myFile.ReadFloat('photo','left',0);

    fontSize := myFile.ReadInteger('font','size',0);
    fontName := myFile.readString('font','name','');
    fontBold := myFile.readString('font','style','');
    fontWidth := myFile.ReadFloat('font','width',0);
    fontHeight := myFile.ReadFloat('font','height',0);

    NoVisible := myFile.ReadBool(posType+'no','visible',false);
    NoTop := myFile.ReadFloat(posType+'no','top',0);
    NoLeft := myFile.ReadFloat(posType+'no','left',0);

    nameVisible := myFile.ReadBool(posType+'name','visible',false);
    nameTop := myFile.ReadFloat(posType+'name','top',0);
    nameLeft := myFile.ReadFloat(posType+'name','left',0);

    typeVisible := myFile.ReadBool(posType+'type','visible',false);
    typeTop := myFile.ReadFloat(posType+'type','top',0);
    typeLeft := myFile.ReadFloat(posType+'type','left',0);

    deptVisible := myFile.ReadBool(posType+'dept','visible',false);
    deptTop := myFile.ReadFloat(posType+'dept','top',0);
    deptLeft := myFile.ReadFloat(posType+'dept','left',0);

    specVisible := myFile.ReadBool(posType+'spec','visible',false);
    specTop := myFile.ReadFloat(posType+'spec','top',0);
    specLeft := myFile.ReadFloat(posType+'spec','left',0);


    idCardVisible := myFile.ReadBool(posType+'idCard','visible',false);
    idCardTop := myFile.ReadFloat(posType+'idCard','top',0);
    idCardLeft := myFile.ReadFloat(posType+'idCard','left',0);

    cardNoVisible := myFile.ReadBool(posType+'cardNo','visible',false);
    cardNoTop := myFile.ReadFloat(posType+'cardNo','top',0);
    cardNoLeft := myFile.ReadFloat(posType+'cardNo','left',0);

    classNoVisible := myFile.ReadBool(posType+'classNo','visible',false);
    classNoTop := myFile.ReadFloat(posType+'classNo','top',0);
    classNoLeft := myFile.ReadFloat(posType+'classNo','left',0);
  finally
    myFile.Free;
  end;
end;

procedure TfrmCardPrint.setCardPosition(cardType: string);
begin
  readPositionInfo(cardType);
  if pageOrien='P' then
    qckrpPrint.Page.Orientation := poPortrait
  else
    qckrpPrint.Page.Orientation := poLandscape;
  qckrpPrint.Page.Width := pageWidth;
  qckrpPrint.Page.Length := pageHeight;
  if pageHeight>60 then
    frmCardPrint.Height := 450
  else
    frmCardPrint.Height := 350;
    
  qckrpPrint.Top := pnlTop.Height+10;
  qckrpPrint.Left := Round((frmCardPrint.Width-qckrpprint.Width)/2);
  
  qrbndDetailBand1.Size.Height := qckrpPrint.Page.Length;
  qrbndDetailBand1.Size.Width := qckrpPrint.Page.Width;

  imgPhoto.Size.Width := photoWidth;
  imgPhoto.Size.Height := photoHeight;
  imgPhoto.Size.Left := photoLeft;
  imgPhoto.Size.Top := photoTop;

  qrlblNo.Font.Size := fontSize;
  qrlblNo.Font.Name := fontName;
  qrlblNo.Visible := NoVisible;
  qrlblNo.Enabled := NoVisible;
  qrlblNo.Size.Width := fontWidth;
  qrlblNo.Size.Height := fontHeight;
  qrlblNo.Size.Top := NoTop;
  qrlblNo.Size.Left := NoLeft;

  qrlblname.Font.Size := fontSize;
  qrlblname.Font.Name := fontName;
  qrlblname.Visible := nameVisible;
  qrlblname.Enabled := nameVisible;
  qrlblname.Size.Width := fontWidth;
  qrlblname.Size.Height := fontHeight;
  qrlblname.Size.Top := nameTop;
  qrlblname.Size.Left := nameLeft;

  qrlbltype.Font.Size := fontSize;
  qrlbltype.Font.Name := fontName;
  qrlbltype.Visible := typeVisible;
  qrlbltype.Enabled := typeVisible;
  qrlbltype.Size.Width := fontWidth;
  qrlbltype.Size.Height := fontHeight;
  qrlbltype.Size.Top := typeTop;
  qrlbltype.Size.Left := typeLeft;

  qrlbldept.Font.Size := fontSize;
  qrlbldept.Font.Name := fontName;
  qrlbldept.Visible := deptVisible;
  qrlbldept.Enabled := deptVisible;
  qrlbldept.Size.Width := fontWidth;
  qrlbldept.Size.Height := fontHeight;
  qrlbldept.Size.Top := deptTop;
  qrlbldept.Size.Left := deptLeft;

  qrlblspec.Font.Size := fontSize;
  qrlblspec.Font.Name := fontName;
  qrlblspec.Visible := specVisible;
  qrlblspec.Enabled := specVisible;
  qrlblspec.Size.Width := fontWidth;
  qrlblspec.Size.Height := fontHeight;
  qrlblspec.Size.Top := specTop;
  qrlblspec.Size.Left := specLeft;

  qrlblidCard.Font.Size := fontSize;
  qrlblidCard.Font.Name := fontName;
  qrlblidCard.Visible := idCardVisible;
  qrlblidCard.Enabled := idCardVisible;
  qrlblidCard.Size.Width := fontWidth;
  qrlblidCard.Size.Height := fontHeight;
  qrlblidCard.Size.Top := idCardTop;
  qrlblidCard.Size.Left := idCardLeft;

  qrlblCardNo.Font.Size := fontSize;
  qrlblCardNo.Font.Name := fontName;
  qrlblCardNo.Visible := CardNoVisible;
  qrlblCardNo.Enabled := CardNoVisible;
  qrlblCardNo.Size.Width := fontWidth;
  qrlblCardNo.Size.Height := fontHeight;
  qrlblCardNo.Size.Top := CardNoTop;
  qrlblCardNo.Size.Left := CardNoLeft;

  qrlblClassNo.Font.Size := fontSize;
  qrlblClassNo.Font.Name := fontName;
  qrlblClassNo.Visible := classNoVisible;
  qrlblClassNo.Enabled := classNoVisible;
  qrlblClassNo.Size.Width := fontWidth;
  qrlblClassNo.Size.Height := fontHeight;
  qrlblClassNo.Size.Top := classNoTop;
  qrlblClassNo.Size.Left := classNoLeft;

end;

procedure TfrmCardPrint.FormShow(Sender: TObject);
var
  sqlstr:string;
begin
  if cardType = 'stu' then
  begin
    frmCardPrint.Caption := '学生卡打印';
    setCardPosition('stu');
  end;
  if cardType = 'emp' then
  begin
    frmCardPrint.Caption := '教师卡打印';
    setCardPosition('emp');
  end;
  sqlStr:='select '+ areaName + ',' + areaNo + ' from ' + tblArea;
  sqlStr:=sqlStr+' where '+areaFather+'=1 order by '+areaNo;
  AddData(cbbArea,sqlStr);
end;

procedure TfrmCardPrint.queryBaseInfo(sstuempNo, sareaId, scustId: string);
var
  sqlStr:string;
  qryExecSQL:TADOQuery;
  Fjpg: TJpegImage;
begin
  sqlStr:=queryBaseInfoSql(sstuempNo,sareaId,scustId);
  qryExecSQL := nil;
  Fjpg:=nil;
  imgPhoto.Picture.Graphic:=nil;
  try
    Fjpg := TJpegImage.Create;
    qryExecSQL := TADOQuery.Create(nil);
    qryExecSQL.Connection := frmdm.conn;
    qryExecSQL.Close;
    qryExecSQL.SQL.Clear;
    qryExecSQL.SQL.Add(sqlStr);
    qryExecSQL.Prepared;
    qryExecSQL.Open;
    if not qryExecSQL.IsEmpty then
    begin
      qryExecSQL.First;
      scutId:=qryExecSQL.fieldbyname(custId).asstring;
      qrlblName.Caption:=Trim(qryExecSQL.fieldbyname(custName).AsString);
      qrlblNo.Caption:=Trim(qryExecSQL.fieldbyname(stuempNo).AsString);
      qrlblType.Caption:=getTypeName(Trim(qryExecSQL.fieldbyname(custType).AsString));
      qrlblDept.Caption:=getDeptName(Trim(qryExecSQL.fieldbyname(custDeptNo).AsString));
      qrlblSpec.Caption:=getSName(Trim(qryExecSQL.fieldbyname(custSpecNo).AsString));
      //加入身份证号和卡号
      qrlblidCard.Caption:=Trim(qryExecSQL.fieldbyname(custId).AsString);
      qrlblCardNo.Caption := getCardNo(Trim(qryExecSQL.fieldbyname(custId).AsString));
      //加入班级
      qrlblClassNo.Caption := Trim(qryExecSQL.fieldbyname(classNo).AsString);
      //ShowMessage('学工号'+qryExecSQL.fieldbyname(stuempNo).AsString+'---');
      //取得是否制卡及照片相关信息getCardNo

      Fjpg := getPhotoInfo(qryExecSQL.fieldbyname(custId).AsString);
      if Fjpg<>nil then
        imgPhoto.Picture.Graphic:=Fjpg;
      if Trim(cpIfCard)='1' then
        lblIfCard.Caption:='该照片已经制卡，制卡时间：'+cpcardDate+'-'+cpCardTime
      else
        lblIfCard.Caption:='';
    end
    else
      ShowMessage('客户信息表无相关信息，请重新指定查询条件！');
  finally
    Fjpg.Free;
    qryExecSQL.Destroy;
  end;
end;

procedure TfrmCardPrint.btnQueryClick(Sender: TObject);
begin
  if (Trim(edtStuempNo.Text)='')and(cbbArea.Text='')and(Trim(edtCustNo.Text)='') then
  begin
    ShowMessage('请输入查询条件，然后再查询！');
    edtStuempNo.SetFocus;
    Exit;
  end;
  queryBaseInfo(Trim(edtStuempNo.Text),subString(cbbArea.Text,'-','l'),Trim(edtCustNo.Text));
  btnPrint.Enabled:=True;
end;

procedure TfrmCardPrint.btnExitClick(Sender: TObject);
begin
  close;
end;

procedure TfrmCardPrint.updateMakeCardInfo;
var
  sqlStr:string;
  tmpQuery:TADOQuery;
begin
  sqlStr:='update '+tblPhoto+' set '+pIfCard+'='+#39+inttostr(1)+#39+','+pCardDate+'=';
  sqlStr:=sqlStr+#39+formatdatetime('yyyymmdd',Date)+#39+','+pCardTime+'=';
  sqlStr:=sqlStr+#39+formatdatetime('hhmmss',Now)+#39+' where ';
  sqlStr:=sqlStr+custId+'='+scutid;
  tmpQuery:=nil;
  try
    tmpQuery := TADOQuery.Create(nil);
    tmpQuery.Connection := frmdm.conn;
    tmpQuery.Close;
    tmpQuery.SQL.Clear;
    tmpQuery.SQL.Add(sqlStr);
    tmpQuery.Prepared;
    tmpQuery.ExecSQL;
  finally
    tmpQuery.Destroy;
  end;
end;

end.
