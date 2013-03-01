unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,AliasServ;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    btnBrowse: TButton;
    mmAlias1: TMemo;
    mmAlias2: TMemo;
    mmPath1: TMemo;
    mmPath2: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    btnTest: TButton;
    OpenDialog1: TOpenDialog;
    Label5: TLabel;
    Label6: TLabel;
    lbReal: TLabel;
    lbResult: TLabel;
    btnUpdate: TButton;
    Label7: TLabel;
    lbAlias: TLabel;
    Label9: TLabel;
    lbPath: TLabel;
    procedure btnBrowseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    PathServer1,PathServer2 : TPathServer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnBrowseClick(Sender: TObject);
begin
  if OpenDialog1.execute then
    Edit1.text := OpenDialog1.FileName;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PathServer1 := TPathServer.Create(self);
  PathServer2 := TPathServer.Create(self);
  PathServer1.NextPathServer :=PathServer2;
end;

procedure TForm1.btnUpdateClick(Sender: TObject);
begin
  PathServer1.AliasServer.LoadFromStrings(mmAlias1.lines);
  PathServer2.AliasServer.LoadFromStrings(mmAlias2.lines);
  PathServer1.SearchPaths := mmPath1.lines;
  PathServer2.SearchPaths := mmPath2.lines;
end;

procedure TForm1.btnTestClick(Sender: TObject);
var
  Result : boolean;
  Realname : string;
begin
  result := PathServer1.GetRealFileName(edit1.text,RealName);
  lbResult.caption := IntToStr(integer(result));
  lbReal.caption := RealName;
  lbAlias.caption := PathServer1.MatchedAlias;
  lbPath.caption := PathServer1.MatchedPath;
end;

end.
