unit uImport;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ExtCtrls, FileCtrl, ComCtrls, Buttons, jpeg, phtIfRepalce
    , Db, Ora;

type
    TfrmImport = class(TForm)
        pnlTop: TPanel;
        lbl1: TLabel;
        drvcbb1: TDriveComboBox;
        dirlstPhoto: TDirectoryListBox;
        fllstPhoto: TFileListBox;
        Label1: TLabel;
        dtpDate: TDateTimePicker;
        dtpTime: TDateTimePicker;
        pnl1: TPanel;
        lstError: TListBox;
        Label2: TLabel;
        pb1: TProgressBar;
        btnImport: TBitBtn;
        BitBtn1: TBitBtn;
        procedure BitBtn1Click(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure btnImportClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
    private
        { Private declarations }
        FPersonNo: string;

        FOldJPEG, FNewJPEG: TJPEGImage;
        FReply: TphtReply;

        ErrorPersonNo: TStrings;
        ErrorPersonName: TStrings;
    public
        { Public declarations }
    end;

var
    frmImport: TfrmImport;

implementation

uses uCommon, Udm;

{$R *.dfm}

procedure TfrmImport.BitBtn1Click(Sender: TObject);
begin
    close();
end;

procedure TfrmImport.FormShow(Sender: TObject);
begin
    dtpdate.Date := Date;
    dtptime.Time := Now;
end;

procedure TfrmImport.btnImportClick(Sender: TObject);
var i: Integer;
    FCurrentSetDir: string;
    FFileName: string;
    F: TFileStream;
    BS: TMemoryStream;
    M1: TMemoryStream;
    //F2: TFileStream;
    Buffer: Word;
    J: Integer;
    CurDir: string;
    FailDir: string;
    SkipDir: string;

    sqlImprot: string;
    sqlCustInfo: string;

    scustId, sStuempNo: string;

    photoQuery: TOraQuery;
begin
    if fllstPhoto.Items.Count = 0 then begin
        ShowMessage('没有照片可以批量导入');
        Exit;
    end;
    pb1.Position := 0;
    pb1.Min := 0;

    FReply := rpNone;

    lstError.Items.Clear;
    CurDir := dirlstPhoto.Directory;
    FailDir := CurDir + '\导入失败照片';
    SkipDir := CurDir + '\导入跳过照片';
    CreateDir(FailDir);
    CreateDir(SkipDir);

    pb1.Max := fllstPhoto.Items.Count;
    for i := 0 to fllstPhoto.Items.Count - 1 do begin
        pb1.Position := i + 1;

        FCurrentSetDir := dirlstPhoto.Directory;
        FFileName := Trim(fllstPhoto.Items.Strings[i]);
        FPersonNo := getJpgNo(FFileName);
        //到客户表中查询该学工号是否存在,不存在写入错误信息
        //存在调用写照片信息函数查询照片表是否存在学工号信息
        photoQuery := nil;
        try
            sqlCustInfo := 'select ' + custId + ',' + stuempNo + ' from ' + tblCust + ' where ';
            sqlCustInfo := sqlCustInfo + stuempNo + '=' + QuotedStr(FPersonNo);
            photoQuery := TOraQuery.Create(nil);
            photoQuery.Connection := frmdm.conn;
            photoQuery.Close;
            photoQuery.SQL.Clear;
            photoQuery.SQL.Add(sqlCustInfo);
            photoQuery.Open;
            if not photoQuery.IsEmpty then begin
                scustId := photoQuery.fieldbyname(custId).AsString;
                sStuempNo := photoQuery.fieldbyname(stuempNo).AsString;
                insertPhotoData(scustId, sStuempNo);
            end
            else begin
                ErrorPersonNo.Add(stuempNo);
                ErrorPersonName.Add('');
                lstError.Items.Add('学/工号为：' + QuotedStr(FPersonNo) + '的人员基本信息不存在, 导入失败!');
                photoQuery.Close;
                CopyFile(PChar(CurDir + '\' + FFileName), PChar(FailDir + '\' + FFileName), false);
                Continue;
            end;
        finally
            photoQuery.Free;
        end;

        sqlImprot := 'select ' + custId + ',' + stuempNo + ',' + pPhoto + ',' + pphotoDate + ',' + pphototime + ' from ';
        sqlImprot := sqlImprot + tblPhoto + ' where ' + stuempNo + '=' + QuotedStr(FPersonNo);
        frmdm.qryImport.Close;
        frmdm.qryImport.SQL.Clear;
        frmdm.qryImport.SQL.Add(sqlImprot);
        frmdm.qryImport.Open;
        {
        if qryImprot.IsEmpty then
        begin
          ErrorPersonNo.Add(stuempNo);
          ErrorPersonName.Add('');
          lstError.Items.Add('学/工号为：' + QuotedStr(FPersonNo) + '的人员基本信息不存在, 导入失败!');
          qryImprot.Recordset.Close;
          qryImprot.Close;
          CopyFile(PChar(CurDir+'\'+FFileName), PChar(FailDir+'\'+FFileName), false);
          Continue;
        end;
        }
        if (FReply <> rpAllReplace) and (not frmdm.qryImport.FieldByName(pPhoto).IsNull) then begin
            //BS := TADOBlobStream.Create(TBlobField(qryImprot.FieldByName(pPhoto)),bmread);
            BS := TMemoryStream.Create;
            TBlobField(frmdm.qryImport.FieldByName(pPhoto)).SaveToStream(BS);
            BS.Position := 0;
            if BS.Size > 4 then
                FOldJPEG.LoadFromStream(BS);
            try
                FNewJPEG.LoadFromFile(FFileName);
            except
                lstError.Items.Add('学/工号为：' + FPersonNo + '的图片格式错误, 导入失败! ');
                CopyFile(PChar(CurDir + '\' + FFileName), PChar(FailDir + '\' + FFileName), false);
                Continue;
            end;

            FReply := frmIfRepalce.GetReply(FPersonNo, FOldJPEG, FNewJPEG);

            case FReply of
                rpReplace: ;

                rpSkip: begin
                        CopyFile(PChar(CurDir + '\' + FFileName), PChar(SkipDir + '\' + FFileName), false);
                        Continue;
                    end;
                rpCancel: begin
                        for J := I to fllstPhoto.Items.Count - 1 do begin
                            FFileName := Trim(fllstPhoto.Items.Strings[J]);
                            CopyFile(PChar(CurDir + '\' + FFileName), PChar(SkipDir + '\' + FFileName), false);
                        end;
                        Break;
                    end;
            end;
        end;
        frmdm.qryImport.Edit;
        F := TFileStream.Create(FCurrentSetDir + '\' + FFileName, fmOpenRead);
        F.Position := 0;
        F.ReadBuffer(Buffer, 2); //读取文件的前２个字节，放到Buffer里面
        if Buffer <> $D8FF then begin
            ErrorPersonNo.Add(FPersonNo + '的图片信息导入失败,图片格式不正确!');
            lstError.Items.Add(FPersonNo + '的图片信息导入失败,图片格式不正确!');
            CopyFile(PChar(CurDir + '\' + FFileName), PChar(FailDir + '\' + FFileName), false);
            continue;
        end;
        try
            F.Position := 0;
            //M1 := TMemoryStream.Create;
            //TBlobField(qryImprot.FieldByName(pPhoto)).SaveToStream(M1);
            //如果照片大小超过数据库Blob字段大小 600k,保存失败，
            if F.Size > 600000 then begin
                lstError.Items.Add('学/工号为：' + FPersonNo + '的图片信息过大, 导入失败! ');
                CopyFile(PChar(CurDir + '\' + FFileName), PChar(FailDir + '\' + FFileName), false);
                Continue;
            end;
            TBlobField(frmdm.qryImport.FieldByName(pPhoto)).loadfromStream(F);

            frmdm.qryImport.FieldByName(pPhotoDate).Value := FormatDateTime('yyyymmdd', dtpdate.date);
            frmdm.qryImport.FieldByName(pPhotoTime).Value := FormatDateTime('hhmmss', dtpdate.time);
            try
                frmdm.qryImport.Post;
            except
                ErrorPersonNo.Add(FPersonNo + '的图片信息导入失败!');
                lstError.Items.Add(FPersonNo + '的图片信息导入失败!');
                CopyFile(PChar(CurDir + '\' + FFileName), PChar(FailDir + '\' + FFileName), false);
                continue;
            end;

        finally
            F.Free;
            //M1.Free;
        end;
    end;
    ShowMessage('导入照片完成！');
    // if _Dir is empty, then remove
    RemoveDir(FailDir);
    RemoveDir(SkipDir);
end;

procedure TfrmImport.FormCreate(Sender: TObject);
begin
    ErrorPersonNo := TStringList.Create;
    ErrorPersonName := TStringList.Create;

    FOldJPEG := TJPEGImage.Create;
    FNewJPEG := TJPEGImage.Create;

end;

procedure TfrmImport.FormDestroy(Sender: TObject);
begin
    ErrorPersonNo.Free;
    ErrorPersonName.Free;

    FOldJPEG.Free;
    FNewJPEG.Free;

end;

end.
