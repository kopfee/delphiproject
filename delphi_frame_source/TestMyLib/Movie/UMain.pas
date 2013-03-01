unit UMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,MovieViewer;

type
  TForm1 = class(TForm)
    Notebook1: TNotebook;
    Panel1: TPanel;
    Label1: TLabel;
    edFileName: TEdit;
    btnBrowse: TButton;
    btnOpen: TButton;
    pnMovie0: TPanel;
    pnMovie1: TPanel;
    OpenDialog1: TOpenDialog;
    ckDesigned: TCheckBox;
    procedure btnBrowseClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure ckDesignedClick(Sender: TObject);
  private
    { Private declarations }
    OldMovieView,NewMovieView : TMovieView;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnBrowseClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    edFileName.Text := OpenDialog1.FileName;
    btnOpenClick(Sender);
  end;
end;

procedure TForm1.btnOpenClick(Sender: TObject);
begin
  if FileExists(edFileName.Text) then
  begin
    // must use application as owner
    // to resolve name-error
    NewMovieView := TMovieView.Create(application);
    //NewMovieView.Align := alClient;
    if Notebook1.PageIndex=0 then
      NewMovieView.Parent := pnMovie1
    else
      NewMovieView.Parent := pnMovie0;
    NewMovieView.OpenFile(edFileName.Text);
    Notebook1.PageIndex := 1-Notebook1.PageIndex;
    // must set align after PageIndex changed
    // not before set PageIndex
    // otherwise not align correctly
    NewMovieView.Align := alClient;
    OldMovieView.free;
    OldMovieView := NewMovieView;
    NewMovieView := nil;
  end;
end;

procedure TForm1.ckDesignedClick(Sender: TObject);
begin
  if OldMovieView<>nil then
    OldMovieView.Designed := ckDesigned.checked;
end;

end.
