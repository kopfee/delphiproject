object frmExport: TfrmExport
  Left = 212
  Top = 161
  BorderStyle = bsDialog
  Caption = #29031#29255#20449#24687#23548#20986
  ClientHeight = 516
  ClientWidth = 792
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 792
    Height = 137
    Align = alTop
    BevelOuter = bvNone
    Color = 16053492
    TabOrder = 0
    object Label1: TLabel
      Left = 17
      Top = 16
      Width = 62
      Height = 15
      AutoSize = False
      Caption = #23398'/'#24037#21495#65306
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 24
      Top = 40
      Width = 55
      Height = 15
      AutoSize = False
      Caption = #22995'  '#21517#65306
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 254
      Top = 40
      Width = 69
      Height = 15
      AutoSize = False
      Caption = #23458#25143#31867#21035#65306
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 520
      Top = 16
      Width = 57
      Height = 15
      AutoSize = False
      Caption = #37096'  '#38376#65306
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 520
      Top = 40
      Width = 57
      Height = 15
      AutoSize = False
      Caption = #19987'  '#19994#65306
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 10
      Top = 64
      Width = 69
      Height = 15
      AutoSize = False
      Caption = #24320#22987#26085#26399#65306
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 266
      Top = 16
      Width = 57
      Height = 15
      AutoSize = False
      Caption = #21306'  '#22495#65306
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label11: TLabel
      Left = 254
      Top = 64
      Width = 69
      Height = 15
      AutoSize = False
      Caption = #32467#26463#26085#26399#65306
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object chkCust: TCheckBox
      Left = 520
      Top = 64
      Width = 137
      Height = 17
      BiDiMode = bdLeftToRight
      Caption = #33258#23450#20041#26465#20214#26597#35810
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentBiDiMode = False
      ParentFont = False
      TabOrder = 8
    end
    object edtStuEmpNo: TEdit
      Left = 78
      Top = 11
      Width = 147
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object edtName: TEdit
      Left = 78
      Top = 36
      Width = 147
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object dtpBegin: TDateTimePicker
      Left = 78
      Top = 60
      Width = 147
      Height = 21
      Date = 39099.464709375000000000
      Time = 39099.464709375000000000
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object dtpEnd: TDateTimePicker
      Left = 326
      Top = 60
      Width = 155
      Height = 21
      Date = 39099.464709375000000000
      Time = 39099.464709375000000000
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 7
    end
    object cbbDept: TDBLookupComboboxEh
      Left = 575
      Top = 11
      Width = 138
      Height = 21
      EditButtons = <>
      ListSource = dsDept
      TabOrder = 2
      Visible = True
    end
    object cbbType: TDBLookupComboboxEh
      Left = 325
      Top = 36
      Width = 154
      Height = 21
      EditButtons = <>
      ListSource = dsType
      TabOrder = 4
      Visible = True
    end
    object cbbSpec: TDBLookupComboboxEh
      Left = 575
      Top = 36
      Width = 138
      Height = 21
      EditButtons = <>
      ListSource = dsSpec
      TabOrder = 5
      Visible = True
    end
    object cbbArea: TDBLookupComboboxEh
      Left = 325
      Top = 11
      Width = 154
      Height = 21
      EditButtons = <>
      ListSource = dsArea
      TabOrder = 1
      Visible = True
    end
    object grp1: TGroupBox
      Left = 80
      Top = 84
      Width = 633
      Height = 45
      Caption = #29031#29255#22823#23567#35774#32622
      TabOrder = 9
      object lbl1: TLabel
        Left = 208
        Top = 21
        Width = 45
        Height = 15
        AutoSize = False
        Caption = #23485#24230#65306
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object lbl2: TLabel
        Left = 344
        Top = 21
        Width = 45
        Height = 15
        AutoSize = False
        Caption = #39640#24230#65306
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object lbl3: TLabel
        Left = 296
        Top = 21
        Width = 30
        Height = 15
        AutoSize = False
        Caption = #20687#32032
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object lbl4: TLabel
        Left = 432
        Top = 21
        Width = 30
        Height = 15
        AutoSize = False
        Caption = #20687#32032
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label12: TLabel
        Left = 472
        Top = 21
        Width = 138
        Height = 15
        AutoSize = False
        Caption = '('#23485#21644#39640#27604#20363#20026' 3:4)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object chkSetSize: TCheckBox
        Left = 10
        Top = 22
        Width = 167
        Height = 17
        Caption = #23548#20986#26102#37325#35774#29031#29255#22823#23567
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object edtWidth: TEdit
        Left = 245
        Top = 16
        Width = 49
        Height = 23
        AutoSize = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnChange = edtWidthChange
        OnClick = edtWidthClick
        OnKeyPress = edtWidthKeyPress
      end
      object edtHeight: TEdit
        Left = 382
        Top = 16
        Width = 49
        Height = 23
        AutoSize = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnChange = edtWidthChange
        OnClick = edtWidthClick
        OnKeyPress = edtWidthKeyPress
      end
    end
  end
  object pnl1: TPanel
    Left = 0
    Top = 137
    Width = 792
    Height = 88
    Align = alTop
    BevelOuter = bvNone
    Color = 16053492
    TabOrder = 1
    object Label7: TLabel
      Left = 55
      Top = 3
      Width = 15
      Height = 60
      Caption = #26597#35810#35821#21477
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object mmoSql: TMemo
      Left = 80
      Top = 0
      Width = 689
      Height = 81
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object pnl2: TPanel
    Left = 0
    Top = 225
    Width = 792
    Height = 88
    Align = alTop
    BevelOuter = bvNone
    Color = 16053492
    TabOrder = 2
    object Label8: TLabel
      Left = 56
      Top = 4
      Width = 15
      Height = 60
      Caption = #38169#13#35823#13#25552#13#31034
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object lstError: TListBox
      Left = 80
      Top = 0
      Width = 689
      Height = 81
      ImeName = #25340#38899#21152#21152#38598#21512#29256
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object btnQuery: TButton
    Left = 544
    Top = 464
    Width = 65
    Height = 24
    Caption = '&Q'#26597' '#35810
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = btnQueryClick
  end
  object btnExport: TButton
    Left = 624
    Top = 464
    Width = 65
    Height = 24
    Caption = '&E'#23548' '#20986
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = btnExportClick
  end
  object btnExit: TButton
    Left = 704
    Top = 464
    Width = 65
    Height = 24
    Caption = '&X'#36864' '#20986
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = btnExitClick
  end
  object pnl3: TPanel
    Left = 0
    Top = 313
    Width = 792
    Height = 144
    Align = alTop
    BevelOuter = bvNone
    Color = 16053492
    TabOrder = 3
    object Label9: TLabel
      Left = 56
      Top = 4
      Width = 15
      Height = 60
      Caption = #26597#35810#32467#26524
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object dbgrdhData: TDBGridEh
      Left = 80
      Top = 0
      Width = 689
      Height = 144
      Ctl3D = False
      DataSource = dsQuery
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      FooterColor = clWindow
      FooterFont.Charset = ANSI_CHARSET
      FooterFont.Color = clNavy
      FooterFont.Height = -13
      FooterFont.Name = #23435#20307
      FooterFont.Style = []
      FooterRowCount = 1
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      SumList.Active = True
      TabOrder = 0
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clBlue
      TitleFont.Height = -15
      TitleFont.Name = #23435#20307
      TitleFont.Style = []
      Columns = <
        item
          EditButtons = <>
          Footer.Value = #21512#35745#65306
          Footer.ValueType = fvtStaticText
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #23458#25143#21495
          Width = 50
        end
        item
          EditButtons = <>
          Footer.ValueType = fvtCount
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #23398#24037#21495
          Width = 100
        end
        item
          EditButtons = <>
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #22995#21517
          Width = 100
        end
        item
          EditButtons = <>
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #37096#38376
          Width = 100
        end
        item
          EditButtons = <>
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #19987#19994
          Width = 100
        end
        item
          EditButtons = <>
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #31867#21035
          Width = 100
        end
        item
          EditButtons = <>
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #29677#32423
          Width = 80
        end>
    end
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 496
    Width = 792
    Height = 20
    Align = alBottom
    TabOrder = 7
  end
  object dsType: TDataSource
    DataSet = frmdm.qryType
    Left = 336
    Top = 240
  end
  object dsDept: TDataSource
    DataSet = frmdm.qryDept
    Left = 144
    Top = 136
  end
  object dsArea: TDataSource
    DataSet = frmdm.qryArea
    Left = 144
    Top = 232
  end
  object dsSpec: TDataSource
    DataSet = frmdm.qrySpec
    Left = 248
    Top = 136
  end
  object dsQuery: TDataSource
    DataSet = frmdm.qryQuery
    Left = 264
    Top = 232
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Excel'#26684#24335'|*.xls|'#32593#39029#26684#24335'|*.htm|Word'#26684#24335'|*.rtf|'#25991#26412#25991#20214'|*.txt'
    Left = 384
    Top = 145
  end
end
