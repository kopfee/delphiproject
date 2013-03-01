unit Design2;

interface

uses windows,messages,classes,controls,Design,DragMoveUtils;

type
  TDesigner2 = class(TCustomDesigner)
  private
    FGrabBoard: TGrabBoard;
    //FCount : integer;
    procedure   DoSizePosChanged(sender : TObject);
    procedure   BoardMouseDown(sender : TGrabBoard; var msg : TWMNCLBUTTONDOWN; var handled:boolean);
  protected
    function    GetDesignCtrl: TControl; override;
    procedure   InternalSetDesignCtrl(Acontrol: TControl); override;
    procedure   CtrlSizeMove(ACtrl: TControl); override;
    function    HookThis(acontrol : TControl):boolean; override;
  public
    Constructor Create(AOwner : TComponent);override;
    class function getDesignFrameClass : TDesignFrameClass; override;
    property    GrabBoard : TGrabBoard read FGrabBoard;
  published

  end;

implementation

uses sysUtils;

{ TDesigner2 }

constructor TDesigner2.Create(AOwner: TComponent);
begin
  inherited;
  FGrabBoard := TGrabBoard(DesignFrame);
  FGrabBoard.OnSizePosChanged:=DoSizePosChanged;
  FGrabBoard.OnSpecialMouseDown := BoardMouseDown;
end;

class function TDesigner2.getDesignFrameClass: TDesignFrameClass;
begin
  result := TGrabBoard;
end;

procedure TDesigner2.CtrlSizeMove(ACtrl: TControl);
var
  dc : TControl;
begin
  if DesignCtrl=ACtrl then
  begin
    dc := FGrabBoard;
    if (dc.left<>actrl.Left) or (dc.top<>actrl.top)
      or (dc.width<>actrl.width) or (dc.Height<>actrl.Height) then
    begin
      {DesignCtrl:=nil;
      DesignCtrl:=ACtrl;}
      FGrabBoard.UpdateSize;
      DoSizePosChanged(self);
    end;
  end;
end;

function TDesigner2.GetDesignCtrl: TControl;
begin
  result := TGrabBoard(DesignFrame).DestCtrl;
end;

procedure TDesigner2.InternalSetDesignCtrl(Acontrol: TControl);
begin
  TGrabBoard(DesignFrame).DestCtrl:=Acontrol;
  if Acontrol<>nil then
  begin
    TGrabBoard(DesignFrame).MoveEnabled := CanMoveCtrl(Acontrol);
    TGrabBoard(DesignFrame).SizeEnabled := CanSizeCtrl(Acontrol);
  end;
  DoDesignCtrlChanged(AControl);
  if Acontrol<>nil then
    //SetFocusOn(Self);
    Windows.SetFocus(Handle);
end;

procedure TDesigner2.DoSizePosChanged(sender: TObject);
begin
  //DoDesignCtrlChanged(GetDesignCtrl);
  CtrlPosChanged;
end;

function TDesigner2.HookThis(acontrol: TControl): boolean;
begin
  result := not (acontrol is TGrabHandle);
  result := result and inherited HookThis(acontrol);
end;

procedure TDesigner2.BoardMouseDown(sender: TGrabBoard;
  var msg: TWMNCLBUTTONDOWN; var handled:boolean);
var
  PlaceOn : TWinControl;
  P1,P2 : TPoint;
  ACtrl : TControl;
  LinkedCtrl : TControl;
begin
	//if not PtInRect(GetControlRect(self),Point(msg.XCursor,msg.YCursor))
  p1 := point(msg.XCursor,msg.YCursor);
  LinkedCtrl := DesignCtrl;
  if (msg.HitTest=HTCaption) and (LinkedCtrl is TWinControl) then
  begin
    ACtrl := ChildFromPos(TWinControl(LinkedCtrl),p1,true);
    //ACtrl := ChildFromPos(Designer,p1,false); // new
    if (ACtrl<>DesignCtrl) and (ACtrl<>nil) then
    begin
      DesignCtrl := ACtrl;
      LinkedCtrl := ACtrl;
      handled:=true;
    end;
  end;
  if PlaceNewCtrl and (LinkedCtrl<>nil) then
  begin
    //if LinkedCtrl is TWinControl then PlaceOn := LinkedCtrl as TWinControl
    if csAcceptsControls in LinkedCtrl.controlstyle then PlaceOn := LinkedCtrl as TWinControl
    else PlaceOn := LinkedCtrl.parent;
    P2 := PlaceOn.ScreenToClient(p1);
    DoPlaceNewCtrl(PlaceOn,p2.x,p2.Y);
    handled := true;
  end;
  {// force to back
  sendtoback;}
  {if not handled and (msg.HitTest=HTCaption) then
  begin
    inc(FCount);
    outputDebugString(pchar(IntToStr(FCount)+' drag'));
  end;}
end;

end.
