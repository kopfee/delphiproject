object frmdm: Tfrmdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 310
  Top = 455
  Height = 217
  Width = 592
  object conn: TOraSession
    Options.Direct = True
    Username = 'ykt_cur'
    Password = 'kingstar'
    Left = 16
    Top = 8
  end
  object qryImport: TOraQuery
    Session = conn
    Left = 16
    Top = 67
  end
  object qryQuery: TOraQuery
    Session = conn
    Left = 80
    Top = 68
  end
  object qrySpec: TOraQuery
    Session = conn
    Left = 208
    Top = 10
  end
  object qryArea: TOraQuery
    Session = conn
    Left = 144
    Top = 67
  end
  object qryDept: TOraQuery
    Session = conn
    Left = 144
    Top = 8
  end
  object qryType: TOraQuery
    Session = conn
    Left = 80
    Top = 8
  end
  object qryAdd: TOraQuery
    Left = 288
    Top = 16
  end
  object qryFeeType: TOraQuery
    Left = 352
    Top = 24
  end
end
