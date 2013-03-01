unit UTestList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, WVCtrls, CheckLst, WorkViews;

type
  TForm1 = class(TForm)
    WorkView1: TWorkView;
    WVCheckListBox1: TWVCheckListBox;
    WVCheckListBox2: TWVCheckListBox;
    WVEdit1: TWVEdit;
    WVEdit2: TWVEdit;
    Label1: TLabel;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

end.
