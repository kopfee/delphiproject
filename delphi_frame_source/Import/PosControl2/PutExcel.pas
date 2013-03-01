unit PutExcel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Spin, checklst, Db, DBTables, Excels,Math;

type
  TfrmExcel = class(TForm)
    CheckListBox1: TCheckListBox;
    CheckBox1: TCheckBox;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    AdvExcel1: TAdvExcel;
    Table1: TTable;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    FDataSet:TDataSet;
  public
    { Public declarations }
    procedure ShowForm(DataSet:TDataSet);
  end;

var
  frmExcel: TfrmExcel;

implementation

{$R *.DFM}

procedure TfrmExcel.ShowForm(DataSet:TDataSet);
var i:integer;
begin
  FDataSet:=DataSet;
  with FDataSet do
  begin
    for i:=0 to FieldCount-1 do
    begin
      if Fields[i].Visible=TRUE then
      begin
        CheckListBox1.Items.Add(Fields[i].DisplayLabel);
        CheckListBox1.Checked[CheckListBox1.Items.Count-1]:=TRUE;
      end;
    end;
  end;
  ShowModal;
end;

procedure TfrmExcel.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmExcel.BitBtn1Click(Sender: TObject);
var row,col,colwidth,tempword,count:integer;
    content,thefirst,tempstr:string;
begin
  try
    AdvExcel1.Connect;
  except
    messagedlg('Excel not found!',mtWarning,[mbOk],0);
    exit;
  end;
  AdvExcel1.StartTable;
  AdvExcel1.DisableInput;
  with FDataSet do
  begin
    DisableControls;
    for col:=0 to FieldCount-1 do
    begin
      tempstr:=Fields[col].DisplayLabel;
      tempword:=CheckListBox1.Items.Indexof(tempstr);
      if tempword<>-1 then
      if (CheckListBox1.Checked[tempword]) and (Fields[col].Visible) then Break;
    end;
    first;
    row:=SpinEdit1.Value-1;
    thefirst:=Fields[Col].asString;
    if CheckBox1.Checked=TRUE then
    begin
      row:=row+1;
      thefirst:=Fields[Col].DisplayLabel;
    end;
    count:=-1;
    for col:=0 to FieldCount-1 do
    begin
      colwidth:=Fields[col].DisplayWidth;
      tempword:=length(Fields[col].DisplayLabel);
      colwidth:=MaxIntValue([colwidth,tempword]);
      tempstr:=Fields[col].DisplayLabel;
      tempword:=CheckListBox1.Items.Indexof(tempstr);
      if tempword<>-1 then
      if (CheckListBox1.Checked[tempword]) and (Fields[col].Visible) then
      begin
        count:=count+1;
        AdvExcel1.Exec('[COLUMN.WIDTH('+inttostr(colwidth)+',"C'+inttostr(count+SpinEdit2.Value)+'")]');
        if CheckBox1.Checked=TRUE then
        begin
          content:=Fields[col].DisplayLabel;
          AdvExcel1.PutStrAt(row,count+SpinEdit2.Value,content);
        end;
      end;
    end;


    while not eof do
    begin
      row:=row+1;
      count:=-1;
      for col:=0 to FieldCount-1 do
      begin
        tempstr:=Fields[col].DisplayLabel;
        tempword:=CheckListBox1.Items.Indexof(tempstr);
        if tempword<>-1 then
        if (CheckListBox1.Checked[tempword]) and (Fields[col].Visible) then
        begin
          count:=count+1;
          content:=Fields[col].asString;
          AdvExcel1.PutStrAt(row,count+SpinEdit2.Value,content);
        end;
      end;
      Next;
    end;
    EnableControls;
  end;
  AdvExcel1.EndTable;
  AdvExcel1.EnableInput;
  AdvExcel1.PutStrAt(SpinEdit1.Value,SpinEdit2.Value,thefirst);
  AdvExcel1.Disconnect;
  messagedlg('Transfer Successful!',mtInformation,[mbOk],0);
  Close;
end;

end.
