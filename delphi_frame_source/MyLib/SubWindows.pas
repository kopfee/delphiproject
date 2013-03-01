unit SubWindows;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> SubWindows
   <What> 某些子类化的窗口
   <Written By> Huang YanLai
   <History>
**********************************************}

interface

uses windows,Messages,classes,sysutils,WinUtils;

{ TConvertHitTest
  converts HTClient to ClientTo when Enabled.
}
type
  TConvertHitTest = class(TSubClassWindow)
  private
    procedure WMNCHITTEST(var msg : TWMNCHITTEST);message WM_NCHITTEST;
  protected
    //procedure WndProc(var MyMsg : TMessage); override;
  public
    ClientTo : integer;
    constructor create(hw : THandle); override;
  end;

  TPassMouseToParent = class(TConvertHitTest)
  public
    constructor create(hw : THandle); override;
  end;

implementation

{ TConvertHitTest }

constructor TConvertHitTest.create(hw: THandle);
begin
  inherited create(hw);
  ClientTo := HTClient;
end;

procedure TConvertHitTest.WMNCHITTEST(var msg: TWMNCHITTEST);
begin
  inherited;
  if (Msg.result=HTClient) and Enabled then
    Msg.result := ClientTo;
end;

{
procedure TConvertHitTest.WndProc(var MyMsg: TMessage);
begin
  inherited WndProc(MyMsg);

end;
}
{ TPassMouseToParent }

constructor TPassMouseToParent.create(hw: THandle);
begin
  inherited create(hw);
  ClientTo := HTTransparent;
end;

end.
