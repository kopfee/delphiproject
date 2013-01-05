object frmLimit: TfrmLimit
  Left = 250
  Top = 195
  BorderStyle = bsDialog
  Caption = #26435#38480#20449#24687#35774#32622
  ClientHeight = 344
  ClientWidth = 529
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 529
    Height = 297
    Align = alTop
    BevelOuter = bvNone
    Color = 16053492
    TabOrder = 0
    object lbl1: TLabel
      Left = 264
      Top = 16
      Width = 60
      Height = 15
      Caption = #30331#24405#21517#65306
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 263
      Top = 40
      Width = 61
      Height = 15
      Caption = #22995'  '#21517#65306
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 249
      Top = 64
      Width = 75
      Height = 15
      Caption = #29983#25928#26102#38388#65306
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 249
      Top = 88
      Width = 75
      Height = 15
      Caption = #22833#25928#26102#38388#65306
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 249
      Top = 112
      Width = 75
      Height = 15
      Caption = #30331#24405#23494#30721#65306
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 249
      Top = 136
      Width = 75
      Height = 15
      Caption = #22797#26680#23494#30721#65306
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object dbgrdhDb: TDBGridEh
      Left = 0
      Top = 0
      Width = 233
      Height = 297
      Align = alLeft
      Ctl3D = True
      DataSource = dsQuery
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'MS Sans Serif'
      FooterFont.Style = []
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clNavy
      TitleFont.Height = -15
      TitleFont.Name = #23435#20307
      TitleFont.Style = []
      Columns = <
        item
          EditButtons = <>
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #30331#24405#21517
          Width = 80
        end
        item
          EditButtons = <>
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #22995#21517
          Width = 120
        end>
    end
    object grpLimit: TGroupBox
      Left = 240
      Top = 160
      Width = 289
      Height = 137
      Caption = #26435#38480#20449#24687
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      object chkStat: TCheckBox
        Tag = 2
        Left = 16
        Top = 64
        Width = 73
        Height = 17
        Caption = #25293#29031#32479#35745
        TabOrder = 6
      end
      object chkQuery: TCheckBox
        Tag = 3
        Left = 16
        Top = 88
        Width = 73
        Height = 17
        Caption = #20449#24687#26597#35810
        TabOrder = 8
      end
      object chkLimit: TCheckBox
        Tag = 1
        Left = 16
        Top = 40
        Width = 73
        Height = 17
        Caption = #26435#38480#31649#29702
        TabOrder = 3
      end
      object chkImport: TCheckBox
        Tag = 4
        Left = 16
        Top = 112
        Width = 73
        Height = 17
        Caption = #29031#29255#23548#20837
        TabOrder = 10
      end
      object chkExport: TCheckBox
        Tag = 5
        Left = 96
        Top = 16
        Width = 73
        Height = 17
        Caption = #29031#29255#23548#20986
        TabOrder = 1
      end
      object chkAddCust: TCheckBox
        Tag = 6
        Left = 96
        Top = 40
        Width = 97
        Height = 17
        Caption = #28155#21152#20154#21592#20449#24687
        TabOrder = 4
      end
      object chkEditCust: TCheckBox
        Tag = 7
        Left = 96
        Top = 64
        Width = 97
        Height = 17
        Caption = #20462#25913#20154#21592#20449#24687
        TabOrder = 7
      end
      object chkStuPrint: TCheckBox
        Tag = 8
        Left = 96
        Top = 112
        Width = 81
        Height = 17
        Caption = #23398#29983#21345#25171#21360
        TabOrder = 11
        Visible = False
      end
      object chkEmpPrint: TCheckBox
        Tag = 9
        Left = 200
        Top = 112
        Width = 80
        Height = 17
        Caption = #25945#24072#21345#25171#21360
        TabOrder = 12
        Visible = False
      end
      object chkDelPhoto: TCheckBox
        Tag = 10
        Left = 200
        Top = 16
        Width = 73
        Height = 17
        Caption = #21024#38500#29031#29255
        TabOrder = 2
      end
      object chkSavePhoto: TCheckBox
        Tag = 11
        Left = 200
        Top = 40
        Width = 73
        Height = 17
        Caption = #20445#23384#29031#29255
        TabOrder = 5
      end
      object chkEnabled: TCheckBox
        Left = 16
        Top = 16
        Width = 73
        Height = 17
        Caption = #26159#21542#21487#29992
        TabOrder = 0
      end
      object CheckBox1: TCheckBox
        Tag = 12
        Left = 96
        Top = 88
        Width = 89
        Height = 17
        Caption = #20154#21592#20449#24687#23548#20837
        TabOrder = 9
      end
    end
    object edtCode: TEdit
      Left = 320
      Top = 10
      Width = 129
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      TabOrder = 1
    end
    object edtName: TEdit
      Left = 320
      Top = 34
      Width = 129
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      MaxLength = 20
      ParentFont = False
      TabOrder = 2
    end
    object edtBegin: TEdit
      Left = 320
      Top = 58
      Width = 129
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      MaxLength = 15
      ParentFont = False
      TabOrder = 3
    end
    object edtEnd: TEdit
      Left = 320
      Top = 82
      Width = 129
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      MaxLength = 15
      ParentFont = False
      TabOrder = 4
    end
    object edtpwd: TEdit
      Left = 320
      Top = 106
      Width = 129
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      MaxLength = 15
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 5
    end
    object edtRepwd: TEdit
      Left = 320
      Top = 131
      Width = 129
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      MaxLength = 15
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 6
    end
  end
  object btnAdd: TBitBtn
    Left = 200
    Top = 312
    Width = 65
    Height = 25
    Caption = '&A'#28155' '#21152
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = btnAddClick
  end
  object btnSave: TBitBtn
    Left = 280
    Top = 311
    Width = 65
    Height = 25
    Caption = '&S'#20445' '#23384
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object btnExit: TBitBtn
    Left = 440
    Top = 311
    Width = 65
    Height = 25
    Caption = '&X'#36864' '#20986
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = btnExitClick
  end
  object BitBtn1: TBitBtn
    Left = 360
    Top = 311
    Width = 65
    Height = 25
    Caption = '&D'#21024' '#38500
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = BitBtn1Click
  end
  object dsQuery: TDataSource
    DataSet = frmdm.qryQuery
    Left = 128
    Top = 64
  end
end
