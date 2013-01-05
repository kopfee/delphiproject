object frmMain: TfrmMain
  Left = 202
  Top = 137
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #25293#29031'/'#21046#21345#31649#29702#31995#32479
  ClientHeight = 685
  ClientWidth = 1016
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mm1
  OldCreateOrder = False
  Position = poDefault
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlPhotoInfo: TPanel
    Left = 0
    Top = 0
    Width = 241
    Height = 685
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'pnlPhotoInfo'
    TabOrder = 0
    object pnlPhoto: TPanel
      Left = 0
      Top = 295
      Width = 241
      Height = 320
      Align = alBottom
      BevelInner = bvRaised
      BevelOuter = bvLowered
      Caption = #26174#31034#29031#29255
      Color = 16053492
      TabOrder = 1
      object imgPhoto: TImage
        Left = 2
        Top = 2
        Width = 237
        Height = 316
        Align = alClient
        Stretch = True
      end
      object btn1: TButton
        Left = 16
        Top = 234
        Width = 153
        Height = 25
        Caption = #30456#26426#21462#26223#26694#35774#32622#39044#35272
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Visible = False
        OnClick = btn1Click
      end
      object cbbMenu: TComboBox
        Left = 16
        Top = 264
        Width = 145
        Height = 21
        ItemHeight = 13
        TabOrder = 1
        Visible = False
      end
    end
    object pnlOperator: TPanel
      Left = 0
      Top = 615
      Width = 241
      Height = 70
      Align = alBottom
      BevelOuter = bvNone
      Color = 16053492
      TabOrder = 2
      object grp1: TGroupBox
        Left = 0
        Top = 2
        Width = 241
        Height = 57
        Color = 16053492
        ParentColor = False
        TabOrder = 0
        object btnEditInfo: TButton
          Left = 128
          Top = 19
          Width = 73
          Height = 24
          Caption = #20462#25913#20449#24687
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -14
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          Visible = False
          OnClick = btnEditInfoClick
        end
        object btnDelPhoto: TButton
          Left = 48
          Top = 19
          Width = 125
          Height = 24
          Caption = #21024#38500#31995#32479#29031#29255
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = btnDelPhotoClick
        end
      end
    end
    object grp2: TGroupBox
      Left = 0
      Top = 0
      Width = 241
      Height = 295
      Align = alClient
      Caption = #22522#26412#20449#24687
      Color = 16053492
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      object Label13: TLabel
        Left = 3
        Top = 32
        Width = 62
        Height = 15
        Alignment = taRightJustify
        AutoSize = False
        Caption = #23458#25143#21495
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblCustNo: TLabel
        Left = 72
        Top = 32
        Width = 164
        Height = 15
        AutoSize = False
        Caption = #22995#21517#65306
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object lblStuEmpNo: TLabel
        Left = 72
        Top = 56
        Width = 164
        Height = 15
        AutoSize = False
        Caption = #22995#21517#65306
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label1: TLabel
        Left = 3
        Top = 56
        Width = 62
        Height = 15
        Alignment = taRightJustify
        AutoSize = False
        Caption = #23398#24037#21495
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbl1: TLabel
        Left = 3
        Top = 80
        Width = 62
        Height = 15
        Alignment = taRightJustify
        AutoSize = False
        Caption = #22995#21517
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblName: TLabel
        Left = 72
        Top = 80
        Width = 164
        Height = 15
        AutoSize = False
        Caption = #22995#21517#65306
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object lblType: TLabel
        Left = 72
        Top = 104
        Width = 164
        Height = 15
        AutoSize = False
        Caption = #22995#21517#65306
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 3
        Top = 104
        Width = 62
        Height = 15
        Alignment = taRightJustify
        AutoSize = False
        Caption = #23458#25143#31867#21035
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 3
        Top = 128
        Width = 62
        Height = 15
        Alignment = taRightJustify
        AutoSize = False
        Caption = #26657#21306
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblArea: TLabel
        Left = 72
        Top = 128
        Width = 164
        Height = 15
        AutoSize = False
        Caption = #22995#21517#65306
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object lblDept: TLabel
        Left = 72
        Top = 152
        Width = 164
        Height = 15
        AutoSize = False
        Caption = #22995#21517#65306
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 3
        Top = 152
        Width = 62
        Height = 15
        Alignment = taRightJustify
        AutoSize = False
        Caption = #37096#38376
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 3
        Top = 176
        Width = 62
        Height = 15
        Alignment = taRightJustify
        AutoSize = False
        Caption = #19987#19994
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblSpec: TLabel
        Left = 72
        Top = 176
        Width = 164
        Height = 15
        AutoSize = False
        Caption = #22995#21517#65306
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object lblState: TLabel
        Left = 72
        Top = 200
        Width = 164
        Height = 15
        AutoSize = False
        Caption = #22995#21517#65306
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label6: TLabel
        Left = 3
        Top = 200
        Width = 62
        Height = 15
        Alignment = taRightJustify
        AutoSize = False
        Caption = #29366#24577
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label7: TLabel
        Left = 3
        Top = 224
        Width = 62
        Height = 15
        Alignment = taRightJustify
        AutoSize = False
        Caption = #27880#20876#26085#26399
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblRegDate: TLabel
        Left = 72
        Top = 224
        Width = 164
        Height = 15
        AutoSize = False
        Caption = #22995#21517#65306
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object lblCardId: TLabel
        Left = 72
        Top = 248
        Width = 164
        Height = 15
        AutoSize = False
        Caption = '123456789123456789'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label8: TLabel
        Left = 3
        Top = 248
        Width = 62
        Height = 15
        Alignment = taRightJustify
        AutoSize = False
        Caption = #36523#20221#35777#21495
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
      end
      object bvl1: TBevel
        Left = 69
        Top = 244
        Width = 168
        Height = 21
        Shape = bsBottomLine
        Style = bsRaised
      end
      object Bevel1: TBevel
        Left = 69
        Top = 220
        Width = 168
        Height = 21
        Shape = bsBottomLine
        Style = bsRaised
      end
      object Bevel2: TBevel
        Left = 69
        Top = 196
        Width = 168
        Height = 21
        Shape = bsBottomLine
        Style = bsRaised
      end
      object Bevel3: TBevel
        Left = 69
        Top = 172
        Width = 168
        Height = 21
        Shape = bsBottomLine
        Style = bsRaised
      end
      object Bevel4: TBevel
        Left = 69
        Top = 148
        Width = 168
        Height = 21
        Shape = bsBottomLine
        Style = bsRaised
      end
      object Bevel5: TBevel
        Left = 69
        Top = 125
        Width = 168
        Height = 21
        Shape = bsBottomLine
        Style = bsRaised
      end
      object Bevel6: TBevel
        Left = 69
        Top = 101
        Width = 168
        Height = 21
        Shape = bsBottomLine
        Style = bsRaised
      end
      object Bevel7: TBevel
        Left = 69
        Top = 77
        Width = 168
        Height = 21
        Shape = bsBottomLine
        Style = bsRaised
      end
      object Bevel8: TBevel
        Left = 69
        Top = 53
        Width = 168
        Height = 21
        Shape = bsBottomLine
        Style = bsRaised
      end
      object bvlCustId: TBevel
        Left = 69
        Top = 29
        Width = 168
        Height = 21
        Shape = bsBottomLine
        Style = bsRaised
      end
    end
  end
  object pnlRight: TPanel
    Left = 610
    Top = 0
    Width = 406
    Height = 685
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object pnl3: TPanel
      Left = 0
      Top = 0
      Width = 406
      Height = 685
      Align = alClient
      BevelOuter = bvNone
      Color = clSkyBlue
      TabOrder = 0
      object shpL: TShape
        Left = 32
        Top = 24
        Width = 1
        Height = 65
        Pen.Color = clLime
      end
      object shpT: TShape
        Left = 48
        Top = 16
        Width = 65
        Height = 1
        Pen.Color = clLime
      end
      object shpR: TShape
        Left = 120
        Top = 24
        Width = 1
        Height = 65
        Pen.Color = clLime
      end
      object shpB: TShape
        Left = 56
        Top = 24
        Width = 65
        Height = 1
        Pen.Color = clLime
      end
      object shpA: TShape
        Left = 64
        Top = 32
        Width = 65
        Height = 1
        Pen.Color = clLime
      end
      object VideoWindow1: TVideoWindow
        Left = 5
        Top = 13
        Width = 398
        Height = 350
        FilterGraph = FilterGraph1
        VMROptions.Mode = vmrWindowed
        Color = clBackground
        object shpSelect: TShape
          Left = 112
          Top = 72
          Width = 129
          Height = 153
          Cursor = crSizeAll
          Brush.Color = clWindow
          Pen.Color = clMenuHighlight
          Pen.Mode = pmMask
          Pen.Style = psDashDotDot
          OnMouseDown = shpSelectMouseDown
          OnMouseMove = shpSelectMouseMove
          OnMouseUp = shpSelectMouseUp
        end
      end
      object grpCam: TGroupBox
        Left = 267
        Top = 374
        Width = 136
        Height = 173
        Caption = #25668#20687#22836#25805#20316
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object btnCamFormat: TButton
          Left = 13
          Top = 80
          Width = 109
          Height = 24
          Caption = #25668#20687#22836#26684#24335
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = btnCamFormatClick
        end
        object btnSetCam: TButton
          Left = 13
          Top = 111
          Width = 109
          Height = 24
          Caption = #25668#20687#22836#35774#32622
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = btnSetCamClick
        end
        object btnCamClose: TButton
          Left = 13
          Top = 142
          Width = 109
          Height = 24
          Caption = #20851#38381#25668#20687#22836
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = btnCamCloseClick
        end
        object btnConnCam: TRzMenuButton
          Left = 13
          Top = 19
          Width = 109
          Caption = #36830#25509#25668#20687#22836
          TabOrder = 3
          DropDownMenu = pmDev
        end
        object btnPhoto: TButton
          Left = 13
          Top = 49
          Width = 109
          Height = 24
          Caption = #25293#25668#29031#29255
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = btnPhotoClick
        end
      end
      object imgShow: TImageEnVect
        Left = 5
        Top = 380
        Width = 255
        Height = 301
        Background = clMoneyGreen
        ParentCtl3D = False
        AutoFit = True
        AutoStretch = True
        ImageEnVersion = '3.0.2'
        EnableInteractionHints = True
        TabOrder = 2
      end
      object GroupBox1: TGroupBox
        Left = 266
        Top = 552
        Width = 137
        Height = 129
        Caption = #29031#29255#25805#20316
        TabOrder = 3
        object btnSavePhoto: TButton
          Left = 13
          Top = 19
          Width = 109
          Height = 24
          Caption = #20445#23384#33267#31995#32479
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = btnSavePhotoClick
        end
        object btnSaveAs: TButton
          Left = 13
          Top = 58
          Width = 109
          Height = 24
          Caption = #20445#23384#33267#26412#22320
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = btnSaveAsClick
        end
        object btnOpenPictrue: TBitBtn
          Left = 13
          Top = 97
          Width = 109
          Height = 24
          Caption = #25171#24320#26412#22320#25991#20214
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = btnOpenPictrueClick
        end
      end
      object btnGetPhoto: TBitBtn
        Left = 290
        Top = 290
        Width = 65
        Height = 58
        Caption = #21462#29031#29255
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        Visible = False
        OnClick = btnGetPhotoClick
        Glyph.Data = {
          36100000424D3610000000000000360000002800000020000000200000000100
          2000000000000010000000000000000000000000000000000000FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
          BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF007F7F7F000000
          0000000000000000000000000000000000007F7F7F00BFBFBF00BFBFBF00BFBF
          BF00BFBFBF00BFBFBF00BFBFBF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00BFBFBF00BFBFBF00000000000000000000000000000000000000
          00000000000000000000000000000000000000000000000000007F7F7F00BFBF
          BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF007F7F7F0000000000000000000000
          0000000000000000000000000000BFBFBF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00BFBFBF00BFBFBF00000000007F7F7F00000000007F7F7F00000000007F7F
          7F00000000007F7F7F00000000007F7F7F0000000000BFBFBF00BFBFBF000000
          000000000000000000000000000000000000BFBFBF00BFBFBF00000000007F7F
          7F00000000007F7F7F000000000000000000FFFFFF00FFFFFF00FFFFFF00BFBF
          BF00BFBFBF000000000000000000000000007F7F7F00000000007F7F7F000000
          00007F7F7F00000000007F7F7F0000000000BFBFBF007F7F7F00000000007F7F
          00007F7F00007F7F00007F7F00007F7F0000000000007F7F7F00BFBFBF000000
          00007F7F7F00000000007F7F7F007F7F7F0000000000FFFFFF00BFBFBF00BFBF
          BF000000000000000000000000007F7F7F00000000007F7F7F00000000007F7F
          7F00000000007F7F7F00000000007F7F7F00BFBFBF00000000007F7F00007F7F
          00007F7F00007F7F0000FFFF00007F7F00007F7F000000000000BFBFBF007F7F
          7F00000000007F7F7F00000000007F7F7F0000000000FFFFFF00BFBFBF00BFBF
          BF00000000007F7F7F0000000000000000007F7F7F00000000007F7F7F000000
          00007F7F7F000000000000000000BFBFBF00000000007F7F00007F7F00007F7F
          00007F7F00007F7F00007F7F0000FFFF00007F7F00007F7F000000000000BFBF
          BF0000000000000000007F7F7F007F7F7F0000000000FFFFFF00FFFFFF00FFFF
          FF000000000000000000000000007F7F7F00000000007F7F7F00000000007F7F
          7F00000000000000000000000000BFBFBF00000000007F7F00007F7F00007F7F
          00007F7F00007F7F00007F7F0000FFFF00007F7F00007F7F000000000000BFBF
          BF00000000007F7F7F00000000007F7F7F0000000000FFFFFF00FFFFFF00FFFF
          FF00000000007F7F7F0000000000000000007F7F7F00000000007F7F7F000000
          0000000000000000000000000000BFBFBF00000000007F7F00007F7F00007F7F
          00007F7F00007F7F00007F7F0000FFFFFF00FFFF00007F7F000000000000BFBF
          BF0000000000000000007F7F7F007F7F7F0000000000FFFFFF00FFFFFF00FFFF
          FF000000000000000000000000007F7F7F00000000007F7F7F00000000007F7F
          7F00000000000000000000000000BFBFBF00000000007F7F00007F7F00007F7F
          00007F7F00007F7F0000FFFF0000FFFFFF007F7F00007F7F000000000000BFBF
          BF00000000007F7F7F00000000007F7F7F0000000000FFFFFF00FFFFFF00FFFF
          FF00000000007F7F7F0000000000000000007F7F7F00000000007F7F7F000000
          0000000000000000000000000000BFBFBF00000000007F7F00007F7F00007F7F
          00007F7F00007F7F0000FFFFFF00FFFF00007F7F00007F7F000000000000BFBF
          BF0000000000000000007F7F7F007F7F7F0000000000FFFFFF00FFFFFF00FFFF
          FF000000000000000000000000007F7F7F00000000007F7F7F00000000007F7F
          7F000000000000000000000000007F7F7F00BFBFBF00000000007F7F00007F7F
          0000FFFF0000FFFFFF00FFFF00007F7F00007F7F000000000000BFBFBF007F7F
          7F00000000007F7F7F00000000007F7F7F0000000000FFFFFF00FFFFFF00FFFF
          FF00000000007F7F7F0000000000000000007F7F7F00000000007F7F7F000000
          000000000000000000007F7F7F0000000000BFBFBF007F7F7F00000000007F7F
          00007F7F00007F7F00007F7F00007F7F0000000000007F7F7F00BFBFBF000000
          00007F7F7F00000000007F7F7F007F7F7F0000000000FFFFFF00FFFFFF00FFFF
          FF000000000000000000000000007F7F7F00000000007F7F7F00000000007F7F
          7F00000000007F7F7F00000000007F7F7F007F7F7F00BFBFBF00BFBFBF000000
          000000000000000000000000000000000000BFBFBF00BFBFBF00000000007F7F
          7F00000000007F7F7F00000000007F7F7F0000000000FFFFFF00FFFFFF00FFFF
          FF00000000007F7F7F0000000000000000007F7F7F00000000007F7F7F000000
          00007F7F7F00000000007F7F7F007F7F7F00BFBFBF00FFFFFF00FFFFFF00BFBF
          BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF007F7F7F00000000007F7F7F000000
          00007F7F7F00000000007F7F7F007F7F7F0000000000FFFFFF00FFFFFF00FFFF
          FF00000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000BFBFBF00BFBFBF00BFBFBF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF007F7F7F000000000000000000000000000000
          00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
          FF0000000000000000007F7F7F00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
          BF00BFBFBF00BFBFBF00BFBFBF000000000000000000FFFFFF00BFBFBF00BFBF
          BF00BFBFBF00BFBFBF000000000000000000BFBFBF00BFBFBF00BFBFBF00BFBF
          BF00BFBFBF00BFBFBF00BFBFBF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
          FF00000000007F7F7F007F7F7F00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
          BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF0000000000000000000000
          00000000000000000000BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
          BF00BFBFBF00BFBFBF00BFBFBF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
          FF00000000007F7F7F007F7F7F00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
          BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
          BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
          BF00BFBFBF00BFBFBF00BFBFBF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
          FF00000000007F7F7F00BFBFBF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
          FF0000000000BFBFBF00BFBFBF007F7F7F000000000000000000000000000000
          000000000000BFBFBF007F7F7F00000000007F7F7F007F7F7F007F7F7F007F7F
          7F007F7F7F007F7F7F0000000000BFBFBF00BFBFBF007F7F7F00000000000000
          000000000000BFBFBF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF000000000000000000000000007F7F7F00FFFFFF00FFFFFF00FFFF
          FF0000000000000000000000000000000000BFBFBF00BFBFBF00BFBFBF00BFBF
          BF00BFBFBF00BFBFBF00000000000000000000000000000000007F7F7F00FFFF
          FF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF007F7F7F000000000000000000000000000000
          0000FFFFFF00FFFFFF00000000007F7F7F0000000000BFBFBF00BFBFBF00BFBF
          BF00BFBFBF0000000000FFFFFF00FFFFFF00FFFFFF007F7F7F00000000000000
          0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00000000007F7F7F00FFFFFF00FFFFFF00FFFF
          FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
          0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
        Layout = blGlyphTop
      end
    end
  end
  object pnlLeft: TPanel
    Left = 241
    Top = 0
    Width = 369
    Height = 685
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object grp3: TGroupBox
      Left = 0
      Top = 0
      Width = 369
      Height = 97
      Align = alTop
      Caption = #26597#35810#26465#20214
      Color = 16053492
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      object Label10: TLabel
        Left = 184
        Top = 21
        Width = 49
        Height = 14
        AutoSize = False
        Caption = #23398'/'#24037#21495
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label11: TLabel
        Left = 8
        Top = 21
        Width = 56
        Height = 16
        AutoSize = False
        Caption = #25152#23646#21306#22495
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object edtStuempNo: TEdit
        Left = 184
        Top = 37
        Width = 153
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnKeyDown = edtStuempNoKeyDown
      end
      object btnQuery: TBitBtn
        Left = 8
        Top = 65
        Width = 65
        Height = 27
        Caption = '&Q'#26597' '#35810
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnQueryClick
      end
      object btnCustQuery: TBitBtn
        Left = 80
        Top = 65
        Width = 81
        Height = 27
        Caption = #35814#32454#26597#35810
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        Visible = False
        OnClick = N6Click
      end
      object cbbArea: TDBLookupComboboxEh
        Left = 9
        Top = 37
        Width = 159
        Height = 22
        DropDownBox.Rows = 15
        EditButtons = <>
        ListSource = dsArea
        TabOrder = 3
        Visible = True
      end
    end
    object dbgCustomer: TDBGridEh
      Left = 0
      Top = 97
      Width = 369
      Height = 588
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
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      SumList.Active = True
      TabOrder = 1
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clNavy
      TitleFont.Height = -15
      TitleFont.Name = #23435#20307
      TitleFont.Style = []
      OnCellClick = dbgCustomerCellClick
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
          Title.Caption = #23398#24037#21495
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
          Title.Caption = #37096#38376
          Width = 120
        end
        item
          EditButtons = <>
          Footers = <>
          Title.Alignment = taCenter
          Title.Caption = #36523#20221#35777#21495
          Width = 150
        end>
    end
  end
  object mm1: TMainMenu
    AutoHotkeys = maManual
    Left = 288
    Top = 216
    object N1: TMenuItem
      Caption = #31995#32479#31649#29702
      object N3: TMenuItem
        Caption = #26435#38480#25511#21046
        Visible = False
        OnClick = N3Click
      end
      object N21: TMenuItem
        Caption = #20462#25913#23494#30721
        OnClick = N21Click
      end
      object N15: TMenuItem
        Caption = #36864#20986
        OnClick = N15Click
      end
    end
    object N4: TMenuItem
      Caption = #32479#35745#25253#34920
      object N5: TMenuItem
        Caption = #25293#29031#32479#35745
        OnClick = N5Click
      end
      object N6: TMenuItem
        Caption = #25293#29031#20449#24687#26597#35810
        OnClick = N6Click
      end
    end
    object N7: TMenuItem
      Caption = #25968#25454#25805#20316
      object N9: TMenuItem
        Caption = #29031#29255#23548#20986
        OnClick = N9Click
      end
      object N8: TMenuItem
        Caption = #29031#29255#23548#20837
        Visible = False
        OnClick = N8Click
      end
      object N22: TMenuItem
        Caption = #20154#21592#20449#24687#23548#20837
        Visible = False
        OnClick = N22Click
      end
      object N16: TMenuItem
        Caption = #28155#21152#20154#21592#20449#24687
        Visible = False
        OnClick = N16Click
      end
      object N17: TMenuItem
        Caption = #20462#25913#20154#21592#20449#24687
        OnClick = btnEditInfoClick
      end
    end
    object N10: TMenuItem
      Caption = #21046#21345#31649#29702
      object N11: TMenuItem
        Caption = #25209#37327#25171#21360
        OnClick = N11Click
      end
    end
    object NPrint_W: TMenuItem
      Caption = #30333#21345#25171#21360
      Visible = False
    end
    object N2: TMenuItem
      Caption = #22270#20687#22788#29702
      object N18: TMenuItem
        Caption = #39068#33394#35843#25972
        OnClick = N18Click
      end
      object N19: TMenuItem
        Caption = #22270#20687#25928#26524
        OnClick = N19Click
      end
      object N20: TMenuItem
        Caption = #21435#38500#32418#30524
        OnClick = N20Click
      end
    end
    object N13: TMenuItem
      Caption = #24110#21161' '
      object N12: TMenuItem
        Caption = #25171#24320#25991#20214#22841
        OnClick = N12Click
      end
      object N14: TMenuItem
        Caption = #20851#20110#25293#29031#25171#21345#31995#32479
        OnClick = N14Click
      end
    end
  end
  object ImageEnIO1: TImageEnIO
    Background = clBtnFace
    PreviewFont.Charset = DEFAULT_CHARSET
    PreviewFont.Color = clWindowText
    PreviewFont.Height = -11
    PreviewFont.Name = 'MS Sans Serif'
    PreviewFont.Style = []
    Left = 528
    Top = 408
  end
  object opnmgndlg: TOpenImageEnDialog
    Filter = 
      'All graphics|*.jpg;*.jpeg;*.gif;*.tif;*.tiff;*.pcx;*.png;*.bmp;*' +
      '.wmf;*.emf;*.ico;*.cur;*.avi|JPEG Bitmap (JPG;JPEG)|*.jpg;*.jpeg' +
      '|CompuServe Bitmap (GIF)|*.gif|TIFF Bitmap (TIF;TIFF)|*.tif;*.ti' +
      'ff|PaintBrush (PCX)|*.pcx|Portable Network Graphics (PNG)|*.png|' +
      'Windows Bitmap (BMP)|*.bmp|OS/2 Bitmap (BMP)|*.bmp|Enhanced Wind' +
      'ows Metafile (EMF)|*.emf|Windows Metafile (WMF)|*.wmf|Icon resou' +
      'rce (ICO)|*.ico|Cursor Resource (CUR)|*.cur|Video for Windows (A' +
      'VI)|*.avi'
    PreviewBorderStyle = iepsCropShadow
    Left = 304
    Top = 328
  end
  object svmgndlg1: TSaveImageEnDialog
    Filter = 
      'JPEG Bitmap (JPG)|*.jpg|CompuServe Bitmap (GIF)|*.gif|TIFF Bitma' +
      'p (TIF)|*.tif|PaintBrush (PCX)|*.pcx|Portable Network Graphics (' +
      'PNG)|*.png|Windows Bitmap (BMP)|*.bmp|OS/2 Bitmap (BMP)|*.bmp|Ta' +
      'rga Bitmap (TGA)|*.tga|Portable PixMap (PXM)|*.pxm|Portable PixM' +
      'ap (PPM)|*.ppm|Portable GreyMap (PGM)|*.pgm|Portable Bitmap (PBM' +
      ')|*.pbm|JPEG2000 (JP2)|*.jp2|JPEG2000 Code Stream (J2K)|*.j2k|Mu' +
      'ltipage PCX (DCX)|*.dcx'
    ExOptions = [sdShowPreview, sdShowAdvanced]
    AttachedImageEnIO = imgShow
    Left = 355
    Top = 415
  end
  object ImageEnProc1: TImageEnProc
    Background = clBtnFace
    PreviewsParams = [prppShowResetButton, prppHardReset]
    PreviewFont.Charset = DEFAULT_CHARSET
    PreviewFont.Color = clWindowText
    PreviewFont.Height = -11
    PreviewFont.Name = 'MS Sans Serif'
    PreviewFont.Style = []
    Left = 426
    Top = 307
  end
  object ImageEnProc2: TImageEnProc
    Background = clBtnFace
    PreviewsParams = [prppDefaultLockPreview]
    PreviewFont.Charset = DEFAULT_CHARSET
    PreviewFont.Color = clWindowText
    PreviewFont.Height = -11
    PreviewFont.Name = 'MS Sans Serif'
    PreviewFont.Style = []
    Left = 523
    Top = 288
  end
  object qryPhoto: TOraQuery
    Session = frmdm.conn
    Left = 395
    Top = 195
  end
  object pmDev: TPopupMenu
    Left = 682
    Top = 153
    object N111: TMenuItem
      Caption = '11'
    end
    object N221: TMenuItem
      Caption = '22'
    end
  end
  object SampleGrabber1: TSampleGrabber
    FilterGraph = FilterGraph1
    MediaType.data = {
      7669647300001000800000AA00389B717DEB36E44F52CE119F530020AF0BA770
      FFFFFFFF0000000001000000809F580556C3CE11BF0100AA0055595A00000000
      0000000000000000}
    Left = 746
    Top = 257
  end
  object FilterGraph1: TFilterGraph
    Mode = gmCapture
    GraphEdit = True
    LinearVolume = True
    Left = 754
    Top = 321
  end
  object Filter1: TFilter
    BaseFilter.data = {00000000}
    FilterGraph = FilterGraph1
    Left = 762
    Top = 385
  end
  object dsQuery: TDataSource
    DataSet = frmdm.qryQuery
    Left = 489
    Top = 176
  end
  object dsArea: TDataSource
    DataSet = frmdm.qryArea
    Left = 409
    Top = 144
  end
end
