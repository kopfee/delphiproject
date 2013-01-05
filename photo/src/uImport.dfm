object frmImport: TfrmImport
  Left = 248
  Top = 186
  BorderStyle = bsDialog
  Caption = #29031#29255#20449#24687#23548#20837
  ClientHeight = 398
  ClientWidth = 569
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 569
    Height = 217
    Align = alTop
    BevelOuter = bvNone
    Color = 16053492
    TabOrder = 0
    object lbl1: TLabel
      Left = 16
      Top = 10
      Width = 90
      Height = 15
      AutoSize = False
      Caption = #29031#29255#25152#22312#20301#32622
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 299
      Top = 10
      Width = 73
      Height = 15
      AutoSize = False
      Caption = #23548#20837#26085#26399#65306
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object drvcbb1: TDriveComboBox
      Left = 112
      Top = 8
      Width = 177
      Height = 19
      DirList = dirlstPhoto
      TabOrder = 0
    end
    object dirlstPhoto: TDirectoryListBox
      Left = 112
      Top = 32
      Width = 249
      Height = 185
      FileList = fllstPhoto
      ItemHeight = 16
      TabOrder = 1
    end
    object fllstPhoto: TFileListBox
      Left = 368
      Top = 32
      Width = 193
      Height = 185
      ItemHeight = 13
      Mask = '*.jpg'
      TabOrder = 2
    end
    object dtpDate: TDateTimePicker
      Left = 368
      Top = 6
      Width = 97
      Height = 21
      Date = 39098.658506400460000000
      Time = 39098.658506400460000000
      TabOrder = 3
    end
    object dtpTime: TDateTimePicker
      Left = 464
      Top = 6
      Width = 97
      Height = 21
      Date = 39098.658506400460000000
      Time = 39098.658506400460000000
      Kind = dtkTime
      TabOrder = 4
    end
  end
  object pnl1: TPanel
    Left = 0
    Top = 217
    Width = 569
    Height = 120
    Align = alTop
    BevelOuter = bvNone
    Color = 16053492
    TabOrder = 1
    object Label2: TLabel
      Left = 16
      Top = 10
      Width = 150
      Height = 15
      AutoSize = False
      Caption = #23548#20837#36807#31243#20013#30340#38169#35823#20449#24687
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object lstError: TListBox
      Left = 16
      Top = 31
      Width = 545
      Height = 82
      ImeName = #25340#38899#21152#21152#38598#21512#29256
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object pb1: TProgressBar
    Left = 0
    Top = 376
    Width = 569
    Height = 22
    Align = alBottom
    Smooth = True
    TabOrder = 2
  end
  object btnImport: TBitBtn
    Left = 384
    Top = 344
    Width = 65
    Height = 25
    Caption = '&I'#23548' '#20837
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = btnImportClick
  end
  object BitBtn1: TBitBtn
    Left = 488
    Top = 344
    Width = 65
    Height = 25
    Caption = '&E'#36820' '#22238
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = BitBtn1Click
  end
end
