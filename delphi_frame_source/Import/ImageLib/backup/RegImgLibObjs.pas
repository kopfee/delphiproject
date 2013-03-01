unit RegImgLibObjs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,Controls;

procedure Register;

implementation

uses ImageLibX,ImgLibObjs,DLGImgObjPropEd,DsgnIntf;

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
  RegisterComponents('users',[TILImage]);
  RegisterPropertyEditor(TImgLibObj.ClassInfo,nil,'',TImgLibObjProperty);
  RegisterComponentEditor(TILImage,TILImageEditor);
end;


{ TImgLibObjProperty }

procedure TImgLibObjProperty.Edit;
var
  OpenDialog :  TdlgImgObjpropEditor;
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

function TImgLibObjProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paSubProperties, paDialog, paReadOnly];
end;

{ TILImageEditor }

procedure TILImageEditor.ExecuteVerb(Index: Integer);
begin
  with Component as TILImage do
  case index of
    0 : LoadImage;
    1 : ImageObj.Clear;
  end;
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
    OpenDialog.execute(TILImage(Component).ImageObj);
  finally
    OpenDialog.free;
  end;
end;

end.
