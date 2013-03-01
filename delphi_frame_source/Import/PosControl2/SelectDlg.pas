unit SelectDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, StdCtrls, Buttons, Grids, DBGrids;

type
  TfrmSelectDlg = class(TForm)
    grdSelect: TDBGrid;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    SelectDataSource: TDataSource;
    Label1: TLabel;
    Label2: TLabel;
    FindKey: TComboBox;
    FindValue: TEdit;
    procedure grdDblClick(Sender: TObject);
    procedure FindKeyChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FindValueKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    sql : String;
    time : integer;
    function Execute(const KeyField,KeyValue:string):boolean;
  end;

implementation

{$R *.DFM}

procedure TfrmSelectDlg.grdDblClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmSelectDlg.FindKeyChange(Sender: TObject);
var temp : string;
begin

     SelectDataSource.DataSet.Close;
     TQuery(SelectDataSource.DataSet).SQL.Clear;
     temp := sql  + ' order by '
             + grdSelect.Columns.Items[FindKey.ItemIndex].FieldName;
     TQuery(SelectDataSource.DataSet).SQL.Add ( temp );
     SelectDataSource.DataSet.Open ;
end;

procedure TfrmSelectDlg.FormCreate(Sender: TObject);
begin
     time := 0;
end;

procedure TfrmSelectDlg.FormShow(Sender: TObject);
begin
     if time = 0 then
        sql := TQuery(SelectDataSource.DataSet).SQL.Strings[0];
     sql := sql;
     FindValue.SetFocus ;
     FindValue.SelectAll;

end;

procedure TfrmSelectDlg.FindValueKeyPress(Sender: TObject; var Key: Char);
begin
     if Key = #13 then
     begin
          SelectDataSource.DataSet.Locate (grdSelect.Columns.Items[FindKey.ItemIndex].FieldName
                                     ,Trim(FindValue.Text)
                                     ,[loPartialKey]);
          FindValue.SetFocus;
          FindValue.SelectAll;
     end
end;

function TfrmSelectDlg.Execute(const KeyField,KeyValue:string):boolean;
begin
  FindValue.text := KeyValue;
  SelectDataSource.DataSet.Locate(KeyField,KeyValue,[loPartialKey]);
  result := Showmodal=mrOK;
end;

end.
