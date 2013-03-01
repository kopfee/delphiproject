unit PImage;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TPImage = class(TImage)
  private
    { Private declarations }
    FAutoRected : Boolean;
    FPicIsPreDef  : Boolean;
    FPreDefPicFileName : String;
    FResourceName : string;
  protected
    { Protected declarations }
    procedure SetAutoRected(Value : Boolean);
    procedure SetPreDefPicFileName(Value : string);
    procedure SetResourceName(Value : string);
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
    property AutoRected : Boolean read FAutoRected write SetAutoRected;
    property PicIsPreDef : Boolean read FPicIsPreDef write FPicIsPreDef;
    property Picture stored False;
    property PreDefPicFileName : string read FPreDefPicFileName write SetPreDefPicFileName;
    property ResourceName: string read FResourceName write SetResourceName;
  end;

procedure Register;

implementation

constructor TPImage.Create(AOwner: TComponent);
begin
     inherited;
end;

procedure TPImage.SetAutoRected(Value : Boolean);
begin
     FAutoRected := Value;
     if FAutoRected then
     begin
        if Width < Height then
           Height := Width
        else
            Width := Height;
     end;
end;

procedure TPimage.WMPaint(var Message: TWMPaint);
begin
     inherited;
     if FAutoRected then
     begin
        if Width < Height then
           Height := Width
        else
            Width := Height;
     end;
end;

procedure TPImage.SetPreDefPicFileName(Value : string);
var  tmpPicture: TPicture;
     tmpBitmap: TBitmap;
begin
     if (Value = '') then
     begin
           FPreDefPicFileName := Value;
           exit;
     end;
     if FPreDefPicFileName <> Value then
        if FileExists(Value)  then
           FPreDefPicFileName := Value;

     tmpPicture := TPicture.Create;
     tmpBitmap := TBitmap.Create;

     if not (csDesigning in ComponentState) then //运行时
     begin
          if FPicIsPreDef = True then //预定义
          begin
               try
                  tmpPicture.Bitmap.LoadFromFile(FPreDefPicFileName);
               except
                     try
                        tmpPicture.Bitmap.LoadFromResourceName(HInstance,FResourceName);
                     except
                     end;
               end;
          end
          else
          begin
               try
                  tmpPicture.Bitmap.LoadFromResourceName(HInstance,FResourceName);
               except
               end;
          end;
          Picture := tmpPicture;
     end
     else  //设计时
     begin
          if FPicIsPreDef = True then //预定义
          begin
               if FPreDefPicFileName <> '' then
               try
                  tmpBitmap.LoadFromFile(FPreDefPicFileName);
               except
                     showmessage('无法装载位图文件');
               end;
          end;
          Picture.Bitmap := tmpBitmap;
     end;
     tmpPicture.Free;
     tmpBitmap.Free;
end;

procedure TPImage.SetResourceName(Value : string);
var tmpPicture: TPicture;
    tmpBitmap: TBitmap;
begin
     FResourceName := Value;
     tmpPicture := TPicture.Create;
     tmpBitmap := TBitmap.Create;

     if not (csDesigning in ComponentState) then //运行时
     begin
          if FPicIsPreDef <> True then //未预定义
          begin
               try
                  tmpPicture.Bitmap.LoadFromResourceName(HInstance,FResourceName);
               except
               end;
          end;
          Picture := tmpPicture;
     end;
     tmpPicture.Free;
     tmpBitmap.Free;
end;

procedure Register;
begin
     RegisterComponents('PosControl', [TPImage]);
end;

end.
