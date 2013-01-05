unit UtilOffice;

interface

uses
    Comobj, SysUtils, Forms, Windows,Office2000;
var
    v_office: Variant;

function OpenExcel(strFileName: string): Boolean;
function OpenWord(strFileName: string): Boolean;
function EditWord(strFileName: string): Boolean;
function OpenPowerPoint(strFileName: string): Boolean;

implementation
uses unit1;

function OpenPowerPoint(strFileName: string): Boolean;
begin
    Result := True;
    try
        //v_office := CreateOleObject('PowerPoint.Application');
        form1.PowerPointApplication1.Connect;
        form1.PowerPointApplication1.Visible := 1;
        form1.PowerPointApplication1.Presentations.Open(strFileName, msofalse, msotrue, msotrue);

        with form1.PowerPointApplication1.Presentations.Item(1) do begin
            //SlideShowSettings.AdvanceMode := ppSlideShowUseSlideTimings;
            SlideShowSettings.LoopUntilStopped := msoTrue;
            SlideShowSettings.Run;
        end;
    except
        Application.MessageBox('打开PowerPoint失败', PChar(Application.Title), MB_ICONERROR);
        Result := False;
    end;
    //    v_office.Visible := True;
    //    v_office.Caption := '';
    //v_office.Presentations.Open(strFileName);
end;

function OpenExcel(strFileName: string): Boolean;
begin
    Result := True;
    try
        v_office := CreateOleObject('Excel.Application');
    except
        Application.MessageBox('打开Excel失败', PChar(Application.Title), MB_ICONERROR);
        Result := False;
    end;
    v_office.Visible := True;
    v_office.Caption := '';
    v_office.WorkBooks.Open(strFileName); //打开工作簿
    v_office.WorkSheets[1].Activate; //设置第1个工作表为活动工作表
end;

function OpenWord(strFileName: string): Boolean;
begin
    Result := True;
    try
        v_office := CreateOleObject('Word.Application');
        v_office.Visible := true;
        v_office.Caption := strFileName;
        v_office.Documents.Open(FileName := strFileName, ReadOnly := True);
        //FileName:=strFileName,ReadOnly:=True
    except
        Application.MessageBox('打开Word失败', PChar(Application.Title), MB_ICONERROR);
        Result := False;
    end;
end;


function EditWord(strFileName: string): Boolean;
begin
    Result := True;
    try
        v_office := CreateOleObject('Word.Application');
        v_office.Visible := true;
        v_office.Caption := strFileName;
        v_office.Documents.Open(FileName := strFileName, ReadOnly := false);
    except
        Application.MessageBox('打开Word失败', PChar(Application.Title), MB_ICONERROR);
        Result := False;
    end;
end;

end.

 