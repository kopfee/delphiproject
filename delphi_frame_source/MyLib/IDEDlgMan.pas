unit IDEDlgMan;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls,ExptIntf;

type
  TdlgIDEDlgMan = class(TForm)
    btnInstall: TButton;
    btnUninstall: TButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    btnTest: TButton;
    procedure btnInstallClick(Sender: TObject);
    procedure btnUninstallClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
  private
    { Private declarations }
    procedure CheckButton;
  public
    { Public declarations }
    procedure Execute;
  end;

var
  dlgIDEDlgMan: TdlgIDEDlgMan;

type
  TIDEDlgs = class(TIExpert)
  public
    { Expert UI strings }
    function GetName: string; Override;
    function GetAuthor: string; Override;
    function GetComment: string; Override;
    function GetPage: string; Override;
    function GetGlyph: HICON; Override;
    function GetStyle: TExpertStyle; Override;
    function GetState: TExpertState; Override;
    function GetIDString: string; Override;
    function GetMenuText: string; Override;
    { Launch the Expert }
    procedure Execute; Override;
  end;

procedure Register;

implementation

{$R *.DFM}

uses IDEDlgs;

procedure Register;
begin
  RegisterLibraryExpert(TIDEDlgs.Create);
end;

{ TdlgIDEDlgMan }

procedure TdlgIDEDlgMan.CheckButton;
var
  b : boolean;
begin
  b := isInstalled;
  btnInstall.Enabled := not b;
  btnUninstall.Enabled := b;
  btnTest.Enabled := b;
end;

procedure TdlgIDEDlgMan.Execute;
begin
  CheckButton;
  ShowModal;
end;

procedure TdlgIDEDlgMan.btnInstallClick(Sender: TObject);
begin
  InstallDlgs;
  CheckButton;
end;

procedure TdlgIDEDlgMan.btnUninstallClick(Sender: TObject);
begin
  UnInstallDlgs;
  CheckButton;
end;

procedure TdlgIDEDlgMan.btnTestClick(Sender: TObject);
begin
  TestDlg;
end;

{ TIDEDlgs }

procedure TIDEDlgs.Execute;
var
  Dialog : TdlgIDEDlgMan;
begin
  Dialog := TdlgIDEDlgMan.create(nil);
  try
    Dialog.Execute;
  finally
    Dialog.free;
  end;
end;

function TIDEDlgs.GetAuthor: string;
begin
  result := 'HYL';
end;

function TIDEDlgs.GetComment: string;
begin
  result := 'IDE Dlgs';
end;

function TIDEDlgs.GetGlyph: HICON;
begin
  result := 0;
end;

function TIDEDlgs.GetIDString: string;
begin
  result := 'HYL.IDEDlgs';
end;

function TIDEDlgs.GetMenuText: string;
begin
  result := 'IDEDlgs';
end;

function TIDEDlgs.GetName: string;
begin
  result := 'IDEDlgs';
end;

function TIDEDlgs.GetPage: string;
begin
  result := '';
end;

function TIDEDlgs.GetState: TExpertState;
begin
  result := [esEnabled];
end;

function TIDEDlgs.GetStyle: TExpertStyle;
begin
  result := esStandard;
end;

end.
