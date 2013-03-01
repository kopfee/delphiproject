unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Design, ExtCtrls, BkGround, Grids;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    cbDesign: TCheckBox;
    BackGround1: TBackGround;
    Designer1: TDesigner;
    Label1: TLabel;
    Button1: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    CheckBox2: TCheckBox;
    RadioButton1: TRadioButton;
    ListBox1: TListBox;
    StaticText1: TStaticText;
    GroupBox1: TGroupBox;
    Panel2: TPanel;
    StringGrid1: TStringGrid;
    cbTransparent: TCheckBox;
    procedure cbDesignClick(Sender: TObject);
    procedure cbTransparentClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.cbDesignClick(Sender: TObject);
begin
  Designer1.Designed:=cbDesign.checked;
end;

procedure TForm1.cbTransparentClick(Sender: TObject);
begin
  BackGround1.Transparent := cbTransparent.checked;
end;

end.
