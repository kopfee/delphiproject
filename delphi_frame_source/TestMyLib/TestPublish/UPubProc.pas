unit UPubProc;

// for test published procedure

interface

uses Sysutils,Classes,controls;

type
	TTest1 = class(TComponent)
	private
    FOnNotify: TNotifyEvent;
	published
  	procedure RespondNotifyEvent(sender : TObject);
	  property	OnNotify : TNotifyEvent read FOnNotify	write FOnNotify;
	end;

procedure Register;

implementation

{ TTest1 }

procedure TTest1.RespondNotifyEvent(sender: TObject);
begin
  if Assigned(FOnNotify) then FOnNotify(sender);
end;


procedure Register;
begin
  registerComponents('users',[TTest1]);
end;
end.
