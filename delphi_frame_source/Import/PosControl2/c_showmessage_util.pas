unit c_showmessage_util;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  Tc_showmessageFORM = class(TForm)
    Button1: TButton;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  c_showmessageFORM: Tc_showmessageFORM;

procedure c_showmessage(const msg:string);

implementation

{$R *.DFM}
//====================================================================
procedure c_showmessage(const msg:string);//refrence c_showmessageFORM
const
minformwidth: integer=200;
marginwidth: integer=20;

begin
with c_showmessageFORM do
  begin
    //设置主要提示信息.
    label1.caption:=msg;
    //以下横向排版
    if label1.width>=(minformwidth-marginwidth*2) then
        clientwidth:=label1.width + marginwidth*2
    else
        clientwidth:=minformwidth;
    label1.left:=(clientwidth - label1.width) div 2;
    button1.left:=(clientwidth - button1.width) div 2;
    //以下纵向排版
    button1.Top:=label1.Top+label1.Height+16;
    ClientHeight:=button1.Top+button1.Height+16;

    showmodal;
  end;// of with
end;

end.
