unit UFoldView2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs,ShlObj,ShellAPI;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SHELLVIEW : ISHELLVIEW;
  end;

var
  Form1: TForm1;

implementation

uses ComObj;

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var
  Explorer : IUnknown;
  Desktop : IShellFolder;
  ShellBrowse : IShellBrowser;
  settings : TFOLDERSETTINGS;
  TheWnd : HWND;
  p : pointer;
  ARect : TRect;
begin
  Explorer := nil;
  OLECheck(SHGetInstanceExplorer(Explorer));
  {SHGetInstanceExplorer(Explorer);
  ShellBrowse := Explorer as  IShellBrowser;}
  OLECheck(SHGetDesktopFolder(Desktop));
  //ShellBrowse := Desktop as IShellBrowser;
  //Desktop.QueryInterface(IID_IShellBrowser,ShellBrowse);
  OLECheck(Desktop.CreateViewObject(handle,
  	IID_ISHELLVIEW,p));
  ShellView := IShellView(p);
  settings.viewmode := FVM_ICON	;
  settings.fFlags := FWF_AUTOARRANGE ;
  ARect := RECT(0,0,width,height);
  OLECheck(ShellView.CreateViewWindow(nil,
     settings,
     ShellBrowse,
     ARect,
     TheWnd));
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if ShellView<>nil then
	  ShellView.DestroyViewWindow;
  ShellView:=nil;
end;

end.
