object loginForm: TloginForm
  Left = 616
  Top = 319
  Width = 253
  Height = 169
  BorderIcons = []
  Caption = #30331#24405
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 245
    Height = 142
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Color = clWhite
    TabOrder = 0
    object Label1: TLabel
      Left = 15
      Top = 24
      Width = 60
      Height = 15
      AutoSize = False
      Caption = #25805#20316#21592
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 15
      Top = 56
      Width = 61
      Height = 15
      AutoSize = False
      Caption = #23494'  '#30721
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object edtpwd: TEdit
      Left = 79
      Top = 51
      Width = 145
      Height = 23
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 1
      Text = 'Qwe123'
    end
    object edtOper: TEdit
      Left = 79
      Top = 19
      Width = 145
      Height = 23
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'jojo'
    end
    object btnLogin: TRzBitBtn
      Left = 48
      Top = 104
      Caption = #30331' '#24405
      TabOrder = 2
      OnClick = btnLoginClick
      Kind = bkOK
    end
    object btnExit: TRzBitBtn
      Left = 144
      Top = 104
      Caption = #21462' '#28040
      TabOrder = 3
      OnClick = btnExitClick
      Kind = bkCancel
    end
  end
end
