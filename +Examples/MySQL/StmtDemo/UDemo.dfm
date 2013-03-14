object Form1: TForm1
  Left = 202
  Top = 125
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 318
  ClientWidth = 578
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 24
    Width = 138
    Height = 205
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 32
    Width = 22
    Height = 13
    Caption = 'Host'
  end
  object Label2: TLabel
    Left = 16
    Top = 72
    Width = 48
    Height = 13
    Caption = 'Username'
  end
  object Label3: TLabel
    Left = 16
    Top = 112
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object Label5: TLabel
    Left = 8
    Top = 8
    Width = 32
    Height = 13
    Caption = 'Server'
  end
  object Label4: TLabel
    Left = 152
    Top = 8
    Width = 41
    Height = 13
    Caption = 'Protocoll'
  end
  object Label6: TLabel
    Left = 16
    Top = 152
    Width = 46
    Height = 13
    Caption = 'Database'
  end
  object HostEdit: TEdit
    Left = 16
    Top = 48
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'localhost'
  end
  object UserEdit: TEdit
    Left = 16
    Top = 88
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'root'
  end
  object PasswordEdit: TEdit
    Left = 16
    Top = 128
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
  end
  object LoginButton: TButton
    Left = 62
    Top = 195
    Width = 75
    Height = 25
    Caption = 'Login'
    TabOrder = 4
    OnClick = LoginButtonClick
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 299
    Width = 578
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 100
      end
      item
        Width = 50
      end>
  end
  object FillButton: TButton
    Left = 8
    Top = 235
    Width = 138
    Height = 25
    Caption = 'Fill Sample Table'
    Enabled = False
    TabOrder = 5
    OnClick = FillButtonClick
  end
  object QueryButton: TButton
    Left = 8
    Top = 266
    Width = 138
    Height = 25
    Caption = 'Query Sample Table'
    Enabled = False
    TabOrder = 6
    OnClick = QueryButtonClick
  end
  object Memo: TMemo
    Left = 152
    Top = 24
    Width = 417
    Height = 267
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 7
  end
  object DatabaseEdit: TEdit
    Left = 16
    Top = 168
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'test'
  end
end
