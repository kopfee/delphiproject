object frmIfRepalce: TfrmIfRepalce
  Left = 313
  Top = 138
  Width = 402
  Height = 381
  BorderIcons = []
  Caption = #30830#35748#29031#29255#26367#25442
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 14
  object grp1: TGroupBox
    Left = 8
    Top = 8
    Width = 353
    Height = 257
    Caption = #29031#29255#20449#24687
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 20
      Width = 147
      Height = 14
      AutoSize = False
      Caption = #25968#25454#24211#20013#24050#26377#23398'/'#24037#21495#20026
    end
    object Label4: TLabel
      Left = 24
      Top = 44
      Width = 133
      Height = 14
      AutoSize = False
      Caption = #35201#35206#30422#20197#21069#30340#29031#29255#21527'?'
    end
    object lblNum: TLabel
      Left = 176
      Top = 20
      Width = 42
      Height = 14
      Caption = 'lblNum'
    end
    object Label3: TLabel
      Left = 288
      Top = 20
      Width = 49
      Height = 14
      AutoSize = False
      Caption = #30340#29031#29255#12290
    end
    object Label2: TLabel
      Left = 72
      Top = 68
      Width = 42
      Height = 14
      Caption = #26087#29031#29255
    end
    object Label5: TLabel
      Left = 232
      Top = 68
      Width = 42
      Height = 14
      Caption = #26032#29031#29255
    end
    object imgNew: TImage
      Left = 192
      Top = 85
      Width = 120
      Height = 160
      Stretch = True
    end
    object imgOld: TImage
      Left = 32
      Top = 85
      Width = 120
      Height = 160
      Stretch = True
    end
  end
  object grp2: TGroupBox
    Left = 8
    Top = 272
    Width = 353
    Height = 57
    Caption = #25805#20316
    TabOrder = 1
    object btnReplace: TButton
      Left = 16
      Top = 24
      Width = 75
      Height = 25
      Caption = #35206#30422
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnReplaceClick
    end
    object btnAllReplace: TButton
      Left = 96
      Top = 24
      Width = 75
      Height = 25
      Caption = #20840#37096#35206#30422
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnAllReplaceClick
    end
    object btnSkip: TButton
      Left = 176
      Top = 24
      Width = 75
      Height = 25
      Caption = #36339#36807
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = btnSkipClick
    end
    object btnCancel: TButton
      Left = 264
      Top = 24
      Width = 75
      Height = 25
      Caption = #21462#28040
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = btnCancelClick
    end
  end
end
