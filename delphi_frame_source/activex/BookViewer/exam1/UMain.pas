unit UMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, PDGLib_TLB, ExtDialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls,
  Menus;

type
  TfmViewer = class(TForm)
    Viewer: TPdg;
    pnTools: TPanel;
    Label1: TLabel;
    edURL: TEdit;
    OpenDialogEx1: TOpenDialogEx;
    btnPrev: TSpeedButton;
    btnNext: TSpeedButton;
    pnBottom: TPanel;
    pnStatus: TPanel;
    pnZoom: TPanel;
    pnPageNo: TPanel;
    btnFullScreen: TSpeedButton;
    btnOpen: TSpeedButton;
    btnBrowse: TSpeedButton;
    PopupMenu1: TPopupMenu;
    N111: TMenuItem;
    N121: TMenuItem;
    N131: TMenuItem;
    N141: TMenuItem;
    N151: TMenuItem;
    N161: TMenuItem;
    N171: TMenuItem;
    N181: TMenuItem;
    procedure btnBrowseClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure ViewerBeforeTransfer(Sender: TObject);
    procedure ViewerTransferComplete(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure pnPageNoClick(Sender: TObject);
    procedure pnZoomClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure btnFullScreenClick(Sender: TObject);
    procedure SetTheZoom(Sender: TObject);
  private
    { Private declarations }
    FisFullScreen: boolean;
    oldLeft,oldTop,oldWidth,oldHeight : integer;
    fullscreenX,fullscreenY,fullscreenW,fullscreenH : integer;
    procedure SetIsFullScreen(const Value: boolean);
    procedure WMGETMINMAXINFO(var message : TWMGETMINMAXINFO);message WM_GETMINMAXINFO;
    procedure decZoom;
    procedure incZoom;
  public
    { Public declarations }
    property  isFullScreen : boolean read FisFullScreen write SetIsFullScreen;
  end;

var
  fmViewer: TfmViewer;

implementation

uses CompUtils;

{$R *.DFM}

procedure TfmViewer.btnBrowseClick(Sender: TObject);
begin
  OpenDialogEx1.Execute;
end;

procedure TfmViewer.btnOpenClick(Sender: TObject);
begin
  Viewer.URL := edURL.text;
  //Viewer.LoadPage(edURL.text,0,0,100);
end;

procedure TfmViewer.ViewerBeforeTransfer(Sender: TObject);
begin
  pnPageNo.caption := Viewer.pagenum;
  pnStatus.caption := 'Transfering...';
end;

procedure TfmViewer.ViewerTransferComplete(Sender: TObject);
begin
  if Viewer.ValidPage then
    pnStatus.caption := 'Complete' else
    pnStatus.caption := 'Bad page';
  pnZoom.Caption := IntToStr(Viewer.Zoom);
end;

procedure TfmViewer.btnPrevClick(Sender: TObject);
begin
  Viewer.GotoPreviousPage;
end;

procedure TfmViewer.btnNextClick(Sender: TObject);
begin
  Viewer.GotoNextPage;
end;

procedure TfmViewer.pnPageNoClick(Sender: TObject);
var
  newPage : string;
begin
  newPage := Viewer.pagenum;
  if InputQuery('Goto Page','Page No:',newPage) then
  begin
    Viewer.pagenum := newPage;
  end;
end;

{
procedure TfmViewer.pnZoomClick(Sender: TObject);
var
  zoom : integer;
  pageNo : string;
begin
  zoom :=  Viewer.Zoom;
  pageNo := Viewer.pagenum;
  if dlgZoom.execute(Zoom) then
  begin
    Viewer.SetZoom(zoom);
  end;
end;
}

procedure TfmViewer.pnZoomClick(Sender: TObject);
begin
  PopupAMenu(PopupMenu1,pnZoom);
end;

procedure TfmViewer.SpeedButton1Click(Sender: TObject);
begin
  Viewer.GotoContent;
end;

procedure TfmViewer.WMGETMINMAXINFO(var message: TWMGETMINMAXINFO);
begin
  inherited ;
  with message.MinMaxInfo^.ptMaxTrackSize do
  begin
    x:=2 * screen.width;
    y:=2 * screen.height;
  end;
end;

procedure TfmViewer.FormActivate(Sender: TObject);
begin
  oldLeft:=left;
  oldTop:=top;
  oldWidth:=width;
  oldHeight:=height;
  fullscreenX:=-(width-clientWidth) div 2;
  fullscreenY:=-(height-clientHeight)-pnTools.Height;
  fullscreenW:=Screen.width+(width-clientWidth);
  fullscreenH:= (height-clientHeight) // caption height
    + pnTools.Height + Screen.Height + pnBottom.Height;
end;

procedure TfmViewer.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if ActiveControl<>edURL then
  begin
    case key of
      #27 : isFullScreen := false; // ESC
      #9  : isFullScreen := not isFullScreen; // TAB
      '-' : decZoom;
      '+' : incZoom;
    end;
  end;
end;

procedure TfmViewer.SetIsFullScreen(const Value: boolean);
begin
  if (FisFullScreen <> Value) then
  begin
    FisFullScreen := value;
    if (FisFullScreen) then
    begin
      oldLeft:=left;
      oldTop:=top;
      oldWidth:=width;
      oldHeight:=height;
      setBounds(fullscreenX,fullscreenY,fullscreenW,fullscreenH);
    end else
    setBounds(oldLeft,oldTop,oldWidth,oldHeight);
  end;
end;

procedure TfmViewer.FormCreate(Sender: TObject);
begin
  FisFullScreen := false;
end;

procedure TfmViewer.btnFullScreenClick(Sender: TObject);
begin
  isFullScreen := true;
end;

procedure TfmViewer.SetTheZoom(Sender: TObject);
begin
  Viewer.SetZoom(TComponent(Sender).tag);
end;

procedure TfmViewer.decZoom;
begin
  if Viewer.Zoom<8 then
    Viewer.SetZoom(Viewer.Zoom+1);
end;

procedure TfmViewer.incZoom;
begin
  if Viewer.Zoom>1 then
    Viewer.SetZoom(Viewer.Zoom-1);
end;

end.
