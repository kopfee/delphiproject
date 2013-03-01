unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
uses TypInfo, typUtils;

procedure mysetcaption(acomponent : Tcomponent; const s : string);
begin
  SetStringProperty(acomponent ,'Caption',s);
end;

procedure mysetfont(acomponent : Tcomponent; f : TFont);
begin
{  TypeInfo := acomponent.classInfo;
  PropInfo := GetPropInfo(TypeInfo,'Font');
  if (propInfo<>nil)
  and (propInfo^.PropType^.Kind = tkClass)
    then begin
           PropValue := TObject(GetOrdProp(acomponent ,PropInfo));
           if PropValue is f.classType
              then (PropValue as TPersistent).assign(f);
         end;}
   SetOrdProperty(acomponent ,'Font',longint(f));
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  mysetcaption(label1,edit1.text);
  mysetcaption(panel1,edit1.text);
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  mysetFont(label1,bitbtn1.font);
  mysetfont(panel1,bitbtn1.font);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  label4.caption := IntToHex(longint(Bitbtn1.font),8);
  label5.caption := IntToHex(longint(panel1.font),8);
end;

end.
