object Form1: TForm1
  Left = 202
  Top = 125
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 387
  ClientWidth = 762
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
    Height = 169
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
  object Label4: TLabel
    Left = 152
    Top = 8
    Width = 46
    Height = 13
    Caption = 'Database'
  end
  object Label5: TLabel
    Left = 8
    Top = 8
    Width = 32
    Height = 13
    Caption = 'Server'
  end
  object Label6: TLabel
    Left = 264
    Top = 7
    Width = 26
    Height = 13
    Caption = 'Table'
  end
  object Label7: TLabel
    Left = 376
    Top = 8
    Width = 27
    Height = 13
    Caption = 'Fields'
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
    Top = 158
    Width = 75
    Height = 25
    Caption = 'Login'
    TabOrder = 3
    OnClick = LoginButtonClick
  end
  object DatabaseListBox: TListBox
    Left = 152
    Top = 24
    Width = 106
    Height = 169
    Enabled = False
    ItemHeight = 13
    TabOrder = 4
    OnClick = DatabaseListBoxClick
  end
  object TableListBox: TListBox
    Left = 264
    Top = 23
    Width = 106
    Height = 170
    Enabled = False
    ItemHeight = 13
    TabOrder = 5
    OnClick = TableListBoxClick
  end
  object TableGrid: TDrawGrid
    Left = 8
    Top = 200
    Width = 746
    Height = 161
    DefaultColWidth = 83
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 10
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect, goThumbTracking]
    TabOrder = 6
    OnDrawCell = TableGridDrawCell
  end
  object FieldListGrid: TStringGrid
    Left = 376
    Top = 22
    Width = 378
    Height = 171
    ColCount = 4
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 10
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect, goThumbTracking]
    TabOrder = 7
    ColWidths = (
      64
      64
      36
      189)
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 368
    Width = 762
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
end
