object frmAddCustInfo: TfrmAddCustInfo
  Left = 253
  Top = 215
  BorderStyle = bsDialog
  Caption = #28155#21152#25293#29031#20154#21592#20449#24687
  ClientHeight = 221
  ClientWidth = 488
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 488
    Height = 161
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Color = 16053492
    TabOrder = 0
    object lbl1: TLabel
      Left = 24
      Top = 16
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
    object Label1: TLabel
      Left = 255
      Top = 16
      Width = 54
      Height = 15
      Caption = #22995'  '#21517':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 17
      Top = 50
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
      Left = 31
      Top = 83
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
      Left = 255
      Top = 80
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
      Left = 31
      Top = 117
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
    object Label6: TLabel
      Left = 241
      Top = 112
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
    object lblCustId: TLabel
      Left = 33
      Top = 136
      Width = 45
      Height = 15
      Caption = #23458#25143#21495
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object Label7: TLabel
      Left = 241
      Top = 48
      Width = 68
      Height = 15
      AutoSize = False
      Caption = #25910#36153#31867#21035':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object cbbType: TDBLookupComboboxEh
      Left = 88
      Top = 45
      Width = 144
      Height = 21
      DataSource = dsAdd
      DropDownBox.Rows = 15
      EditButtons = <>
      ListSource = dsType
      TabOrder = 3
      Visible = True
    end
    object cbbArea: TDBLookupComboboxEh
      Left = 88
      Top = 111
      Width = 144
      Height = 21
      DataSource = dsAdd
      DropDownBox.Rows = 15
      EditButtons = <>
      ListSource = dsArea
      TabOrder = 7
      Visible = True
    end
    object cbbDept: TDBLookupComboboxEh
      Left = 88
      Top = 78
      Width = 144
      Height = 21
      DataSource = dsAdd
      DropDownBox.Rows = 15
      EditButtons = <>
      ListSource = dsDept
      TabOrder = 5
      Visible = True
    end
    object cbbSpec: TDBLookupComboboxEh
      Left = 315
      Top = 76
      Width = 149
      Height = 21
      DataSource = dsAdd
      DropDownBox.Rows = 15
      EditButtons = <>
      ListSource = dsSpec
      TabOrder = 4
      Visible = True
    end
    object edtStuempNo: TDBEditEh
      Left = 88
      Top = 12
      Width = 145
      Height = 21
      DataSource = dsAdd
      EditButtons = <>
      MaxLength = 20
      TabOrder = 0
      Visible = True
    end
    object edtName: TDBEditEh
      Left = 315
      Top = 12
      Width = 150
      Height = 21
      DataSource = dsAdd
      EditButtons = <>
      MaxLength = 60
      TabOrder = 1
      Visible = True
    end
    object edtCardId: TDBEditEh
      Left = 315
      Top = 108
      Width = 150
      Height = 21
      DataSource = dsAdd
      EditButtons = <>
      MaxLength = 20
      TabOrder = 6
      Visible = True
    end
    object cbbFeeType: TDBLookupComboboxEh
      Left = 315
      Top = 44
      Width = 149
      Height = 21
      DataSource = dsAdd
      DropDownBox.Rows = 15
      EditButtons = <>
      ListSource = dsFeeType
      TabOrder = 2
      Visible = True
    end
  end
  object btnOper: TBitBtn
    Left = 296
    Top = 176
    Width = 65
    Height = 25
    Caption = 'btnOper'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btnOperClick
  end
  object BitBtn1: TBitBtn
    Left = 392
    Top = 176
    Width = 65
    Height = 25
    Caption = '&X'#36864' '#20986
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = BitBtn1Click
  end
  object dsType: TDataSource
    DataSet = frmdm.qryType
    Left = 144
    Top = 8
  end
  object dsDept: TDataSource
    DataSet = frmdm.qryDept
    Left = 144
    Top = 40
  end
  object dsArea: TDataSource
    DataSet = frmdm.qryArea
    Left = 144
    Top = 80
  end
  object dsSpec: TDataSource
    DataSet = frmdm.qrySpec
    Left = 392
    Top = 8
  end
  object dsAdd: TDataSource
    DataSet = frmdm.qryAdd
    Left = 392
    Top = 40
  end
  object dsFeeType: TDataSource
    DataSet = frmdm.qryFeeType
    Left = 392
    Top = 72
  end
end
