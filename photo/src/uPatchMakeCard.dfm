object frmPatchMakeCard: TfrmPatchMakeCard
  Left = 210
  Top = 153
  BorderStyle = bsDialog
  Caption = #25209#37327#21046#21345
  ClientHeight = 518
  ClientWidth = 753
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 753
    Height = 142
    Align = alTop
    BevelOuter = bvNone
    Color = 16053492
    TabOrder = 0
    object Label5: TLabel
      Left = 497
      Top = 13
      Width = 54
      Height = 15
      AutoSize = False
      Caption = #21306'  '#22495':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 51
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
      Left = 274
      Top = 40
      Width = 54
      Height = 15
      Caption = #37096'  '#38376':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 497
      Top = 38
      Width = 54
      Height = 15
      AutoSize = False
      Caption = #19987'  '#19994':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 58
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
      Left = 274
      Top = 13
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
    object lbl1: TLabel
      Left = 51
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
    object Label7: TLabel
      Left = 483
      Top = 64
      Width = 68
      Height = 15
      AutoSize = False
      Caption = #25171#21360#31867#21035':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 277
      Top = 63
      Width = 60
      Height = 15
      Caption = #34920#21333#21517#65306
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object lblPath: TLabel
      Left = 484
      Top = 89
      Width = 269
      Height = 17
      AutoSize = False
      Caption = 'lblPath'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 66
      Top = 89
      Width = 53
      Height = 15
      AutoSize = False
      Caption = #25209#27425#21495':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 292
      Top = 89
      Width = 45
      Height = 15
      Caption = #29677#32423#65306
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object cbbType: TDBLookupComboboxEh
      Left = 122
      Top = 34
      Width = 144
      Height = 21
      DropDownBox.Rows = 15
      EditButtons = <>
      ListSource = dsType
      TabOrder = 3
      Visible = True
    end
    object cbbArea: TDBLookupComboboxEh
      Left = 554
      Top = 10
      Width = 144
      Height = 21
      DropDownBox.Rows = 15
      EditButtons = <>
      ListSource = dsArea
      TabOrder = 2
      Visible = True
    end
    object cbbSpec: TDBLookupComboboxEh
      Left = 554
      Top = 34
      Width = 144
      Height = 21
      DropDownBox.Rows = 15
      EditButtons = <>
      ListSource = dsSpec
      TabOrder = 5
      Visible = True
    end
    object cbbDept: TDBLookupComboboxEh
      Left = 330
      Top = 34
      Width = 144
      Height = 21
      DropDownBox.Rows = 15
      EditButtons = <>
      ListSource = dsDept
      TabOrder = 4
      Visible = True
    end
    object edtStuEmpNo: TEdit
      Left = 122
      Top = 7
      Width = 143
      Height = 23
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object edtName: TEdit
      Left = 330
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
    object btnOper: TBitBtn
      Left = 472
      Top = 111
      Width = 65
      Height = 25
      Caption = '&Q'#26597' '#35810
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 13
      OnClick = btnOperClick
    end
    object BitBtn1: TBitBtn
      Left = 632
      Top = 111
      Width = 65
      Height = 25
      Caption = '&X'#36864' '#20986
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 15
      OnClick = BitBtn1Click
    end
    object edtCardId: TEdit
      Left = 122
      Top = 58
      Width = 144
      Height = 23
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object btnMakeCard: TBitBtn
      Left = 552
      Top = 111
      Width = 65
      Height = 25
      Caption = #25209#37327#21046#21345
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 14
      OnClick = btnMakeCardClick
    end
    object chkSaveData: TCheckBox
      Left = 176
      Top = 114
      Width = 105
      Height = 17
      Caption = #20445#30041#26597#35810#32467#26524
      TabOrder = 18
    end
    object cbbMenu: TComboBox
      Left = 554
      Top = 59
      Width = 144
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 8
      OnChange = cbbMenuChange
    end
    object chkSelectAll: TCheckBox
      Left = 8
      Top = 114
      Width = 49
      Height = 17
      Caption = #20840#36873
      TabOrder = 16
      OnClick = chkSelectAllClick
    end
    object edtSheet: TEdit
      Left = 330
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
      Text = 'sheet1'
    end
    object btnOpen: TBitBtn
      Left = 392
      Top = 111
      Width = 65
      Height = 25
      Caption = #25171#24320'Xls'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 12
      OnClick = btnOpenClick
    end
    object chkXls: TCheckBox
      Left = 64
      Top = 114
      Width = 105
      Height = 17
      Caption = #20351#29992'Excel'#26597#35810
      TabOrder = 17
    end
    object btnClear: TBitBtn
      Left = 312
      Top = 111
      Width = 65
      Height = 25
      Caption = #28165#31354#32467#26524
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 11
      OnClick = btnClearClick
    end
    object edtBatchNO: TEdit
      Left = 122
      Top = 84
      Width = 144
      Height = 23
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 9
    end
    object edtClassNo: TEdit
      Left = 330
      Top = 84
      Width = 143
      Height = 23
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 10
    end
  end
  object lvCustInfo: TRzListView
    Left = 0
    Top = 142
    Width = 753
    Height = 376
    Align = alClient
    AlphaSortAll = True
    Checkboxes = True
    Columns = <
      item
        Caption = #23458#25143#21495
        Width = 70
      end
      item
        Caption = #23398'/'#24037#21495
        Width = 90
      end
      item
        Caption = #36523#20221#35777#21495
        Width = 120
      end
      item
        Caption = #23458#25143#31867#21035
        Width = 90
      end
      item
        Caption = #22995#21517
        Width = 70
      end
      item
        Caption = #37096#38376
        Width = 120
      end
      item
        Caption = #19987#19994
        Width = 173
      end>
    FlatScrollBars = True
    GridLines = True
    SortType = stBoth
    TabOrder = 1
    ViewStyle = vsReport
  end
  object qckrpPrint: TQuickRep
    Left = 205
    Top = 3000
    Width = 325
    Height = 204
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    Frame.Style = psClear
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Functions.Strings = (
      'PAGENUMBER'
      'COLUMNNUMBER'
      'REPORTTITLE')
    Functions.DATA = (
      '0'
      '0'
      #39#39)
    Options = [FirstPageHeader, LastPageFooter]
    Page.Columns = 1
    Page.Orientation = poPortrait
    Page.PaperSize = Custom
    Page.Values = (
      0.000000000000000000
      540.000000000000000000
      0.000000000000000000
      859.895833333333400000
      0.000000000000000000
      0.000000000000000000
      0.000000000000000000)
    PrinterSettings.Copies = 1
    PrinterSettings.Duplex = False
    PrinterSettings.FirstPage = 0
    PrinterSettings.LastPage = 0
    PrinterSettings.OutputBin = Auto
    PrintIfEmpty = True
    SnapToGrid = True
    Units = MM
    Zoom = 100
    object qrbndDetailBand1: TQRBand
      Left = 0
      Top = 0
      Width = 325
      Height = 193
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Frame.Style = psClear
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        510.645833333333300000
        859.895833333333300000)
      BandType = rbDetail
      object qrshpL5: TQRShape
        Left = 248
        Top = 121
        Height = 1
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          2.645833333333333000
          656.166666666666800000
          320.145833333333400000
          171.979166666666700000)
        Shape = qrsRectangle
      end
      object qrshpL4: TQRShape
        Left = 248
        Top = 111
        Height = 1
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          2.645833333333333000
          656.166666666666800000
          293.687500000000000000
          171.979166666666700000)
        Shape = qrsRectangle
      end
      object qrshpL3: TQRShape
        Left = 248
        Top = 102
        Height = 1
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          2.645833333333333000
          656.166666666666800000
          269.875000000000000000
          171.979166666666700000)
        Shape = qrsRectangle
      end
      object qrshpL2: TQRShape
        Left = 248
        Top = 95
        Height = 1
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          2.645833333333333000
          656.166666666666800000
          251.354166666666700000
          171.979166666666700000)
        Shape = qrsRectangle
      end
      object qrshpL1: TQRShape
        Left = 248
        Top = 88
        Height = 1
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          2.645833333333333000
          656.166666666666800000
          232.833333333333400000
          171.979166666666700000)
        Shape = qrsRectangle
      end
      object qrlblType: TQRLabel
        Left = 120
        Top = 157
        Width = 35
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.270833333333330000
          317.500000000000000000
          415.395833333333400000
          92.604166666666680000)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = #31867#21035
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 11
      end
      object qrlblSpec: TQRLabel
        Left = 120
        Top = 136
        Width = 35
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.270833333333330000
          317.500000000000000000
          359.833333333333400000
          92.604166666666680000)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = #19987#19994
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 11
      end
      object qrlblNo: TQRLabel
        Left = 120
        Top = 88
        Width = 52
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.979166666666670000
          317.500000000000000000
          232.833333333333400000
          137.583333333333300000)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = #23398#24037#21495
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object qrlblName: TQRLabel
        Left = 120
        Top = 104
        Width = 35
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.979166666666670000
          317.500000000000000000
          275.166666666666700000
          92.604166666666680000)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = #22995#21517
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object qrlblFoot2: TQRLabel
        Left = 208
        Top = 160
        Width = 40
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.270833333333330000
          550.333333333333400000
          423.333333333333300000
          105.833333333333300000)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = #39029#23614'2'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object qrlblFoot1: TQRLabel
        Left = 32
        Top = 160
        Width = 34
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.979166666666670000
          84.666666666666680000
          423.333333333333300000
          89.958333333333340000)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = #39029#23614'1'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object qrlblDept: TQRLabel
        Left = 120
        Top = 120
        Width = 35
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.979166666666670000
          317.500000000000000000
          317.500000000000000000
          92.604166666666680000)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = #37096#38376
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object qrlblClassNo: TQRLabel
        Left = 120
        Top = 48
        Width = 35
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.270833333333330000
          317.500000000000000000
          127.000000000000000000
          92.604166666666680000)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = #29677#32423
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 11
      end
      object qrlblCardType: TQRLabel
        Left = 248
        Top = 24
        Width = 52
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.270833333333330000
          656.166666666666800000
          63.500000000000000000
          137.583333333333300000)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = #21345#31867#21035
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 11
      end
      object qrlblCardNo: TQRLabel
        Left = 120
        Top = 70
        Width = 35
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.270833333333330000
          317.500000000000000000
          185.208333333333300000
          92.604166666666680000)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = #21345#21495
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 11
      end
      object qrlbl5: TQRLabel
        Left = 176
        Top = 120
        Width = 52
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.270833333333330000
          465.666666666666800000
          317.500000000000000000
          137.583333333333300000)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = #39064#22836#20116
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 11
      end
      object qrlbl4: TQRLabel
        Left = 176
        Top = 104
        Width = 52
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.270833333333330000
          465.666666666666800000
          275.166666666666700000
          137.583333333333300000)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = #39064#22836#22235
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 11
      end
      object qrlbl3: TQRLabel
        Left = 176
        Top = 88
        Width = 52
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.270833333333330000
          465.666666666666800000
          232.833333333333400000
          137.583333333333300000)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = #39064#22836#19977
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 11
      end
      object qrlbl2: TQRLabel
        Left = 176
        Top = 72
        Width = 52
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.270833333333330000
          465.666666666666800000
          190.500000000000000000
          137.583333333333300000)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = #39064#22836#20108
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 11
      end
      object qrlbl1: TQRLabel
        Left = 176
        Top = 56
        Width = 52
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.270833333333330000
          465.666666666666800000
          148.166666666666700000
          137.583333333333300000)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = #39064#22836#19968
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 11
      end
      object imgTitle: TQRImage
        Left = 8
        Top = 16
        Width = 177
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          66.145833333333340000
          21.166666666666670000
          42.333333333333340000
          468.312500000000100000)
        Stretch = True
      end
      object imgPhoto: TQRImage
        Left = 15
        Top = 46
        Width = 71
        Height = 90
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          238.125000000000000000
          39.687500000000000000
          121.708333333333300000
          187.854166666666700000)
        Stretch = True
      end
      object qrlblExtField1: TQRLabel
        Left = 176
        Top = 141
        Width = 52
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.270833333333330000
          465.666666666666800000
          373.062500000000000000
          137.583333333333300000)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = #25193#23637#19968
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 11
      end
      object qrlblExtField2: TQRLabel
        Left = 176
        Top = 165
        Width = 52
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.270833333333330000
          465.666666666666800000
          436.562499999999900000
          137.583333333333300000)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = #25193#23637#20108
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 11
      end
    end
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
  object dlgOpen: TOpenDialog
    Left = 432
    Top = 288
  end
  object qrySource: TADOQuery
    Connection = conSource
    LockType = ltUnspecified
    Parameters = <>
    Left = 448
    Top = 376
  end
  object conSource: TADOConnection
    LoginPrompt = False
    Left = 504
    Top = 416
  end
end
