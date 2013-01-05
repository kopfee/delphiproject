unit uCustImport;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, GridsEh, DBGridEh, ComCtrls, Buttons, DB, ADODB;

type
    TfrmCustImport = class(TForm)
        dbgrdhDb: TDBGridEh;
        pb1: TProgressBar;
        grp2: TGroupBox;
        lbl1: TLabel;
        edtSheetName: TEdit;
        btnOpenExcel: TBitBtn;
        btnCloseExcel: TBitBtn;
        btnImport: TBitBtn;
        btnExit: TBitBtn;
        Label1: TLabel;
        lblFilePath: TLabel;
        dsOpen: TDataSource;
        conOpen: TADOConnection;
        qryOpen: TADOQuery;
        dlgOpen: TOpenDialog;
        btnQueryData: TBitBtn;
        grp1: TGroupBox;
        mmo1: TMemo;
        BitBtn1: TBitBtn;
        dlgSave: TSaveDialog;
        procedure btnExitClick(Sender: TObject);
        procedure btnOpenExcelClick(Sender: TObject);
        procedure btnCloseExcelClick(Sender: TObject);
        procedure btnImportClick(Sender: TObject);
        procedure btnQueryDataClick(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure BitBtn1Click(Sender: TObject);
    private
        { Private declarations }
        procedure closeDataSet;
    public
        { Public declarations }
    end;

var
    frmCustImport: TfrmCustImport;

implementation

uses uCommon;

{$R *.dfm}

procedure TfrmCustImport.btnExitClick(Sender: TObject);
begin
    qryOpen.Close;
    conOpen.Connected := false;
    close;
end;

procedure TfrmCustImport.btnOpenExcelClick(Sender: TObject);
begin
    dlgOpen.Title := '请选择相应的Excel文件';
    dlgOpen.Filter := 'Excel(*.xls)|*.xls';
    if dlgOpen.Execute then
        lblFilePath.Caption := dlgOpen.FileName;
end;

procedure TfrmCustImport.btnCloseExcelClick(Sender: TObject);
begin
    closeDataSet;
    btnImport.Enabled := False;
    btnCloseExcel.Enabled := False;
end;

procedure TfrmCustImport.btnImportClick(Sender: TObject);
var
    i: Integer;
    sNo, sCardNo, sName, sDept: string;
    sType, sArea, sFeeType, sSpec: string;
    procedure pbStatus();
    begin
        pb1.Position := i;
        qryOpen.Next;
    end;
begin
    if qryOpen.RecordCount = 0 then begin
        ShowMessage('没有你要导入的数据！');
        Exit;
    end;
    if qryOpen.RecordCount < 2 then begin
        ShowMessage('要导入的数据小于2条，请直接到客户信息设置里面添加客户信息！');
        Exit;
    end;
    mmo1.Clear;
    qryOpen.First;
    pb1.Max := qryOpen.RecordCount;
    for i := 1 to qryOpen.RecordCount do begin
        sNo := qryOpen.fieldbyname('学工号').AsString;
        sCardNo := qryOpen.fieldbyname('身份证号').AsString;
        sName := qryOpen.fieldbyname('姓名').AsString;
        sType := qryOpen.fieldbyname('人员类别').AsString;
        sArea := '1';
        sFeeType := '99';
        sDept := qryOpen.fieldbyname('部门').AsString;
        sSpec := qryOpen.fieldbyname('专业').AsString;
        if (Trim(sNo) = '') and (Trim(sCardNo) = '') then begin
            mmo1.Lines.Add('姓名 ' + sName + ' 信息不全，该条记录没有导入，请加入学/工号或身份证号');
            pbStatus;
        end;
        if (Trim(sType) = '') or (Trim(sFeeType) = '') or (Trim(sArea) = '') then begin
            mmo1.Lines.Add('姓名 ' + sName + ' 信息不全，该条记录没有导入，校区，客户类别，收费类别都不能为空');
            pbStatus;
            Continue;
        end;
        //在添加前先检查是否存在学工号和身份证号
        if haveStuEmpNo(sNo) then begin
            //写已经存在信息
            mmo1.Lines.Add('学/工号 ' + sNo + ' 信息已经存在，该条信息没有导入');
            pbStatus;
            Continue;
        end;
        //保存客户信息
        if addCustInfo(sNo, sName, stype, sArea, sCardNo, sDept, sSpec, sFeeType) then begin
            pbStatus;
            Continue;
        end
        else begin
            //写失败信息
            mmo1.Lines.Add('学/工号 ' + sNo + ' 信息已经导入失败');
            pbStatus;
            Continue;
        end;
    end;
    ShowMessage('批量导入客户信息完成！');
    closeDataSet;
    btnImport.Enabled := False;
    btnCloseExcel.Enabled := False;
end;

procedure TfrmCustImport.btnQueryDataClick(Sender: TObject);
var
    sqlstr: string;
    i: Integer;
begin
    try
        if conOpen.Connected = True then
            conOpen.Connected := False;
        conOpen.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' +
            Trim(lblFilePath.Caption) + ';Extended Properties=Excel 8.0;Persist Security Info=False';
        conOpen.Connected := True;
        qryOpen.Connection := conOpen;

        sqlstr := 'select * from [' + Trim(edtSheetName.Text) + '$] where 学工号<>' + #39 + '' + #39;
        qryOpen.Close;
        qryOpen.SQL.Clear;
        qryOpen.SQL.Add(sqlstr);
        qryOpen.Open;
        for i := 0 to dbgrdhDb.Columns.Count - 1 do begin
            dbgrdhDb.Columns[i].Width := 100;
            dbgrdhDb.Columns[i].Title.Alignment := taCenter;
        end;
    except
        ShowMessage('打开数据表失败，请检查打开的Excel文件是否正确！');
        Exit;
    end;
    btnImport.Enabled := True;
    btnCloseExcel.Enabled := True;
end;

procedure TfrmCustImport.closeDataSet;
begin
    if qryOpen.Active then begin
        qryOpen.Recordset.Close;
        qryOpen.Close;
    end;
    if conOpen.Connected then
        conOpen.Connected := false;
end;

procedure TfrmCustImport.FormDestroy(Sender: TObject);
begin
    closeDataSet;
end;

procedure TfrmCustImport.BitBtn1Click(Sender: TObject);
begin
    if mmo1.Text = '' then begin
        ShowMessage('没有要保存的文本信息！');
        Exit;
    end;
    dlgSave.Title := '请选择要保存的文件路径';
    dlgSave.Filter := '文本文件|*.txt';
    if dlgSave.Execute then
        mmo1.Lines.SaveToFile(dlgSave.FileName + '.txt');
end;

end.
