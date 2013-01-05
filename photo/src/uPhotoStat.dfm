object frmPhotoStat: TfrmPhotoStat
  Left = 280
  Top = 187
  BorderStyle = bsDialog
  Caption = #25293#29031#20154#25968#32479#35745
  ClientHeight = 435
  ClientWidth = 726
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 726
    Height = 81
    Align = alTop
    BevelOuter = bvNone
    Color = 16053492
    TabOrder = 0
    object Label2: TLabel
      Left = 9
      Top = 48
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
      Left = 231
      Top = 24
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
      Left = 232
      Top = 48
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
    object Label5: TLabel
      Left = 24
      Top = 24
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
    object Label1: TLabel
      Left = 451
      Top = 48
      Width = 75
      Height = 15
      Caption = #32467#26463#26085#26399#65306
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 451
      Top = 24
      Width = 75
      Height = 15
      Caption = #24320#22987#26085#26399#65306
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object cbbType: TDBLookupComboboxEh
      Left = 80
      Top = 42
      Width = 144
      Height = 21
      DropDownBox.Rows = 15
      EditButtons = <>
      ListSource = dsType
      TabOrder = 4
      Visible = True
    end
    object cbbDept: TDBLookupComboboxEh
      Left = 288
      Top = 20
      Width = 144
      Height = 21
      DropDownBox.Rows = 15
      EditButtons = <>
      ListSource = dsDept
      TabOrder = 2
      Visible = True
    end
    object cbbSpec: TDBLookupComboboxEh
      Left = 288
      Top = 44
      Width = 144
      Height = 21
      DropDownBox.Rows = 15
      EditButtons = <>
      ListSource = dsSpec
      TabOrder = 5
      Visible = True
    end
    object cbbArea: TDBLookupComboboxEh
      Left = 80
      Top = 18
      Width = 144
      Height = 21
      DropDownBox.Rows = 15
      EditButtons = <>
      ListSource = dsArea
      TabOrder = 1
      Visible = True
    end
    object dtpBegin: TDateTimePicker
      Left = 528
      Top = 20
      Width = 97
      Height = 21
      Date = 39100.672388055560000000
      Time = 39100.672388055560000000
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object dtpEnd: TDateTimePicker
      Left = 528
      Top = 44
      Width = 97
      Height = 21
      Date = 39100.672388055560000000
      Time = 39100.672388055560000000
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object chkDate: TCheckBox
      Left = 451
      Top = 5
      Width = 70
      Height = 15
      Caption = #38480#23450#26085#26399
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
  object dbgrdhData: TDBGridEh
    Left = 0
    Top = 81
    Width = 726
    Height = 320
    Align = alTop
    DataSource = dsQuery
    Flat = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = []
    FooterColor = clWindow
    FooterFont.Charset = ANSI_CHARSET
    FooterFont.Color = clMaroon
    FooterFont.Height = -13
    FooterFont.Name = #23435#20307
    FooterFont.Style = []
    FooterRowCount = 1
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
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
        Title.Caption = #25152#23646#21306#22495
        Width = 100
      end
      item
        EditButtons = <>
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #37096#38376
        Width = 200
      end
      item
        EditButtons = <>
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #19987#19994
        Width = 150
      end
      item
        EditButtons = <>
        Footer.FieldName = 'totNum'
        Footer.ValueType = fvtSum
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #24635#20154#25968
        Width = 80
      end
      item
        EditButtons = <>
        Footer.FieldName = 'photoNum'
        Footer.ValueType = fvtSum
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #24050#25293#29031#20154#25968
        Width = 80
      end
      item
        EditButtons = <>
        Footer.FieldName = 'unPhotoNum'
        Footer.ValueType = fvtSum
        Footers = <>
        Title.Alignment = taCenter
        Title.Caption = #26410#25293#29031#20154#25968
        Width = 80
      end>
  end
  object BitBtn1: TBitBtn
    Left = 600
    Top = 407
    Width = 65
    Height = 25
    Caption = '&X'#36864' '#20986
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = BitBtn1Click
  end
  object btnOper: TBitBtn
    Left = 424
    Top = 407
    Width = 65
    Height = 25
    Caption = #32479' '#35745
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = btnOperClick
  end
  object BitBtn2: TBitBtn
    Left = 512
    Top = 407
    Width = 65
    Height = 25
    Caption = #23548#20986#25968#25454
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = BitBtn2Click
  end
  object dsType: TDataSource
    DataSet = frmdm.qryType
    Left = 208
    Top = 128
  end
  object dsDept: TDataSource
    DataSet = frmdm.qryDept
    Left = 208
    Top = 176
  end
  object dsArea: TDataSource
    DataSet = frmdm.qryArea
    Left = 208
    Top = 224
  end
  object dsSpec: TDataSource
    DataSet = frmdm.qrySpec
    Left = 456
    Top = 128
  end
  object dsQuery: TDataSource
    DataSet = frmdm.qryQuery
    Left = 456
    Top = 176
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Excel'#26684#24335'|*.xls|'#32593#39029#26684#24335'|*.htm|Word'#26684#24335'|*.rtf|'#25991#26412#25991#20214'|*.txt'
    Left = 416
    Top = 225
  end
end
