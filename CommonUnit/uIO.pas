unit uIO;


interface

procedure writeLog(content:String);
procedure makeDir(dirString:String);


implementation
uses
    SysUtils,Forms,FileCtrl;

procedure writeLog(content:String);
var
    logFilename : String;
    F : Textfile;
begin
    makeDir(ExtractFilePath(Application.EXEName) + '..\logs\');
    logFilename := ExtractFilePath(Application.EXEName) + '..\logs\'
        + FormatDateTime('yyyymmdd',Now()) + '.log';
    if fileExists(logFilename) then begin
        AssignFile(F, logFilename);
        Append(F);
    end
    else begin
        AssignFile(F, logFilename);
        ReWrite(F);
    end;
    Writeln(F, content);
    Flush(F);
    Closefile(F);

end;

procedure makeDir(dirString:String);
begin
    if not  DirectoryExists(dirString) then begin
        if not CreateDir(dirString) then
            raise Exception.Create('Cannot create ' + dirString);
    end;
end;


end.

