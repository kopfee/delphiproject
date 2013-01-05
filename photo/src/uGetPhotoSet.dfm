object frmGetPhotoSet: TfrmGetPhotoSet
  Left = 319
  Top = 293
  BorderStyle = bsDialog
  Caption = #25968#25454#24211#35774#32622
  ClientHeight = 235
  ClientWidth = 420
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
    Width = 420
    Height = 235
    Align = alClient
    BevelOuter = bvNone
    Color = 16053492
    TabOrder = 0
    object lbl1: TLabel
      Left = 24
      Top = 16
      Width = 353
      Height = 15
      AutoSize = False
      Caption = #25968#25454#24211#25152#22312#20301#32622#65288#20363#22914#65306'127.0.0.1:1521:yktdb'#65289
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 24
      Top = 72
      Width = 345
      Height = 15
      AutoSize = False
      Caption = #25968#25454#24211#29992#25143#21517
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 24
      Top = 128
      Width = 345
      Height = 15
      AutoSize = False
      Caption = #25968#25454#24211#23494#30721
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object edtPath: TEdit
      Left = 24
      Top = 40
      Width = 353
      Height = 21
      TabOrder = 0
    end
    object edtPre: TEdit
      Left = 24
      Top = 96
      Width = 353
      Height = 21
      TabOrder = 1
    end
    object edtNativePath: TEdit
      Left = 24
      Top = 152
      Width = 353
      Height = 21
      TabOrder = 2
    end
    object btnOK: TRzBitBtn
      Left = 216
      Top = 192
      Caption = #30830'  '#23450
      TabOrder = 3
      OnClick = btnOKClick
      Kind = bkOK
    end
    object btnCancel: TRzBitBtn
      Left = 312
      Top = 192
      Caption = #21462' '#28040
      TabOrder = 4
      OnClick = btnCancelClick
      Kind = bkCancel
    end
  end
end
