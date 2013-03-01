unit ComWriUtils;

// Components writers' utilities

interface

uses windows,messages,sysutils,Classes,Controls,ExtCtrls;

{ 1. "RegisterRefProp" and "ReferTo" }

{ How to use "RegisterRefProp" and "ReferTo"
  1) in YourComponent.create
    call RegisterRefProp(self,'MyProperty');
  2) in YourComponent.SetMyProperty(value : TComponent)
    call ReferTo(value)
}

{ Register  a property that refers a component.
  The property must be published.
}
type
  TReferenceMan = class(TComponent)
  private
    FClients : TStringList;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor 	destroy; override;
    procedure 	RegisterRefProp(Instance : TComponent; const PropName : string);
    procedure 	ReferTo(RefInstance : TComponent);
  end;

procedure RegisterRefProp(Instance : TComponent; const PropName : string);

procedure ReferTo(RefInstance : TComponent);

{ 2. Some Exceptions and procedure
  remove to Safecode.
}

implementation

uses TypInfo,TypUtils,safecode;

var
  ReferenceMan : TReferenceMan;

procedure RegisterRefProp(Instance : TComponent; const PropName : string);
begin
  ReferenceMan.RegisterRefProp(Instance,PropName);
end;

procedure ReferTo(RefInstance : TComponent);
begin
  ReferenceMan.ReferTo(RefInstance);
end;

{ TReferenceMan }

constructor TReferenceMan.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FClients := TStringList.create;
end;

destructor TReferenceMan.destroy;
begin
  FClients.free;
  inherited destroy;
end;

procedure TReferenceMan.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  i : integer;
  ex : Exception;
begin
  ex := nil;
  if Operation<>opRemove then exit;
  repeat
    i := FClients.IndexOfObject(AComponent);
    if i>=0 then FClients.delete(i);
  until i<0;
  for i:=0 to FClients.count-1 do
    try
      if AComponent=GetClassProperty(FClients.objects[i],FClients[i])
       then SetClassProperty(FClients.objects[i],FClients[i],nil);
    except
      On e : Exception do Ex:=e;
    end;
  inherited Notification(AComponent ,Operation);
  if ex<>nil then raise ex;
end;

procedure TReferenceMan.ReferTo(RefInstance: TComponent);
begin
  if RefInstance<>nil then
    RefInstance.freeNotification(self);
end;

procedure TReferenceMan.RegisterRefProp(Instance: TComponent;
  const PropName: string);
var
  PropInfo: PPropInfo;
begin
  if checkProperty(Instance,PropName,
    [tkClass], PropInfo)
    then begin
           FClients.addObject(Propname,Instance);
           Instance.freeNotification(self);
         end
    else RaiseInvalidParam;
end;


initialization
  ReferenceMan := TReferenceMan.create(nil);
finalization
  ReferenceMan.free;
end.
