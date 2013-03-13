object MainForm: TMainForm
  Left = 198
  Top = 171
  BorderStyle = bsToolWindow
  Caption = #19968#21345#36890#37197#32622#24037#20855
  ClientHeight = 142
  ClientWidth = 307
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object rzpnl1: TRzPanel
    Left = 0
    Top = 0
    Width = 307
    Height = 142
    Align = alClient
    Alignment = taLeftJustify
    BorderInner = fsFlat
    BorderOuter = fsFlat
    TabOrder = 0
    object btnExit: TRzButton
      Left = 216
      Top = 104
      Caption = #36864' '#20986
      Color = 15791348
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      HighlightColor = 16026986
      HotTrack = True
      HotTrackColor = 3983359
      ParentFont = False
      TabOrder = 0
      OnClick = btnExitClick
    end
    object btnEncrypt: TRzButton
      Left = 104
      Top = 48
      Caption = #21152#23494#35299#23494
      Color = 15791348
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      HighlightColor = 16026986
      HotTrack = True
      HotTrackColor = 3983359
      ParentFont = False
      TabOrder = 1
      OnClick = btnEncryptClick
    end
  end
end
