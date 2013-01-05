object Form1: TForm1
  Left = 186
  Top = 123
  Width = 830
  Height = 515
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #38376#31105#36890#36947#24037#20855#31665
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 42
    Top = 239
    Width = 21
    Height = 13
    Caption = 'SN:'
  end
  object Label2: TLabel
    Left = 42
    Top = 268
    Width = 49
    Height = 13
    Caption = 'New IP:'
  end
  object Label3: TLabel
    Left = 42
    Top = 316
    Width = 35
    Height = 13
    Caption = 'Mask:'
  end
  object Label4: TLabel
    Left = 42
    Top = 364
    Width = 56
    Height = 13
    Caption = 'Gateway:'
  end
  object Label5: TLabel
    Left = 66
    Top = 292
    Width = 203
    Height = 13
    Caption = ' .          .          .    .'
  end
  object Label6: TLabel
    Left = 66
    Top = 340
    Width = 203
    Height = 13
    Caption = ' .          .          .    .'
  end
  object Label7: TLabel
    Left = 66
    Top = 388
    Width = 203
    Height = 13
    Caption = ' .          .          .    .'
  end
  object Label9: TLabel
    Left = 675
    Top = 255
    Width = 26
    Height = 13
    Caption = #21345#21495
  end
  object Label10: TLabel
    Left = 675
    Top = 285
    Width = 26
    Height = 13
    Caption = #38376#21495
  end
  object Label8: TLabel
    Left = 186
    Top = 412
    Width = 42
    Height = 13
    Caption = 'Label8'
  end
  object Label11: TLabel
    Left = 250
    Top = 412
    Width = 52
    Height = 13
    Caption = #31186#21518#21516#27493
  end
  object Label12: TLabel
    Left = 659
    Top = 228
    Width = 39
    Height = 13
    Caption = #23398#24037#21495
  end
  object Label13: TLabel
    Left = 344
    Top = 399
    Width = 52
    Height = 13
    Caption = #24310#26102#38388#38548
  end
  object Label14: TLabel
    Left = 472
    Top = 401
    Width = 13
    Height = 13
    Caption = #31186
  end
  object btnConfigOne: TButton
    Left = 42
    Top = 412
    Width = 113
    Height = 25
    Caption = #21333#19968#35774#22791#27979#35797
    TabOrder = 0
    OnClick = btnConfigOneClick
  end
  object Text1: TMemo
    Left = 194
    Top = 24
    Width = 425
    Height = 365
    Lines.Strings = (
      '')
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object btnExit: TButton
    Left = 34
    Top = 198
    Width = 121
    Height = 25
    Caption = 'Exit'
    TabOrder = 2
    OnClick = btnExitClick
  end
  object EditSN: TEdit
    Left = 74
    Top = 236
    Width = 65
    Height = 21
    TabOrder = 3
    Text = '51001'
  end
  object EditIP1: TEdit
    Left = 35
    Top = 284
    Width = 29
    Height = 21
    TabOrder = 4
    Text = '192'
  end
  object EditIP2: TEdit
    Left = 69
    Top = 284
    Width = 29
    Height = 21
    TabOrder = 5
    Text = '168'
  end
  object EditIP3: TEdit
    Left = 103
    Top = 284
    Width = 29
    Height = 21
    TabOrder = 6
    Text = '3'
  end
  object EditIP4: TEdit
    Left = 136
    Top = 284
    Width = 33
    Height = 21
    TabOrder = 7
    Text = '90'
  end
  object EditMask1: TEdit
    Left = 35
    Top = 332
    Width = 30
    Height = 21
    TabOrder = 8
    Text = '255'
  end
  object EditMask2: TEdit
    Left = 69
    Top = 332
    Width = 30
    Height = 21
    TabOrder = 9
    Text = '255'
  end
  object EditMask3: TEdit
    Left = 103
    Top = 332
    Width = 31
    Height = 21
    TabOrder = 10
    Text = '255'
  end
  object EditMask4: TEdit
    Left = 137
    Top = 332
    Width = 29
    Height = 21
    TabOrder = 11
    Text = '0'
  end
  object EditGateway1: TEdit
    Left = 37
    Top = 380
    Width = 29
    Height = 21
    TabOrder = 12
    Text = '192'
  end
  object EditGateway2: TEdit
    Left = 69
    Top = 380
    Width = 30
    Height = 21
    TabOrder = 13
    Text = '168'
  end
  object EditGateway3: TEdit
    Left = 102
    Top = 380
    Width = 31
    Height = 21
    TabOrder = 14
    Text = '3'
  end
  object EditGateway4: TEdit
    Left = 137
    Top = 380
    Width = 29
    Height = 21
    TabOrder = 15
    Text = '1'
  end
  object btnManualRecord: TButton
    Left = 690
    Top = 338
    Width = 113
    Height = 25
    Caption = #25163#24037#25552#21462#35760#24405
    TabOrder = 16
    OnClick = btnManualRecordClick
  end
  object btnConfigDev: TButton
    Left = 34
    Top = 12
    Width = 121
    Height = 25
    Caption = #35774#32622#25511#21046#22120'IP'
    TabOrder = 17
    OnClick = btnConfigDevClick
  end
  object btnInitPrivilege: TButton
    Left = 34
    Top = 125
    Width = 121
    Height = 25
    Caption = #37325#26032#21021#22987#21270#26435#38480
    TabOrder = 18
    OnClick = btnInitPrivilegeClick
  end
  object btnMonitorDevice: TButton
    Left = 690
    Top = 20
    Width = 113
    Height = 25
    Caption = #23454#26102#30417#25511#21047#21345
    TabOrder = 19
    OnClick = btnMonitorDeviceClick
  end
  object btnDownload: TButton
    Left = 690
    Top = 52
    Width = 113
    Height = 25
    Caption = #21517#21333#22686#37327#19979#21457
    TabOrder = 20
    OnClick = btnDownloadClick
  end
  object btnDeletePrivilege: TButton
    Left = 658
    Top = 306
    Width = 73
    Height = 25
    Caption = #21024#38500#26435#38480
    TabOrder = 21
    OnClick = btnDeletePrivilegeClick
  end
  object Edit2: TEdit
    Left = 707
    Top = 250
    Width = 96
    Height = 21
    TabOrder = 22
  end
  object Edit3: TEdit
    Left = 707
    Top = 282
    Width = 96
    Height = 21
    TabOrder = 23
    Text = '1'
  end
  object btnGetPrivilege: TButton
    Left = 690
    Top = 84
    Width = 113
    Height = 25
    Caption = #33719#24471#26435#38480#20010#25968
    TabOrder = 24
    OnClick = btnGetPrivilegeClick
  end
  object btnSyncTIme: TButton
    Left = 34
    Top = 76
    Width = 121
    Height = 25
    Caption = #26657#20934#35774#22791#26102#38047
    TabOrder = 25
    OnClick = btnSyncTImeClick
  end
  object btnCleanPrivilege: TButton
    Left = 34
    Top = 100
    Width = 121
    Height = 25
    Caption = #28165#31354#26435#38480
    TabOrder = 26
    OnClick = btnCleanPrivilegeClick
  end
  object btnAddPriv: TButton
    Left = 730
    Top = 306
    Width = 73
    Height = 25
    Caption = #22686#21152#26435#38480
    TabOrder = 27
    OnClick = btnAddPrivClick
  end
  object btnAutoGet: TButton
    Left = 690
    Top = 370
    Width = 113
    Height = 25
    Caption = #33258#21160#25552#21462#35760#24405
    TabOrder = 28
    OnClick = btnAutoGetClick
  end
  object btnSyncData: TButton
    Left = 690
    Top = 116
    Width = 113
    Height = 25
    Caption = #25163#24037#21517#21333#21516#27493
    TabOrder = 29
    OnClick = btnSyncDataClick
  end
  object btnAutoSync: TButton
    Left = 690
    Top = 148
    Width = 113
    Height = 25
    Caption = #33258#21160#22686#37327#19979#21457
    TabOrder = 30
    OnClick = btnAutoSyncClick
  end
  object btnStopTask: TButton
    Left = 34
    Top = 149
    Width = 121
    Height = 25
    Caption = #20572#27490#33258#21160#20219#21153
    TabOrder = 31
    OnClick = btnStopTaskClick
  end
  object btnUploadData: TButton
    Left = 690
    Top = 396
    Width = 113
    Height = 25
    Caption = #19978#20256#25968#25454
    TabOrder = 32
    OnClick = btnUploadDataClick
  end
  object btnAutoUpload: TButton
    Left = 690
    Top = 420
    Width = 113
    Height = 25
    Caption = #33258#21160#19978#20256#35760#24405
    TabOrder = 33
    OnClick = btnAutoUploadClick
  end
  object BitBtn1: TBitBtn
    Left = 290
    Top = 324
    Width = 75
    Height = 25
    Caption = 'BitBtn1'
    TabOrder = 34
    Visible = False
    OnClick = BitBtn1Click
  end
  object edtStuempno: TEdit
    Left = 706
    Top = 223
    Width = 97
    Height = 21
    TabOrder = 35
  end
  object Button1: TButton
    Left = 490
    Top = 268
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 36
    Visible = False
    OnClick = Button1Click
  end
  object cbDevice: TComboBox
    Left = 632
    Top = 184
    Width = 171
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 37
  end
  object btnAlwaysOpen: TButton
    Left = 499
    Top = 419
    Width = 113
    Height = 25
    Caption = #24120#24320
    TabOrder = 38
    OnClick = btnAlwaysOpenClick
  end
  object Button2: TButton
    Left = 379
    Top = 419
    Width = 113
    Height = 25
    Caption = #35835#21345#24320#38392
    TabOrder = 39
    OnClick = Button2Click
  end
  object edtDelay: TEdit
    Left = 416
    Top = 395
    Width = 49
    Height = 21
    TabOrder = 40
    Text = '2'
  end
  object Button3: TButton
    Left = 34
    Top = 173
    Width = 121
    Height = 25
    Caption = #38169#35823#34917#21457
    TabOrder = 41
    Visible = False
  end
  object btnConnectDevice: TButton
    Left = 35
    Top = 49
    Width = 121
    Height = 25
    Caption = 'ConnectDevice'
    TabOrder = 42
    Visible = False
    OnClick = btnConnectDeviceClick
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 330
    Top = 84
  end
  object OraSession1: TOraSession
    Options.Direct = True
    Username = 'ykt_cur'
    Password = 'kingstar'
    Server = '192.168.3.254:1521:hrxy'
    Left = 194
    Top = 84
  end
  object OraQuery1: TOraQuery
    Session = OraSession1
    FetchAll = True
    Left = 258
    Top = 84
  end
  object Timer2: TTimer
    Enabled = False
    OnTimer = Timer2Timer
    Left = 410
    Top = 92
  end
  object Timer3: TTimer
    Enabled = False
    OnTimer = Timer3Timer
    Left = 490
    Top = 100
  end
  object Timer4: TTimer
    Interval = 3600000
    OnTimer = Timer4Timer
    Left = 218
    Top = 204
  end
  object TimerLabel8: TTimer
    Enabled = False
    OnTimer = TimerLabel8Timer
    Left = 330
    Top = 236
  end
  object IdUDPClient1: TIdUDPClient
    BroadcastEnabled = True
    Port = 0
    Left = 242
    Top = 324
  end
  object RzTrayIcon1: TRzTrayIcon
    Animate = True
    PopupMenu = PopupMenu1
    Left = 546
    Top = 308
  end
  object PopupMenu1: TPopupMenu
    Left = 498
    Top = 308
    object N5: TMenuItem
      Caption = #25171#24320#30446#24405
      OnClick = N5Click
    end
    object N1: TMenuItem
      Caption = #33258#21160#22686#37327#19979#21457
      OnClick = btnAutoSyncClick
    end
    object N2: TMenuItem
      Caption = #33258#21160#25552#21462#35760#24405
      OnClick = btnAutoGetClick
    end
    object N3: TMenuItem
      Caption = #33258#21160#19978#20256#35760#24405
      OnClick = btnAutoUploadClick
    end
    object N4: TMenuItem
      Caption = #36864#20986
      OnClick = btnExitClick
    end
  end
end
