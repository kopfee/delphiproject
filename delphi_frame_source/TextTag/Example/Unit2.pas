unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Contnrs;

type
  TForm1 = class(TForm)
    mmSource: TMemo;
    btnParse: TButton;
    mmResult: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnParseClick(Sender: TObject);
  private
    { Private declarations }
    FFuncs : TObjectList;
    procedure ViewResult;
    procedure AddInfo(const s:string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses FuncScripts;

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FFuncs := TObjectList.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FFuncs.Free;
end;

procedure TForm1.btnParseClick(Sender: TObject);
begin
  FFuncs.Clear;
  mmResult.Lines.Clear;
  ParseFunctions(mmSource.Text,FFuncs);
  ViewResult;
end;

procedure TForm1.ViewResult;
var
  i,j : integer;
begin
  for i:=0 to FFuncs.Count-1 do
  with TScriptFunc(FFuncs[i]) do
  begin
    AddInfo('Function '+FunctionName);
    for j:=0 to Params.Count-1 do
    begin
      AddInfo(IntToStr(J)+':'+Params[J]);
    end;
    AddInfo('');
  end;
end;

procedure TForm1.AddInfo(const s: string);
begin
  mmResult.Lines.Add(s);
end;

end.
