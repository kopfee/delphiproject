unit DLGImgObjPropEd2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgLibObjs, ExtCtrls, StdCtrls, Buttons, ExtDlgs;

type
  TdlgImgObjpropEditor = class(TForm)
    btnLoad: TBitBtn;
    btnClear: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    Panel1: TPanel;
    ILImage1: TILImage;
    OpenPictureDialog1: TOpenPictureDialog;
    btnSave: TBitBtn;
    procedure btnLoadClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function  Execute(ImageObj : TCustomImgLibObj) : boolean;
  end;

var
  dlgImgObjpropEditor: TdlgImgObjpropEditor;

implementation

{$R *.DFM}

procedure TdlgImgObjpropEditor.btnLoadClick(Sender: TObject);
begin
  OpenPictureDialog1.Title := 'Load Image';
  if OpenPictureDialog1.Execute then
    ILImage1.ImageObj.LoadFromFile(OpenPictureDialog1.FileName);
end;

procedure TdlgImgObjpropEditor.btnClearClick(Sender: TObject);
begin
  ILImage1.ImageObj.Clear;
  //Invalidate;
end;

function TdlgImgObjpropEditor.Execute(ImageObj: TCustomImgLibObj): boolean;
begin
  ILImage1.ImageObj.Assign(ImageObj);
  ILImage1.Transparent := false;
  result := showmodal=mrOK;
  if result and (ImageObj<>nil) then
  begin
    ILImage1.ImageObj.Transparent := ImageObj.Transparent;
    if ImageObj is TImgLibObj then
      ImageObj.Assign(ILImage1.ImageObj)
    else if ImageObj is TImgLibViewObj then
    begin
      TImgLibViewObj(ImageObj).SetHandles(
        ILImage1.ImageObj.Bitmap.Handle,
        ILImage1.ImageObj.Bitmap.Palette);
      ILImage1.ImageObj.Bitmap.ReleasePalette;  
      ILImage1.ImageObj.Bitmap.ReleaseHandle;
    end;
  end;
end;

procedure TdlgImgObjpropEditor.btnSaveClick(Sender: TObject);
begin
  OpenPictureDialog1.Title := 'Save Image';
  if OpenPictureDialog1.Execute then
    ILImage1.ImageObj.SaveToFile(OpenPictureDialog1.FileName);
end;

end.
