unit RegImgLibObjs;
(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,Controls;

procedure Register;

implementation

uses ImageLibX,ImgLibObjs,DLGImgObjPropEd,DsgnIntf,Dialogs;

type
  TImgLibObjProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function  GetAttributes: TPropertyAttributes; override;
  end;

  TILImageEditor = class(TComponentEditor)
  private
    procedure LoadImage;
  public
    function  GetVerbCount: Integer; override;
    function  GetVerb(Index: Integer): string;override;
    procedure ExecuteVerb(Index: Integer); override;
  end;


procedure Register;
begin
  //RegisterFileExt;
  RegisterComponents('UserCtrls',[TILImage,TILImageView]);
  {RegisterPropertyEditor(TImgLibObj.ClassInfo,nil,'',TImgLibObjProperty);
  RegisterComponentEditor(TILImage,TILImageEditor);}
  RegisterPropertyEditor(TCustomImgLibObj.ClassInfo,nil,'',TImgLibObjProperty);
  RegisterComponentEditor(TCustomILImage,TILImageEditor);
end;


{ TImgLibObjProperty }

{
procedure TImgLibObjProperty.Edit;
var
  OpenDialog :  TdlgImgObjpropEditor;
  //image : TImgLibObj;
  image : TImgLibObj;
begin
  image := TImgLibObj.Create;
  image.Assign(TImgLibObj(getOrdValue));
  OpenDialog := TdlgImgObjpropEditor.Create(nil);
  try
    if OpenDialog.execute(image) then
    begin
      SetOrdValue(integer(image));
    end;
  finally
    OpenDialog.free;
    image.free;
  end;
end;
}

procedure TImgLibObjProperty.Edit;
var
  OpenDialog :  TdlgImgObjpropEditor;
  image,workimage : TCustomImgLibObj;
begin
  workimage := TCustomImgLibObj(GetOrdValue);
  {ShowMessage('workimage OK');
  ShowMessage('workimage :'+workimage.ClassName);}
  image := TCustomImgLibObjClass(workimage.ClassType).Create;
  //ShowMessage('image OK');
  image.Assign(workimage);
  //ShowMessage('assign OK');
  OpenDialog := TdlgImgObjpropEditor.Create(nil);
  try
    if OpenDialog.execute(image) then
    begin
      SetOrdValue(integer(image));
    end;
  finally
    OpenDialog.free;
    image.free;
    Modified;
  end;
end;

function TImgLibObjProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paSubProperties, paDialog, paReadOnly];
end;

{ TILImageEditor }

procedure TILImageEditor.ExecuteVerb(Index: Integer);
begin
  with Component as TCustomILImage do
  case index of
    0 : LoadImage;
    1 : ImageObj.Clear;
  end;
  Designer.Modified;
end;

function TILImageEditor.GetVerb(Index: Integer): string;
begin
  case index of
    0 :  result := 'Load Image...';
    1 :  result := 'Clear Image';
  end;
end;

function TILImageEditor.GetVerbCount: Integer;
begin
  result := 2;
end;

procedure TILImageEditor.LoadImage;
var
  OpenDialog :  TdlgImgObjpropEditor;
begin
  OpenDialog := TdlgImgObjpropEditor.Create(nil);
  try
    OpenDialog.execute(TCustomILImage(Component).ImageObj);
  finally
    OpenDialog.free;
  end;
end;

end.
