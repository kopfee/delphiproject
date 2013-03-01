unit UAdjustCtrlFrame;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, Buttons, UTools, RPCtrls;

type
  TfaAdjustCtrls = class(TFrame)
    GroupBox1: TGroupBox;
    btnAlignLeft: TSpeedButton;
    btnAlignCenter: TSpeedButton;
    btnAlignRight: TSpeedButton;
    ckHAlign: TCheckBox;
    GroupBox2: TGroupBox;
    btnAlignTop: TSpeedButton;
    btnAlignMiddle: TSpeedButton;
    btnAlignBottom: TSpeedButton;
    btnAlignMultiLine: TSpeedButton;
    ckVAlign: TCheckBox;
    ckLeft: TCheckBox;
    ckRight: TCheckBox;
    ckWidth: TCheckBox;
    ckTop: TCheckBox;
    ckBottom: TCheckBox;
    ckHeight: TCheckBox;
    edLeft: TSpinEdit;
    edRight: TSpinEdit;
    edWidth: TSpinEdit;
    edTop: TSpinEdit;
    edBottom: TSpinEdit;
    edHeight: TSpinEdit;
    gbFrames: TGroupBox;
    btnFrameLeft: TSpeedButton;
    btnFrameTop: TSpeedButton;
    btnFrameBottom: TSpeedButton;
    btnFrameRight: TSpeedButton;
    ckFrames: TCheckBox;
    GroupBox3: TGroupBox;
    btnAnchorLeft: TSpeedButton;
    btnAnchorTop: TSpeedButton;
    btnAnchorBottom: TSpeedButton;
    btnAnchorRight: TSpeedButton;
    ckAnchors: TCheckBox;
  private
    { Private declarations }
    procedure WriteCtrlParams(Ctrl : TRDCustomControl);
    procedure DoUpdateCtrls(AComponent : TComponent; Extra1 : Pointer; Extra2 : Pointer);
  public
    { Public declarations }
    procedure ClearCheckBox;
    procedure ReadCtrlParams(Ctrl : TRDCustomControl);
    procedure UpdateSelectedCtrls(ASelection : ISimpleSelection);
  end;

implementation

uses RPDefines;

{$R *.DFM}

procedure TfaAdjustCtrls.ClearCheckBox;
var
  I : Integer;
begin
  for I:=0 to ComponentCount-1 do
  begin
    if Components[I] is TCheckBox then
      TCheckBox(Components[I]).Checked := False;
  end;
end;

procedure TfaAdjustCtrls.DoUpdateCtrls(AComponent: TComponent; Extra1,
  Extra2: Pointer);
begin
  WriteCtrlParams(TRDCustomControl(AComponent));
end;

procedure TfaAdjustCtrls.ReadCtrlParams(Ctrl: TRDCustomControl);
begin
  // frame
  ckFrames.Checked := false;
  btnFrameLeft.Down := Ctrl.Frame.Left>=0;
  btnFrameRight.Down := Ctrl.Frame.Right>=0;
  btnFrameTop.Down := Ctrl.Frame.Top>=0;
  btnFrameBottom.Down := Ctrl.Frame.Bottom>=0;
  // anchor
  ckAnchors.Checked := false;
  btnAnchorLeft.Down := akLeft in Ctrl.Anchors;
  btnAnchorRight.Down := akRight in Ctrl.Anchors;
  btnAnchorTop.Down := akTop in Ctrl.Anchors;
  btnAnchorBottom.Down := akBottom in Ctrl.Anchors;
  // size & position
  ckLeft.Checked := false;
  edLeft.Value := Ctrl.Left;
  ckRight.Checked := false;
  edRight.Value := Ctrl.RightDistance;
  ckTop.Checked := false;
  edTop.Value := Ctrl.Top;
  ckBottom.Checked := false;
  edBottom.Value := Ctrl.BottomDistance;
  ckWidth.Checked := false;
  edWidth.Value := Ctrl.Width;
  ckHeight.Checked := false;
  edHeight.Value := Ctrl.Height;
  // align
  if Ctrl is TRDLabel then
  with TRDLabel(Ctrl) do
  begin
    case HAlign of
      haLeft    : btnAlignLeft.down := true;
      haRight   : btnAlignRight.down := true;
      haCenter  : btnAlignCenter.down := true;
    end;
    case VAlign of
      vaTop     : btnAlignTop.down := true;
      vaBottom  : btnAlignBottom.down := true;
      vaCenter  : btnAlignMiddle.down := true;
      vaMultiLine:btnAlignMultiLine.down := true;
    end;
  end;
  ckHAlign.Checked:=False;
  ckVAlign.Checked:=False;
end;


procedure TfaAdjustCtrls.UpdateSelectedCtrls(ASelection : ISimpleSelection);
begin
  //FModified := True;
  EnumComponent(ASelection,TRDCustomControl,DoUpdateCtrls,nil,nil);
end;

procedure TfaAdjustCtrls.WriteCtrlParams(Ctrl: TRDCustomControl);
begin
  // frame
  if ckFrames.Checked then
  begin
    if btnFrameLeft.Down then
       Ctrl.Frame.Left:=0 else
       Ctrl.Frame.Left:=-1;
    if btnFrameRight.Down then
       Ctrl.Frame.Right:=0 else
       Ctrl.Frame.Right:=-1;
    if btnFrameTop.Down then
       Ctrl.Frame.Top:=0 else
       Ctrl.Frame.Top:=-1;
    if btnFrameBottom.Down then
       Ctrl.Frame.Bottom:=0 else
       Ctrl.Frame.Bottom:=-1;
  end;

  // anchor
  if ckAnchors.Checked then
  begin
    if btnAnchorLeft.Down then
      Ctrl.Anchors := Ctrl.Anchors + [akLeft] else
      Ctrl.Anchors := Ctrl.Anchors - [akLeft];
    if btnAnchorRight.Down then
      Ctrl.Anchors := Ctrl.Anchors + [akRight] else
      Ctrl.Anchors := Ctrl.Anchors - [akRight];
    if btnAnchorTop.Down then
      Ctrl.Anchors := Ctrl.Anchors + [akTop] else
      Ctrl.Anchors := Ctrl.Anchors - [akTop];
    if btnAnchorBottom.Down then
      Ctrl.Anchors := Ctrl.Anchors + [akBottom] else
      Ctrl.Anchors := Ctrl.Anchors - [akBottom];
  end;

  // size & position
  if ckLeft.Checked then
    Ctrl.Left := edLeft.Value;
  if ckRight.Checked then
    Ctrl.RightDistance := edRight.Value;
  if ckTop.Checked then
    Ctrl.Top := edTop.Value;
  if ckBottom.Checked then
    Ctrl.BottomDistance := edBottom.Value;
  if ckWidth.Checked then
    Ctrl.Width := edWidth.Value;
  if ckHeight.Checked then
    Ctrl.Height := edHeight.Value;
  // align
  if Ctrl is TRDLabel then
  with TRDLabel(Ctrl) do
  begin
    if ckHAlign.Checked then
      if btnAlignLeft.down then
        HAlign := haLeft
      else if btnAlignRight.down then
        HAlign := haRight
      else
        HAlign := haCenter;
    if ckVAlign.Checked then
      if btnAlignTop.down then
        VAlign := vaTop
      else if btnAlignBottom.down then
        VAlign := vaBottom
      else if btnAlignMiddle.down then
        VAlign := vaCenter
      else
        VAlign := vaMultiLine;
  end;
end;

end.
