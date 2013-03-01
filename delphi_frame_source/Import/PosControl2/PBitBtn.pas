unit PBitBtn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TPBitBtn = class(TBitBtn)
  private
    { Private declarations }
    FPicFileName : String;
    FResourceName: string;
  protected
    { Protected declarations }
    procedure SetPicFileName(Value: string);
    procedure SetResourceName(Value: string);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
    property Glyph stored False;
    property PicFileName: string read FPicFileName write SetPicFileName;
    property ResourceName: string read FResourceName write SetResourceName;
  end;

procedure Register;

implementation

constructor TPBitBtn.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     Font.Name := 'ËÎÌו';
     Font.Size := 11;
end;

procedure TPBitBtn.SetPicFileName(Value : string);
var tmpBitmap: TBitmap;
begin
     FPicFileName := Value;
     if (csDesigning in ComponentState) then
     begin
          tmpBitmap := TBitmap.Create;
          try
             tmpBitmap.LoadFromFile(FPicFileName);
          except
          end;
          Glyph := tmpBitmap;
          tmpBitmap.Free;
     end;
end;

procedure TPBitBtn.SetResourceName(Value : string);
var tmpBitmap: TBitmap;
begin
     FResourceName := Value;
     if not (csDesigning in ComponentState) then
     begin
          tmpBitmap := TBitmap.Create;
          try
             tmpBitmap.LoadFromResourceName(HInstance,Value);
          except
          end;
          Glyph := tmpBitmap;
          tmpBitmap.Free;
     end;
end;

procedure Register;
begin
     RegisterComponents('PosControl', [TPBitBtn]);
end;

end.

