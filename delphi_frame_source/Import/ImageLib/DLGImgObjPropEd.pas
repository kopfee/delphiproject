unit DLGImgObjPropEd;
(*****   Code Written By Huang YanLai   *****)

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
    OpenPictureDialog1: TOpenPictureDialog;
    btnSave: TBitBtn;
    procedure btnLoadClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
    ILImage1 : TCustomILImage;
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
  public
    { Public declarations }
    function  Execute(ImageObj : TCustomImgLibObj) : boolean;
  end;

var
  dlgImgObjpropEditor: TdlgImgObjpropEditor;

implementation

uses ShellAPI;

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
  if ImageObj is TImgLibObj then
    ILImage1 := TILImage.Create(self)
  else if ImageObj is TImgLibViewObj then
    ILImage1 := TILImageView.Create(self)
  else
  begin
    result:=false;
    exit;
  end;

  try
    DragAcceptFiles(handle,true);
    ILImage1.Align := alClient;
    ILImage1.Parent := Panel1;
    ILImage1.ImageObj.Assign(ImageObj);
    ILImage1.ImageObj.Transparent := false;

    result := showmodal=mrOK;
    if result and (ImageObj<>nil) then
    begin
      ILImage1.ImageObj.Transparent := ImageObj.Transparent;
      ImageObj.Assign(ILImage1.ImageObj);
    end;
  finally
    ILImage1.free;
    DragAcceptFiles(handle,false);
  end;
end;

procedure TdlgImgObjpropEditor.btnSaveClick(Sender: TObject);
begin
  OpenPictureDialog1.Title := 'Save Image';
  if OpenPictureDialog1.Execute then
    ILImage1.ImageObj.SaveToFile(OpenPictureDialog1.FileName);
end;

procedure TdlgImgObjpropEditor.WMDropFiles(var Msg: TWMDropFiles);
var
  CFileName: array[0..MAX_PATH] of Char;
begin
  try
    if DragQueryFile(Msg.Drop, 0, CFileName, MAX_PATH) > 0 then
    begin
      ILImage1.ImageObj.LoadFromFile(CFileName);
      Msg.Result := 0;
    end;
  finally
    DragFinish(Msg.Drop);
  end;
end;

end.
