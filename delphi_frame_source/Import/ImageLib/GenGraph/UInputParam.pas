unit UInputParam;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, CompGroup, Spin;

type
  TfmInputParam = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    seWidth: TSpinEdit;
    seHeight: TSpinEdit;
    apColor: TAppearanceProxy;
    ColorDialog1: TColorDialog;
    btnGen: TButton;
    Label3: TLabel;
    cbShape: TComboBox;
    procedure btnGenClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmInputParam: TfmInputParam;

implementation

uses UGenGraph, UViewGraph;

{$R *.DFM}

const
  TestFileName = 'c:\test.gif';

procedure TfmInputParam.btnGenClick(Sender: TObject);
begin
  GenGif(seWidth.Value,seHeight.Value,apColor.Color,cbShape.ItemIndex,TestFileName);
  fmViewer.Execute(TestFileName);
end;

end.
