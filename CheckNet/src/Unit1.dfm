object Form1: TForm1
  Left = 610
  Top = 402
  Width = 307
  Height = 166
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 120
    Width = 299
    Height = 19
    Panels = <>
  end
  object Button1: TButton
    Left = 56
    Top = 40
    Width = 185
    Height = 25
    Caption = 'Manual Test'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 104
    Top = 8
  end
  object RzTrayIcon1: TRzTrayIcon
    PopupMenu = PopupMenu1
    Left = 40
    Top = 8
  end
  object PopupMenu1: TPopupMenu
    Left = 72
    Top = 8
    object Exit1: TMenuItem
      Caption = 'Exit'
      OnClick = Exit1Click
    end
  end
end
