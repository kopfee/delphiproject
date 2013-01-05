object frmPhotoQuery: TfrmPhotoQuery
  Left = 288
  Top = 130
  BorderStyle = bsDialog
  Caption = #25293#29031#20449#24687#26597#35810
  ClientHeight = 518
  ClientWidth = 753
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 753
    Height = 121
    Align = alTop
    BevelOuter = bvNone
    Color = 16053492
    TabOrder = 0
    object Label5: TLabel
      Left = 538
      Top = 13
      Width = 54
      Height = 15
      Caption = #21306'  '#22495':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 107
      Top = 38
      Width = 68
      Height = 15
      AutoSize = False
      Caption = #23458#25143#31867#21035':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 329
      Top = 40
      Width = 54
      Height = 15
      AutoSize = False
      Caption = #37096'  '#38376':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 538
      Top = 40
      Width = 54
      Height = 15
      Caption = #19987'  '#19994':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 114
      Top = 12
      Width = 61
      Height = 15
      AutoSize = False
      Caption = #23398'/'#24037#21495':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 329
      Top = 13
      Width = 54
      Height = 15
      AutoSize = False
      Caption = #22995'  '#21517':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object lbl1: TLabel
      Left = 107
      Top = 63
      Width = 68
      Height = 15
      AutoSize = False
      Caption = #36523#20221#35777#21495':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object cbbType: TDBLookupComboboxEh
      Left = 178
      Top = 34
      Width = 144
      Height = 21
      DropDownBox.Rows = 15
      EditButtons = <>
      ListSource = dsType
      TabOrder = 4
      Visible = True
    end
    object cbbArea: TDBLookupComboboxEh
      Left = 594
      Top = 10
      Width = 144
      Height = 21
      DropDownBox.Rows = 15
      EditButtons = <>
      ListSource = dsArea
      TabOrder = 3
      Visible = True
    end
    object cbbSpec: TDBLookupComboboxEh
      Left = 594
      Top = 34
      Width = 144
      Height = 21
      DropDownBox.Rows = 15
      EditButtons = <>
      ListSource = dsSpec
      TabOrder = 6
      Visible = True
    end
    object cbbDept: TDBLookupComboboxEh
      Left = 386
      Top = 34
      Width = 144
      Height = 21
      DropDownBox.Rows = 15
      EditButtons = <>
      ListSource = dsDept
      TabOrder = 5
      Visible = True
    end
    object edtStuEmpNo: TEdit
      Left = 178
      Top = 7
      Width = 143
      Height = 23
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object edtName: TEdit
      Left = 386
      Top = 7
      Width = 143
      Height = 23
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object rgPhoto: TRadioGroup
      Left = 114
      Top = 83
      Width = 207
      Height = 32
      Caption = #26159#21542#25293#29031
      Columns = 3
      ItemIndex = 0
      Items.Strings = (
        #26159
        #21542
        #20840#37096)
      TabOrder = 8
    end
    object btnOper: TBitBtn
      Left = 352
      Top = 90
      Width = 65
      Height = 25
      Caption = '&Q'#26597' '#35810
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 10
      OnClick = btnOperClick
    end
    object BitBtn2: TBitBtn
      Left = 432
      Top = 90
      Width = 65
      Height = 25
      Caption = #23548#20986#25968#25454
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 11
      OnClick = BitBtn2Click
    end
    object BitBtn1: TBitBtn
      Left = 672
      Top = 90
      Width = 65
      Height = 25
      Caption = '&X'#36864' '#20986
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 13
      OnClick = BitBtn1Click
    end
    object btnPhoto: TBitBtn
      Left = 512
      Top = 90
      Width = 65
      Height = 25
      Caption = '&P'#25293' '#29031
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 12
      OnClick = btnPhotoClick
    end
    object pnlPhoto: TPanel
      Left = 0
      Top = 0
      Width = 90
      Height = 121
      Align = alLeft
      BevelOuter = bvNone
      Color = 16053492
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object imgPhoto: TImage
        Left = 0
        Top = 0
        Width = 90
        Height = 121
        Align = alClient
        Stretch = True
      end
    end
    object edtCardId: TEdit
      Left = 178
      Top = 58
      Width = 143
      Height = 23
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 7
    end
    object btnMakeCard: TBitBtn
      Left = 592
      Top = 89
      Width = 65
      Height = 25
      Caption = '&M'#21046' '#21345
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 9
      OnClick = btnMakeCardClick
    end
  end
  object dbgrdhDb: TDBGridEh
    Left = 0
    Top = 121
    Width = 753
    Height = 397
    Align = alClient
    Ctl3D = True
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
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    RowLines = 1
    SumList.Active = True
    TabOrder = 1
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clNavy
    TitleFont.Height = -15
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
    OnCellClick = dbgrdhDbCellClick
    Columns = <
      item
        EditButtons = <>
        Footer.Value = #21512#35745#65306
        Footer.ValueType = fvtStaticText
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #23458#25143#21495
        Width = 70
      end
      item
        EditButtons = <>
        Footer.ValueType = fvtCount
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #23398'/'#24037#21495
        Width = 100
      end
      item
        EditButtons = <>
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #22995#21517
        Width = 80
      end
      item
        EditButtons = <>
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #23458#25143#31867#21035
        Width = 100
      end
      item
        EditButtons = <>
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #19987#19994
        Width = 120
      end
      item
        EditButtons = <>
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #37096#38376
        Width = 120
      end
      item
        EditButtons = <>
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #21306#22495
        Width = 80
      end
      item
        EditButtons = <>
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #36523#20221#35777#21495
        Width = 100
      end>
  end
  object dsType: TDataSource
    DataSet = frmdm.qryType
    Left = 224
    Top = 200
  end
  object dsDept: TDataSource
    DataSet = frmdm.qryDept
    Left = 224
    Top = 248
  end
  object dsArea: TDataSource
    DataSet = frmdm.qryArea
    Left = 224
    Top = 296
  end
  object dsSpec: TDataSource
    DataSet = frmdm.qrySpec
    Left = 472
    Top = 200
  end
  object dsQuery: TDataSource
    DataSet = frmdm.qryQuery
    Left = 472
    Top = 248
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Excel'#26684#24335'|*.xls|'#32593#39029#26684#24335'|*.htm|Word'#26684#24335'|*.rtf|'#25991#26412#25991#20214'|*.txt'
    Left = 120
    Top = 161
  end
end
