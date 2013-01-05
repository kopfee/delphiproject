object frmMain: TfrmMain
  Left = 404
  Top = 135
  Width = 626
  Height = 491
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'CRM'#28040#24687#20013#24515
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 191
    Width = 618
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object RzMemo1: TRzMemo
    Left = 0
    Top = 194
    Width = 618
    Height = 247
    Align = alClient
    TabOrder = 0
  end
  object RzListView1: TRzListView
    Left = 0
    Top = 41
    Width = 618
    Height = 150
    Align = alTop
    Columns = <
      item
        Caption = #24207#21495
      end
      item
        Caption = #35746#21333#21495
      end
      item
        AutoSize = True
        Caption = #20869#23481
      end>
    Items.Data = {
      4A0000000300000000000000FFFFFFFFFFFFFFFF000000000000000001310000
      0000FFFFFFFFFFFFFFFF0000000000000000013200000000FFFFFFFFFFFFFFFF
      00000000000000000133}
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    OnSelectItem = RzListView1SelectItem
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 441
    Width = 618
    Height = 23
    Panels = <
      item
        Width = 50
      end
      item
        Width = 200
      end
      item
        Width = 50
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 618
    Height = 41
    Align = alTop
    TabOrder = 3
    object btnImport: TButton
      Left = 24
      Top = 8
      Width = 105
      Height = 25
      Caption = #23548#20837#23458#25143#36164#26009
      TabOrder = 0
      OnClick = btnImportClick
    end
    object BitBtn1: TBitBtn
      Left = 520
      Top = 8
      Width = 75
      Height = 25
      Caption = #36864#20986'&C'
      TabOrder = 1
      OnClick = N1Click
      Kind = bkClose
    end
    object Button1: TButton
      Left = 248
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 2
      OnClick = Button1Click
    end
  end
  object RzTrayIcon1: TRzTrayIcon
    PopupMenu = PopupMenu1
    Left = 240
    Top = 312
  end
  object PopupMenu1: TPopupMenu
    Left = 168
    Top = 312
    object N1: TMenuItem
      Caption = #36864#20986
      OnClick = N1Click
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 352
    Top = 312
  end
  object OpenDialog1: TOpenDialog
    Left = 168
    Top = 8
  end
end
