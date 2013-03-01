unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs,ADODB_TLB, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    edSource: TEdit;
    edCmd: TEdit;
    btnOpen: TButton;
    Label1: TLabel;
    Label2: TLabel;
    lsRecords: TListBox;
    Splitter1: TSplitter;
    lsDetail: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure lsRecordsClick(Sender: TObject);
  private
    { Private declarations }
    Records : _Recordset;
    Connection: _Connection;
    Bookmarks : variant;
    procedure GetAllRecords;
    procedure GotoRecord(Bookmark : Variant);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation


{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Connection:= CoConnection.Create;
  Records := CoRecordset.Create;
end;

procedure TForm1.btnOpenClick(Sender: TObject);
var
	aff : OleVariant;
begin
  {Records.Close;
  Connection.Close;}
  Connection.Open(edSource.text,'','',-1);
  //Records:=Connection.Execute(edCmd.text,aff,2);
  Records.Open(edCmd.text,Connection,adOpenKeyset,adLockOptimistic,adCmdTable);
  GetAllRecords;
  //edit1.text := Records.Fields.item[0].Name;
end;

procedure TForm1.GetAllRecords;
var
  index : integer;
  Bookmark : variant;
  count : integer;
  i : integer;
begin
  lsRecords.Items.Clear;
  lsDetail.items.Clear;
  count := Records.RecordCount;
  Bookmarks := VarArrayCreate([0,count-1],varVariant);
  Records.MoveFirst;
  i:=0;
  while not Records.EOF do
  begin
    Bookmark := Records.Bookmark;
    outputDebugString(pchar(
      format('%d,%d',[
        VarArrayLowBound(Bookmark,1),
        VarArrayHighBound(Bookmark,1)]
        )));
    lsRecords.Items.Add(String(Records.Fields.item[0].Value));
    Bookmarks[i]:=Bookmark;
    inc(i);
    {index := Integer(Records.AbsolutePosition);
    lsRecords.Items.AddObject(
      String(Records.Fields.item[0].Value),
      TObject(index));}
    Records.MoveNext;
  end;
  GotoRecord(Bookmarks[0]);
end;

procedure TForm1.lsRecordsClick(Sender: TObject);
var
  BookMark : variant;
begin
  if (lsRecords.ItemIndex>=0) and (lsRecords.ItemIndex<lsRecords.Items.count) then
  begin
    //Index := Integer(lsRecords.Items.Objects[lsRecords.ItemIndex]);
    BookMark := BookMarks[lsRecords.ItemIndex];
    GotoRecord(BookMark);
  end;
end;

procedure TForm1.GotoRecord(Bookmark : Variant);
var
  i : integer;
begin
  lsDetail.items.Clear;
  Records.Bookmark:= Bookmark;
  for i:=0 to Records.Fields.Count-1 do
    lsDetail.items.Add(format('%10s : %s',
      [string(Records.Fields.Item[i].name),
       string(Records.Fields.Item[i].value)
      ]
      ));
end;

end.
