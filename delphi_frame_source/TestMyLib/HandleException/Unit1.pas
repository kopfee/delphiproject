unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, DBTables, ExtCtrls, DBCtrls, Grids, DBGrids;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Database1: TDatabase;
    Table1: TTable;
    DataSource1: TDataSource;
    Button4: TButton;
    Button5: TButton;
    StoredProc1: TStoredProc;
    Button6: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses HdExcpEx;

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  i,j : integer;
begin
  try
    SetProgressMsg('整数除法');
    j := 0;
    i := i div j;
  except
    HandleProgressException;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  f : real;
begin
  try
    SetProgressMsg('浮点数除法');
    f := 0;
    f := 0 / f;
  except
    HandleProgressException;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  i : integer;
  P : ^Integer;
begin
  try
    SetProgressMsg('指针运算');
    p := nil;
    i := p^;
  except
    HandleProgressException;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  try
    SetProgressMsg('插入数据');
    Table1.Append;
    Table1.Fields[0].AsString:='01';
    Table1.Post;
  except
    HandleProgressException;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  InstallExceptHanlder;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
    SetProgressMsg('插入数据');
    Table1.Append;
    Table1.Fields[0].AsString:='01';
    Table1.Post;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  StoredProc1.ExecProc;
end;

end.
