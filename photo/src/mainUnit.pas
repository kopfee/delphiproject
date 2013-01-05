unit mainUnit;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, Menus, ExtCtrls, StdCtrls, Buttons, ComCtrls,
    jpeg, DB, ADODB, DBCtrls, imageenio, ieview, imageenview,
    hyieutils, ieopensavedlg, imageenproc, ievect, videocap,
    PSCAMLIB,
    MemDS, ShellAPI, DBGridEh, DSPack, DBAccess, Ora, GridsEh, Mask,
    DBCtrlsEh, DBLookupEh, RzButton,
    DirectShow9, ActiveX, DSUtil;

type
    TfrmMain = class(TForm)
        mm1: TMainMenu;
        N1: TMenuItem;
        N3: TMenuItem;
        N4: TMenuItem;
        N5: TMenuItem;
        N6: TMenuItem;
        N7: TMenuItem;
        N8: TMenuItem;
        N9: TMenuItem;
        N10: TMenuItem;
        N11: TMenuItem;
        N13: TMenuItem;
        N14: TMenuItem;
        N15: TMenuItem;
        N16: TMenuItem;
        N17: TMenuItem;
        ImageEnIO1: TImageEnIO;
        opnmgndlg: TOpenImageEnDialog;
        N2: TMenuItem;
        N18: TMenuItem;
        N19: TMenuItem;
        N20: TMenuItem;
        svmgndlg1: TSaveImageEnDialog;
        N21: TMenuItem;
        N22: TMenuItem;
        pnlPhotoInfo: TPanel;
        pnlPhoto: TPanel;
        imgPhoto: TImage;
        pnlOperator: TPanel;
        grp1: TGroupBox;
        btnEditInfo: TButton;
        btnDelPhoto: TButton;
        grp2: TGroupBox;
        Label13: TLabel;
        lblCustNo: TLabel;
        lblStuEmpNo: TLabel;
        Label1: TLabel;
        lbl1: TLabel;
        lblName: TLabel;
        lblType: TLabel;
        Label4: TLabel;
        Label5: TLabel;
        lblArea: TLabel;
        lblDept: TLabel;
        Label2: TLabel;
        Label3: TLabel;
        lblSpec: TLabel;
        lblState: TLabel;
        Label6: TLabel;
        Label7: TLabel;
        lblRegDate: TLabel;
        lblCardId: TLabel;
        Label8: TLabel;
        bvl1: TBevel;
        Bevel1: TBevel;
        Bevel2: TBevel;
        Bevel3: TBevel;
        Bevel4: TBevel;
        Bevel5: TBevel;
        Bevel6: TBevel;
        Bevel7: TBevel;
        Bevel8: TBevel;
        bvlCustId: TBevel;
        pnlRight: TPanel;
        pnl3: TPanel;
        pnlLeft: TPanel;
        grp3: TGroupBox;
        Label10: TLabel;
        Label11: TLabel;
        edtStuempNo: TEdit;
        btnQuery: TBitBtn;
        btnCustQuery: TBitBtn;
        ImageEnProc1: TImageEnProc;
        ImageEnProc2: TImageEnProc;
        shpL: TShape;
        shpT: TShape;
        shpR: TShape;
        shpB: TShape;
        shpA: TShape;
        NPrint_W: TMenuItem;
        qryPhoto: TOraQuery;
        pmDev: TPopupMenu;
        N111: TMenuItem;
        SampleGrabber1: TSampleGrabber;
        FilterGraph1: TFilterGraph;
        Filter1: TFilter;
        VideoWindow1: TVideoWindow;
        N221: TMenuItem;
        btn1: TButton;
        cbbMenu: TComboBox;
        grpCam: TGroupBox;
        btnCamFormat: TButton;
        btnSetCam: TButton;
        btnCamClose: TButton;
        btnConnCam: TRzMenuButton;
        shpSelect: TShape;
        imgShow: TImageEnVect;
        btnPhoto: TButton;
        GroupBox1: TGroupBox;
        btnSavePhoto: TButton;
        btnSaveAs: TButton;
        btnGetPhoto: TBitBtn;
        btnOpenPictrue: TBitBtn;
        dsQuery: TDataSource;
        cbbArea: TDBLookupComboboxEh;
        dsArea: TDataSource;
        dbgCustomer: TDBGridEh;
        N12: TMenuItem;
        procedure N11Click(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure btnQueryClick(Sender: TObject);
        procedure N8Click(Sender: TObject);
        procedure N9Click(Sender: TObject);
        procedure btnDelPhotoClick(Sender: TObject);
        procedure N16Click(Sender: TObject);
        procedure btnEditInfoClick(Sender: TObject);
        procedure N5Click(Sender: TObject);
        procedure N14Click(Sender: TObject);
        procedure N3Click(Sender: TObject);
        procedure btnSavePhotoClick(Sender: TObject);
        procedure N6Click(Sender: TObject);
        procedure btnOpenPictrueClick(Sender: TObject);
        procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
        procedure btnPhotoClick(Sender: TObject);
        procedure btnCamCloseClick(Sender: TObject);
        procedure imgCamViewChange(Sender: TObject; Change: Integer);
        procedure btnSetCamClick(Sender: TObject);
        procedure btnCamFormatClick(Sender: TObject);
        procedure N18Click(Sender: TObject);
        procedure N19Click(Sender: TObject);
        procedure N20Click(Sender: TObject);
        procedure btnPhotoShowClick(Sender: TObject);
        procedure btnPhotoCloseClick(Sender: TObject);
        procedure trckbr1Change(Sender: TObject);
        procedure btnSetParamClick(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure shpSelectMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure shpSelectMouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure shpSelectMouseUp(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure btnSaveAsClick(Sender: TObject);
        procedure N21Click(Sender: TObject);
        procedure N15Click(Sender: TObject);
        procedure N22Click(Sender: TObject);
        procedure btnGetPhotoClick(Sender: TObject);
        procedure N23Click(Sender: TObject);
        procedure edtStuempNoKeyDown(Sender: TObject; var Key: Word;
            Shift: TShiftState);
        procedure btn1Click(Sender: TObject);
        procedure dbgCustomerCellClick(Column: TColumnEh);
        procedure N12Click(Sender: TObject);
    private
        { Private declarations }
        //FCap : TCapture;
        camType: string; //相机类型，canon为数码相机，cam为摄像头
        shpSelectLeft: Integer;
        m_p1, setRemoteParam: psRemoteReleaseParameters;
        m_connect: boolean;
        procedure clearCaption();

        procedure fillCbb();

        procedure queryBaseInfo(sstuempNo: string; sareaId: string; scustId: string);

        procedure queryPhoto(scustId: string);

        procedure cutPhoto(savePhotoName: string);

        procedure VideoFrame(Sender: TObject; Bitmap: TIEDibBitmap);

        procedure drawShpSelect();

        procedure setViewBoxPosi(leftP: Integer);

        procedure saveCononPhotoToDisk();

        procedure setViewBoxVisible(param: Boolean);

        procedure getPrintMenu(sender: TObject);

        procedure openPrintM(sender: TObject);

        procedure getPrintMenu_W(sender: TObject);

        procedure openPrintM_W(sender: TObject);
        //设置相机参数
        function getImageSizeAndQuality(inData: Integer): Integer;
        procedure setImageSize(inData: Integer);
        procedure setImageQuality(inData: Integer);
        procedure setWhiteBalance(inData: Integer);
        procedure setISO(inData: Integer);
        procedure setFlash(inData: Integer);
        procedure setPhotoEffect(inData: Integer);
        procedure queryData;
    public
        { Public declarations }
        iCustId: Integer;
        ifPhoto: Boolean;
        procedure OnSelectDevice(sender: TObject);
    end;

var
    frmMain: TfrmMain;
    yPos: integer;
    xPos: integer;
    leftMouse: boolean;
    hWndC: THandle;
    SysDev: TSysDevEnum;

procedure ViewfinerCallbackFunction(buf_adr: pointer; buf_size: integer); cdecl;
procedure ProgressCallbackFunction(p: integer); cdecl;

implementation


uses uConst, uCommon, Udm, uImport, uExport, uAddCustInfo, uPhotoStat,
    uAbout, uLimit, Ulogin, uPhotoQuery, uModifyPwd, uCustImport,
    uGetPhotoSet, uCardPrintTemp, uPatchMakeCard, TLoggerUnit,
    uCardPrintTemp_W;

{$R *.dfm}

{ TfrmMain }

procedure ViewfinerCallbackFunction(buf_adr: pointer; buf_size: integer); cdecl;
var mem_stream: TMemoryStream;
    Jpg: TJpegImage;
begin
    try
        try
            try
                mem_stream := TMemoryStream.Create;
                mem_stream.Write(buf_adr^, buf_size);
            except on e: Exception do begin
                    TLogger.GetInstance.Debug('连接相机错误--' + e.Message);
                    ShowMessage(e.Message + '--该错误可能是由硬件冲突引起的，请使用相机自带的拍照软件！');
                end;
            end;
            try
                Jpg := TJpegImage.Create;
                try
                    mem_stream.Position := 0;
                    Jpg.LoadFromStream(mem_stream);
                except on e1: Exception do
                        ShowMessage(e1.Message + '--硬件冲突，请使用相机自带的拍照软件！');
                end;
                //frmMain.imgCanon.picture.Assign(Jpg);
            finally
                Jpg.Free;
            end;
        finally
            mem_stream.Free;
        end;
    except
        on e: Exception do begin
            TLogger.GetInstance.Debug('驱动错误--' + e.Message);
            ShowMessage('可能是驱动问题，请重新打开数码相机试试...');
        end;
    end;
end;

procedure ProgressCallbackFunction(p: integer); cdecl;
begin

end;

procedure TfrmMain.N11Click(Sender: TObject);
begin
    frmPatchMakeCard := TfrmPatchMakeCard.Create(nil);
    frmPatchMakeCard.ShowModal;
    frmPatchMakeCard.Free;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
    apppath := ExtractFilePath(Application.ExeName);
    getphotoconfigs;
    //frmMain.BorderStyle := bsToolWindow;
    //frmMain.BorderStyle := bsSingle;
    if useRemoteSoft = True then begin
        pnlRight.Visible := False;
        btnGetPhoto.Visible := True;
        btnPhoto.Visible := False;
        frmMain.Width := 620;
        try
            delFileBat(photopath, '*.jpg');
        except
        end;
    end
    else if useRemoteSoft = false then begin
        frmMain.Width := 1024;
        pnlRight.Visible := True;
        btnGetPhoto.Visible := False;
        btnPhoto.Visible := True;
    end;

end;

procedure TfrmMain.clearCaption;
begin
    lblStuempNo.Caption := '';
    lblName.Caption := '';
    lblType.Caption := '';
    lblArea.Caption := '';
    lblCardId.Caption := '';
    lblDept.Caption := '';
    lblRegDate.Caption := '';
    lblSpec.Caption := '';
    lblState.Caption := '';
    lblCustNo.Caption := '';
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
    i: integer;
    Device: TMenuItem;
begin
    TLogger.GetInstance.Debug('开始登陆制卡中心');
    loginform := TloginForm.Create(nil);
    loginform.Caption := Application.Title + '--' + loginform.Caption;
    if (loginform.ShowModal = mrOK) then
        loginform.Free;

    frmMain.Top := -1;
    frmMain.Left := -1;
    frmMain.Height := 730;

    frmMain.Caption := Application.Title + '-' + loginName;
    clearCaption();
    TLogger.GetInstance.Debug('开始加载打印菜单');
    fillCbb();
    btnDelPhoto.Enabled := False;
    btnEditInfo.Enabled := False;
    btnSavePhoto.Enabled := False;
    shpSelect.Visible := False;
    shpL.Visible := False;
    shpT.Visible := False;
    shpR.Visible := False;
    shpB.Visible := False;
    shpA.Visible := False;
    getPrintMenu(Sender);
    getPrintMenu_w(Sender);
    TLogger.GetInstance.Debug('[' + loginName + ']登陆成功');

    SysDev := TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);
    pmDev.items.clear;
    if SysDev.CountFilters > 0 then begin
        for i := 0 to SysDev.CountFilters - 1 do begin
            Device := TMenuItem.Create(pmDev);
            Device.Caption := SysDev.Filters[i].FriendlyName;
            Device.Tag := i;
            Device.OnClick := OnSelectDevice;
            pmDev.items.Add(Device);
        end;
    end
    else begin
        btnConnCam.Enabled := false;
        btnCamClose.Enabled := false;
    end;

    dbgCustomer.Columns[0].FieldName := custId;
    dbgCustomer.Columns[1].FieldName := stuempNo;
    dbgCustomer.Columns[2].FieldName := custName;
    dbgCustomer.Columns[3].FieldName := deptName;
    dbgCustomer.Columns[4].FieldName := custCardId;

end;

procedure TfrmMain.OnSelectDevice(sender: TObject);
begin
    FilterGraph1.ClearGraph;
    FilterGraph1.Active := false;
    Filter1.BaseFilter.Moniker := SysDev.GetMoniker(TMenuItem(Sender).tag);
    FilterGraph1.Active := true;
    with FilterGraph1 as ICaptureGraphBuilder2 do
        RenderStream(@PIN_CATEGORY_PREVIEW, nil, Filter1 as IBaseFilter, SampleGrabber1 as IBaseFilter, VideoWindow1 as IbaseFilter);
    FilterGraph1.Play;

    shpSelect.Visible := true;
    //btnSetCam.Enabled := true;
    //btnCamFormat.Enabled := True;
    btnCamClose.Enabled := True;
    btnPhoto.Enabled := True;
    btnConnCam.Enabled := False;


    camType := 'cam';
end;

procedure TfrmMain.fillCbb;
begin
    frmdm.qryArea.Close;
    frmdm.qryArea.SQL.Clear;
    frmdm.qryArea.SQL.Add(areaQuery);
    frmdm.qryArea.Open;
    cbbArea.KeyField := areaNo;
    cbbArea.ListField := areaName;

end;

procedure TfrmMain.queryBaseInfo(sstuempNo: string; sareaId: string; scustId: string);
var
    sqlStr: string;
    qryExecSQL: TOraQuery;
    Fjpg: TJpegImage;
begin
    sqlStr := queryBaseInfoSql(sstuempNo, sareaId, scustId);
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
            lblCustNo.Caption := qryExecSQL.fieldbyname(custId).AsString;
            lblName.Caption := qryExecSQL.fieldbyname(custName).AsString;
            lblStuEmpNo.Caption := qryExecSQL.fieldbyname(stuempNo).AsString;


            lblType.Caption := getTypeName(qryExecSQL.fieldbyname(custType).AsString);
            lblArea.Caption := getAreaName(qryExecSQL.fieldbyname(custArea).AsString);
            lblDept.Caption := getDeptName(qryExecSQL.fieldbyname(custDeptNo).AsString);
            lblSpec.Caption := getSName(qryExecSQL.fieldbyname(custSpecNo).AsString);
            lblState.Caption := getStatesName(qryExecSQL.fieldbyname(custState).AsString);

            lblRegDate.Caption := qryExecSQL.fieldbyname(custRegTime).AsString;
            lblCardId.Caption := qryExecSQL.fieldbyname(custCardId).AsString;
            //执行照片库中信息插入操作
            insertPhotoData(Trim(lblCustNo.Caption), Trim(lblStuEmpNo.Caption));

            queryPhoto(qryExecSQL.fieldbyname(custId).AsString);

            Fjpg := getPhotoInfo(qryExecSQL.fieldbyname(custId).AsString);
            if Fjpg = nil then
                pnlphoto.Caption := '没有照片'
            else
                imgPhoto.Picture.Graphic := Fjpg;

            btnDelPhoto.Enabled := True;
            btnEditInfo.Enabled := True;
            if useRemoteSoft then
                btnGetPhoto.Enabled := True;
        end
        else begin
            clearCaption();
            ShowMessage('客户信息表无相关信息，请重新指定查询条件！');
        end;
    finally
        Fjpg.Free;
        qryExecSQL.Destroy;
    end;
end;

procedure TfrmMain.btnQueryClick(Sender: TObject);
begin
    if (Trim(edtStuempNo.Text) = '') and (cbbArea.Text = '') then begin
        ShowMessage('请输入查询条件，然后再查询！');
        edtStuempNo.SetFocus;
        Exit;
    end;
    queryData;
end;

procedure TfrmMain.queryData;
var
    sqlStr: string;
begin
    sqlStr := photoQuery;
    if edtStuEmpNo.Text <> '' then
        sqlStr := sqlStr + ' and cust.' + stuempNo + ' like ' + #39 + '%' + edtStuEmpNo.Text + '%' + #39;
    if cbbArea.Text <> '' then
        sqlStr := sqlStr + ' and cust.' + custArea + '=' + inttostr(cbbArea.KeyValue);
    {
    if edtName.Text <> '' then
        sqlStr := sqlStr + ' and cust.' + custName + ' like ' + #39 + '%' + edtname.Text + '%' + #39;
    if cbbDept.Text <> '' then
        sqlStr := sqlStr + ' and cust.' + custDeptNo + '=' + #39 + cbbdept.KeyValue + #39;
    if cbbType.Text <> '' then
        sqlStr := sqlStr + ' and cust.' + custType + '=' + inttostr(cbbType.KeyValue);
    if cbbSpec.Text <> '' then
        sqlStr := sqlStr + ' and cust.' + custSpecNo + '=' + #39 + cbbspec.KeyValue + #39;
    if edtCardId.Text <> '' then
        sqlStr := sqlStr + ' and cust.' + custCardId + '=' + #39 + trim(edtCardId.Text) + #39;

    }

    frmdm.qryQuery.Close;
    frmdm.qryQuery.SQL.Clear;
    frmdm.qryQuery.SQL.Add(sqlStr);
    frmdm.qryQuery.Prepared;
    frmdm.qryQuery.Open;
    if frmdm.qryQuery.IsEmpty then
        ShowMessage('没有你指定条件的数据，请重新选择统计条件！');
end;

procedure TfrmMain.N8Click(Sender: TObject);
begin
    if judgelimit(loginLimit, Mdl_import) = False then begin
        ShowMessage('你没有操作该项的权限！');
        Exit;
    end;
    frmImport := TfrmImport.Create(nil);
    frmImport.ShowModal;
    frmImport.Free;
end;

procedure TfrmMain.N9Click(Sender: TObject);
begin
    if judgelimit(loginLimit, Mdl_export) = False then begin
        ShowMessage('你没有操作该项的权限！');
        Exit;
    end;
    frmExport := TfrmExport.Create(nil);
    frmExport.ShowModal;
    frmExport.Free;
end;

procedure TfrmMain.queryPhoto(scustId: string);
var
    sqlstr: string;
begin
    sqlstr := 'select ' + custId + ',' + stuempNo + ',' + pPhoto + ',' + pminphoto + ',' + pPhotoDate + ',' + pPhotoDTime;
    sqlstr := sqlstr + ',' + pPhotoTime + ' from ' + tblPhoto + ' where ' + custId + '=' + scustId;
    qryPhoto.Close;
    qryPhoto.SQL.Clear;
    qryPhoto.SQL.Add(sqlstr);
    qryPhoto.Open;
end;

procedure TfrmMain.btnDelPhotoClick(Sender: TObject);
begin
    if judgelimit(loginLimit, Mdl_delphoto) = False then begin
        ShowMessage('你没有操作该项的权限！');
        Exit;
    end;
    if qryPhoto.IsEmpty then begin
        ShowMessage('没有你要查询的照片信息，无法删除！');
        Exit;
    end;
    if Application.MessageBox(PChar('你确定要删除照片信息吗？'), PChar(Application.Title), MB_ICONQUESTION + mb_yesno) = idno then
        Exit;
    qryPhoto.First;
    qryPhoto.Edit;
    qryPhoto.FieldByName(pPhotoDate).Assign(nil);
    qryPhoto.FieldByName(pPhotoTime).Assign(nil);
    qryPhoto.FieldByName(pPhoto).Assign(nil);
    qryPhoto.FieldByName(PMinPhoto).Assign(nil);
    qryPhoto.Post;
    imgPhoto.Picture.Graphic := nil;
end;

procedure TfrmMain.N16Click(Sender: TObject);
begin
    if judgelimit(loginLimit, Mdl_addCust) = False then begin
        ShowMessage('你没有操作该项的权限！');
        Exit;
    end;
    frmAddCustInfo := TfrmAddCustInfo.create(nil);
    frmAddCustInfo.operType := 'add';
    frmAddCustInfo.ShowModal;
    frmAddCustInfo.Free;
end;

procedure TfrmMain.btnEditInfoClick(Sender: TObject);
begin
    if judgelimit(loginLimit, Mdl_EditCust) = False then begin
        ShowMessage('你没有操作该项的权限！');
        Exit;
    end;
    if lblCustNo.Caption = '' then begin
        ShowMessage('请先查询要修改的人员信息，然后修改！');
        Exit;
    end;
    frmAddCustInfo := TfrmAddCustInfo.Create(nil);
    frmAddCustInfo.operType := 'edit';
    frmAddCustInfo.lblCustId.Caption := Trim(lblCustNo.Caption);
    frmAddCustInfo.ShowModal;
    frmAddCustInfo.Free;
end;

procedure TfrmMain.N5Click(Sender: TObject);
begin
    if judgelimit(loginLimit, Mdl_photoStat) = False then begin
        ShowMessage('你没有操作该项的权限！');
        Exit;
    end;
    frmPhotoStat := TfrmPhotoStat.Create(nil);
    frmPhotoStat.ShowModal;
    frmPhotoStat.Free;
end;

procedure TfrmMain.N14Click(Sender: TObject);
begin
    frmAbout := TfrmAbout.Create(nil);
    frmAbout.ShowModal;
    frmAbout.Free;
end;

procedure TfrmMain.N3Click(Sender: TObject);
begin
    if judgelimit(loginLimit, Mdl_limit) = False then begin
        ShowMessage('你没有操作该项的权限！');
        Exit;
    end;
    frmLimit := TfrmLimit.Create(nil);
    frmLimit.ShowModal;
    frmLimit.Free;
end;

procedure TfrmMain.btnSavePhotoClick(Sender: TObject);
var
    F: TmemoryStream;
    oldJpeg: TJPEGImage;
    FJpeg: TJpegImage;

    tmpBmp: TBitmap;
    OldGraphics: TBitmap;
    expJpg: TJPEGImage;
    FMin: TmemoryStream;
begin
    if judgelimit(loginLimit, mdl_savephoto) = False then begin
        ShowMessage('你没有操作该项的权限！');
        Exit;
    end;
    if qryPhoto.IsEmpty then begin
        ShowMessage('请先查出要保存照片的人员信息，然后再保存照片！');
        Exit;
    end;
    if imgShow.Bitmap = nil then begin
        ShowMessage('请先拍照或打开要保存的照片，然后再保存！');
        Exit;
    end;
    oldJpeg := getPhotoInfo(lblCustNo.Caption);
    if oldJpeg <> nil then
        if Application.MessageBox(PChar('客户号为[' + lblcustNo.Caption + ']姓名为[' + lblName.caption + ']的照片已经存在，你要覆盖以前的照片吗？'), PChar(Application.Title), MB_YESNO + mb_iconquestion) = idno then
            Exit;
    F := nil;
    FJpeg := nil;

    OldGraphics := nil;
    tmpBmp := nil;
    expJpg := nil;

    qryPhoto.Edit;
    try
        FJpeg := TJpegImage.Create;
        FJpeg.Assign(imgShow.Bitmap);
        F := TmemoryStream.Create;
        FJpeg.SaveToStream(F);
        if F.Size > 600000 then begin
            ShowMessage('该张照片过大，拍摄的照片请不要超过600K!');
            Exit;
        end;

        //保存小照片
        OldGraphics := TBitmap.Create;
        //先把jpg格式的照片转换为bmp格式
        OldGraphics.Assign(FJpeg);
        //重新定义照片的大小
        tmpBmp := TBitmap.Create;
        tmpBmp.Width := minWidth;
        tmpBmp.Height := minHeight;
        tmpBmp.Canvas.StretchDraw(Rect(0, 0, tmpBmp.Width, tmpBmp.Height), OldGraphics);

        //重新把照片转换为jpg格式
        expJpg := TJPEGImage.Create;
        expJpg.Assign(tmpBmp);
        FMin := TmemoryStream.Create;
        expJpg.SaveToStream(FMin);

        //保存到本地
        if not DirectoryExists(diskpath) then
            if CreateDir(diskpath) = False then
                ShowMessage('不能创建文件夹：' + diskPath + '请检查是否存在该磁盘！');
        try
            f.SaveToFile(diskpath + '\' + lblstuempno.Caption + '.jpg');
        except
        end;
        TBlobField(qryPhoto.FieldByName(pPhoto)).loadfromStream(F);
        TBlobField(qryPhoto.FieldByName(PMinPhoto)).loadfromStream(FMin);
        qryPhoto.FieldByName(pPhotoDate).asstring := formatdatetime('yyyymmdd', SysUtils.Date);
        qryPhoto.FieldByName(pPhotoTime).asstring := formatdatetime('HHMMSS', now);
        //加入精确时间，格式yyyymmddhhmmsszzz,现在支持oracle和db2-----------------------]]]]]]]]]]]]]
        qryPhoto.FieldByName(pPhotoDTime).asstring := getDbTime;


        qryPhoto.Post;
        imgShow.Assign(nil);
        //pnlPhotoMain.Caption := '照片保存成功';
        btnSavePhoto.Enabled := False;
        btnSaveAs.Enabled := False;
        queryBaseInfo('', '', lblCustNo.Caption);
        if useRemoteSoft then
            delFileBat(photopath, '*.jpg');
    finally
        F.Destroy;
        FJpeg.Destroy;
        OldGraphics.Destroy;
        tmpBmp.Destroy;
        expJpg.Destroy;
        FMin.Destroy;
    end;
end;

procedure TfrmMain.N6Click(Sender: TObject);
begin
    if judgelimit(loginLimit, Mdl_photoQuery) = False then begin
        ShowMessage('你没有操作该项的权限！');
        Exit;
    end;
    frmPhotoQuery := TfrmPhotoQuery.Create(nil);
    ifPhoto := False;
    frmPhotoQuery.btnMakeCard.Enabled := False;
    frmPhotoQuery.ShowModal;
    if ifPhoto then
        queryBaseInfo('', '', IntToStr(iCustId));
    frmPhotoQuery.Free;
end;

procedure TfrmMain.btnOpenPictrueClick(Sender: TObject);
begin
    if opnmgndlg.Execute then begin
        imgShow.IO.LoadFromFile(opnmgndlg.FileName);
        if rotate = True then begin
            imgShow.Proc.Rotate(angle, True, ierFast, -1);
            imgShow.Fit;
        end;
        btnSavePhoto.Enabled := True;
        btnSaveAs.Enabled := True;
    end;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    FilterGraph1.ClearGraph;
    FilterGraph1.Active := false;
    if Application.MessageBox('你确定要退出拍照/制卡管理系统吗？', PChar(Application.Title), MB_ICONQUESTION + mb_yesno) = idno then begin
        CanClose := False;
    end;
end;

procedure TfrmMain.btnPhotoClick(Sender: TObject);
begin
    if lblCustNo.Caption = '' then begin
        ShowMessage('请先查询出要拍照的人员，然后再拍照！');
        edtStuempNo.SetFocus;
        Exit;
    end;
    if camType = 'cam' then begin
        //SampleGrabber1.GetBitmap(Image1.Picture.Bitmap);
        SampleGrabber1.GetBitmap(imgShow.Bitmap);
        imgShow.Proc.Update;
        //imgShow.Fit;
    end
    else begin
        showmessage('没有合适照片拍摄设备，请检查设备是否连接正确！');
        Exit;
    end;
    btnSavePhoto.Enabled := True;
    btnSaveAs.Enabled := True;
end;

procedure TfrmMain.btnCamCloseClick(Sender: TObject);
begin
    //SysDev.Free;
    FilterGraph1.ClearGraph;
    FilterGraph1.Active := false;

    camType := '';
    btnConnCam.Enabled := True;
    btnPhoto.Enabled := False;
    btnSetCam.Enabled := False;
    btnCamFormat.Enabled := False;
    btnCamClose.Enabled := False;

end;

procedure TfrmMain.cutPhoto(savePhotoName: string);
var
    ExtendName: string;
    Srcjpeg, Destjpeg: Tjpegimage;
    //newbmp: TBitmap;
    SrcBmp, DestBmp: TBitmap;
    width, height, left: Integer;
begin
    SrcBmp := nil;
    DestBmp := nil;
    Srcjpeg := nil;
    Destjpeg := nil;
    ExtendName := ExtractFileExt(savePhotoName);
    try
        SrcBmp := TBitmap.Create;
        Srcjpeg := Tjpegimage.Create;
        if ExtendName = '.jpg' then begin
            Srcjpeg.LoadFromFile(savePhotoName);
            SrcBmp.Assign(Srcjpeg);
        end
        else if ExtendName = '.bmp' then begin
            SrcBmp.LoadFromFile(savePhotoName);
        end;

        height := SrcBmp.Height;
        width := Round(height * 3 / 4 + 0.5);
        left := Round(SrcBmp.Width * shpselectleft / imgW + 0.5);
        DestBmp := TBitmap.Create;
        DestBmp.Width := width;
        DestBmp.Height := height;

        DestBmp.Canvas.CopyRect(Rect(0, 0, width, height), SrcBmp.Canvas, Rect(left, 0, width + left, height));

        Destjpeg := TJPEGImage.Create;
        Destjpeg.Assign(DestBmp);
        Destjpeg.SaveToFile(savePhotoName);
        //DestBmp.SaveToFile(savePhotoName);
    finally
        SrcBmp.Free;
        DestBmp.Free;
        Srcjpeg.Free;
        Destjpeg.Free;
    end;
end;

procedure TfrmMain.VideoFrame(Sender: TObject; Bitmap: TIEDibBitmap);
begin
    {
    Bitmap.CopyToTBitmap(imgCam.Bitmap);
    imgCam.Update;
    imgCam.Fit;
    }
end;

procedure TfrmMain.imgCamViewChange(Sender: TObject; Change: Integer);
begin
    {
    if imgCam.Selected then
        Exit;
    imgCam.Select(0, 0, selectW, selectH);
    }
end;

procedure TfrmMain.btnSetCamClick(Sender: TObject);
var
    hr: longint;
    pProcAmp: IAMVideoProcAmp;
    prop: TVideoProcAmpProperty;
    val: longint;
    flags: TVideoProcAmpFlags;
begin
    hr := SysDev.GetBaseFilter(0).QueryInterface(IID_IAMVideoProcAmp, pProcAmp);
    if (Succeeded(hr)) then begin
        pProcAmp.Set_(prop, val, flags);
    end;
end;

procedure TfrmMain.btnCamFormatClick(Sender: TObject);
var
    hr: longint;
    pProcAmc: IAMCameraControl;
    val: longint;
    flags: TCameraControlFlags;
begin
    hr := SysDev.GetBaseFilter(0).QueryInterface(IAMCameraControl, pProcAmc);
    if (Succeeded(hr)) then begin
        pProcAmc.Set_(CameraControl_Exposure, val, flags);
    end;
end;

procedure TfrmMain.N18Click(Sender: TObject);
begin
    try
        imgShow.Proc.DoPreviews(ppeColorAdjust);
    except
    end;
end;

procedure TfrmMain.N19Click(Sender: TObject);
begin
    try
        imgShow.Proc.DoPreviews(ppeEffects);
    except
    end;
end;

procedure TfrmMain.N20Click(Sender: TObject);
begin
    try
        imgShow.Proc.RemoveRedEyes;
    except
    end;
end;

procedure TfrmMain.btnPhotoShowClick(Sender: TObject);
begin
    if m_connect then begin
        try
            //psTReleaseStartViewFinder;
        except
            ShowMessage('显示图像失败，重新显示...');
            Exit;
        end;
        btnPhoto.Enabled := True;
        //btnPhotoClose.Enabled := True;
        //btnPhotoShow.Enabled := False;
    end;
end;

procedure TfrmMain.btnPhotoCloseClick(Sender: TObject);
begin
    try
        //psTReleaseStopViewFinder;
    except
        ShowMessage('关闭图像失败，重新关闭...');
        Exit;
    end;
    //btnCloseCanon.Enabled := True;
    //btnPhotoShow.Enabled := True;

    //imgCanon.Picture.Assign(nil);
end;

//******************************************************************************
//相机参数设置相关**************************************************************
{-------------------------------------------------------------------------------
  过程名:    TFormViewfinder.getImageSizeAndQuality
  参数:      inData: Integer
  返回值:    Integer  9:大，8：中1，7中2，6小   ：1一般，2精细，3极精细
-------------------------------------------------------------------------------}

function TfrmMain.getImageSizeAndQuality(inData: Integer): Integer;
begin
    case inData of
        0: Result := 93;
        1: Result := 92;
        2: Result := 91;
        3: Result := 83;
        4: Result := 82;
        5: Result := 81;
        6: Result := 73;
        7: Result := 72;
        8: Result := 71;
        9: Result := 63;
        10: Result := 62;
        11: Result := 61;
    else
        Result := 10;
    end;
end;

procedure TfrmMain.setFlash(inData: Integer);
begin
    case inData of
        0: setRemoteParam.StrobeSetting := psRemoteFormatFlashOff;
        1: setRemoteParam.StrobeSetting := psRemoteFormatFlashAuto;
        2: setRemoteParam.StrobeSetting := psRemoteFormatFlashOn;
        3: setRemoteParam.StrobeSetting := psRemoteFormatFlashAutoRedEye;
        4: setRemoteParam.StrobeSetting := psRemoteFormatFlashOnRedEye;
    else
        setRemoteParam.StrobeSetting := psRemoteFormatFlashNotUsed;
    end;
end;

procedure TfrmMain.setImageQuality(inData: Integer);
var
    ss: string;
begin
    ss := Copy(IntToStr(inData), 2, 1);
    case StrToInt(ss) of
        3: setRemoteParam.CompQuality := psRemoteFormatQualitySuperfine;
        2: setRemoteParam.CompQuality := psRemoteFormatQualityFine;
        1: setRemoteParam.CompQuality := psRemoteFormatQualityNormal;
    else
        setRemoteParam.CompQuality := psRemoteFormatQualityNotUsed;
    end;
end;

procedure TfrmMain.setImageSize(inData: Integer);
var
    ss: string;
begin
    ss := Copy(IntToStr(inData), 0, 1);
    case StrToInt(ss) of
        9: setRemoteParam.ImageSize := psRemoteFormatSizeMedium;
        8: setRemoteParam.ImageSize := psRemoteFormatSizeMedium1;
        7: setRemoteParam.ImageSize := psRemoteFormatSizeMedium2;
        6: setRemoteParam.ImageSize := psRemoteFormatSizeSmall;
    else
        setRemoteParam.ImageSize := psRemoteFormatSizeNotUsed;
    end;
end;

procedure TfrmMain.setISO(inData: Integer);
begin
    case inData of
        0: setRemoteParam.ISO := psRemoteFormatISO50;
        1: setRemoteParam.ISO := psRemoteFormatISO100;
        2: setRemoteParam.ISO := psRemoteFormatISO200;
        3: setRemoteParam.ISO := psRemoteFormatISO400;
        4: setRemoteParam.ISO := psRemoteFormatISOAuto;
    else
        setRemoteParam.ISO := psRemoteFormatISONotUsed;
    end;
end;

procedure TfrmMain.setPhotoEffect(inData: Integer);
begin
    case inData of
        0: setRemoteParam.PhotoEffect := psRemoteFormatPhotoEffectOff;
        1: setRemoteParam.PhotoEffect := psRemoteFormatPhotoEffectVivid;
        2: setRemoteParam.PhotoEffect := psRemoteFormatPhotoEffectNeutral;
        3: setRemoteParam.PhotoEffect := psRemoteFormatPhotoEffectLowSharpening;
        4: setRemoteParam.PhotoEffect := psRemoteFormatPhotoEffectSepia;
        5: setRemoteParam.PhotoEffect := psRemoteFormatPhotoEffectBW;
    else
        setRemoteParam.PhotoEffect := psRemoteFormatPhotoEffectNotUsed;
    end;
end;

procedure TfrmMain.setWhiteBalance(inData: Integer);
begin
    case inData of
        0: setRemoteParam.WhiteBalanceSetting := psRemoteFormatWBAuto;
        1: setRemoteParam.WhiteBalanceSetting := psRemoteFormatWBDaylight;
        2: setRemoteParam.WhiteBalanceSetting := psRemoteFormatWBCloudy;
        3: setRemoteParam.WhiteBalanceSetting := psRemoteFormatWBTungsten;
        4: setRemoteParam.WhiteBalanceSetting := psRemoteFormatWBFluorscent;
        5: setRemoteParam.WhiteBalanceSetting := psRemoteFormatWBFluorescentLight;
        6: setRemoteParam.WhiteBalanceSetting := psRemoteFormatWBCustom;
    else
        setRemoteParam.WhiteBalanceSetting := psRemoteFormatWBNotUsed;
    end;
end;

procedure TfrmMain.trckbr1Change(Sender: TObject);
begin
    if m_connect then begin
        //psTReleaseSetZoomPosition(trckbr1.Position);
    end;
end;

//相机参数设置相关（结束）******************************************************
//******************************************************************************
//******************************************************************************

procedure TfrmMain.btnSetParamClick(Sender: TObject);
begin
    if m_connect then begin
        //setImageQuality(getImageSizeAndQuality(cbbImageSize.ItemIndex));
        //setImageSize(getImageSizeAndQuality(cbbImageSize.ItemIndex));
        //setWhiteBalance(cbbWhiteBalance.ItemIndex);
        //setISO(cbbISO.ItemIndex);
        //setFlash(cbbFlash.ItemIndex);
        //setPhotoEffect(cbbPhotoEffect.ItemIndex);
        try
            psTReleaseSetParams(setRemoteParam);
        except
            ShowMessage('设置数码相机参数失败，重新设置...');
        end;
    end;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
    TLogger.FreeInstances;
    SysDev.Free;
end;

procedure TfrmMain.shpSelectMouseMove(Sender: TObject; Shift: TShiftState;
    X, Y: Integer);
var
    shpLeft: integer;
    shpTop: integer;
    shpRight: integer;
begin
    shpLeft := shpSelect.Left + X - xPos;
    shpRight := shpSelect.Left + X - xPos + shpSelect.Width;
    //if shpRight > imgCanon.Width then
    //    shpLeft := imgCanon.Width - shpSelect.width;

    if shpLeft <= 0 then
        shpLeft := 0;
    shpTop := 0;

    if (leftMouse) then begin
        shpSelect.Left := shpLeft;
        shpSelectLeft := shpLeft;
        shpSelect.Top := shpTop;

        setViewBoxPosi(shpLeft);
        //shp1.Left := shpSelect.Left+20;
        //shp1.Top := shpSelect.Top + 30;
        //Shape1.Left := shpSelect.Left + 30;
        //Shape1.Top := shpSelect.top + 20
    end;
end;

procedure TfrmMain.shpSelectMouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if button = mbleft then begin
        yPos := y;
        xPos := x;
        leftMouse := true;
    end
    else begin
        leftMouse := false;
    end;
end;

procedure TfrmMain.shpSelectMouseUp(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
begin
    if button = mbleft then
        leftMouse := false;
end;

procedure TfrmMain.drawShpSelect;
begin
    shpSelect.Height := selectH;
    shpSelect.Width := selectW;
end;

procedure TfrmMain.saveCononPhotoToDisk;
var
    filename, filename2: string;
    sa, sa2: array[0..280] of char;
begin
    filename := apppath + lblCustNo.Caption + '.jpg';
    filename2 := apppath + lblCustNo.Caption + '.jpg';
    if m_connect then begin
        try
            m_p1 := psTReleaseGetParams();
            psTrelease(psTReleaseDoSupportRemote);
            strpcopy(sa, filename);
            strpcopy(sa2, filename2);
            psTReleaseGetThumbnail(sa2);
            psTReleaseGetPicture(sa);
        except
            ShowMessage('照片拍摄失败，请重新拍摄...');
            Exit;
        end;
    end;
    //剪切照片
    cutPhoto(filename);
    //载入到预览框
    imgShow.IO.LoadFromFile(filename);
    //删除照片
    DeleteFile(filename);
end;

procedure TfrmMain.btnSaveAsClick(Sender: TObject);
begin
    if svmgndlg1.Execute then begin
        imgShow.IO.SaveToFile(svmgndlg1.FileName);
    end;
end;

procedure TfrmMain.N21Click(Sender: TObject);
begin
    frmModifyPwd := TfrmModifyPwd.Create(nil);
    frmModifyPwd.ShowModal;
    frmModifyPwd.Free;
end;

procedure TfrmMain.N15Click(Sender: TObject);
begin
    if Application.MessageBox('你确定要退出拍照/制卡管理系统吗？', PChar(Application.Title), MB_ICONQUESTION + mb_yesno) = idyes then
        Application.Terminate;

end;

procedure TfrmMain.N22Click(Sender: TObject);
begin
    if judgelimit(loginLimit, mdl_custImport) = False then begin
        ShowMessage('你没有操作该项的权限！');
        Exit;
    end;
    frmCustImport := TfrmCustImport.Create(nil);
    frmCustImport.ShowModal;
    frmCustImport.Free;
end;

procedure TfrmMain.btnGetPhotoClick(Sender: TObject);
begin
    if lblCustNo.Caption = '' then begin
        ShowMessage('请先查询出要拍照的人员，然后再拍照！');
        edtStuempNo.SetFocus;
        Exit;
    end;

    //从硬盘中取得已经拍摄的照片
    if FileExists(photopath + '\' + photopre + '.jpg') then begin
        imgShow.IO.LoadFromFile(photopath + '\' + photopre + '.jpg');
        if rotate = True then begin
            imgShow.Proc.Rotate(angle, True, ierFast, -1);
            imgShow.Fit;
        end;
        btnSavePhoto.Enabled := True;
        btnSaveAs.Enabled := True;
    end
    else
        ShowMessage('要取的照片：' + photopath + '\' + photopre + '.jpg 不存在，请检查路径是否正确！');
end;

procedure TfrmMain.N23Click(Sender: TObject);
begin
    frmGetPhotoSet := TfrmGetPhotoSet.Create(nil);
    frmGetPhotoSet.ShowModal;
    frmGetPhotoSet.Free;
end;

procedure TfrmMain.edtStuempNoKeyDown(Sender: TObject; var Key: Word;
    Shift: TShiftState);
begin
    if Key = vk_return then
        btnQuery.Click;
end;

procedure TfrmMain.setViewBoxVisible(param: Boolean);
begin
    shpL.Visible := param;
    shpT.Visible := param;
    shpR.Visible := param;
    shpB.Visible := param;
    shpA.Visible := param;
end;

procedure TfrmMain.setViewBoxPosi(leftP: Integer);
begin
    shpL.Top := veL_top;
    shpL.Left := leftP + veL_left;
    shpL.Height := veL_height;

    shpR.Top := veR_top;
    shpR.Left := leftP + veR_left;
    shpR.Height := veR_height;

    shpT.Top := veT_top;
    shpT.Left := leftP + veT_left;
    shpT.Width := veT_width;

    shpB.Top := veB_top;
    shpB.Left := leftP + veB_left;
    shpB.Width := veB_width;

    shpA.Top := veA_top;
    shpA.Left := leftP + veA_left;
    shpA.Width := veA_width;
end;

procedure TfrmMain.btn1Click(Sender: TObject);
begin
    if camType = 'cam' then begin
        ShowMessage('摄像头拍照模式不支持该功能！');
        Exit;
    end;
    shpSelect.Visible := True;
    setViewBoxVisible(ve_visible);
    drawShpSelect;
    if ve_visible then
        setViewBoxPosi(0);
end;

{-------------------------------------------------------------------------------
  过程名:    TfrmMain.getPrintMenu得到用户自定义菜单
-------------------------------------------------------------------------------}

procedure TfrmMain.getPrintMenu(sender: TObject);
var
    i: Integer;
    menuCount: Integer;
    custM: TMenuItem;
begin
    try
        cbbMenu.Items.Clear;
        cbbMenu.Items.LoadFromFile(apppath + sPrintTemplateDir + 'printmenu.txt');
        menuCount := cbbMenu.Items.Count;
        for i := 0 to menuCount - 1 do begin
            custM := TMenuItem.Create(Self);
            custM.Tag := i;
            custM.Caption := cbbMenu.Items.Strings[i];
            N10.Add(custM);
            custM.OnClick := openPrintM;
        end;
    except
        on e: Exception do begin
            ShowMessage('加载用户自定义菜单失败--' + e.Message);
        end;
    end;
end;

procedure TfrmMain.openPrintM(sender: TObject);
var
    Item: TMenuItem;
    printType: string;
begin
    case TMenuItem(Sender).tag of
        0..1000: printType := TMenuItem(sender).Caption;
        -9991: ShowMessage(Item.Items[0].Caption);
    end;

    frmCardPrintTemp := TfrmCardPrintTemp.create(nil);
    frmCardPrintTemp.cardType := Trim(printType);
    frmCardPrintTemp.ShowModal;
    frmCardPrintTemp.Free;
end;

procedure TfrmMain.getPrintMenu_W(sender: TObject);
var
    i: Integer;
    menuCount: Integer;
    custM: TMenuItem;
begin
    try
        cbbMenu.Items.Clear;
        cbbMenu.Items.LoadFromFile(apppath + sPrintTemplateDir + 'printmenu_w.txt');
        menuCount := cbbMenu.Items.Count;
        for i := 0 to menuCount - 1 do begin
            custM := TMenuItem.Create(Self);
            custM.Tag := i;
            custM.Caption := cbbMenu.Items.Strings[i];
            NPrint_W.Add(custM);
            custM.OnClick := openPrintM_W;
        end;
    except
        on e: Exception do begin
            ShowMessage('加载用户自定义菜单失败--' + e.Message);
        end;
    end;
end;

procedure TfrmMain.openPrintM_W(sender: TObject);
var
    Item: TMenuItem;
    printType: string;
begin
    case TMenuItem(Sender).tag of
        0..1000: printType := TMenuItem(sender).Caption;
        -9991: ShowMessage(Item.Items[0].Caption);
    end;

    frmCardPrintTemp_W := TfrmCardPrintTemp_W.create(nil);
    frmCardPrintTemp_W.cardType := Trim(printType);
    frmCardPrintTemp_W.ShowModal;
    frmCardPrintTemp_W.Free;
end;

procedure TfrmMain.dbgCustomerCellClick(Column: TColumnEh);
begin
    if (frmdm.qryQuery.IsEmpty or frmdm.qryQuery.Active = False) then
        Exit;
    if dbgCustomer.DataSource.DataSet.IsEmpty then
        Exit;
    try
        queryBaseInfo('', '', Trim(dbgCustomer.DataSource.DataSet.fieldbyname(custId).AsString));
    except on e: Exception do begin
            TLogger.GetInstance.Debug('查询持卡人错误--' + e.Message);
        end;
    end;
end;

procedure TfrmMain.N12Click(Sender: TObject);

var
    Handle: integer;
begin
    TLogger.GetInstance.Info('系统目录：' + ExtractFilePath(Application.ExeName));
    ShellExecute(Handle,
        nil,
        'Explorer.exe',
        PChar(Format('/e,/select,%s', [ExtractFilePath(Application.ExeName)])),
        nil,
        SW_NORMAL);
end;

end.

