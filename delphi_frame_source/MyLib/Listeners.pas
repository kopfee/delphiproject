unit Listeners;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> Listeners
   <What> 定义IListener,实现对Listener设计模式的支持
   <Written By> Huang YanLai
   <History>
**********************************************}


interface

uses classes;

type
  TObjectEvent = class(TObject);

  IListener = interface
    procedure Notify(Sender : TObject; Event : TObjectEvent);
  end;

  TListenerSupport = class
  private
    FSender: TObject;
    FList : TInterfaceList;
  public
    procedure   addListener(Listener : IListener);
    procedure   removeListener(Listener : IListener);
    procedure   notifyListeners(Event : TObjectEvent);
    // notifyListeners2 call notifyListeners, then free Event
    procedure   notifyListeners2(Event : TObjectEvent);
    constructor Create(ASender : TObject);
    Destructor  Destroy;override;
    property    Sender : TObject read FSender;
  end;

implementation

uses LogFile, SysUtils;

{ TListenerSupport }

constructor TListenerSupport.Create(ASender: TObject);
begin
  inherited Create;
  FList := TInterfaceList.create;
  FSender:=ASender;
end;

destructor TListenerSupport.Destroy;
var
  AList : TObject;
begin
  AList := FList;
  FList := nil;
  FreeAndNil(AList);
  inherited;
end;

procedure TListenerSupport.notifyListeners(Event : TObjectEvent);
var
  i : integer;
begin
  if FList<>nil then
  begin
    FList.Lock;
    try
      //for i:=0 to FList.count-1 do
      // sometimes when it Notified a listener,
      // the listener will be removed from this list
      // there maybe a out of list exception
      for i:=FList.count-1 downto 0 do
        IListener(FList[i]).Notify(FSender,Event);
    finally
      FList.UnLock;
    end;
  end;
end;

procedure TListenerSupport.addListener(Listener: IListener);
begin
  if FList<>nil then
    FList.add(Listener);
  writeLog('add listener',lcDebug);
end;

procedure TListenerSupport.removeListener(Listener: IListener);
begin
  if FList<>nil then
    FList.Remove(Listener);
  writeLog('remove listener',lcDebug);
end;

procedure TListenerSupport.notifyListeners2(Event: TObjectEvent);
begin
  try
    notifyListeners(Event);
  finally
    Event.free;
  end;
end;

end.
