program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  HdExcpEx in '..\..\MyLib\HdExcpEx.pas' {ErrorMsgDialog};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TErrorMsgDialog, ErrorMsgDialog);
  Application.Run;
end.
