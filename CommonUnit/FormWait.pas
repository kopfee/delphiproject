unit FormWait;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    ActiveX, Dialogs, StdCtrls;

type
    TfrmWait = class(TForm)
        lblPrompt: TLabel;
        procedure FormCreate(Sender: TObject);
        procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    private
        { Private declarations }
    public
        { Public declarations }
    end;
    TFromWaitThread = class(TThread)
    private
        MyProc: TProcedure;
    protected
        procedure Execute; override;
    public
        constructor Create(proc: TProcedure; MSG: string);
    end;

procedure OpenWaitWnd(Msg: string; Style: Integer = SW_SHOWNORMAL);
procedure CloseWaitWnd;

var
    frmWait: TfrmWait;

implementation

{$R *.dfm}


var
    theWaitWindow: TfrmWait = nil;

constructor TFromWaitThread.Create(proc: TProcedure; MSG: string);
begin
    inherited Create(TRUE);
    MyProc := proc;
    OpenWaitWnd(MSG);
end;

procedure TFromWaitThread.Execute;
begin
    CoInitialize(nil);
    MyProc;
    CloseWaitWnd;
    CoUnInitialize;
end;

procedure OpenWaitWnd(Msg: string; Style: Integer = SW_SHOWNORMAL); export;
begin
    if not Assigned(theWaitWindow) then begin
        theWaitWindow := TfrmWait.Create(application);
    end;
    theWaitWindow.lblPrompt.Caption := MSG;
    SetWindowPos(theWaitWindow.Handle, HWND_TOP, (Screen.Width - theWaitWindow.Width) shr 1,
        (Screen.Height - theWaitWindow.Height shl 1) shr 1, 0, 0, SWP_SHOWWINDOW or SWP_NOACTIVATE or SWP_NOSIZE);

    theWaitWindow.Show;
    Application.ProcessMessages;
    //Application.Mainform.Enabled := False;
end;


procedure CloseWaitWnd; export;
begin
    if Assigned(theWaitWindow) then
        theWaitWindow.Close;
end;

procedure TfrmWait.FormCreate(Sender: TObject);
begin
    AlphaBlend := True;
//    BorderStyle := bsToolWindow;
end;

procedure TfrmWait.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    // CloseWaitWnd;
    // Application.Mainform.Enabled := true;
end;

end.

