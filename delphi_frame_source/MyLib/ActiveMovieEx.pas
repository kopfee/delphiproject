unit ActiveMovieEx;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, AMovie_TLB;

type
  TActiveMovieEx = class(TActiveMovie,IDispatch)
  private
    { Private declarations }
    FDesigned : boolean;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
  protected
    { Protected declarations }
  public
    { Public declarations }
    procedure   BeginSetproperty;
    procedure   EndSetproperty;
  published
    { Published declarations }
  end;

procedure Register;

implementation

uses ActiveX,ComObj;

procedure Register;
begin
  RegisterComponents('ActiveX', [TActiveMovieEx]);
end;

function StringToVarOleStr(const S: string): Variant;
begin
  VarClear(Result);
  TVarData(Result).VOleStr := StringToOleStr(S);
  TVarData(Result).VType := varOleStr;
end;

{ TActiveMovieEx }

procedure TActiveMovieEx.BeginSetproperty;
begin
  FDesigned := true;
end;


procedure TActiveMovieEx.EndSetproperty;
begin
  FDesigned := false;
end;

function TActiveMovieEx.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HResult;
var
  F: TFont;
  Form : TForm;
begin
  if (Flags and DISPATCH_PROPERTYGET <> 0) and (VarResult <> nil) then
  begin
    Result := S_OK;
    case DispID of
      DISPID_AMBIENT_BACKCOLOR:
        PVariant(VarResult)^ := Color;
      DISPID_AMBIENT_DISPLAYNAME:
        PVariant(VarResult)^ := StringToVarOleStr(Name);
      DISPID_AMBIENT_FONT:
      begin
        Form :=TForm(GetParentForm(self));
        if Form<>nil then
          F := Form.Font
        else
          F := Font;
       { if (Parent <> nil) and ParentFont then
          F := Parent.Font
        else }
          //F := Font;

        PVariant(VarResult)^ := FontToOleFont(F);
      end;
      DISPID_AMBIENT_FORECOLOR:
        PVariant(VarResult)^ := Font.Color;
      DISPID_AMBIENT_LOCALEID:
        PVariant(VarResult)^ := GetUserDefaultLCID;
      DISPID_AMBIENT_MESSAGEREFLECT:
        PVariant(VarResult)^ := True;
      DISPID_AMBIENT_USERMODE:
        PVariant(VarResult)^ := not FDesigned ;
      DISPID_AMBIENT_UIDEAD:
        PVariant(VarResult)^ := FDesigned; //csDesigning in ComponentState;
      DISPID_AMBIENT_SHOWGRABHANDLES:
        PVariant(VarResult)^ := False;
      DISPID_AMBIENT_SHOWHATCHING:
        PVariant(VarResult)^ := False;
      DISPID_AMBIENT_SUPPORTSMNEMONICS:
        PVariant(VarResult)^ := True;
      DISPID_AMBIENT_AUTOCLIP:
        PVariant(VarResult)^ := True;
    else
      Result := DISP_E_MEMBERNOTFOUND;
    end;
  end else
    Result := DISP_E_MEMBERNOTFOUND;
end;

end.
