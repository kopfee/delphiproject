object Form1: TForm1
  Left = 275
  Top = 168
  Width = 1092
  Height = 565
  Align = alClient
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Splitter1: TSplitter
    Left = 0
    Top = 397
    Width = 1084
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1084
    Height = 397
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 1
    object Image1: TImage
      Left = 1
      Top = 1
      Width = 1082
      Height = 395
      Align = alClient
      Stretch = True
    end
    object WindowsMediaPlayer1: TWindowsMediaPlayer
      Left = 1
      Top = 1
      Width = 1082
      Height = 395
      Align = alClient
      TabOrder = 0
      ControlData = {
        000300000800000000000500000000000000F03F030000000000050000000000
        0000000008000200000000000300010000000B00FFFF0300000000000B00FFFF
        08000200000000000300320000000B00000008000A000000660075006C006C00
        00000B0000000B0000000B00FFFF0B00FFFF0B00000008000200000000000800
        020000000000080002000000000008000200000000000B000000D46F0000D328
        0000}
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 400
    Width = 1084
    Height = 138
    Align = alBottom
    BorderStyle = bsSingle
    TabOrder = 0
    object RzPageControl1: TRzPageControl
      Left = 1
      Top = 1
      Width = 408
      Height = 132
      ActivePage = TabSheet1
      ActivePageDefault = TabSheet1
      Align = alLeft
      TabIndex = 0
      TabOrder = 0
      FixedDimension = 18
      object TabSheet1: TRzTabSheet
        Caption = #36164#28304#24211
        object btnSelect: TButton
          Left = 40
          Top = 30
          Width = 113
          Height = 25
          Caption = #36873#25321#36164#28304#30446#24405
          TabOrder = 0
          OnClick = btnSelectClick
        end
      end
      object TabSheet2: TRzTabSheet
        Caption = #26495#20070#31995#32479
      end
      object TabSheet3: TRzTabSheet
        Caption = #27969#31243#32534#36753
      end
      object TabSheet4: TRzTabSheet
        Caption = #25945#23398#31649#29702
      end
      object TabSheet5: TRzTabSheet
        Caption = #31995#32479#35774#32622
      end
    end
    object RzPanel1: TRzPanel
      Left = 716
      Top = 1
      Width = 363
      Height = 132
      Align = alRight
      TabOrder = 1
      object Label1: TLabel
        Left = 87
        Top = 48
        Width = 132
        Height = 12
        Caption = #31186#20043#21518#23558#25773#25918#19979#19968#20010#25991#26723
      end
      object lblHint: TLabel
        Left = 55
        Top = 48
        Width = 12
        Height = 12
        Caption = '11'
      end
      object btnPlay: TButton
        Left = 8
        Top = 6
        Width = 75
        Height = 25
        Caption = #25773#25918
        TabOrder = 0
        OnClick = btnPlayClick
      end
      object btnPause: TButton
        Left = 82
        Top = 6
        Width = 75
        Height = 25
        Caption = #26242#20572
        TabOrder = 1
        OnClick = btnPauseClick
      end
      object btnStop: TButton
        Left = 156
        Top = 6
        Width = 75
        Height = 25
        Caption = #20572#27490
        TabOrder = 2
        OnClick = btnStopClick
      end
      object MediaPlayer1: TMediaPlayer
        Left = 238
        Top = 6
        Width = 85
        Height = 30
        VisibleButtons = [btPlay, btPause, btStop]
        Display = Panel2
        TabOrder = 3
      end
    end
    object RzGroupBox1: TRzGroupBox
      Left = 409
      Top = 1
      Width = 307
      Height = 132
      Align = alClient
      Caption = #36164#28304#21015#34920
      TabOrder = 2
      object CheckListBox1: TCheckListBox
        Left = 1
        Top = 13
        Width = 305
        Height = 118
        Align = alClient
        ItemHeight = 13
        PopupMenu = PopupMenu1
        Style = lbOwnerDrawFixed
        TabOrder = 0
        OnDblClick = CheckListBox1DblClick
      end
    end
  end
  object OpenDialog1: TOpenDialog
    InitialDir = 'C:\'
    Left = 40
    Top = 264
  end
  object PopupMenu1: TPopupMenu
    Left = 320
    Top = 200
    object N1: TMenuItem
      Caption = #32534#36753
      OnClick = N1Click
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 192
    Top = 224
  end
  object PowerPointApplication1: TPowerPointApplication
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    AutoQuit = False
    Left = 144
    Top = 184
  end
end
