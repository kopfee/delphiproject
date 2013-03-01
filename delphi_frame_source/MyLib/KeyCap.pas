unit KeyCap;

// %KeyCap : ²¶×½°´¼ü
(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs,ComWriUtils;

type
  TEnterKeyCapture = class;

  TEnterKeyFilter = class(ComWriUtils.TMsgFilter)
  private
    EnterKeyCapture: TEnterKeyCapture;
    procedure WMChar(var msg : TWMChar);message WM_Char;
  end;

  // %TEnterKeyCapture : ²¶×½Enter¼ü
  TEnterKeyCapture = class(TComponent)
  private
    { Private declarations }
    FOnEnterPressed: TNotifyEvent;
    FWinControl: TWinControl;
    procedure SetWinControl(const Value: TWinControl);
    procedure	EnterPressed;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
  published
    { Published declarations }
    property	WinControl : TWinControl read FWinControl write SetWinControl;
    property  OnEnterPressed : TNotifyEvent
    	read FOnEnterPressed write FOnEnterPressed;
  end;

implementation

{ TEnterKeyCapture }

constructor TEnterKeyCapture.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RegisterRefProp(self,'WinControl');
end;

procedure TEnterKeyCapture.EnterPressed;
begin
  if Assigned(FOnEnterPressed) then FOnEnterPressed(self);
end;

procedure TEnterKeyCapture.SetWinControl(const Value: TWinControl);
var
  Filter : TEnterKeyFilter;
begin
  if value<>FWinControl then
  begin
    UnhookMsgFilter(FWinControl,TEnterKeyFilter);
    FWinControl := Value;
    if FWinControl<>nil then
    begin
      Filter := TEnterKeyFilter(HookMsgFilter(FWinControl,TEnterKeyFilter));
	    Filter.EnterKeyCapture:=self;
		  ReferTo(value);
    end;
  end;
end;

{ TEnterKeyFilter }

procedure TEnterKeyFilter.WMChar(var msg: TWMChar);
begin
  inherited;
  if (msg.CharCode = vk_Return) and  (EnterKeyCapture<>nil) then
  	EnterKeyCapture.EnterPressed;
end;

end.
