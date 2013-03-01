unit UIntfComps;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  // the test interface
  IMyInterface = interface
    // must have a GUID!
    ['{A2E399C0-D4D3-11D4-AAFD-00C0268E6AE8}']
    function  GetName : string;
  end;

  // the client component that need the interface reference
  TInterfaceClient = class(TComponent)
  private
    FMyInterface: IMyInterface;
    FInterfaceInstance: TComponent;
    procedure   SetInterfaceInstance(const Value: TComponent);
    procedure   SetMyInterface(const Value: IMyInterface);
  protected
    // because TComponent does not implement the interface reference couting
    // you must free the interface reference when its instance destroyed
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    // only public the instance property
    property    MyInterface : IMyInterface read FMyInterface write SetMyInterface;
  published
    // the instance that can provide the interface
    property    InterfaceInstance : TComponent read FInterfaceInstance write SetInterfaceInstance;
  end;

  // a component that provides the interface
  TInterfaceProvider = class(TComponent,IMyInterface)
  private

  protected

  public
    function  GetName : string;
  published

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TInterfaceClient, TInterfaceProvider]);
end;

{ TInterfaceClient }

procedure TInterfaceClient.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  // when the interface instance go dead, free the interface reference
  if (AComponent=FInterfaceInstance) and (Operation=opRemove) then
    InterfaceInstance := nil;
end;

procedure TInterfaceClient.SetInterfaceInstance(const Value: TComponent);
begin
  if FInterfaceInstance <> Value then
  begin
    FInterfaceInstance := Value;
    if FInterfaceInstance<>nil then
    begin
      // first, free the interface reference
      FMyInterface := nil;
      // the instance can provide the desired interface?
      if FInterfaceInstance.GetInterface(IMyInterface,FMyInterface) then
        // have gotten the interface reference
        FInterfaceInstance.FreeNotification(Self)
      else
        // there is no the interface reference
        FInterfaceInstance := nil;
    end
    else
    begin
      // there is no the interface instance
      FMyInterface := nil;
    end;
  end;
end;

procedure TInterfaceClient.SetMyInterface(const Value: IMyInterface);
begin
  // when user manually directly set interface
  FMyInterface := Value;
  FInterfaceInstance := nil;
end;

{ TInterfaceProvider }

function TInterfaceProvider.GetName: string;
begin
  Result := Name;
end;

end.
