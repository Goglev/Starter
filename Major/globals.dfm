object dmGlobal: TdmGlobal
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  Height = 637
  Width = 807
  object seOracle: TOracleSession
    AfterLogOn = seOracleAfterLogOn
    DesignConnection = True
    LogonUsername = 'p'
    LogonPassword = 'telex'
    LogonDatabase = 'ORACLE'
    Preferences.ConvertUTF = cuUTF8ToUTF16
    NullValue = nvNull
    Connected = True
    Left = 16
    Top = 8
  end
  object mdStruc: TMetaDataSource
    DataSetList = <
      item
        DataSet = quMipodr
        DataSetName = 'quMipodr'
      end>
    Left = 64
    Top = 8
  end
  object fsFields: TFormStorage
    Active = False
    Options = []
    UseRegistry = True
    StoredValues = <>
    Left = 232
    Top = 64
  end
  object quMipodr: TASUPQuery
    SQL.Strings = (
      'SELECT '
      'A.*,'
      'B.KOD MIPODR_KOD,'
      'SUBSTR(B.PKOD,5)||'#39' '#39'||B.SNAIM VERH_PODR,'
      'B.PNAIM VERH_NAIM,'
      'A.ROWID'
      'FROM'
      'MIPODR B,'
      'VPODR A'
      'WHERE B.ID=A.MIPODR_ID'
      'AND A.MIUROVEN_KOD= :DEPT_LEVEL'
      '/* END_REFRESH */')
    Optimize = False
    Variables.Data = {
      0400000001000000160000003A0044004500500054005F004C00450056004500
      4C0003000000040000000100000000000000}
    QBEDefinition.QBEFieldDefs = {
      050000000A0000000400000049004400010000000000060000004B004F004400
      0100000000000A00000053004E00410049004D000100000000000A0000005000
      4E00410049004D00010000000000120000004D00490050004F00440052005F00
      49004400010000000000180000004D004900550052004F00560045004E005F00
      4B004F0044000100000000000800000050004B004F0044000100000000001400
      00004D00490050004F00440052005F004B004F00440001000000000012000000
      56004500520048005F0050004F00440052000100000000001200000056004500
      520048005F004E00410049004D00010000000000}
    Cursor = crSQLWait
    QueryAllRecords = False
    UpdatingTable = 'VPODR'
    Session = seOracle
    BeforePost = CheckLevelBeforePost
    ReActive = True
    Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
    Order = 'VERH_PODR ASC,A.KOD ASC'
    AccessLevel = [aqQuerying, aqPrinting]
    EditorClassName = 'TfmMipodr'
    UpdTabAlias = 'A'
    TreeNodeIndex = 0
    Left = 141
    Top = 8
    object quMipodrVERH_PODR: TStringField
      DisplayLabel = #1042#1077#1088#1093'. '#1087#1086#1076#1088'.'
      DisplayWidth = 18
      FieldKind = fkInternalCalc
      FieldName = 'VERH_PODR'
      Visible = False
      Size = 27
    end
    object quMipodrKOD: TIntegerField
      DisplayLabel = #1050#1086#1076
      DisplayWidth = 2
      FieldName = 'KOD'
      Origin = 'A.KOD'
      Required = True
      DisplayFormat = '00'
      EditFormat = '00'
    end
    object quMipodrSNAIM: TStringField
      DisplayLabel = #1057#1086#1082#1088'. '#1085#1072#1080#1084'.'
      FieldName = 'SNAIM'
      Origin = 'A.SNAIM'
      Required = True
      Size = 10
    end
    object quMipodrPNAIM: TStringField
      DisplayLabel = #1055#1086#1083#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      FieldName = 'PNAIM'
      Origin = 'A.PNAIM'
      Required = True
      Size = 100
    end
    object quMipodrID: TFloatField
      Tag = 2
      DisplayLabel = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      FieldName = 'ID'
      Origin = 'A.ID'
      Visible = False
    end
    object quMipodrMIPODR_ID: TFloatField
      Tag = 2
      DisplayLabel = #1042#1077#1088#1093'. '#1087#1086#1076#1088'.'
      FieldName = 'MIPODR_ID'
      Origin = 'A.MIPODR_ID'
      Visible = False
      OnChange = quMipodrMIPODR_IDChange
    end
    object quMipodrMIPODR_KOD: TIntegerField
      Tag = 2
      DisplayLabel = #1050#1086#1076' '#1074#1077#1088#1093'. '#1087#1086#1076#1088'.'
      DisplayWidth = 2
      FieldKind = fkInternalCalc
      FieldName = 'MIPODR_KOD'
      Visible = False
      DisplayFormat = '00'
      EditFormat = '00'
    end
    object quMipodrVERH_NAIM: TStringField
      Tag = 2
      FieldKind = fkInternalCalc
      FieldName = 'VERH_NAIM'
      Visible = False
      Size = 100
    end
    object quMipodrMIUROVEN_KOD: TIntegerField
      Tag = 2
      DisplayWidth = 2
      FieldName = 'MIUROVEN_KOD'
      Origin = 'A.MIUROVEN_KOD'
      Visible = False
      DisplayFormat = '00'
      EditFormat = '00'
    end
  end
  object quMiuroven: TASUPQuery
    SQL.Strings = (
      'SELECT A.*,A.ROWID FROM MIUROVEN A')
    Optimize = False
    Cursor = crSQLWait
    UpdatingTable = 'MIUROVEN'
    Session = seOracle
    ReActive = True
    Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1091#1088#1086#1074#1085#1077#1081' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
    Order = 'KOD ASC'
    AccessLevel = [aqQuerying, aqPrinting]
    EditorClassName = 'TfmNSI'
    ReportClassName = 'TfmxStdRep'
    UpdTabAlias = 'A'
    TreeNodeIndex = 0
    Left = 120
    Top = 64
    object quMiurovenKOD: TIntegerField
      DisplayLabel = #1050#1086#1076
      DisplayWidth = 2
      FieldName = 'KOD'
      Required = True
      DisplayFormat = '00'
      EditFormat = '00'
    end
    object quMiurovenSNAIM: TStringField
      DisplayLabel = #1057#1086#1082#1088'.'#1085#1072#1080#1084'.'
      FieldName = 'SNAIM'
      Required = True
      Size = 10
    end
    object quMiurovenPNAIM: TStringField
      DisplayLabel = #1055#1086#1083#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      FieldName = 'PNAIM'
      Required = True
      Size = 100
    end
  end
  object quMiPolz: TASUPQuery
    SQL.Strings = (
      'SELECT A.*,A.ROWID,'
      'B.PNAIM MIROL_NAIM,'
      'B.ORANAIM MIROL_ORANAIM'
      'FROM'
      '  MIROL B,'
      '  VPOLZ A'
      'WHERE B.KOD= A.MIROL_KOD  '
      '/* END_REFRESH */')
    Optimize = False
    Cursor = crSQLWait
    UpdatingTable = 'VPOLZ'
    Session = seOracle
    ReActive = True
    Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
    Order = 'A.PNAIM ASC'
    EditorClassName = 'TfmMiPolz'
    UpdTabAlias = 'A'
    TreeNodeIndex = 0
    Left = 13
    Top = 64
    object quMiPolzPNAIM: TStringField
      DisplayLabel = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
      DisplayWidth = 30
      FieldName = 'PNAIM'
      Origin = 'A.PNAIM'
      Required = True
      Size = 100
    end
    object quMiPolzMIROL_KOD: TIntegerField
      DisplayLabel = #1050#1086#1076
      DisplayWidth = 2
      FieldName = 'MIROL_KOD'
      Origin = 'A.MIROL_KOD'
      Required = True
      OnChange = RefreshCalcFields
      DisplayFormat = '00'
      EditFormat = '00'
    end
    object quMiPolzMIROL_NAIM: TStringField
      DisplayLabel = #1055#1086#1083#1085#1086#1084#1086#1095'.'#1085#1072#1080#1084'.'
      DisplayWidth = 50
      FieldKind = fkInternalCalc
      FieldName = 'MIROL_NAIM'
      Size = 100
    end
    object quMiPolzORANAIM: TStringField
      DisplayLabel = 'ORACLE-'#1048#1084#1103
      FieldName = 'ORANAIM'
      Origin = 'A.ORANAIM'
      Required = True
    end
    object quMiPolzMIROL_ORANAIM: TStringField
      Tag = 2
      DisplayLabel = 'ORACLE-'#1056#1086#1083#1100
      FieldKind = fkInternalCalc
      FieldName = 'MIROL_ORANAIM'
      Visible = False
    end
    object quMiPolzMIPODSIS_KOD: TIntegerField
      Tag = 2
      DisplayLabel = #1055#1086#1076#1089#1080#1089#1090#1077#1084#1072
      DisplayWidth = 2
      FieldName = 'MIPODSIS_KOD'
      Visible = False
      DisplayFormat = '00'
      EditFormat = '00'
    end
  end
  object quMiRol: TASUPQuery
    SQL.Strings = (
      'SELECT A.*,A.ROWID FROM V_ROLE A'
      '/* END_REFRESH */')
    Optimize = False
    QBEDefinition.QBEFieldDefs = {
      0500000004000000060000004B004F0044000100000000000A00000050004E00
      410049004D000100000000000E0000004F00520041004E00410049004D000100
      000000000A00000053004800490046005200010000000000}
    Cursor = crSQLWait
    AutoCalcFields = False
    UpdatingTable = 'V_ROLE'
    Session = seOracle
    ReActive = True
    Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1087#1086#1083#1085#1086#1084#1086#1095#1080#1081
    Order = 'KOD ASC'
    EditorClassName = 'TfmMiRol'
    UpdTabAlias = 'A'
    TreeNodeIndex = 0
    Left = 64
    Top = 64
    object quMiRolKOD: TIntegerField
      DisplayLabel = #1050#1086#1076
      DisplayWidth = 2
      FieldName = 'KOD'
      Required = True
      DisplayFormat = '00'
      EditFormat = '00'
    end
    object quMiRolPNAIM: TStringField
      DisplayLabel = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      DisplayWidth = 30
      FieldName = 'PNAIM'
      Required = True
      Size = 100
    end
    object quMiRolORANAIM: TStringField
      DisplayLabel = 'ORACLE-'#1056#1086#1083#1100
      FieldName = 'ORANAIM'
      Required = True
    end
    object quMiRolSHIFR: TStringField
      DisplayLabel = #1064#1080#1092#1088
      FieldName = 'SHIFR'
      Size = 10
    end
  end
  object quMiPrava: TASUPQuery
    SQL.Strings = (
      'SELECT'
      'DISTINCT'
      'A.*,A.ROWID,'
      'B.PNAIM MIPOLZ_NAIM,'
      'D.SNAIM MIPODR_SNAIM,'
      'NODE_PATH(D.ID,D.MIUROVEN_KOD,2)  MIPODR_PNAIM,'
      'SUBSTR(D.PKOD,5) MIPODR_KOD,'
      'UPDR.KOD MIUPDR_KOD,'
      'UPDR.SNAIM MIUPDR_NAIM,'
      'A.MIPODR_ID MIPODR_ID'
      'FROM'
      'VPOLZ B,'
      'MIDETAL E,'
      'MIPODR UPDR,'
      'MIDETAL QUERY,'
      'MIPODR D,'
      'VPRAVA A'
      'WHERE'
      'D.ID=A.MIPODR_ID'
      'AND UPDR.MIUROVEN_KOD= 1'
      'AND UPDR.ID= E.MIPODR_ID'
      'AND D.ID= E.MIPODR_ID_DETAL'
      'AND D.ID= QUERY.MIPODR_ID_DETAL'
      'AND QUERY.MIPODR_ID= :MAIN_DEPT'
      'AND B.ORANAIM= A.MIPOLZ_ORANAIM'
      '/* END_REFRESH */'
      ' ')
    Optimize = False
    Variables.Data = {
      0400000001000000140000003A004D00410049004E005F004400450050005400
      03000000040000000100000000000000}
    Cursor = crSQLWait
    AutoCalcFields = False
    LockingMode = lmNone
    UpdatingTable = 'VPRAVA'
    Session = seOracle
    ReActive = True
    Caption = #1044#1086#1089#1090#1091#1087' '#1082' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
    Order = 'MIPOLZ_NAIM ASC,MIPODR_KOD ASC'
    EditorClassName = 'TfmMiPrava'
    UpdTabAlias = 'A'
    TreeNodeIndex = 0
    Left = 272
    Top = 8
    object quMiPravaMIPOLZ_NAIM: TStringField
      DisplayLabel = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
      DisplayWidth = 30
      FieldKind = fkInternalCalc
      FieldName = 'MIPOLZ_NAIM'
      Required = True
      Size = 100
    end
    object quMiPravaMIPODR_KOD: TStringField
      DisplayLabel = #1055#1086#1076#1088'.'
      DisplayWidth = 8
      FieldKind = fkInternalCalc
      FieldName = 'MIPODR_KOD'
      OnChange = MasPodrChange
      Size = 16
    end
    object quMiPravaMIPODR_SNAIM: TStringField
      DisplayLabel = #1055#1086#1076#1088'. '#1085#1072#1080#1084'.'
      FieldKind = fkInternalCalc
      FieldName = 'MIPODR_SNAIM'
      Size = 10
    end
    object quMiPravaMIPODR_PNAIM: TStringField
      Tag = 2
      DisplayLabel = #1055#1086#1076#1088'. '#1085#1072#1080#1084'.('#1087')'
      FieldKind = fkInternalCalc
      FieldName = 'MIPODR_PNAIM'
      Visible = False
      Size = 255
    end
    object quMiPravaMIUPDR_KOD: TIntegerField
      DisplayLabel = #1059#1082'.'#1087#1086#1076#1088'.'
      DisplayWidth = 2
      FieldKind = fkInternalCalc
      FieldName = 'MIUPDR_KOD'
      Visible = False
      OnChange = MasPodrChange
      DisplayFormat = '00'
      EditFormat = '00'
    end
    object quMiPravaMIUPDR_NAIM: TStringField
      DisplayLabel = #1059#1082'.'#1085#1072#1080#1084'.'
      FieldKind = fkInternalCalc
      FieldName = 'MIUPDR_NAIM'
      Visible = False
      Size = 10
    end
    object quMiPravaMIPODR_ID: TFloatField
      Tag = 2
      DisplayLabel = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      FieldName = 'MIPODR_ID'
      Required = True
      Visible = False
      OnChange = MasPodrChange
    end
    object quMiPravaMIPOLZ_ORANAIM: TStringField
      Tag = 2
      DisplayLabel = #1055#1086#1083#1100#1079'.'
      FieldName = 'MIPOLZ_ORANAIM'
      Required = True
      Visible = False
      OnChange = RefreshCalcFields
    end
    object quMiPravaMIPOLZ_MIPODSIS_KOD: TIntegerField
      Tag = 2
      DisplayLabel = #1050#1086#1076' '#1087#1086#1076#1089#1080#1089#1090#1077#1084#1099
      FieldName = 'MIPOLZ_MIPODSIS_KOD'
      Visible = False
    end
  end
  object quUsers: TOracleDataSet
    SQL.Strings = (
      'select oranaim,pnaim from vpolz '
      'order by pnaim')
    Optimize = False
    Cursor = crSQLWait
    UpdatingTable = 'VPOLZ'
    Session = seOracle
    AfterOpen = quUsersAfterOpen
    AfterClose = quUsersAfterClose
    Left = 176
    Top = 64
    object quUsersORANAIM: TStringField
      FieldName = 'ORANAIM'
      Required = True
    end
    object quUsersPNAIM: TStringField
      FieldName = 'PNAIM'
      Required = True
      Size = 100
    end
  end
  object quMiprava_All: TASUPQuery
    SQL.Strings = (
      'SELECT'
      'A.*,A.ROWID,'
      'B.PNAIM MIPOLZ_NAIM,'
      'to_number(d.pkod) mipred_kod,'
      'd.snaim mipred_naim'
      'FROM'
      'mipodr d,'
      'VPOLZ B,'
      'VPRAVA A'
      'WHERE'
      'A.MIPODR_ID= d.id'
      'and d.miuroven_kod <= 0'
      'AND B.ORANAIM= A.MIPOLZ_ORANAIM'
      '/* END_REFRESH */')
    Optimize = False
    QBEDefinition.QBEFieldDefs = {
      05000000060000001C0000004D00490050004F004C005A005F004F0052004100
      4E00410049004D00010000000000120000004D00490050004F00440052005F00
      49004400010000000000260000004D00490050004F004C005A005F004D004900
      50004F0044005300490053005F004B004F004400010000000000160000004D00
      490050004F004C005A005F004E00410049004D00010000000000140000004D00
      490050005200450044005F004B004F004400010000000000160000004D004900
      50005200450044005F004E00410049004D00010000000000}
    Cursor = crSQLWait
    AutoCalcFields = False
    UpdatingTable = 'VPRAVA'
    Session = seOracle
    BeforePost = quMiprava_AllBeforePost
    ReActive = True
    Caption = #1044#1086#1089#1090#1091#1087' '#1082' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
    Order = 'MIPOLZ_NAIM ASC'
    EditorClassName = 'TfmMiprava_All'
    UpdTabAlias = 'A'
    TreeNodeIndex = 0
    Left = 203
    Top = 8
    object quMiprava_AllMIPOLZ_NAIM: TStringField
      DisplayLabel = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
      DisplayWidth = 30
      FieldKind = fkInternalCalc
      FieldName = 'MIPOLZ_NAIM'
      Required = True
      Size = 100
    end
    object quMiprava_AllMIPODR_ID: TFloatField
      Tag = 2
      DisplayLabel = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      FieldName = 'MIPODR_ID'
      Visible = False
    end
    object quMiprava_AllMIPOLZ_ORANAIM: TStringField
      Tag = 2
      DisplayLabel = #1055#1086#1083#1100#1079'.'
      FieldName = 'MIPOLZ_ORANAIM'
      Required = True
      Visible = False
      OnChange = RefreshCalcFields
    end
    object quMiprava_AllMIPOLZ_MIPODSIS_KOD: TIntegerField
      Tag = 2
      DisplayLabel = #1050#1086#1076' '#1087#1086#1076#1089#1080#1089#1090#1077#1084#1099
      FieldName = 'MIPOLZ_MIPODSIS_KOD'
      Visible = False
    end
    object quMiprava_AllMIPRED_KOD: TFloatField
      DisplayLabel = #1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1077
      DisplayWidth = 2
      FieldKind = fkInternalCalc
      FieldName = 'MIPRED_KOD'
      OnChange = RefreshCalcFields
      OnValidate = EntValidate
      DisplayFormat = '00'
      EditFormat = '00'
    end
    object quMiprava_AllMIPRED_NAIM: TStringField
      DisplayLabel = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      FieldKind = fkInternalCalc
      FieldName = 'MIPRED_NAIM'
      Size = 10
    end
  end
  object opConvert: TOraclePackage
    Session = seOracle
    PackageName = 'PSPODR'
    Cursor = crSQLWait
    Left = 288
    Top = 64
  end
  object quRptQuery: TASUPQuery
    SQL.Strings = (
      'SELECT A.*,A.ROWID'
      'FROM DRAFT_REP A'
      'WHERE (A.USERNAME= USER OR A.USERNAME= '#39'PUBLIC'#39
      '      OR EXISTS ( SELECT 1 FROM VPOLZ'
      
        '                  WHERE MIROL_KOD= sys_context('#39'app_sec'#39', '#39'admin' +
        '_role'#39') AND ORANAIM= USER)'
      '      OR EXISTS'
      '      ( SELECT 1 FROM REP_GRANTEE'
      '        WHERE MIPOLZ_ORANAIM= A.USERNAME'
      
        '        AND MIPOLZ_MIPODSIS_KOD= sys_context('#39'app_sec'#39', '#39'subsyst' +
        'em'#39')'
      '        AND GRANTEE= USER'
      '       )'
      '      )'
      '      AND A.MIPODSIS_KOD= sys_context('#39'app_sec'#39', '#39'subsystem'#39')'
      '/* END_REFRESH */')
    Optimize = False
    SequenceField.ApplyMoment = amOnServer
    QBEDefinition.QBEFieldDefs = {
      05000000070000000400000049004400010000000000080000004E0041004D00
      45000100000000001000000055005300450052004E0041004D00450001000000
      00001000000043004F004D004D0045004E00540053000100000000000E000000
      5200450050004400410054004500010000000000180000004D00490050004F00
      44005300490053005F004B004F00440001000000000010000000570049004E00
      43004C00410053005300010000000000}
    Cursor = crSQLWait
    UpdatingTable = 'DRAFT_REP'
    Session = seOracle
    Caption = #1047#1072#1087#1088#1086#1089#1099
    Order = 'NAME ASC'
    AccessLevel = [aqQuerying, aqEditing, aqDeleting, aqPrinting]
    EditorClassName = 'TfmWorkRpt'
    UpdTabAlias = 'A'
    TreeNodeIndex = 0
    Left = 152
    Top = 288
    object quRptQueryUSERNAME: TStringField
      Tag = 2
      DefaultExpression = 'USER'
      DisplayLabel = #1042#1083#1072#1076#1077#1083#1077#1094
      DisplayWidth = 10
      FieldName = 'USERNAME'
      Visible = False
      Size = 30
    end
    object quRptQueryNAME: TStringField
      DisplayLabel = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      DisplayWidth = 50
      FieldName = 'NAME'
      Required = True
      Size = 100
    end
    object quRptQueryREPDATE: TDateTimeField
      DisplayLabel = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
      FieldName = 'REPDATE'
      Required = True
      DisplayFormat = 'dd.mm.yyyy'
      EditMask = '!99/99/00;1;_'
    end
    object quRptQueryID: TFloatField
      Tag = 2
      FieldName = 'ID'
      Required = True
      Visible = False
    end
    object quRptQueryMIPODSIS_KOD: TIntegerField
      Tag = 2
      DefaultExpression = '5'
      DisplayLabel = #1055#1086#1076#1089#1080#1089#1090#1077#1084#1072
      DisplayWidth = 2
      FieldName = 'MIPODSIS_KOD'
      Visible = False
    end
    object quRptQueryWINCLASS: TStringField
      Tag = 2
      DisplayWidth = 20
      FieldName = 'WINCLASS'
      Visible = False
      Size = 100
    end
  end
  object SetAppContextQuery: TOracleQuery
    SQL.Strings = (
      'begin'
      '  if :start_mode = 1 then'
      '    app_sec.set_subsystem(:syscode);'
      '    app_sec.set_app(:app);'
      '    app_sec.set_user(user);'
      '    app_sec.set_admin_role(:sys_admin_role);'
      '    app_sec.set_version(:ver);'
      
        '    sys.dbms_application_info.set_module(:module_name, :action_n' +
        'ame);'
      '    if :conid is null then'
      '      app_sec.register_session(:module_name, :conid);'
      '    end if;'
      '  else'
      '    app_sec.exit_session(:conid);'
      '  end if;'
      'end;')
    Session = seOracle
    Optimize = False
    Variables.Data = {
      0400000008000000080000003A00410050005000050000000800000073746172
      74657200000000001E0000003A005300590053005F00410044004D0049004E00
      5F0052004F004C00450003000000040000000D00000000000000080000003A00
      560045005200050000000000000000000000180000003A004D004F0044005500
      4C0045005F004E0041004D004500050000000000000000000000180000003A00
      41004300540049004F004E005F004E0041004D00450005000000000000000000
      0000100000003A0053005900530043004F004400450003000000040000001700
      000000000000160000003A00530054004100520054005F004D004F0044004500
      030000000400000001000000000000000C0000003A0043004F004E0049004400
      030000000000000000000000}
    Left = 152
    Top = 122
  end
  object quRepRun: TOracleQuery
    SQL.Strings = (
      'insert into rep_run(rep)'
      'values (:rep)'
      'returning id into :id')
    Session = seOracle
    Optimize = False
    Variables.Data = {
      0400000002000000080000003A00520045005000050000000000000000000000
      060000003A0049004400040000000000000000000000}
    Left = 152
    Top = 233
  end
  object quRepRunPrm: TOracleQuery
    SQL.Strings = (
      'insert into rep_run_prm'
      '  (run_id, pname, pval)'
      'values'
      '  (:run_id, :pname, :pval)')
    Session = seOracle
    Optimize = False
    Variables.Data = {
      04000000030000000E0000003A00520055004E005F0049004400040000000000
      0000000000000C0000003A0050004E0041004D00450005000000000000000000
      00000A0000003A005000560041004C00050000000000000000000000}
    Left = 152
    Top = 177
  end
  object odEnt: TOracleDataSet
    SQL.Strings = (
      'select * from vpred')
    Optimize = False
    QBEDefinition.QBEFieldDefs = {
      0500000006000000060000004B004F0044000100000000000A00000050004E00
      410049004D000100000000000A00000053004E00410049004D00010000000000
      180000004D004900550052004F00560045004E005F004B004F00440001000000
      00000400000049004400010000000000120000004D00490050004F0044005200
      5F0049004400010000000000}
    ReadOnly = True
    Session = seOracle
    Left = 88
    Top = 184
  end
  object mdMiprava: TMetaDataSource
    DataSetList = <
      item
        DataSet = quMiPrava
        DataSetName = 'quMiPrava'
      end
      item
        DataSet = quMiprava_All
        DataSetName = 'quMiprava_All'
      end>
    Left = 336
    Top = 8
  end
  object odRepTitle: TOracleDataSet
    SQL.Strings = (
      'select t.rname, t.rtitle, t.mipodsis_kod'
      'from rep_title t'
      'where nvl(t.mipodsis_kod, :syscode) = :syscode'
      'order by t.rname, t.mipodsis_kod, t.id')
    Optimize = False
    Variables.Data = {
      0400000001000000100000003A0053005900530043004F004400450003000000
      040000000200000000000000}
    QBEDefinition.QBEFieldDefs = {
      05000000030000000A00000052004E0041004D0045000100000000000C000000
      52005400490054004C004500010000000000180000004D00490050004F004400
      5300490053005F004B004F004400010000000000}
    Session = seOracle
    Left = 28
    Top = 185
    object odRepTitleRNAME: TStringField
      FieldName = 'RNAME'
      Required = True
      Size = 255
    end
    object odRepTitleRTITLE: TStringField
      FieldName = 'RTITLE'
      Size = 4000
    end
    object odRepTitleMIPODSIS_KOD: TIntegerField
      FieldName = 'MIPODSIS_KOD'
    end
  end
  object quGetDefEnt: TOracleQuery
    SQL.Strings = (
      'select  d.id, d.pnaim from mipodr d'
      'where d.id = GetDefEnt')
    Session = seOracle
    Optimize = False
    Cursor = crSQLWait
    Left = 88
    Top = 232
  end
end
