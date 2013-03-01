unit FormUtils;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> FormUtils
   <What> 有关Form的工具
   调整Form的大小位置等等
   <Written By> Huang YanLai
   <History>
**********************************************}


interface

uses	Windows, Messages, SysUtils, Classes,Controls,Forms;

{ Form Size/position Utilities.
	How to use them:
	Example : in OnFormCreate handler, write
    SetFormSize(self,0.5,0,5);
   or SetFormPos(self,true,false,false,false);
   or both
}

type
  TFormPosition = (atLeft,atRight,atTop,atBottom);
  TFormPositions = set of TFormPosition;

// set form size relative of Screen
procedure SetFormSize(Form : TCustomForm; WidthPersent, HeightPersent : real);

// set form position relative of Screen
procedure	SetFormPos(Form : TCustomForm; poss : TFormPositions);

// set form at Screen center
procedure	PlaceScreenCenter(Form: TCustomForm);

// set form position relative of another form
procedure SetFormRelatePos(Form,RelateForm : TCustomForm;
	pos : TFormPosition; distance : integer);

// set form position relative of another form, and change form's size.
procedure SetFormRelatePos2(Form,RelateForm : TCustomForm;
	pos : TFormPosition; distance : integer; ChangeSize : boolean);

// set form position relative of another form, and change form's size.
// use offset relative to RelateForm's left or right or top or bottom.
// offset + rightward,downward, - leftward,upward
procedure SetFormRelatePos3(Form,RelateForm : TCustomForm;
	pos : TFormPosition; offset : integer; ChangeSize : boolean);

procedure ShowDockableCtrl(Ctrl : TControl);

implementation

procedure SetFormSize(Form : TCustomForm; WidthPersent, HeightPersent : real);
var
  width,height : integer;
begin
  width := round(Screen.width * WidthPersent);
  height := round(Screen.height * HeightPersent);
  Form.SetBounds(Form.left,Form.top,width,height);
end;

procedure	SetFormPos(Form : TCustomForm; poss : TFormPositions);
var
  left,width,top,height : integer;
begin
  left := Form.left;
  width := Form.width;
  top := Form.top;
  height := Form.height;

  if [atleft,atright] <= poss then
  begin
    left:=0;
    width := screen.width;
  end
  else // not change width
  begin
    if atLeft in poss then left:=0
    else if atRight in poss then left:=screen.width-width;
  end;

  if [attop,atbottom]<=poss then
  begin
    top:=0;
    height := screen.height;
  end
  else // not change height
  begin
    if attop in poss then top:=0
    else if atbottom in poss then top:=screen.height-height;
  end;

  Form.SetBounds(left,top,width,height);
end;

procedure	PlaceScreenCenter(Form: TCustomForm);
var
  Left,top : integer;
begin
  Left := (screen.width - form.width) div 2;
  Top := (screen.Height - form.Height) div 2;
  Form.SetBounds(left,top,form.width,form.Height);
end;

procedure SetFormRelatePos(Form,RelateForm : TCustomForm;
	pos : TFormPosition; distance : integer);
{var
  left,top,width,height : integer;}
begin
{  left := Form.left;
  width := Form.width;
  top := Form.top;
  height := Form.height;
  case pos of
    atLeft:		left := RelateForm.Left - distance - width;
    atRight:	left := RelateForm.Left + RelateForm.width + distance;
    atTop:		top := RelateForm.Top - distance - Height;
    atBottom: top := RelateForm.top + RelateForm.height + distance;
  end;
  Form.SetBounds(left,top,width,height);}
  SetFormRelatePos2(Form,RelateForm,
  	pos,distance,false);
end;

procedure SetFormRelatePos2(Form,RelateForm : TCustomForm;
	pos : TFormPosition; distance : integer; ChangeSize : boolean);
var
  left,top,width,height : integer;
begin
  left := Form.left;
  width := Form.width;
  top := Form.top;
  height := Form.height;
  case pos of
    atLeft:		left := RelateForm.Left - distance - width;
    atRight:	left := RelateForm.Left + RelateForm.width + distance;
    atTop:		top := RelateForm.Top - distance - Height;
    atBottom: top := RelateForm.top + RelateForm.height + distance;
  end;
  if changeSize then
  begin
    width := width + (Form.left-left);
    Height := Height + (Form.top-top);
  end;
  Form.SetBounds(left,top,width,height);
end;

// set form position relative of another form, and change form's size.
// use offset
procedure SetFormRelatePos3(Form,RelateForm : TCustomForm;
	pos : TFormPosition; offset : integer; ChangeSize : boolean);
var
  left,top,width,height : integer;
begin
  left := Form.left;
  width := Form.width;
  top := Form.top;
  height := Form.height;
  case pos of
    atLeft:		left := RelateForm.Left + offset;
    atRight:	left := RelateForm.Left + RelateForm.width + offset;
    atTop:		top := RelateForm.Top + offset;
    atBottom: top := RelateForm.top + RelateForm.height + offset;
  end;
  if changeSize then
  begin
    width := width + (Form.left-left);
    Height := Height + (Form.top-top);
  end;
  Form.SetBounds(left,top,width,height);
end;

procedure ShowDockableCtrl(Ctrl : TControl);
begin
  repeat
    while Ctrl.HostDockSite<>nil do
      Ctrl:=Ctrl.HostDockSite;
    while Ctrl.parent<>nil do
      Ctrl := Ctrl.parent;
  until (Ctrl.parent=nil) and (Ctrl.HostDockSite=nil);
  if Ctrl is TCustomForm then
    with TCustomForm(Ctrl) do
      if WindowState = wsMinimized then
        WindowState := wsNormal;
  Ctrl.show;
end;

end.
