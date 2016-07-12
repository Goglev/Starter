object dmRepDept: TdmRepDept
  OldCreateOrder = True
  Left = 307
  Top = 213
  Height = 155
  Width = 236
  object quUpperDept: TOracleDataSet
    SQL.Strings = (
      'SELECT ID,KOD,SNAIM,PNAIM'
      'FROM P.VSPODR'
      'WHERE MIUROVEN_KOD=1'
      'order by KOD')
    ReadBuffer = 25
    Optimize = True
    Debug = False
    StringFieldsOnly = False
    SequenceField.ApplyMoment = amOnPost
    OracleDictionary.EnforceConstraints = False
    OracleDictionary.UseMessageTable = False
    OracleDictionary.DefaultValues = False
    OracleDictionary.DynamicDefaults = False
    OracleDictionary.FieldKinds = False
    OracleDictionary.DisplayFormats = False
    OracleDictionary.RangeValues = False
    OracleDictionary.RequiredFields = True
    QBEDefinition.SaveQBEValues = True
    QBEDefinition.AllowFileWildCards = True
    QBEDefinition.QBEFontColor = clNone
    QBEDefinition.QBEBackgroundColor = clNone
    Cursor = crSQLWait
    AutoCalcFields = False
    ReadOnly = True
    LockingMode = lmCheckImmediate
    QueryAllRecords = True
    CountAllRecords = False
    RefreshOptions = []
    CommitOnPost = True
    CachedUpdates = False
    QBEMode = False
    Session = dmGlobal.seOracle
    DesignActivation = False
    Active = False
    OnCalcFields = quUpperDeptCalcFields
    Left = 24
    Top = 8
    object quUpperDeptKOD: TIntegerField
      DisplayWidth = 2
      FieldName = 'KOD'
      Required = True
      DisplayFormat = '00'
      EditFormat = '00'
    end
    object quUpperDeptSNAIM: TStringField
      FieldName = 'SNAIM'
      Required = True
      Size = 10
    end
    object quUpperDeptPNAIM: TStringField
      FieldName = 'PNAIM'
      Required = True
      Size = 100
    end
    object quUpperDeptSOSTAV: TStringField
      FieldKind = fkCalculated
      FieldName = 'SOSTAV'
      Size = 255
      Calculated = True
    end
    object quUpperDeptID: TFloatField
      FieldName = 'ID'
      Required = True
    end
  end
  object quUpperTech: TOracleQuery
    SQL.Strings = (
      'SELECT TO_CHAR(KOD,'#39'00'#39') FROM P.VSPODR'
      'WHERE MIPODR_ID= :up_id'
      'AND MIUROVEN_KOD=2'
      'ORDER BY KOD')
    Session = dmGlobal.seOracle
    ReadBuffer = 25
    Optimize = True
    Debug = False
    Variables.Data = {0300000001000000060000003A55505F4944030000000000000000000000}
    Cursor = crSQLWait
    StringFieldsOnly = False
    Threaded = False
    ThreadSynchronized = True
    Left = 96
    Top = 8
  end
  object quWorkShop: TOracleDataSet
    SQL.Strings = (
      'SELECT KOD,SNAIM,PNAIM,ID'
      'FROM P.VSPODR'
      'WHERE MIUROVEN_KOD=2'
      'ORDER BY KOD')
    ReadBuffer = 25
    Optimize = True
    Debug = False
    StringFieldsOnly = False
    SequenceField.ApplyMoment = amOnPost
    OracleDictionary.EnforceConstraints = False
    OracleDictionary.UseMessageTable = False
    OracleDictionary.DefaultValues = False
    OracleDictionary.DynamicDefaults = False
    OracleDictionary.FieldKinds = False
    OracleDictionary.DisplayFormats = False
    OracleDictionary.RangeValues = False
    OracleDictionary.RequiredFields = True
    QBEDefinition.SaveQBEValues = True
    QBEDefinition.AllowFileWildCards = True
    QBEDefinition.QBEFontColor = clNone
    QBEDefinition.QBEBackgroundColor = clNone
    Cursor = crDefault
    ReadOnly = True
    LockingMode = lmCheckImmediate
    QueryAllRecords = True
    CountAllRecords = False
    RefreshOptions = []
    CommitOnPost = True
    CachedUpdates = False
    QBEMode = False
    Session = dmGlobal.seOracle
    DesignActivation = False
    Active = False
    Left = 24
    Top = 64
    object quWorkShopKOD: TIntegerField
      DisplayWidth = 2
      FieldName = 'KOD'
      Required = True
      DisplayFormat = '00'
      EditFormat = '00'
    end
    object quWorkShopSNAIM: TStringField
      FieldName = 'SNAIM'
      Required = True
      Size = 10
    end
    object quWorkShopPNAIM: TStringField
      FieldName = 'PNAIM'
      Required = True
      Size = 100
    end
    object quWorkShopID: TFloatField
      FieldName = 'ID'
      Required = True
    end
  end
  object quDept: TOracleDataSet
    SQL.Strings = (
      'SELECT SUBSTR(PKOD,5,16) LONG_CODE,'
      'SNAIM,PNAIM,MIPODR_ID'
      'FROM P.MIPODR'
      'WHERE DATAVIVOD IS NULL'
      'AND LEVEL>1'
      'START WITH ID= :MIPODR_ID'
      'CONNECT BY PRIOR ID=MIPODR_ID'
      'ORDER BY PKOD')
    ReadBuffer = 25
    Optimize = True
    Debug = False
    Variables.Data = {
      03000000010000000A0000003A4D49504F44525F494403000000000000000000
      0000}
    StringFieldsOnly = False
    SequenceField.ApplyMoment = amOnPost
    OracleDictionary.EnforceConstraints = False
    OracleDictionary.UseMessageTable = False
    OracleDictionary.DefaultValues = False
    OracleDictionary.DynamicDefaults = False
    OracleDictionary.FieldKinds = False
    OracleDictionary.DisplayFormats = False
    OracleDictionary.RangeValues = False
    OracleDictionary.RequiredFields = True
    QBEDefinition.SaveQBEValues = True
    QBEDefinition.AllowFileWildCards = True
    QBEDefinition.QBEFontColor = clNone
    QBEDefinition.QBEBackgroundColor = clNone
    Cursor = crDefault
    Master = quWorkShop
    MasterFields = 'ID'
    DetailFields = 'MIPODR_ID'
    ReadOnly = True
    LockingMode = lmCheckImmediate
    QueryAllRecords = True
    CountAllRecords = False
    RefreshOptions = []
    CommitOnPost = True
    CachedUpdates = False
    QBEMode = False
    Session = dmGlobal.seOracle
    DesignActivation = False
    Active = False
    Left = 96
    Top = 64
  end
end
