unit Main;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls;

type
    TForm1 = class(TForm)
        Memo1: TMemo;
        Button1: TButton;
        Button2: TButton;
        Button3: TButton;
        Button4: TButton;
        Button5: TButton;
        Button6: TButton;
        procedure Button3Click(Sender: TObject);
        procedure Button4Click(Sender: TObject);
        procedure Button5Click(Sender: TObject);
        procedure Button1Click(Sender: TObject);
        procedure Button6Click(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

    TReadCardThread = class(TThread)
    private
        AMemo: TMemo;
        ACardPhyID: array[0..32] of char;
    protected
        procedure Execute; override;
        procedure ShowCardPhyID;
    public
        constructor Create(memo: Tmemo);
    end;


var
    Form1: TForm1;
    st: smallint;
    readdata: array[0..32] of char;
implementation

uses CardDll;
{$R *.dfm}

constructor TReadCardThread.Create(memo: Tmemo);
begin
    inherited Create(false);
    AMemo := memo;
    FreeOnTerminate := true;
end;

procedure TReadCardThread.ShowCardPhyID();
begin
    AMemo.Lines.Add('cardno=[' + ACardPhyID + '],time=[' +datetimetoStr(now())+ ']');
    dc_beep(icdev, 10);
end;

procedure TReadCardThread.Execute();
begin
    while (true) do begin
        application.ProcessMessages;
        st := dc_card_hex(icdev, 1, ACardPhyID);
        if st = 0 then begin
            Synchronize(ShowCardPhyID);
        end;
        sleep(2000);
    end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
    sCardphyid: array[0..16] of Char;
    iCardType: integer;
begin
    Memo1.Lines.Add('open port=' + IntToStr(Wis_OpenPort(100, 9600)));
    Wis_Beep();
    Wis_Beep();
    Memo1.Lines.Add(Wis_GetVersion);
    Wis_Beep();
    iCardType := 1;
    FillChar(sCardphyid, 17, 0);
    Memo1.Lines.Add(IntToStr(Wis_RequestCard(sCardphyid, iCardType)));


end;

procedure TForm1.Button4Click(Sender: TObject);
begin
    Memo1.Lines.Add(IntToStr(Wis_Init));
end;

procedure TForm1.Button5Click(Sender: TObject);
var
    bb: pchar;
begin
    icdev := dc_init(100, 115200);
    dc_beep(icdev, 10);
    if icdev < 0 then begin
        Memo1.Lines.Add('调用 dc_init()函数出错!');
        exit;
    end;
    Memo1.Lines.add('调用 dc_init()函数成功!');

end;

procedure TForm1.Button1Click(Sender: TObject);
var
    sCardPhyId: longword;
    cardmode: integer;
    aTReadCardThread: TReadCardThread;
begin
    cardmode := 1; //MODE为1可反复寻卡, MODE为0卡必须拿开才可重新操作!

    aTReadCardThread := TReadCardThread.Create(memo1);
    //aTReadCardThread.Execute;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
    application.ProcessMessages;
    st := dc_card_hex(icdev, 1, readdata);
    if st = 0 then begin
        Memo1.Lines.Add('cardno=[' + readdata + '],time=[' +datetimetoStr(now())+ ']');
        dc_beep(icdev, 10);
    end
    else begin
        Memo1.Lines.Add('no card');
    end;
end;

end.

