unit ClipbrdMon;

interface

uses  windows,Messages,Classes,WinUtils;

type
  TClipboardMonitor = class(TMessageComponent)
  private
    FActive: boolean;
    FNextViewer : THandle;
    FOnChanged: TNotifyEvent;
    procedure   SetActive(const Value: boolean);
  protected
    procedure   WMCHANGECBCHAIN(var Message:TMessage); message WM_CHANGECBCHAIN;
    procedure   WMDRAWCLIPBOARD(var Message:TMessage); message WM_DRAWCLIPBOARD;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    procedure 	Add;
    procedure 	Delete;
  published
    property    Active : boolean read FActive write SetActive default false;
    property    OnChanged : TNotifyEvent read FOnChanged write FOnChanged;
  end;

implementation

{ TClipboardMonitor }

constructor TClipboardMonitor.Create(AOwner: TComponent);
begin
  inherited;
  FActive := false;
  FNextViewer := 0;
end;

destructor TClipboardMonitor.Destroy;
begin
  active := false;
  inherited;
end;

procedure TClipboardMonitor.Add;
begin
  if not FActive then
  begin
    FNextViewer := SetClipboardViewer(FUtilWindow.Handle);
    FActive := true;
  end;
end;

procedure TClipboardMonitor.Delete;
begin
  if FActive then
  begin
    ChangeClipboardChain(FUtilWindow.Handle, FNextViewer);
    FActive := false;
  end;
end;

procedure TClipboardMonitor.SetActive(const Value: boolean);
begin
  if (FActive <> Value) then
    if (csDesigning in ComponentState) then
      FActive := Value
    else
    if value then
    	Add
    else
    	delete;
end;

procedure TClipboardMonitor.WMCHANGECBCHAIN(var Message: TMessage);
begin
  if LongWord(Message.wParam) = FNextViewer then
    FNextViewer := Message.lParam else
    // Otherwise, pass the message to the next link.
    if (FNextViewer <>0 ) then
      SendMessage(FNextViewer, Message.Msg, Message.wParam, Message.lParam);
end;


procedure TClipboardMonitor.WMDRAWCLIPBOARD(var Message: TMessage);
begin
  if Assigned(FONChanged) then
    FONChanged(self);
  SendMessage(FNextViewer, Message.Msg, Message.wParam, Message.lParam);
end;

end.
