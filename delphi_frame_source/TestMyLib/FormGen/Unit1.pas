unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtDialogs;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    edFile: TEdit;
    btnBrowse: TButton;
    btnSave: TButton;
    OpenDialogEx1: TOpenDialogEx;
    Label6: TLabel;
    btnSave2: TButton;
    Button1: TButton;
    ListBox1: TListBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    edClassName: TEdit;
    Button2: TButton;
    procedure btnBrowseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSave2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    procedure RegisterAllComponents;
  public
    { Public declarations }
    class function classNameAddr : Pointer;
    class function DynamicTableAddr: Pointer;
    class function InstanceSizeAddr: Pointer;
    class function MethodTableAddr: Pointer;
  end;

var
  Form1: TForm1;

function  getClassNameAddr(obj :TObject):pointer;

implementation

uses FrmFileGen,Proxies;

{$R *.DFM}

procedure TForm1.btnBrowseClick(Sender: TObject);
begin
  OpenDialogEx1.Execute;
end;

procedure TForm1.btnSaveClick(Sender: TObject);
begin
  ModuleFileGen(edFile.text,self);
end;

procedure TForm1.btnSave2Click(Sender: TObject);
{var
  form : TForm;}
begin
  {RegisterAllComponents;
  form := TForm.create(Application);
  try
    ReadComponentResFile('Unit1.dfm',form);
    ModuleFileGen(edFile.text,form,'TMyForm','TForm');
  finally
    form.free;
  end;}
  ModuleFileGen(edFile.text,self,edClassName.text,'TForm');
end;

procedure TForm1.RegisterAllComponents;
var
  i : integer;
begin
  for i:=0 to ComponentCount-1 do
    RegisterClass(TPersistentClass(Components[i].ClassType));
end;

type
  TShortString = ^ShortString;

procedure TForm1.Button1Click(Sender: TObject);
var
  p : TShortString;
  p2 : pchar;
  i : integer;
begin
  p := TShortString(classNameAddr);
  label1.caption := IntToHex(integer(p),8);
  ShowMessage(p^);
  p2 := pchar(p);
  inc(p2);
  ListBox1.items.clear;
  for i:=0 to 200 do
  begin
    ListBox1.items.add(p2^);
    inc(p2);
  end;
  p2 := pchar(DynamicTableAddr);
  label2.caption := IntToHex(integer(p2),8);
  p2 := pchar(InstanceSizeAddr);
  label3.caption := IntToHex(integer(p2),8);
  p2 := pchar(MethodTableAddr);
  label4.caption := IntToHex(integer(p2),8);
  p2 := getClassNameAddr(self);
  label5.caption := IntToHex(integer(p2),8);
end;

class function TForm1.classNameAddr: Pointer;
asm
        { ->    EAX VMT                         }
        PUSH    ESI
        MOV     ESI,[EAX].vmtClassName
        MOV     result,ESI
        POP     ESI
end;

class function TForm1.DynamicTableAddr: Pointer;
asm
        { ->    EAX VMT                         }
        PUSH    ESI
        MOV     ESI,[EAX].vmtDynamicTable
        MOV     result,ESI
        POP     ESI
end;

class function TForm1.InstanceSizeAddr: Pointer;
asm
        { ->    EAX VMT                         }
        PUSH    ESI
        MOV     ESI,[EAX].vmtInstanceSize
        MOV     result,ESI
        POP     ESI
end;

class function TForm1.MethodTableAddr: Pointer;
asm
        { ->    EAX VMT                         }
        PUSH    ESI
        MOV     ESI,[EAX].vmtMethodTable
        MOV     result,ESI
        POP     ESI
end;

function  getClassNameAddr(obj :TObject):pointer;
asm
        { ->    EAX VMT                         }
        mov     EAX,obj
        mov     EAX,[EAX]
        MOV     EAX,[EAX].vmtClassName
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Proxies.CreateSubClass(form1,'HYLForm','THYLForm',TForm1);
  showMessage(form1.className);
  Proxies.DestroySubClass(form1);
end;

end.
