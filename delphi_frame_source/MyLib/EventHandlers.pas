unit EventHandlers;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TNotifyHandler = class;

  TNotifyEventEx = procedure (Handler : TNotifyHandler;Sender : TObject) of object;

  TNotifyHandler = class(TComponent)
  private
    FOnNotify: TNotifyEventEx;
    FControl: TControl;
    procedure SetControl(const Value: TControl);
    { Private declarations }
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
  published
    { Published declarations }
    procedure Notify(Sender : TObject);
    property  OnNotify : TNotifyEventEx read FOnNotify write FOnNotify;
    property  Control : TControl read FControl write SetControl;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Users', [TNotifyHandler]);
end;

{ TNotifyHandler }

procedure TNotifyHandler.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (AComponent=FControl) and (Operation=opRemove) then
    FControl := nil;
end;

procedure TNotifyHandler.Notify(Sender: TObject);
begin
  if assigned(FOnNotify) then
    FOnNotify(self,Sender);
end;

type
  TControlAccess = class(TControl);
  
procedure TNotifyHandler.SetControl(const Value: TControl);
begin
  if FControl <> Value then
  begin
    if FControl<>nil then
      TControlAccess(FControl).OnClick := nil;
    FControl := Value;
    if FControl<>nil then
    begin
      FControl.FreeNotification(self);
      TControlAccess(FControl).OnClick := Notify;
    end;
  end;
end;

end.
