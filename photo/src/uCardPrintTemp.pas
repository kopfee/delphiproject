unit uCardPrintTemp;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ExtCtrls, StdCtrls, Buttons, QuickRpt, QRCtrls, jpeg, inifiles, Ora,
    Printers, RzLabel;

type
    TfrmCardPrintTemp = class(TForm)
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
        btnExit: TBitBtn;
        lblPreview: TRzURLLabel;
        qrshpL5: TQRShape;
        qrshpL4: TQRShape;
        qrshpL3: TQRShape;
        qrshpL2: TQRShape;
        qrshpL1: TQRShape;
        qrlblType: TQRLabel;
        qrlblSpec: TQRLabel;
        qrlblNo: TQRLabel;
        qrlblName: TQRLabel;
        qrlblFoot2: TQRLabel;
        qrlblFoot1: TQRLabel;
        qrlblDept: TQRLabel;
        qrlblClassNo: TQRLabel;
        qrlblCardType: TQRLabel;
        qrlblCardNo: TQRLabel;
        qrlbl5: TQRLabel;
        qrlbl4: TQRLabel;
        qrlbl3: TQRLabel;
        qrlbl2: TQRLabel;
        qrlbl1: TQRLabel;
        imgTitle: TQRImage;
        imgPhoto: TQRImage;
        btnDetailQ: TBitBtn;
        qrlblExtField1: TQRLabel;
        qrlblExtField2: TQRLabel;
        procedure btnPrintClick(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure btnQueryClick(Sender: TObject);
        procedure btnExitClick(Sender: TObject);
        procedure lblPreviewClick(Sender: TObject);
        procedure btnDetailQClick(Sender: TObject);
    private
        { Private declarations }
        pageWidth: Real;
        pageHeight: Real;

        titlevisible: Boolean;
        titlename: string;
        titleleft: Real;
        titletop: Real;
        titlewidth: Real;
        titleheight: Real;

        //bgvisible:Boolean;
        //bgname:string;

        photoVisible: Boolean;
        photoWidth: Real;
        photoHeight: Real;
        photoTop: Real;
        photoLeft: Real;

        cardtypevisible: Boolean;
        cardtypename: string;
        cardtypeleft: Real;
        cardtypetop: Real;
        cardtypewidth: Real;
        cardtypeheight: Real;
        cardtypefontsize: Integer;
        cardtypefontname: string;
        cardtypestype: string;

        contfontsize: integer;
        contfontname: string;
        contfontstyle: string;
        contfontheight: Integer;
        contfontwidth: Integer;

        fontSize: integer;
        fontName: string;
        fontStyle: string;
        fontWidth: Integer;
        fontHeight: Integer;

        conttit1visible: Boolean;
        conttit1name: string;
        conttit1left: Real;
        conttit1top: Real;

        conttit2visible: Boolean;
        conttit2name: string;
        conttit2left: Real;
        conttit2top: Real;

        conttit3visible: Boolean;
        conttit3name: string;
        conttit3left: Real;
        conttit3top: Real;

        conttit4visible: Boolean;
        conttit4name: string;
        conttit4left: Real;
        conttit4top: Real;

        conttit5visible: Boolean;
        conttit5name: string;
        conttit5left: Real;
        conttit5top: Real;

        contnameVisible: boolean;
        contnameTop: Real;
        contnameLeft: Real;

        conttypeVisible: boolean;
        conttypeTop: Real;
        conttypeLeft: Real;

        contcustNoVisible: boolean;
        contcustNoTop: Real;
        contcustNoLeft: Real;

        stuempnoVisible: boolean;
        stuempnoTop: Real;
        stuempnoLeft: Real;

        deptVisible: boolean;
        deptTop: Real;
        deptLeft: Real;

        specVisible: boolean;
        specTop: Real;
        specLeft: Real;

        cardNoVisible: Boolean;
        cardNoTop: Real;
        cardNoLeft: Real;

        classNoVisible: Boolean;
        classNoTop: Real;
        classNoLeft: Real;

        extField1Visible: Boolean;
        extField1Top: Real;
        extField1Left: Real;

        extField2Visible: Boolean;
        extField2Top: Real;
        extField2Left: Real;

        foot1name: string;
        foot1fontsize: Integer;
        foot1fontname: string;
        foot1fontstyle: string;
        foot1left: Real;
        foot1top: Real;
        foot1height: Real;
        foot1width: Real;
        foot1visible: Boolean;

        foot2name: string;
        foot2fontsize: Integer;
        foot2fontname: string;
        foot2fontstyle: string;
        foot2left: Real;
        foot2top: Real;
        foot2height: Real;
        foot2width: Real;
        foot2visible: Boolean;

        linewidth: Integer;

        line1visible: Boolean;
        line1left: Real;
        line1top: Real;
        line1width: Real;

        line2visible: Boolean;
        line2left: Real;
        line2top: Real;
        line2width: Real;

        line3visible: Boolean;
        line3left: Real;
        line3top: Real;
        line3width: Real;

        line4visible: Boolean;
        line4left: Real;
        line4top: Real;
        line4width: Real;

        line5visible: Boolean;
        line5left: Real;
        line5top: Real;
        line5width: Real;

        scutId: string;
        procedure readPositionInfo(posType: string);
        procedure setCardPosition(cardType: string);
        procedure queryBaseInfo(sstuempNo: string; sareaId: string; scustId: string);

        function getFontStyles(styles: string): TFontStyles;

        procedure updateMakeCardInfo;
    public
        { Public declarations }
        iCustId: Integer;
        ifMakeCard: Boolean;
        cardType: string;
    end;

var
    frmCardPrintTemp: TfrmCardPrintTemp;

implementation

uses uCommon, Udm, uPhotoQuery, uConst;

{$R *.dfm}

procedure TfrmCardPrintTemp.btnPrintClick(Sender: TObject);
begin
    qckrpPrint.Preview;
    updateMakeCardInfo;
    btnPrint.Enabled := False;
end;

procedure TfrmCardPrintTemp.readPositionInfo(posType: string);
var
    myFile: TiniFile;
begin
    myFile := nil;
    try
        try
            myFile := TiniFile.Create(ExtractFilePath(Application.ExeName) + sPrintTemplateDir + postype + '.ini');
            pageWidth := myFile.ReadFloat('printpage', 'width', 0);
            pageHeight := myFile.ReadFloat('printpage', 'height', 0);

            titlevisible := myFile.ReadBool('title', 'visible', false);
            titlename := myFile.ReadString('title', 'titlename', '');
            titleleft := myFile.ReadFloat('title', 'left', 0);
            titletop := myFile.ReadFloat('title', 'top', 0);
            titlewidth := myFile.ReadFloat('title', 'width', 0);
            titleheight := myFile.ReadFloat('title', 'height', 0);

            //bgvisible:= myFile.ReadBool('background','visible',false);
            //bgname:= myFile.readString('background','name','');

            photoVisible := myFile.ReadBool('photo', 'visible', false);
            photoWidth := myFile.ReadFloat('photo', 'width', 0);
            photoHeight := myFile.ReadFloat('photo', 'height', 0);
            photoTop := myFile.ReadFloat('photo', 'top', 0);
            photoLeft := myFile.ReadFloat('photo', 'left', 0);

            cardtypevisible := myFile.ReadBool('cardtypefont', 'visible', false);
            cardtypename := myFile.readString('cardtypefont', 'cardtypename', '');
            cardtypeleft := myFile.ReadFloat('cardtypefont', 'left', 0);
            cardtypetop := myFile.ReadFloat('cardtypefont', 'top', 0);
            cardtypewidth := myFile.ReadFloat('cardtypefont', 'width', 0);
            cardtypeheight := myFile.ReadFloat('cardtypefont', 'height', 0);
            cardtypefontsize := myFile.ReadInteger('cardtypefont', 'fontsize', 0);
            cardtypefontname := myFile.readString('cardtypefont', 'fontname', '');
            cardtypestype := myFile.readString('cardtypefont', 'style', '');

            contfontsize := myFile.ReadInteger('contexttitlefont', 'size', 0);
            contfontname := myFile.readString('contexttitlefont', 'name', '');
            contfontstyle := myFile.readString('contexttitlefont', 'style', '');
            contfontheight := myFile.ReadInteger('contexttitlefont', 'height', 0);
            contfontwidth := myFile.ReadInteger('contexttitlefont', 'width', 0);

            fontSize := myFile.ReadInteger('contextfont', 'size', 0);
            fontName := myFile.readString('contextfont', 'name', '');
            fontStyle := myFile.readString('contextfont', 'style', '');
            fontWidth := myFile.ReadInteger('contextfont', 'width', 0);
            fontHeight := myFile.ReadInteger('contextfont', 'height', 0);

            conttit1visible := myFile.ReadBool('contexttitle1', 'visible', false);
            conttit1name := myFile.readString('contexttitle1', 'name', '');
            conttit1left := myFile.ReadFloat('contexttitle1', 'left', 0);
            conttit1top := myFile.ReadFloat('contexttitle1', 'top', 0);

            conttit2visible := myFile.ReadBool('contexttitle2', 'visible', false);
            conttit2name := myFile.readString('contexttitle2', 'name', '');
            conttit2left := myFile.ReadFloat('contexttitle2', 'left', 0);
            conttit2top := myFile.ReadFloat('contexttitle2', 'top', 0);

            conttit3visible := myFile.ReadBool('contexttitle3', 'visible', false);
            conttit3name := myFile.readString('contexttitle3', 'name', '');
            conttit3left := myFile.ReadFloat('contexttitle3', 'left', 0);
            conttit3top := myFile.ReadFloat('contexttitle3', 'top', 0);

            conttit4visible := myFile.ReadBool('contexttitle4', 'visible', false);
            conttit4name := myFile.readString('contexttitle4', 'name', '');
            conttit4left := myFile.ReadFloat('contexttitle4', 'left', 0);
            conttit4top := myFile.ReadFloat('contexttitle4', 'top', 0);

            conttit5visible := myFile.ReadBool('contexttitle5', 'visible', false);
            conttit5name := myFile.readString('contexttitle5', 'name', '');
            conttit5left := myFile.ReadFloat('contexttitle5', 'left', 0);
            conttit5top := myFile.ReadFloat('contexttitle5', 'top', 0);

            contnameVisible := myFile.ReadBool('cont_name', 'visible', false);
            contnameTop := myFile.ReadFloat('cont_name', 'top', 0);
            contnameLeft := myFile.ReadFloat('cont_name', 'left', 0);

            conttypeVisible := myFile.ReadBool('cont_type', 'visible', false);
            conttypeTop := myFile.ReadFloat('cont_type', 'top', 0);
            conttypeLeft := myFile.ReadFloat('cont_type', 'left', 0);

            contcustNoVisible := myFile.ReadBool('cont_custno', 'visible', false);
            contcustNoTop := myFile.ReadFloat('cont_custno', 'top', 0);
            contcustNoLeft := myFile.ReadFloat('cont_custno', 'left', 0);

            stuempnoVisible := myFile.ReadBool('cont_stuempno', 'visible', false);
            stuempnoTop := myFile.ReadFloat('cont_stuempno', 'top', 0);
            stuempnoLeft := myFile.ReadFloat('cont_stuempno', 'left', 0);

            deptVisible := myFile.ReadBool('cont_dept', 'visible', false);
            deptTop := myFile.ReadFloat('cont_dept', 'top', 0);
            deptLeft := myFile.ReadFloat('cont_dept', 'left', 0);

            specVisible := myFile.ReadBool('cont_spec', 'visible', false);
            specTop := myFile.ReadFloat('cont_spec', 'top', 0);
            specLeft := myFile.ReadFloat('cont_spec', 'left', 0);

            cardNoVisible := myFile.ReadBool('cont_cardno', 'visible', false);
            cardNoTop := myFile.ReadFloat('cont_cardno', 'top', 0);
            cardNoLeft := myFile.ReadFloat('cont_cardno', 'left', 0);

            classNoVisible := myFile.ReadBool('cont_classno', 'visible', false);
            classNoTop := myFile.ReadFloat('cont_classno', 'top', 0);
            classNoLeft := myFile.ReadFloat('cont_classno', 'left', 0);

            extField1Visible := myFile.ReadBool('ext_field1', 'visible', false);
            extField1Top := myFile.ReadFloat('ext_field1', 'top', 0);
            extField1Left := myFile.ReadFloat('ext_field1', 'left', 0);

            extField2Visible := myFile.ReadBool('ext_field2', 'visible', false);
            extField2Top := myFile.ReadFloat('ext_field2', 'top', 0);
            extField2Left := myFile.ReadFloat('ext_field2', 'left', 0);

            foot1name := myFile.readString('foot1', 'name', '');
            foot1fontsize := myFile.ReadInteger('foot1', 'fontsize', 0);
            foot1fontname := myFile.readString('foot1', 'fontname', '');
            foot1fontstyle := myFile.readString('foot1', 'fontstyle', '');
            foot1left := myFile.ReadFloat('foot1', 'left', 0);
            foot1top := myFile.ReadFloat('foot1', 'top', 0);
            foot1height := myFile.ReadFloat('foot1', 'height', 0);
            foot1width := myFile.ReadFloat('foot1', 'width', 0);
            foot1visible := myFile.ReadBool('foot1', 'visible', false);

            foot2name := myFile.readString('foot2', 'name', '');
            foot2fontsize := myFile.ReadInteger('foot2', 'fontsize', 0);
            foot2fontname := myFile.readString('foot2', 'fontname', '');
            foot2fontstyle := myFile.readString('foot2', 'fontstyle', '');
            foot2left := myFile.ReadFloat('foot2', 'left', 0);
            foot2top := myFile.ReadFloat('foot2', 'top', 0);
            foot2height := myFile.ReadFloat('foot2', 'height', 0);
            foot2width := myFile.ReadFloat('foot2', 'width', 0);
            foot2visible := myFile.ReadBool('foot2', 'visible', false);

            line1visible := myFile.ReadBool('line1', 'visible', false);
            line1left := myFile.ReadFloat('line1', 'left', 0);
            line1top := myFile.ReadFloat('line1', 'top', 0);
            line1width := myFile.ReadFloat('line1', 'width', 0);

            line2visible := myFile.ReadBool('line2', 'visible', false);
            line2left := myFile.ReadFloat('line2', 'left', 0);
            line2top := myFile.ReadFloat('line2', 'top', 0);
            line2width := myFile.ReadFloat('line2', 'width', 0);

            line3visible := myFile.ReadBool('line3', 'visible', false);
            line3left := myFile.ReadFloat('line3', 'left', 0);
            line3top := myFile.ReadFloat('line3', 'top', 0);
            line3width := myFile.ReadFloat('line3', 'width', 0);

            line4visible := myFile.ReadBool('line4', 'visible', false);
            line4left := myFile.ReadFloat('line4', 'left', 0);
            line4top := myFile.ReadFloat('line4', 'top', 0);
            line4width := myFile.ReadFloat('line4', 'width', 0);

            line5visible := myFile.ReadBool('line5', 'visible', false);
            line5left := myFile.ReadFloat('line5', 'left', 0);
            line5top := myFile.ReadFloat('line5', 'top', 0);
            line5width := myFile.ReadFloat('line5', 'width', 0);

            linewidth := myFile.ReadInteger('linewidth', 'width', 0);
        finally
            myFile.Free;
        end;
    except
        on e: Exception do
            ShowMessage('读取配置文件错误--' + e.Message);
    end;
end;

procedure TfrmCardPrintTemp.setCardPosition(cardType: string);
begin
    readPositionInfo(cardType);
    if pageOrien = 'P' then
        qckrpPrint.Page.Orientation := poPortrait
    else
        qckrpPrint.Page.Orientation := poLandscape;
    qckrpPrint.Page.Width := pageWidth;
    qckrpPrint.Page.Length := pageHeight;

    if pageHeight > 60 then
        frmCardPrintTemp.Height := 450
    else
        frmCardPrintTemp.Height := 350;

    qckrpPrint.Top := pnlTop.Height + 10;
    qckrpPrint.Left := Round((frmCardPrintTemp.Width - qckrpprint.Width) / 2 - 10);

    qrbndDetailBand1.Size.Height := qckrpPrint.Page.Length;
    qrbndDetailBand1.Size.Width := qckrpPrint.Page.Width;

    //标题图片设置
    if titlevisible then
        imgTitle.Picture.LoadFromFile(apppath + sPrintTemplateDir + titlename);
    imgTitle.Size.Top := titletop;
    imgTitle.Size.Left := titleleft;
    imgTitle.Size.Width := titlewidth;
    imgTitle.Size.Height := titleheight;
    imgTitle.Visible := titlevisible;
    imgTitle.Enabled := titlevisible;

    //照片位置设置
    imgPhoto.Size.Width := photoWidth;
    imgPhoto.Size.Height := photoHeight;
    imgPhoto.Size.Left := photoLeft;
    imgPhoto.Size.Top := photoTop;
    imgPhoto.Visible := photoVisible;
    imgPhoto.Enabled := photoVisible;

    //卡片类型设置
    qrlblCardType.Caption := cardtypename;
    qrlblCardType.Font.Size := cardtypefontsize;
    qrlblCardType.Font.Name := cardtypefontname;
    qrlblCardType.Font.Style := getFontStyles(cardtypestype);
    qrlblCardType.Size.Left := cardtypeleft;
    qrlblCardType.Size.Top := cardtypetop;
    qrlblCardType.Size.Width := cardtypewidth;
    qrlblCardType.Size.Height := cardtypeheight;
    qrlblCardType.Visible := cardtypevisible;
    qrlblCardType.Enabled := cardtypevisible;

    //打印题头字体设置
    qrlbl1.Font.Name := contfontname;
    qrlbl1.Font.Size := contfontsize;
    qrlbl1.Font.Style := getFontStyles(contfontstyle);
    qrlbl1.Size.Width := contfontwidth;
    qrlbl1.Size.Height := contfontheight;
    qrlbl1.Size.Left := conttit1left;
    qrlbl1.Size.Top := conttit1top;
    qrlbl1.Caption := conttit1name;
    qrlbl1.Visible := conttit1visible;
    qrlbl1.Enabled := conttit1visible;

    qrlbl2.Font.Name := contfontname;
    qrlbl2.Font.Size := contfontsize;
    qrlbl2.Font.Style := getFontStyles(contfontstyle);
    qrlbl2.Size.Width := contfontwidth;
    qrlbl2.Size.Height := contfontheight;
    qrlbl2.Size.Left := conttit2left;
    qrlbl2.Size.Top := conttit2top;
    qrlbl2.Caption := conttit2name;
    qrlbl2.Visible := conttit2visible;
    qrlbl2.Enabled := conttit2visible;
    //qrlbl2.Font.Style
    qrlbl3.Font.Name := contfontname;
    qrlbl3.Font.Size := contfontsize;
    qrlbl3.Font.Style := getFontStyles(contfontstyle);
    qrlbl3.Size.Width := contfontwidth;
    qrlbl3.Size.Height := contfontheight;
    qrlbl3.Size.Left := conttit3left;
    qrlbl3.Size.Top := conttit3top;
    qrlbl3.Caption := conttit3name;
    qrlbl3.Visible := conttit3visible;
    qrlbl3.Enabled := conttit3visible;

    qrlbl4.Font.Name := contfontname;
    qrlbl4.Font.Size := contfontsize;
    qrlbl4.Font.Style := getFontStyles(contfontstyle);
    qrlbl4.Size.Width := contfontwidth;
    qrlbl4.Size.Height := contfontheight;
    qrlbl4.Size.Left := conttit4left;
    qrlbl4.Size.Top := conttit4top;
    qrlbl4.Caption := conttit4name;
    qrlbl4.Visible := conttit4visible;
    qrlbl4.Enabled := conttit4visible;

    qrlbl5.Font.Name := contfontname;
    qrlbl5.Font.Size := contfontsize;
    qrlbl5.Font.Style := getFontStyles(contfontstyle);
    qrlbl5.Size.Width := contfontwidth;
    qrlbl5.Size.Height := contfontheight;
    qrlbl5.Size.Left := conttit5left;
    qrlbl5.Size.Top := conttit5top;
    qrlbl5.Caption := conttit5name;
    qrlbl5.Visible := conttit5visible;
    qrlbl5.Enabled := conttit5visible;


    qrlblNo.Visible := stuempnoVisible;
    qrlblNo.Enabled := stuempnoVisible;
    qrlblNo.Font.Size := fontSize;
    qrlblNo.Font.Name := fontName;
    qrlblNo.Font.Style := getFontStyles(fontStyle);
    qrlblNo.Size.Width := fontWidth;
    qrlblNo.Size.Height := fontHeight;
    qrlblNo.Size.Top := stuempnoTop;
    qrlblNo.Size.Left := stuempnoLeft;

    qrlblname.Visible := contnameVisible;
    qrlblname.Enabled := contnameVisible;
    qrlblname.Font.Size := fontSize;
    qrlblname.Font.Name := fontName;
    qrlblname.Font.Style := getFontStyles(fontStyle);
    qrlblname.Size.Width := fontWidth;
    qrlblname.Size.Height := fontHeight;
    qrlblname.Size.Top := contnameTop;
    qrlblname.Size.Left := contnameLeft;

    qrlbltype.Visible := conttypeVisible;
    qrlbltype.Enabled := conttypeVisible;
    qrlbltype.Font.Size := fontSize;
    qrlbltype.Font.Name := fontName;
    qrlbltype.Font.Style := getFontStyles(fontStyle);
    qrlbltype.Size.Width := fontWidth;
    qrlbltype.Size.Height := fontHeight;
    qrlbltype.Size.Top := conttypeTop;
    qrlbltype.Size.Left := conttypeLeft;

    qrlbldept.Visible := deptVisible;
    qrlbldept.Enabled := deptVisible;
    qrlbldept.Font.Size := fontSize;
    qrlbldept.Font.Name := fontName;
    qrlbldept.Font.Style := getFontStyles(fontStyle);
    qrlbldept.Size.Width := fontWidth;
    qrlbldept.Size.Height := fontHeight;
    qrlbldept.Size.Top := deptTop;
    qrlbldept.Size.Left := deptLeft;

    qrlblspec.Visible := specVisible;
    qrlblspec.Enabled := specVisible;
    qrlblspec.Font.Size := fontSize;
    qrlblspec.Font.Name := fontName;
    qrlblspec.Font.Style := getFontStyles(fontStyle);
    qrlblspec.Size.Width := fontWidth;
    qrlblspec.Size.Height := fontHeight;
    qrlblspec.Size.Top := specTop;
    qrlblspec.Size.Left := specLeft;

    qrlblCardNo.Visible := CardNoVisible;
    qrlblCardNo.Enabled := CardNoVisible;
    qrlblCardNo.Font.Size := fontSize;
    qrlblCardNo.Font.Name := fontName;
    qrlblCardNo.Font.Style := getFontStyles(fontStyle);
    qrlblCardNo.Size.Width := fontWidth;
    qrlblCardNo.Size.Height := fontHeight;
    qrlblCardNo.Size.Top := CardNoTop;
    qrlblCardNo.Size.Left := CardNoLeft;

    qrlblClassNo.Visible := classNoVisible;
    qrlblClassNo.Enabled := classNoVisible;
    qrlblClassNo.Font.Size := fontSize;
    qrlblClassNo.Font.Name := fontName;
    qrlblClassNo.Font.Style := getFontStyles(fontStyle);
    qrlblClassNo.Size.Width := fontWidth;
    qrlblClassNo.Size.Height := fontHeight;
    qrlblClassNo.Size.Top := classNoTop;
    qrlblClassNo.Size.Left := classNoLeft;

    qrlblExtField1.Visible := extField1Visible;
    qrlblExtField1.Enabled := extField1Visible;
    qrlblExtField1.Font.Size := fontSize;
    qrlblExtField1.Font.Name := fontName;
    qrlblExtField1.Font.Style := getFontStyles(fontStyle);
    qrlblExtField1.Size.Width := fontWidth;
    qrlblExtField1.Size.Height := fontHeight;
    qrlblExtField1.Size.Top := extField1Top;
    qrlblExtField1.Size.Left := extField1Left;

    qrlblExtField2.Visible := extField2Visible;
    qrlblExtField2.Enabled := extField2Visible;
    qrlblExtField2.Font.Size := fontSize;
    qrlblExtField2.Font.Name := fontName;
    qrlblExtField2.Font.Style := getFontStyles(fontStyle);
    qrlblExtField2.Size.Width := fontWidth;
    qrlblExtField2.Size.Height := fontHeight;
    qrlblExtField2.Size.Top := extField2Top;
    qrlblExtField2.Size.Left := extField2Left;
    //脚设置
    qrlblFoot1.Caption := foot1name;
    qrlblFoot1.Font.Name := foot1fontname;
    qrlblFoot1.Font.Size := foot1fontsize;
    qrlblFoot1.Font.Style := getFontStyles(foot1fontstyle);
    qrlblFoot1.Size.Width := foot1width;
    qrlblFoot1.Size.Height := foot1height;
    qrlblFoot1.Size.Left := foot1left;
    qrlblFoot1.Size.Top := foot1top;
    qrlblFoot1.Visible := foot1visible;
    qrlblFoot1.Enabled := foot1visible;

    qrlblFoot2.Caption := foot2name;
    qrlblFoot2.Font.Name := foot2fontname;
    qrlblFoot2.Font.Size := foot2fontsize;
    qrlblFoot2.Font.Style := getFontStyles(foot2fontstyle);
    qrlblFoot2.Size.Width := foot2width;
    qrlblFoot2.Size.Height := foot2height;
    qrlblFoot2.Size.Left := foot2left;
    qrlblFoot2.Size.Top := foot2top;
    qrlblFoot2.Visible := foot2visible;
    qrlblFoot2.Enabled := foot2visible;

    //线的设置
    qrshpL1.Visible := line1visible;
    qrshpL1.Enabled := line1visible;
    qrshpL1.Size.Top := line1top;
    qrshpL1.Size.Left := line1left;
    qrshpL1.Size.Width := line1width;
    qrshpL1.Height := linewidth;
    qrshpL1.Pen.Width := linewidth;

    qrshpL2.Visible := line2visible;
    qrshpL2.Enabled := line2visible;
    qrshpL2.Size.Top := line2top;
    qrshpL2.Size.Left := line2left;
    qrshpL2.Size.Width := line2width;
    qrshpL2.Height := linewidth;
    qrshpL2.Pen.Width := linewidth;

    qrshpL3.Visible := line3visible;
    qrshpL3.Enabled := line3visible;
    qrshpL3.Size.Top := line3top;
    qrshpL3.Size.Left := line3left;
    qrshpL3.Size.Width := line3width;
    qrshpL3.Height := linewidth;
    qrshpL3.Pen.Width := linewidth;

    qrshpL4.Visible := line4visible;
    qrshpL4.Enabled := line4visible;
    qrshpL4.Size.Top := line4top;
    qrshpL4.Size.Left := line4left;
    qrshpL4.Size.Width := line4width;
    qrshpL4.Height := linewidth;
    qrshpL4.Pen.Width := linewidth;

    qrshpL5.Visible := line5visible;
    qrshpL5.Enabled := line5visible;
    qrshpL5.Size.Top := line5top;
    qrshpL5.Size.Left := line5left;
    qrshpL5.Size.Width := line5width;
    qrshpL5.Height := linewidth;
    qrshpL5.Pen.Width := linewidth;
end;

procedure TfrmCardPrintTemp.FormShow(Sender: TObject);
var
    sqlstr: string;
begin
    Self.Caption := cardType;
    setCardPosition(cardType);

    sqlStr := 'select ' + areaName + ',' + areaNo + ' from ' + tblArea;
    sqlStr := sqlStr + ' where ' + areaFather + '=1 order by ' + areaNo;
    AddData(cbbArea, sqlStr);
end;

procedure TfrmCardPrintTemp.queryBaseInfo(sstuempNo, sareaId, scustId: string);
var
    sqlStr: string;
    qryExecSQL: TOraQuery;
    Fjpg: TJpegImage;
begin
    sqlStr := photoQuery;
    if Trim(sstuempNo) <> '' then
        sqlStr := sqlStr + ' and ' + stuempNo + '=' + #39 + sstuempNo + #39;
    if Trim(sareaId) <> '' then
        sqlStr := sqlStr + ' and ' + custArea + '=' + sareaId;
    if Trim(scustId) <> '' then
        sqlStr := sqlStr + ' and ' + custId + '=' + scustId;

    //sqlStr:=queryBaseInfoSql(sstuempNo,sareaId,scustId);
    qryExecSQL := nil;
    Fjpg := nil;
    imgPhoto.Picture.Graphic := nil;
    try
        Fjpg := TJpegImage.Create;
        qryExecSQL := TOraQuery.Create(nil);
        qryExecSQL.Connection := frmdm.conn;
        qryExecSQL.Close;
        qryExecSQL.SQL.Clear;
        qryExecSQL.SQL.Add(sqlStr);
        qryExecSQL.Prepared;
        qryExecSQL.Open;
        if not qryExecSQL.IsEmpty then begin
            qryExecSQL.First;
            scutId := qryExecSQL.fieldbyname(custId).asstring;
            qrlblName.Caption := Trim(qryExecSQL.fieldbyname(custName).AsString);
            qrlblNo.Caption := Trim(qryExecSQL.fieldbyname(stuempNo).AsString);
            qrlblType.Caption := getTypeName(Trim(qryExecSQL.fieldbyname(custType).AsString));
            qrlblDept.Caption := getDeptName(Trim(qryExecSQL.fieldbyname(custDeptNo).AsString));
            qrlblSpec.Caption := getSName(Trim(qryExecSQL.fieldbyname(custSpecNo).AsString));
            //加入身份证号和卡号
            qrlblCardNo.Caption := getCardNo(Trim(qryExecSQL.fieldbyname(custId).AsString));
            //加入班级
            qrlblClassNo.Caption := Trim(qryExecSQL.fieldbyname(classNo).AsString);
            //qrlblExtField1.Caption := Trim(qryExecSQL.fieldbyname(extField1).AsString);
            qrlblExtField2.Caption := Trim(qryExecSQL.fieldbyname(extField2).AsString);
            //ShowMessage('学工号'+qryExecSQL.fieldbyname(stuempNo).AsString+'---');
            //取得是否制卡及照片相关信息getCardNo

            Fjpg := getPhotoInfo(qryExecSQL.fieldbyname(custId).AsString);
            if Fjpg <> nil then
                imgPhoto.Picture.Graphic := Fjpg;
            if Trim(cpIfCard) = '1' then
                lblIfCard.Caption := '该照片已经制卡，制卡时间：' + cpcardDate + '-' + cpCardTime
            else
                lblIfCard.Caption := '';
        end
        else
            ShowMessage('客户信息表无相关信息，请重新指定查询条件！');
    finally
        Fjpg.Free;
        qryExecSQL.Destroy;
    end;
end;

procedure TfrmCardPrintTemp.btnQueryClick(Sender: TObject);
begin
    if (Trim(edtStuempNo.Text) = '') and (cbbArea.Text = '') and (Trim(edtCustNo.Text) = '') then begin
        ShowMessage('请输入查询条件，然后再查询！');
        edtStuempNo.SetFocus;
        Exit;
    end;
    queryBaseInfo(Trim(edtStuempNo.Text), subString(cbbArea.Text, '-', 'l'), Trim(edtCustNo.Text));
    btnPrint.Enabled := True;
end;

procedure TfrmCardPrintTemp.btnExitClick(Sender: TObject);
begin
    close;
end;

procedure TfrmCardPrintTemp.updateMakeCardInfo;
var
    sqlStr: string;
    tmpQuery: TOraQuery;
begin
    sqlStr := 'update ' + tblPhoto + ' set ' + pIfCard + '=' + #39 + inttostr(1) + #39 + ',' + pCardDate + '=';
    sqlStr := sqlStr + #39 + formatdatetime('yyyymmdd', Date) + #39 + ',' + pCardTime + '=';
    sqlStr := sqlStr + #39 + formatdatetime('hhmmss', Now) + #39 + ' where ';
    sqlStr := sqlStr + custId + '=' + scutid;
    tmpQuery := nil;
    try
        tmpQuery := TOraQuery.Create(nil);
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

procedure TfrmCardPrintTemp.lblPreviewClick(Sender: TObject);
begin
    Self.Caption := cardType;
    setCardPosition(cardType);

end;

{-------------------------------------------------------------------------------
  过程名:    TfrmCardPrintTemp.getFontStyles取得字体style属性
  参数:      styles: string
  返回值:    TFontStyles
-------------------------------------------------------------------------------}

function TfrmCardPrintTemp.getFontStyles(styles: string): TFontStyles;
var
    fontStyles: TFontStyles; //[fsBold,fsItalic,fsUnderline,fsStrikeOut]
begin
    fontStyles := [];
    if Pos('fsBold', styles) > 0 then
        fontStyles := fontStyles + [fsBold];
    if Pos('fsItalic', styles) > 0 then
        fontStyles := fontStyles + [fsItalic];
    if Pos('fsUnderline', styles) > 0 then
        fontStyles := fontStyles + [fsUnderline];
    if Pos('fsStrikeOut', styles) > 0 then
        fontStyles := fontStyles + [fsStrikeOut];

    Result := fontStyles;
end;

procedure TfrmCardPrintTemp.btnDetailQClick(Sender: TObject);
begin
    if judgelimit(loginLimit, Mdl_photoQuery) = False then begin
        ShowMessage('你没有操作该项的权限！');
        Exit;
    end;
    frmPhotoQuery := TfrmPhotoQuery.Create(nil);
    ifMakeCard := False;
    frmPhotoQuery.btnPhoto.Enabled := False;
    frmPhotoQuery.wType := 'k';
    frmPhotoQuery.ShowModal;
    if ifMakeCard then begin
        queryBaseInfo('', '', IntToStr(iCustId));
        btnPrint.Enabled := True;
    end;
    frmPhotoQuery.Free;

end;

end.

