unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ExtCtrls, StdCtrls, Dialogs, ExtDialogs;

type
  TForm1 = class(TForm)
    Button1: TButton;
    OpenDialogEx1: TOpenDialogEx;
    Label1: TLabel;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  OpenDialogEx1.NewStyle :=CheckBox1.Checked;
  OpenDialogEx1.IsSaveDialog := CheckBox2.Checked;
  //OpenDialogEx1.FileName := Edit1.Text;
  if CheckBox3.Checked then
    OpenDialogEx1.Options := OpenDialogEx1.Options+[ofNoDereferenceLinks]
  else
    OpenDialogEx1.Options := OpenDialogEx1.Options-[ofNoDereferenceLinks];
  OpenDialogEx1.Execute;  
  {if OpenDialogEx1.Execute then
    Edit1.Text:=OpenDialogEx1.FileName;}
end;

end.
