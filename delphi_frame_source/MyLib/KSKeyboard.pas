unit KSKeyboard;
{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>KSKeyboard
   <What>包含和键盘相关的函数
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

interface

uses Windows, Messages, Classes, Controls;

const
  AltMask = $20000000;

  lcSimulateKey = 16;

type
  // 按键状态
  TKSKeyState = (ksDown, ksUp, ksToggled);

  // 按键状态组合
  TKSKeyStates = set of TKSKeyState;

  {
    <Class>TKSKeyboard
    <What>键盘对象。包含的类方法提供键盘相关的操作
    <Properties>
      -
    <Methods>
      GetKeyState - 获得按键(VK_XXXX)状态
      GetShiftState - 获得特殊键状态
      IsDown - 判断按键是否按下
      IsToggled - 判断特殊按键（NumLock）是否处于按下状态。
      CurKeyToShortCut - 将当前按键转换为快捷键
      SimulateKey - 模拟按键输入
    <Event>
      -
  }
  TKSKeyboard = class(TObject)
  private

  protected

  public
    class function  GetKeyState(Key : Integer) : TKSKeyStates;
    class function  GetShiftState : TShiftState;
    class function  IsDown(Key : Integer) : Boolean;
    class function  IsToggled(Key : Integer) : Boolean;
    class function  CurKeyToShortCut(Msg : TWMKey): TShortcut;
    class procedure SimulateKey(VirKey : byte; shift: TShiftState);
  end;

  // 方便访问的定义
  Keyboard=TKSKeyboard;

//function Keyboard : TKSKeyboard;

implementation

uses SysUtils, Forms, LogFile, ConvertUtils;
{
var
  FKeyboard : TKSKeyboard = nil;

function Keyboard : TKSKeyboard;
begin
  if FKeyboard=nil then
  begin
    FKeyboard := TKSKeyboard.Create;
  end;
  Result := FKeyboard;
end;
}
{ TKSKeyboard }

class function TKSKeyboard.CurKeyToShortCut(Msg: TWMKey): TShortcut;
begin
  Result := Byte(Msg.CharCode);
  if Windows.GetKeyState(VK_SHIFT) < 0 then Inc(Result, scShift);
  if Windows.GetKeyState(VK_CONTROL) < 0 then Inc(Result, scCtrl);
  if (msg.KeyData and AltMask) <> 0 then Inc(Result, scAlt);
end;

class function TKSKeyboard.GetKeyState(Key: Integer): TKSKeyStates;
var
  Data : SmallInt;
begin
  Data := Windows.GetKeyState(Key);
  if Data<0 then
    Result := [ksDown] else
    Result := [ksUp];
  if (Data and $01)>0 then
    Result := Result + [ksToggled];
end;

class function TKSKeyboard.GetShiftState: TShiftState;
var
  KeyboardState: TKeyboardState;
begin
  GetKeyboardState(KeyboardState);
  Result := KeyboardStateToShiftState(KeyboardState);
end;

class function TKSKeyboard.IsDown(Key: Integer): Boolean;
var
  Data : SmallInt;
begin
  Data := Windows.GetKeyState(Key);
  Result :=  Data<0;
end;

class function TKSKeyboard.IsToggled(Key: Integer): Boolean;
var
  Data : SmallInt;
begin
  Data := Windows.GetKeyState(Key);
  Result := (Data and $01)>0;
end;

class procedure TKSKeyboard.SimulateKey(VirKey: byte; shift: TShiftState);
var
  ctrlPressed,altPressed,shiftPressed : boolean;
  Inputs : Array[1..7] of TInput;
  InputCount : integer;

  procedure addInput(VKCode : byte; status:integer);
  begin
    inc(InputCount);
    Inputs[InputCount].Itype := INPUT_KEYBOARD;
    with Inputs[InputCount].ki do
    begin
      wVk := VKCode;
      wScan := 0;
      time := 0;
      dwExtraInfo := 0;
      dwFlags := status;
    end;
  end;

  procedure check(keyPressed : boolean; ashift : TShiftState; VKCode : byte; Undo:boolean);
  begin
    if not Undo then
    begin
      if keyPressed and not (ashift <= shift) then
      begin
        addInput(VKCode,KEYEVENTF_KEYUP);
        writeLog(IntToStr(VKCode)+' up',lcSimulateKey);
      end
      else if {not keyPressed and} (ashift <= shift) then
      begin
        addInput(VKCode,0);
        writeLog(IntToStr(VKCode)+' down',lcSimulateKey);
      end;
    end else
    begin
      if keyPressed and not (ashift <= shift) then
      begin
        addInput(VKCode,0);
        writeLog(IntToStr(VKCode)+' down',lcSimulateKey);
      end
      else if not keyPressed and (ashift <= shift) then
      begin
        addInput(VKCode,KEYEVENTF_KEYUP);
        writeLog(IntToStr(VKCode)+' up',lcSimulateKey);
      end;
    end;
  end;

begin
  {
  InputCount:=0;
  ctrlPressed := GetAsyncKeyState(VK_CONTROL)<0;
  altPressed := GetAsyncKeyState(VK_Menu)<0;
  shiftPressed := GetAsyncKeyState(VK_Shift)<0;
  writeLog('Alt:'+BoolStrs[altPressed]+' Ctrl:'+BoolStrs[CtrlPressed]+' Shift:'+BoolStrs[ShiftPressed]);

  check(shiftPressed,[ssShift],VK_Shift,false);
  check(ctrlPressed,[ssCtrl],VK_Control,false);
  check(altPressed,[ssAlt],VK_Menu,false);

  //keybd_event(VirKey,0,0,0);
  addInput(VirKey,0);

  check(shiftPressed,[ssShift],VK_Shift,true);
  check(ctrlPressed,[ssCtrl],VK_Control,true);
  check(altPressed,[ssAlt],VK_Menu,true);

  sendInput(InputCount,Inputs[1],sizeof(Inputs[1]));
  }

  InputCount:=0;
  ctrlPressed := GetAsyncKeyState(VK_CONTROL)<0;
  altPressed := GetAsyncKeyState(VK_Menu)<0;
  shiftPressed := GetAsyncKeyState(VK_Shift)<0;
  writeLog('Alt:'+BoolStrs[altPressed]+' Ctrl:'+BoolStrs[CtrlPressed]+' Shift:'+BoolStrs[ShiftPressed],lcSimulateKey);

  check(shiftPressed,[ssShift],VK_Shift,false);
  check(ctrlPressed,[ssCtrl],VK_Control,false);
  check(altPressed,[ssAlt],VK_Menu,false);

  //keybd_event(VirKey,0,0,0);
  addInput(VirKey,0);
  sendInput(InputCount,Inputs[1],sizeof(Inputs[1]));

  InputCount:=0;
  if shiftPressed<>(GetAsyncKeyState(VK_Shift)<0) then
    check(shiftPressed,[ssShift],VK_Shift,true);
  if ctrlPressed<>(GetAsyncKeyState(VK_Control)<0) then
    check(ctrlPressed,[ssCtrl],VK_Control,true);
  if altPressed<>(GetAsyncKeyState(VK_Menu)<0) then
  check(altPressed,[ssAlt],VK_Menu,true);
end;

initialization

finalization
  //FreeAndNil(FKeyboard);

end.
