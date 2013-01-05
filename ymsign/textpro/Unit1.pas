unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  todostr,sFile,sDir:string;
  sr:TSearchRec;
  fTextFile,freadFile:TextFile ;
  FileContent:TStringList;
begin
   if SysUtils.FindFirst('d:\software\subjects\*.*',faDirectory,sr)=0 then
   begin
     repeat
       sFile:=Trim(sr.Name);
       if (sFile<> '.') and (sFile<>'..') then
       begin
         sDir:='d:\software\subjects\'+sr.Name;
         sFile:=sDir+'\'+'settings.txt';
      //   fileopen(freadFile,1)

       if fileexists(sFile) then
       begin
         assignfile(freadFile,sFile);
         reset(freadFile);
         readln(freadFile,todostr);

       //  FileContent.LoadFromFile(sFile);
       //  todostr:=FileContent.Strings[0];
         closefile(freadFile);
         if fileexists('d:\software\todofile.txt') then
         begin
         assignfile(fTextFile,'d:\software\todofile.txt');
         Append(fTextFile);
         writeln(fTextFile,todostr);
         closefile(fTextFile);
         //ɾĿ¼
         DeleteFile(PAnsiChar(sDir));
         removedir(sDir);
         end;
       end;
       end;
     until SysUtils.FindNext(sr)<>0;;
     SysUtils.FindClose(sr);
     button1.Caption :='ok';
   end;
  //while d:/software have filejia
  //begin
  //    AssignFile
  //    readfile(settings,1,todostr);
  //    Append(todofile);
  //    writeln(todostr) ;
  //    deletefile( filejia )
  //end;


end;

end.
