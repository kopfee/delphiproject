unit uCardPrintTemp_W;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ExtCtrls, StdCtrls, Buttons, jpeg, inifiles, Ora,
    Printers, RzLabel, RM_Common, RM_Class;

type
    TfrmCardPrintTemp_W = class(TForm)
        pnlTop: TPanel;
        lbl12: TLabel;
        edtStuEmpNo: TEdit;
        btnQuery: TBitBtn;
        btnPrint: TBitBtn;
        Label11: TLabel;
        cbbArea: TComboBox;
        Label1: TLabel;
        edtCustNo: TEdit;
        lblIfCard: TLabel;
        btnExit: TBitBtn;
        lblPreview: TRzURLLabel;
        btnDetailQ: TBitBtn;
        pnlPrint: TPanel;
        imgBG: TImage;
        imgPhoto: TImage;
        lblClassName: TLabel;
        lblCardNo: TLabel;
        lblStuEmpNo: TLabel;
        lblName: TLabel;
        lblDept: TLabel;
        lblSpec: TLabel;
        lblType: TLabel;
        lblFoot1: TLabel;
        lblFoot2: TLabel;
        lbl1: TLabel;
        lbl2: TLabel;
        lbl3: TLabel;
        lbl4: TLabel;
        lbl5: TLabel;
        lbl6: TLabel;
        lbl7: TLabel;
        lblCardType: TLabel;
        shp1: TShape;
        shp2: TShape;
        shp3: TShape;
        shp4: TShape;
        shp5: TShape;
        Label2: TLabel;
        cbbBackGround: TComboBox;
        btnPBackG: TBitBtn;
        rpt1: TRMReport;
        procedure btnPrintClick(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure btnQueryClick(Sender: TObject);
        procedure btnExitClick(Sender: TObject);
        procedure lblPreviewClick(Sender: TObject);
        procedure btnDetailQClick(Sender: TObject);
        procedure cbbBackGroundChange(Sender: TObject);
        procedure btnPBackGClick(Sender: TObject);
    private
        { Private declarations }
        //pageOrien:string;
        //pageWidth:Integer;
        //pageHeight:Integer;

        bgvisible: Boolean;
        bgname: string;
        //bgleft:Integer;
        //bgtop:Integer;
        //bgwidth:Integer;
        //bgheight:Integer;

        //bgvisible:Boolean;
        //bgname:string;

        photoVisible: Boolean;
        photoWidth: Integer;
        photoHeight: Integer;
        photoTop: Integer;
        photoLeft: Integer;

        cardtypevisible: Boolean;
        cardtypename: string;
        cardtypeleft: Integer;
        cardtypetop: Integer;
        cardtypewidth: Integer;
        cardtypeheight: Integer;
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
        conttit1left: Integer;
        conttit1top: Integer;

        conttit2visible: Boolean;
        conttit2name: string;
        conttit2left: Integer;
        conttit2top: Integer;

        conttit3visible: Boolean;
        conttit3name: string;
        conttit3left: Integer;
        conttit3top: Integer;

        conttit4visible: Boolean;
        conttit4name: string;
        conttit4left: Integer;
        conttit4top: Integer;

        conttit5visible: Boolean;
        conttit5name: string;
        conttit5left: Integer;
        conttit5top: Integer;

        contnameVisible: boolean;
        contnameTop: Integer;
        contnameLeft: Integer;

        conttypeVisible: boolean;
        conttypeTop: Integer;
        conttypeLeft: Integer;

        contcustNoVisible: boolean;
        contcustNoTop: Integer;
        contcustNoLeft: Integer;

        stuempnoVisible: boolean;
        stuempnoTop: Integer;
        stuempnoLeft: Integer;

        deptVisible: boolean;
        deptTop: Integer;
        deptLeft: Integer;

        specVisible: boolean;
        specTop: Integer;
        specLeft: Integer;

        cardNoVisible: Boolean;
        cardNoTop: Integer;
        cardNoLeft: Integer;

        classNoVisible: Boolean;
        classNoTop: Integer;
        classNoLeft: Integer;

        extField1Visible: Boolean;
        extField1Top: Integer;
        extField1Left: Integer;

        extField2Visible: Boolean;
        extField2Top: Integer;
        extField2Left: Integer;

        foot1name: string;
        foot1fontsize: Integer;
        foot1fontname: string;
        foot1fontstyle: string;
        foot1left: Integer;
        foot1top: Integer;
        foot1height: Integer;
        foot1width: Integer;
        foot1visible: Boolean;

        foot2name: string;
        foot2fontsize: Integer;
        foot2fontname: string;
        foot2fontstyle: string;
        foot2left: Integer;
        foot2top: Integer;
        foot2height: Integer;
        foot2width: Integer;
        foot2visible: Boolean;

        linewidth: Integer;

        line1visible: Boolean;
        line1left: Integer;
        line1top: Integer;
        line1width: Integer;

        line2visible: Boolean;
        line2left: Integer;
        line2top: Integer;
        line2width: Integer;

        line3visible: Boolean;
        line3left: Integer;
        line3top: Integer;
        line3width: Integer;

        line4visible: Boolean;
        line4left: Integer;
        line4top: Integer;
        line4width: Integer;

        line5visible: Boolean;
        line5left: Integer;
        line5top: Integer;
        line5width: Integer;

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
    frmCardPrintTemp_W: TfrmCardPrintTemp_W;

implementation

uses uCommon, Udm, uPhotoQuery, uConst;

{$R *.dfm}

procedure TfrmCardPrintTemp_W.btnPrintClick(Sender: TObject);
var
    Bitmap: TBitmap;
    t1: TRMPictureView;
begin
    Bitmap := nil;
    try
        Bitmap := TBitmap.Create;
        Bitmap.Width := pnlPrint.Width;
        Bitmap.Height := pnlPrint.Height;
        pnlPrint.PaintTo(Bitmap.Canvas, 0, 0);
        Bitmap.SaveToFile(apppath + '9999.bmp');
    finally
        Bitmap.Free;
    end;
    //打印
    //imgPPhoto.Picture.LoadFromFile(apppath+'9999.bmp');
    //pnl1.Print(True);
    //打印完成后删除bmp照片

    rpt1.LoadFromFile(apppath + 'print.rmf');
    t1 := TRMPictureView(rpt1.FindObject('Picture1'));
    if t1 <> nil then
        t1.Picture.LoadFromFile(apppath + '9999.bmp');
    rpt1.ShowReport;

    if FileExists(apppath + '9999.bmp') then
        DeleteFile(apppath + '9999.bmp');
    updateMakeCardInfo;
    btnPrint.Enabled := False;
end;

procedure TfrmCardPrintTemp_W.readPositionInfo(posType: string);
var
    myFile: TiniFile;
begin
    myFile := nil;
    try
        try
            myFile := TiniFile.Create(apppath + sPrintTemplateDir + postype + '.ini');
            //pageWidth := myFile.ReadInteger('printpage','width',0);
            //pageHeight := myFile.ReadInteger('printpage','height',0);

            bgvisible := myFile.ReadBool('title', 'visible', false);
            bgname := myFile.ReadString('title', 'titlename', '');
            //bgleft := myFile.ReadInteger('title','left',0);
            //bgtop := myFile.ReadInteger('title','top',0);
            //bgwidth := myFile.ReadInteger('title','width',0);
            //bgheight := myFile.ReadInteger('title','height',0);

            //bgvisible:= myFile.ReadBool('background','visible',false);
            //bgname:= myFile.readString('background','name','');

            photoVisible := myFile.ReadBool('photo', 'visible', false);
            photoWidth := myFile.ReadInteger('photo', 'width', 0);
            photoHeight := myFile.ReadInteger('photo', 'height', 0);
            photoTop := myFile.ReadInteger('photo', 'top', 0);
            photoLeft := myFile.ReadInteger('photo', 'left', 0);

            cardtypevisible := myFile.ReadBool('cardtypefont', 'visible', false);
            cardtypename := myFile.readString('cardtypefont', 'cardtypename', '');
            cardtypeleft := myFile.ReadInteger('cardtypefont', 'left', 0);
            cardtypetop := myFile.ReadInteger('cardtypefont', 'top', 0);
            cardtypewidth := myFile.ReadInteger('cardtypefont', 'width', 0);
            cardtypeheight := myFile.ReadInteger('cardtypefont', 'height', 0);
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
            conttit1left := myFile.ReadInteger('contexttitle1', 'left', 0);
            conttit1top := myFile.ReadInteger('contexttitle1', 'top', 0);

            conttit2visible := myFile.ReadBool('contexttitle2', 'visible', false);
            conttit2name := myFile.readString('contexttitle2', 'name', '');
            conttit2left := myFile.ReadInteger('contexttitle2', 'left', 0);
            conttit2top := myFile.ReadInteger('contexttitle2', 'top', 0);

            conttit3visible := myFile.ReadBool('contexttitle3', 'visible', false);
            conttit3name := myFile.readString('contexttitle3', 'name', '');
            conttit3left := myFile.ReadInteger('contexttitle3', 'left', 0);
            conttit3top := myFile.ReadInteger('contexttitle3', 'top', 0);

            conttit4visible := myFile.ReadBool('contexttitle4', 'visible', false);
            conttit4name := myFile.readString('contexttitle4', 'name', '');
            conttit4left := myFile.ReadInteger('contexttitle4', 'left', 0);
            conttit4top := myFile.ReadInteger('contexttitle4', 'top', 0);

            conttit5visible := myFile.ReadBool('contexttitle5', 'visible', false);
            conttit5name := myFile.readString('contexttitle5', 'name', '');
            conttit5left := myFile.ReadInteger('contexttitle5', 'left', 0);
            conttit5top := myFile.ReadInteger('contexttitle5', 'top', 0);

            contnameVisible := myFile.ReadBool('cont_name', 'visible', false);
            contnameTop := myFile.ReadInteger('cont_name', 'top', 0);
            contnameLeft := myFile.ReadInteger('cont_name', 'left', 0);

            conttypeVisible := myFile.ReadBool('cont_type', 'visible', false);
            conttypeTop := myFile.ReadInteger('cont_type', 'top', 0);
            conttypeLeft := myFile.ReadInteger('cont_type', 'left', 0);

            contcustNoVisible := myFile.ReadBool('cont_custno', 'visible', false);
            contcustNoTop := myFile.ReadInteger('cont_custno', 'top', 0);
            contcustNoLeft := myFile.ReadInteger('cont_custno', 'left', 0);

            stuempnoVisible := myFile.ReadBool('cont_stuempno', 'visible', false);
            stuempnoTop := myFile.ReadInteger('cont_stuempno', 'top', 0);
            stuempnoLeft := myFile.ReadInteger('cont_stuempno', 'left', 0);

            deptVisible := myFile.ReadBool('cont_dept', 'visible', false);
            deptTop := myFile.ReadInteger('cont_dept', 'top', 0);
            deptLeft := myFile.ReadInteger('cont_dept', 'left', 0);

            specVisible := myFile.ReadBool('cont_spec', 'visible', false);
            specTop := myFile.ReadInteger('cont_spec', 'top', 0);
            specLeft := myFile.ReadInteger('cont_spec', 'left', 0);

            cardNoVisible := myFile.ReadBool('cont_cardno', 'visible', false);
            cardNoTop := myFile.ReadInteger('cont_cardno', 'top', 0);
            cardNoLeft := myFile.ReadInteger('cont_cardno', 'left', 0);

            classNoVisible := myFile.ReadBool('cont_classno', 'visible', false);
            classNoTop := myFile.ReadInteger('cont_classno', 'top', 0);
            classNoLeft := myFile.ReadInteger('cont_classno', 'left', 0);

            extField1Visible := myFile.ReadBool('ext_field1', 'visible', false);
            extField1Top := myFile.ReadInteger('ext_field1', 'top', 0);
            extField1Left := myFile.ReadInteger('ext_field1', 'left', 0);

            extField2Visible := myFile.ReadBool('ext_field2', 'visible', false);
            extField2Top := myFile.ReadInteger('ext_field2', 'top', 0);
            extField2Left := myFile.ReadInteger('ext_field2', 'left', 0);

            foot1name := myFile.readString('foot1', 'name', '');
            foot1fontsize := myFile.ReadInteger('foot1', 'fontsize', 0);
            foot1fontname := myFile.readString('foot1', 'fontname', '');
            foot1fontstyle := myFile.readString('foot1', 'fontstyle', '');
            foot1left := myFile.ReadInteger('foot1', 'left', 0);
            foot1top := myFile.ReadInteger('foot1', 'top', 0);
            foot1height := myFile.ReadInteger('foot1', 'height', 0);
            foot1width := myFile.ReadInteger('foot1', 'width', 0);
            foot1visible := myFile.ReadBool('foot1', 'visible', false);

            foot2name := myFile.readString('foot2', 'name', '');
            foot2fontsize := myFile.ReadInteger('foot2', 'fontsize', 0);
            foot2fontname := myFile.readString('foot2', 'fontname', '');
            foot2fontstyle := myFile.readString('foot2', 'fontstyle', '');
            foot2left := myFile.ReadInteger('foot2', 'left', 0);
            foot2top := myFile.ReadInteger('foot2', 'top', 0);
            foot2height := myFile.ReadInteger('foot2', 'height', 0);
            foot2width := myFile.ReadInteger('foot2', 'width', 0);
            foot2visible := myFile.ReadBool('foot2', 'visible', false);

            line1visible := myFile.ReadBool('line1', 'visible', false);
            line1left := myFile.ReadInteger('line1', 'left', 0);
            line1top := myFile.ReadInteger('line1', 'top', 0);
            line1width := myFile.ReadInteger('line1', 'width', 0);

            line2visible := myFile.ReadBool('line2', 'visible', false);
            line2left := myFile.ReadInteger('line2', 'left', 0);
            line2top := myFile.ReadInteger('line2', 'top', 0);
            line2width := myFile.ReadInteger('line2', 'width', 0);

            line3visible := myFile.ReadBool('line3', 'visible', false);
            line3left := myFile.ReadInteger('line3', 'left', 0);
            line3top := myFile.ReadInteger('line3', 'top', 0);
            line3width := myFile.ReadInteger('line3', 'width', 0);

            line4visible := myFile.ReadBool('line4', 'visible', false);
            line4left := myFile.ReadInteger('line4', 'left', 0);
            line4top := myFile.ReadInteger('line4', 'top', 0);
            line4width := myFile.ReadInteger('line4', 'width', 0);

            line5visible := myFile.ReadBool('line5', 'visible', false);
            line5left := myFile.ReadInteger('line5', 'left', 0);
            line5top := myFile.ReadInteger('line5', 'top', 0);
            line5width := myFile.ReadInteger('line5', 'width', 0);

            linewidth := myFile.ReadInteger('linewidth', 'width', 0);
        finally
            myFile.Free;
        end;
    except
        on e: Exception do
            ShowMessage('读取配置文件错误--' + e.Message);
    end;
end;

procedure TfrmCardPrintTemp_W.setCardPosition(cardType: string);
begin
    readPositionInfo(cardType);

    //标题图片设置
    try
        if bgvisible then begin
            if Trim(cbbBackGround.Text) = '' then
                imgBG.Picture.LoadFromFile(apppath + sPrintTemplateDir + bgname)
            else
                imgBG.Picture.LoadFromFile(apppath + sPrintTemplateDir + trim(cbbBackGround.Text));
        end;
    except
        ShowMessage('找不到默认的背景，请查看设置是否正确！');
    end;
    //imgBG.Top := bgtop;
    //imgBG.Left := bgleft;
    //imgBG.Width := bgwidth;
    //imgBG.Height := bgheight;
    imgBG.Visible := bgvisible;
    imgBG.Enabled := bgvisible;

    //照片位置设置
    imgPhoto.Width := photoWidth;
    imgPhoto.Height := photoHeight;
    imgPhoto.Left := photoLeft;
    imgPhoto.Top := photoTop;
    imgPhoto.Visible := photoVisible;
    imgPhoto.Enabled := photoVisible;

    //卡片类型设置
    lblCardType.Caption := cardtypename;
    lblCardType.Font.Size := cardtypefontsize;
    lblCardType.Font.Name := cardtypefontname;
    lblCardType.Font.Style := getFontStyles(cardtypestype);
    lblCardType.Left := cardtypeleft;
    lblCardType.Top := cardtypetop;
    lblCardType.Width := cardtypewidth;
    lblCardType.Height := cardtypeheight;
    lblCardType.Visible := cardtypevisible;
    lblCardType.Enabled := cardtypevisible;

    //打印题头字体设置
    lbl1.Font.Name := contfontname;
    lbl1.Font.Size := contfontsize;
    lbl1.Font.Style := getFontStyles(contfontstyle);
    lbl1.Width := contfontwidth;
    lbl1.Height := contfontheight;
    lbl1.Left := conttit1left;
    lbl1.Top := conttit1top;
    lbl1.Caption := conttit1name;
    lbl1.Visible := conttit1visible;
    lbl1.Enabled := conttit1visible;

    lbl2.Font.Name := contfontname;
    lbl2.Font.Size := contfontsize;
    lbl2.Font.Style := getFontStyles(contfontstyle);
    lbl2.Width := contfontwidth;
    lbl2.Height := contfontheight;
    lbl2.Left := conttit2left;
    lbl2.Top := conttit2top;
    lbl2.Caption := conttit2name;
    lbl2.Visible := conttit2visible;
    lbl2.Enabled := conttit2visible;
    //lbl2.Font.Style
    lbl3.Font.Name := contfontname;
    lbl3.Font.Size := contfontsize;
    lbl3.Font.Style := getFontStyles(contfontstyle);
    lbl3.Width := contfontwidth;
    lbl3.Height := contfontheight;
    lbl3.Left := conttit3left;
    lbl3.Top := conttit3top;
    lbl3.Caption := conttit3name;
    lbl3.Visible := conttit3visible;
    lbl3.Enabled := conttit3visible;

    lbl4.Font.Name := contfontname;
    lbl4.Font.Size := contfontsize;
    lbl4.Font.Style := getFontStyles(contfontstyle);
    lbl4.Width := contfontwidth;
    lbl4.Height := contfontheight;
    lbl4.Left := conttit4left;
    lbl4.Top := conttit4top;
    lbl4.Caption := conttit4name;
    lbl4.Visible := conttit4visible;
    lbl4.Enabled := conttit4visible;

    lbl5.Font.Name := contfontname;
    lbl5.Font.Size := contfontsize;
    lbl5.Font.Style := getFontStyles(contfontstyle);
    lbl5.Width := contfontwidth;
    lbl5.Height := contfontheight;
    lbl5.Left := conttit5left;
    lbl5.Top := conttit5top;
    lbl5.Caption := conttit5name;
    lbl5.Visible := conttit5visible;
    lbl5.Enabled := conttit5visible;


    lblStuempNo.Visible := stuempnoVisible;
    lblStuempNo.Enabled := stuempnoVisible;
    lblStuempNo.Font.Size := fontSize;
    lblStuempNo.Font.Name := fontName;
    lblStuempNo.Font.Style := getFontStyles(fontStyle);
    lblStuempNo.Width := fontWidth;
    lblStuempNo.Height := fontHeight;
    lblStuempNo.Top := stuempnoTop;
    lblStuempNo.Left := stuempnoLeft;

    lblname.Visible := contnameVisible;
    lblname.Enabled := contnameVisible;
    lblname.Font.Size := fontSize;
    lblname.Font.Name := fontName;
    lblname.Font.Style := getFontStyles(fontStyle);
    lblname.Width := fontWidth;
    lblname.Height := fontHeight;
    lblname.Top := contnameTop;
    lblname.Left := contnameLeft;

    lbltype.Visible := conttypeVisible;
    lbltype.Enabled := conttypeVisible;
    lbltype.Font.Size := fontSize;
    lbltype.Font.Name := fontName;
    lbltype.Font.Style := getFontStyles(fontStyle);
    lbltype.Width := fontWidth;
    lbltype.Height := fontHeight;
    lbltype.Top := conttypeTop;
    lbltype.Left := conttypeLeft;

    lbldept.Visible := deptVisible;
    lbldept.Enabled := deptVisible;
    lbldept.Font.Size := fontSize;
    lbldept.Font.Name := fontName;
    lbldept.Font.Style := getFontStyles(fontStyle);
    lbldept.Width := fontWidth;
    lbldept.Height := fontHeight;
    lbldept.Top := deptTop;
    lbldept.Left := deptLeft;

    lblspec.Visible := specVisible;
    lblspec.Enabled := specVisible;
    lblspec.Font.Size := fontSize;
    lblspec.Font.Name := fontName;
    lblspec.Font.Style := getFontStyles(fontStyle);
    lblspec.Width := fontWidth;
    lblspec.Height := fontHeight;
    lblspec.Top := specTop;
    lblspec.Left := specLeft;

    lblCardNo.Visible := CardNoVisible;
    lblCardNo.Enabled := CardNoVisible;
    lblCardNo.Font.Size := fontSize;
    lblCardNo.Font.Name := fontName;
    lblCardNo.Font.Style := getFontStyles(fontStyle);
    lblCardNo.Width := fontWidth;
    lblCardNo.Height := fontHeight;
    lblCardNo.Top := CardNoTop;
    lblCardNo.Left := CardNoLeft;

    lblClassName.Visible := classNoVisible;
    lblClassName.Enabled := classNoVisible;
    lblClassName.Font.Size := fontSize;
    lblClassName.Font.Name := fontName;
    lblClassName.Font.Style := getFontStyles(fontStyle);
    lblClassName.Width := fontWidth;
    lblClassName.Height := fontHeight;
    lblClassName.Top := classNoTop;
    lblClassName.Left := classNoLeft;

    lbl6.Visible := extField1Visible;
    lbl6.Enabled := extField1Visible;
    lbl6.Font.Size := fontSize;
    lbl6.Font.Name := fontName;
    lbl6.Font.Style := getFontStyles(fontStyle);
    lbl6.Width := fontWidth;
    lbl6.Height := fontHeight;
    lbl6.Top := extField1Top;
    lbl6.Left := extField1Left;

    lbl7.Visible := extField2Visible;
    lbl7.Enabled := extField2Visible;
    lbl7.Font.Size := fontSize;
    lbl7.Font.Name := fontName;
    lbl7.Font.Style := getFontStyles(fontStyle);
    lbl7.Width := fontWidth;
    lbl7.Height := fontHeight;
    lbl7.Top := extField2Top;
    lbl7.Left := extField2Left;
    //脚设置
    lblFoot1.Caption := foot1name;
    lblFoot1.Font.Name := foot1fontname;
    lblFoot1.Font.Size := foot1fontsize;
    lblFoot1.Font.Style := getFontStyles(foot1fontstyle);
    lblFoot1.Width := foot1width;
    lblFoot1.Height := foot1height;
    lblFoot1.Left := foot1left;
    lblFoot1.Top := foot1top;
    lblFoot1.Visible := foot1visible;
    lblFoot1.Enabled := foot1visible;

    lblFoot2.Caption := foot2name;
    lblFoot2.Font.Name := foot2fontname;
    lblFoot2.Font.Size := foot2fontsize;
    lblFoot2.Font.Style := getFontStyles(foot2fontstyle);
    lblFoot2.Width := foot2width;
    lblFoot2.Height := foot2height;
    lblFoot2.Left := foot2left;
    lblFoot2.Top := foot2top;
    lblFoot2.Visible := foot2visible;
    lblFoot2.Enabled := foot2visible;

    //线的设置
    shp1.Visible := line1visible;
    shp1.Enabled := line1visible;
    shp1.Top := line1top;
    shp1.Left := line1left;
    shp1.Width := line1width;
    shp1.Height := linewidth;
    shp1.Pen.Width := linewidth;

    shp2.Visible := line2visible;
    shp2.Enabled := line2visible;
    shp2.Top := line2top;
    shp2.Left := line2left;
    shp2.Width := line2width;
    shp2.Height := linewidth;
    shp2.Pen.Width := linewidth;

    shp3.Visible := line3visible;
    shp3.Enabled := line3visible;
    shp3.Top := line3top;
    shp3.Left := line3left;
    shp3.Width := line3width;
    shp3.Height := linewidth;
    shp3.Pen.Width := linewidth;

    shp4.Visible := line4visible;
    shp4.Enabled := line4visible;
    shp4.Top := line4top;
    shp4.Left := line4left;
    shp4.Width := line4width;
    shp4.Height := linewidth;
    shp4.Pen.Width := linewidth;

    shp5.Visible := line5visible;
    shp5.Enabled := line5visible;
    shp5.Top := line5top;
    shp5.Left := line5left;
    shp5.Width := line5width;
    shp5.Height := linewidth;
    shp5.Pen.Width := linewidth;
    {}
end;

procedure TfrmCardPrintTemp_W.FormShow(Sender: TObject);
var
    sqlstr: string;
begin
    Self.Caption := cardType;
    setCardPosition(cardType);

    sqlStr := 'select ' + areaName + ',' + areaNo + ' from ' + tblArea;
    sqlStr := sqlStr + ' where ' + areaFather + '=1 order by ' + areaNo;
    AddData(cbbArea, sqlStr);
    cbbBackGround.Items.Clear;
    cbbBackGround.Items.LoadFromFile(apppath + sPrintTemplateDir + 'background.txt');
end;

procedure TfrmCardPrintTemp_W.queryBaseInfo(sstuempNo, sareaId, scustId: string);
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
            lblName.Caption := Trim(qryExecSQL.fieldbyname(custName).AsString);
            lblStuempNo.Caption := Trim(qryExecSQL.fieldbyname(stuempNo).AsString);
            lblType.Caption := getTypeName(Trim(qryExecSQL.fieldbyname(custType).AsString));
            lblDept.Caption := getDeptName(Trim(qryExecSQL.fieldbyname(custDeptNo).AsString));
            lblSpec.Caption := getSName(Trim(qryExecSQL.fieldbyname(custSpecNo).AsString));
            //加入身份证号和卡号
            lblCardNo.Caption := getCardNo(Trim(qryExecSQL.fieldbyname(custId).AsString));
            //加入班级
            lblClassName.Caption := Trim(qryExecSQL.fieldbyname(classNo).AsString);
            //lbl6.Caption := Trim(qryExecSQL.fieldbyname(extField1).AsString);
            lbl6.Caption := '';
            lbl7.Caption := Trim(qryExecSQL.fieldbyname(extField2).AsString);
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

procedure TfrmCardPrintTemp_W.btnQueryClick(Sender: TObject);
begin
    if (Trim(edtStuempNo.Text) = '') and (cbbArea.Text = '') and (Trim(edtCustNo.Text) = '') then begin
        ShowMessage('请输入查询条件，然后再查询！');
        edtStuempNo.SetFocus;
        Exit;
    end;
    queryBaseInfo(Trim(edtStuempNo.Text), subString(cbbArea.Text, '-', 'l'), Trim(edtCustNo.Text));
    btnPrint.Enabled := True;
end;

procedure TfrmCardPrintTemp_W.btnExitClick(Sender: TObject);
begin
    close;
end;

procedure TfrmCardPrintTemp_W.updateMakeCardInfo;
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

procedure TfrmCardPrintTemp_W.lblPreviewClick(Sender: TObject);
begin
    Self.Caption := cardType;
    setCardPosition(cardType);

end;

{-------------------------------------------------------------------------------
  过程名:    TfrmCardPrintTemp.getFontStyles取得字体style属性
  参数:      styles: string
  返回值:    TFontStyles
-------------------------------------------------------------------------------}

function TfrmCardPrintTemp_W.getFontStyles(styles: string): TFontStyles;
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

procedure TfrmCardPrintTemp_W.btnDetailQClick(Sender: TObject);
begin
    if judgelimit(loginLimit, Mdl_photoQuery) = False then begin
        ShowMessage('你没有操作该项的权限！');
        Exit;
    end;
    frmPhotoQuery := TfrmPhotoQuery.Create(nil);
    ifMakeCard := False;
    frmPhotoQuery.btnPhoto.Enabled := False;
    frmPhotoQuery.wType := 'w';
    frmPhotoQuery.ShowModal;
    if ifMakeCard then begin
        queryBaseInfo('', '', IntToStr(iCustId));
        btnPrint.Enabled := True;
    end;
    frmPhotoQuery.Free;

end;

procedure TfrmCardPrintTemp_W.cbbBackGroundChange(Sender: TObject);
begin
    //标题图片设置
    try
        if bgvisible then
            imgBG.Picture.LoadFromFile(apppath + sPrintTemplateDir + trim(cbbBackGround.Text));
    except
        ShowMessage('找不到指定的背景，请查看配置是否正确！');
    end;
end;

procedure TfrmCardPrintTemp_W.btnPBackGClick(Sender: TObject);
var
    t1: TRMPictureView;
begin
    //打印背景
    rpt1.LoadFromFile(apppath + sPrintTemplateDir + 'print.rmf');
    t1 := TRMPictureView(rpt1.FindObject('Picture1'));
    if t1 <> nil then begin
        try
            if Trim(cbbBackGround.Text) = '' then
                t1.Picture.LoadFromFile(apppath + sPrintTemplateDir + bgname)
            else
                t1.Picture.LoadFromFile(apppath + sPrintTemplateDir + trim(cbbBackGround.Text));
        except
            ShowMessage('找不到指定的背景，请查看配置是否正确！');
            Exit;
        end;
    end;
    rpt1.ShowReport;

end;

end.

