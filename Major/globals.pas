
unit globals;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, DB, StdCtrls,DBCtrls,DBASUP,WorkForm, Menus, Oracle, OracleData,
  RxPlacemnt;

const
  DefaultUserName= 'p';
  DefaultDataBase= 'oracle';
  SubSystemCode= 23;//Код в справочнике подсистем MIPODSIS
  AdminRoleCode= 13; //Роль администратора задачи
  SubSection='Software\BelarusKali\Starter\';
  StorageSection= SubSection+'Storage\';
  All_Dept_RootId = 0;
  BK_ID = 1; // ид. предприятия Беларуськалий
  //All_Departments_ID= 0;
  No_Departments_ID= -1;
  NullAsInteger= -1;
  InvalidEntMsg = 'Неверный код предприятия';
  InvalidDeptMsg= 'Неверный код подразделения';
  OP_NONEXECUTABLE= $0000;
  OP_EXECUTABLE= $0001;
  RR_DateFormatBoundary= 19;
  CUnRegisteredUser= 'Пользователь не зарегистрирован в данном приложении.';
  SBadInterval = 'Неверно задан диапазон';
  LongDateFmt = 'dd.mm.yyyy';
  EmptyTimeText='    ';
type
  TdmGlobal = class(TDataModule)
    seOracle: TOracleSession;
    mdStruc: TMetaDataSource;
    fsFields: TFormStorage;
    quMipodr: TASUPQuery;
    quMipodrKOD: TIntegerField;
    quMipodrSNAIM: TStringField;
    quMipodrPNAIM: TStringField;
    quMiuroven: TASUPQuery;
    quMiurovenKOD: TIntegerField;
    quMiurovenPNAIM: TStringField;
    quMiurovenSNAIM: TStringField;
    quMipodrID: TFloatField;
    quMipodrMIPODR_ID: TFloatField;
    quMipodrVERH_PODR: TStringField;
    quMipodrMIPODR_KOD: TIntegerField;
    quMipodrVERH_NAIM: TStringField;
    quMipodrMIUROVEN_KOD: TIntegerField;
    quMiPolz: TASUPQuery;
    quMiPolzORANAIM: TStringField;
    quMiPolzMIROL_KOD: TIntegerField;
    quMiPolzPNAIM: TStringField;
    quMiPolzMIROL_NAIM: TStringField;
    quMiPolzMIROL_ORANAIM: TStringField;
    quMiRol: TASUPQuery;
    quMiRolKOD: TIntegerField;
    quMiRolPNAIM: TStringField;
    quMiRolORANAIM: TStringField;
    quMiPrava: TASUPQuery;
    quMiPravaMIPOLZ_ORANAIM: TStringField;
    quMiPravaMIPODR_ID: TFloatField;
    quMiPravaMIPODR_SNAIM: TStringField;
    quMiPravaMIPODR_PNAIM: TStringField;
    quMiPravaMIPODR_KOD: TStringField;
    quMiPravaMIPOLZ_NAIM: TStringField;
    quUsers: TOracleDataSet;
    quUsersORANAIM: TStringField;
    quUsersPNAIM: TStringField;
    quMiPravaMIUPDR_KOD: TIntegerField;
    quMiPravaMIUPDR_NAIM: TStringField;
    quMiprava_All: TASUPQuery;
    quMiprava_AllMIPOLZ_NAIM: TStringField;
    quMiprava_AllMIPODR_ID: TFloatField;
    quMiprava_AllMIPOLZ_ORANAIM: TStringField;
    quMiPolzMIPODSIS_KOD: TIntegerField;
    quMiPravaMIPOLZ_MIPODSIS_KOD: TIntegerField;
    quMiprava_AllMIPOLZ_MIPODSIS_KOD: TIntegerField;
    opConvert: TOraclePackage;
    quRptQuery: TASUPQuery;
    quRptQueryUSERNAME: TStringField;
    quRptQueryNAME: TStringField;
    quRptQueryREPDATE: TDateTimeField;
    quRptQueryID: TFloatField;
    quRptQueryMIPODSIS_KOD: TIntegerField;
    quRptQueryWINCLASS: TStringField;
    SetAppContextQuery: TOracleQuery;
    quRepRun: TOracleQuery;
    quRepRunPrm: TOracleQuery;
    quMiprava_AllMIPRED_KOD: TFloatField;
    quMiprava_AllMIPRED_NAIM: TStringField;
    odEnt: TOracleDataSet;
    mdMiprava: TMetaDataSource;
    odRepTitle: TOracleDataSet;
    odRepTitleRNAME: TStringField;
    odRepTitleRTITLE: TStringField;
    odRepTitleMIPODSIS_KOD: TIntegerField;
    quMiRolSHIFR: TStringField;
    quGetDefEnt: TOracleQuery;
    function IsNumeric(AString: string):boolean;
    procedure DetailsBeforeOpen(DataSet: TDataSet);
    procedure RR_DateFormat(Sender: TField);
    procedure RefreshCalcFields(Sender: TField);
    procedure seOracleAfterLogOn(Sender: TOracleSession);
    procedure CheckLevelBeforePost(DataSet: TDataSet);
    procedure quMipodrMIPODR_IDChange(Sender: TField);
    procedure MasPodrChange(Sender: TField);
    procedure quUsersAfterOpen(DataSet: TDataSet);
    procedure quUsersAfterClose(DataSet: TDataSet);
    procedure quMiprava_AllBeforePost(DataSet: TDataSet);
    procedure EntValidate(Sender: TField);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    procedure SetAllPrivileges(OwnerList,ObjectList: TStrings);
    procedure SetAppContext(ASession: TOracleSession);
  public
    { Public declarations }
    procedure CloseAppSession(ASession: TOracleSession=nil);
  end;

function PutOnClothes(AString: string):string;
function NVL(Field:TField;const Value: Integer):Integer;
function IsEmptyRecord( ADataSet: TDataSet;
                        const UnImportants:Array of TField):bool;
var
  dmGlobal: TdmGlobal;
  All_Departments_ID: Integer;

implementation

uses MENUGnrl, pnlform, spodr, Nsiform,
wuser,wroles, wprava, wpv_all, ExecRep, Utils
,edcnd, nsi20,
wrpt, {stdfrep, stdr20,} eyes, rxverinf, Variants;
{$R *.DFM}


function PutOnClothes(AString: string):string;
begin
  Result:= ''''+AString+''''
end;

function TdmGlobal.IsNumeric;
var
  I: Integer;
begin
  Result:= true;
  I:= 1;
  while Result and (I<=Length(AString)) do
  begin
    Result:= AString[I] in ['0'..'9'];
    Inc(I);
  end;
end;

procedure TdmGlobal.DetailsBeforeOpen(DataSet: TDataSet);
begin
  with DataSet as TASUPQuery do
    QueryAllRecords:= Assigned(Master) and Master.Active;
end;

const
  PriorCentury= 19;
  NextCentury= 20;

procedure TdmGlobal.RR_DateFormat(Sender: TField);
var
  Year,Month,Day: Word;
  FirstDigits: Integer;
  NewVal: TDateTime;
begin
  if Sender is TDateTimeField then
    with Sender as TDateTimeField do
      if not IsNull then
      begin
        if Tag and RECHANGED_FIELDTAG=0 then
        begin
          Tag:= Tag or RECHANGED_FIELDTAG;
          try
            DecodeDate(Value, Year, Month, Day);
            case Year mod 100 of
              0..RR_DateFormatBoundary: FirstDigits:= NextCentury
              else FirstDigits:= PriorCentury
            end;
            Year:= FirstDigits*100 + Year mod 100;
            NewVal:= Value;
            ReplaceDate(NewVal,EncodeDate(Year, Month, Day));
            Value:= NewVal;
          finally
            Tag:= Tag xor RECHANGED_FIELDTAG;
          end
        end
      end;
end;

procedure TdmGlobal.RefreshCalcFields(Sender: TField);
var
  Query: TOracleQuery;
  PosSeparat: Integer;
begin
  Query:= TOracleQuery.Create(Sender);
  try
    if Sender.DataSet is TOracleDataSet then
    begin
      Query.Session:= (Sender.DataSet as TOracleDataSet).Session;
      if Sender= quMiPolzMIROL_KOD then
      begin
        AskSingleManual( Query,'MIROL','KOD','PNAIM',
                         quMiPolzMIROL_KOD,quMiPolzMIROL_NAIM);
        AskSingleManual( Query,'MIROL','KOD','ORANAIM',
                         quMiPolzMIROL_KOD,quMiPolzMIROL_ORANAIM);
      end
      else if Sender= quMiPravaMIPOLZ_ORANAIM then
        AskSingleManual( Query,'VPOLZ','ORANAIM','PNAIM',
                         quMiPravaMIPOLZ_ORANAIM,quMiPravaMIPOLZ_NAIM)
      else if Sender= quMiPrava_AllMIPOLZ_ORANAIM then
        AskSingleManual( Query,'VPOLZ','ORANAIM','PNAIM',
                         quMiPrava_AllMIPOLZ_ORANAIM,quMiPrava_AllMIPOLZ_NAIM)
      else if (Sender.FieldName= 'FNAIM') or (Sender.FieldName= 'INAIM')
              or (Sender.FieldName= 'ONAIM') then
           with Query do
           begin
             SQL.Clear;
             SQL.Append('SELECT INITCAP(:P1) FROM DUAL');
             DeclareVariable('P1',otString);
             SetVariable( 'P1',Sender.DataSet.FieldByName('FNAIM').AsString+' '+
                          Sender.DataSet.FieldByName('INAIM').AsString+' '+
                          Sender.DataSet.FieldByName('ONAIM').AsString);
             Execute;
             Sender.DataSet.FieldByName('FIO').AsString:= FieldAsString(0);
           end
     else if Sender.FieldName = 'COUNTRY_NO' then
        AskSingleManual( Query,'S.COUNTRY','COUNTRY_NO','NAME',
                         Sender,Sender.DataSet.FieldByName('COUNTRY_NAME'))
     else if Sender.FieldName = 'REGION_NO' then
        AskSingleManual( Query,'S.REGION','REGION_NO','NAME',
                         Sender,Sender.DataSet.FieldByName('REGION_NAME'))
     else if Sender.FieldName = 'DISTRICT_NO' then
     with Query do
     begin
       DeleteVariables;
       SQL.Clear;
       SQL.Append('SELECT NAME FROM S.DISTRICT');
       SQL.Append('WHERE COUNTRY_NO=:1 AND REGION_NO=:2 AND DISTRICT=:3');
       DeclareVariable('1',otInteger);
       SetVariable('1',Sender.DataSet.FieldByName('COUNTRY_NO').AsInteger);
       DeclareVariable('2',otInteger);
       SetVariable('2',Sender.DataSet.FieldByName('REGION_NO').AsInteger);
       DeclareVariable('3',otInteger);
       SetVariable('3',Sender.AsInteger);
       Execute;
       if not EOF then
         Sender.DataSet.FieldByName('DISTRICT_NAME').AsString:=
           FieldAsString(0)
       else Sender.DataSet.FieldByName('DISTRICT_NAME').Clear;
     end
    else if Sender.FieldName= 'MIGOROD_KOD' then
     with Query do
     begin
       SQL.Clear;
       SQL.Append('SELECT SNAIM, MINASPUNKT_KOD from MIGOROD');
       SQL.Append('WHERE KOD=:1');
       DeclareVariable('1',otInteger);
       SetVariable('1', Sender.Value);
       Execute;
       if not EOF then
       begin
         Sender.DataSet.FieldByName('MIGOROD_NAIM').AsString:=
           FieldAsString(0);
         Sender.DataSet.FieldByName('MINASPUNKT_KOD').AsInteger:=
           FieldAsInteger(1);
       end
       else
       begin
         Sender.DataSet.FieldByName('MIGOROD_NAIM').Clear;
         Sender.DataSet.FieldByName('MINASPUNKT_KOD').Clear;
       end;
     end
     else if Sender.FieldName='MIPRED_KOD' then

           AskSingleManual( Query,'VPRED',['KOD', 'ID','SNAIM'],
                            [Sender,
                             Sender.DataSet.FieldByName('MIPODR_ID'),
                             Sender.DataSet.FieldByName('MIPRED_NAIM')
                            ]
                           )
      else //Этот блок должен идти в самом конце (обработка по умолчанию)
      begin
        PosSeparat:= Pos('_',Sender.FieldName);
        AskHim( Query,Concat('P.',Copy(Sender.FieldName,1,PosSeparat-1)),Sender
                ,Sender.DataSet.FieldByName
                (Copy(Sender.FieldName,1,PosSeparat)+'NAIM')
                )
      end
    end;
  finally
    Query.Free;
  end;
end;

procedure TdmGlobal.SetAllPrivileges(OwnerList,ObjectList: TStrings);
var
  privQuery: TOracleQuery;
  NumPriv: Integer;
  I: Integer;
  PriorObj,NextObj: string;
  CompList: TList;
  TempAcLevel: TAccessLevel;

function GenerateObjectSet: string;
var
  I: Integer;
begin
  Result:= '';
  for I:= 0 to OwnerList.Count-1 do
  begin
    Result:= Concat(Result,Format('(%s,%s)',[OwnerList[I],ObjectList[I]]));
    if I<OwnerList.Count-1 then
       Result:= Concat(Result,',');
  end;
end;

procedure GetListOfOracleComp(ResList: TList;const OwnerName,ObjectName: string);
var
  iObj: Integer;
begin
  ResList.Clear;
  iObj:= OwnerList.Count-1;
  while iObj>=0 do
  begin
    if (ObjectList[iObj]=InBrack(ObjectName))
              and (OwnerList[iObj]=InBrack(OwnerName)) then
    begin
      ResList.Add(ObjectList.Objects[iObj]);
      ObjectList.Delete(iObj);
      OwnerList.Delete(iObj);
    end;
    Dec(iObj);
  end;
end;

function PrivFormat(const Privilege: string):Integer;
const
  CUnUsePrivilege= -1;

begin
  if Privilege='SELECT' then Result:= Ord(aqQuerying)
  else if Privilege='UPDATE' then Result:= Ord(aqEditing)
    else if Privilege='DELETE' then Result:= Ord(aqDeleting)
      else if Privilege='INSERT' then Result:= Ord(aqInserting)
        else Result:= CUnUsePrivilege;
end;

begin
  if OwnerList.Count>0 then
  begin
    privQuery:= TOracleQuery.Create(Self);
    with privQuery do
    try
      Session:= seOracle;
      SQL.Append('SELECT DISTINCT A.PRIVILEGE,A.TABLE_SCHEMA,A.TABLE_NAME FROM ALL_TAB_PRIVS A, MIROL R, VPOLZ U');
      SQL.Append('WHERE A.GRANTEE IN (SELECT T.GRANTED_ROLE FROM ROLE_ROLE_PRIVS T '+
                 'START WITH T.ROLE=R.ORANAIM CONNECT BY PRIOR GRANTED_ROLE=ROLE UNION SELECT R.ORANAIM FROM DUAL) '+
                 'AND U.ORANAIM=USER AND U.MIROL_KOD=R.KOD');
      SQL.Append(Format('AND (A.TABLE_SCHEMA,A.TABLE_NAME) IN (%s)',
               [GenerateObjectSet]));
      SQL.Append('ORDER BY A.TABLE_SCHEMA,A.TABLE_NAME');
      Execute;
      PriorObj:= '';
      TempAcLevel:= [];
      CompList:= TList.Create;
      while not EOF do
      begin
        NextObj:= Concat(FieldAsString(1),FieldAsString(2));
        if PriorObj<>NextObj then
        begin
          PriorObj:= NextObj;
          for I:= 0 to CompList.Count-1 do
            if TObject(CompList[I]) is TASUPQuery then
               TASUPQuery(CompList[I]).AccessLevel:= TempAcLevel*TASUPQuery(CompList[I]).AccessLevel;
          GetListOfOracleComp(CompList,FieldAsString(1),FieldAsString(2));
          TempAcLevel:= [];
        end;
        for I:= 0 to CompList.Count-1 do
          if TObject(CompList[I]) is TASUPQuery then
          with TASUPQuery(CompList[I]) do
          begin
            NumPriv:= PrivFormat(FieldAsString(0));
            if NumPriv in [Ord(Low(TAccessItems))..Ord(High(TAccessItems))] then
            begin
              TempAcLevel:= TempAcLevel+[TAccessItems(NumPriv)];
              if TAccessItems(NumPriv)= aqQuerying then
                TempAcLevel:= TempAcLevel+[aqPrinting]
            end;
          end
          else if TObject(CompList[I]) is TOraclePackage then
          with TOraclePackage(CompList[I]) do
            if FieldAsString(0)='EXECUTE' then
              Tag:= OP_EXECUTABLE;
        Next;
      end;
      if Length(PriorObj)>0 then
        for I:= 0 to CompList.Count-1 do
            if TObject(CompList[I]) is TASUPQuery then
               TASUPQuery(CompList[I]).AccessLevel:=
                 TempAcLevel*TASUPQuery(CompList[I]).AccessLevel;
      CompList.Free;
    finally
      Free;
    end;
    for I:= 0 to ObjectList.Count-1 do
      if ObjectList.Objects[I] is TASUPQuery then
         TASUPQuery(ObjectList.Objects[I]).AccessLevel:= [];
  end;
end;

const
  Code_Line='QWER2TY3UIOP146ASDFG5_70HJKL8ZXCV9BNM';
  Standard_Line= '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_';

procedure TdmGlobal.seOracleAfterLogOn(Sender: TOracleSession);
var
  I,PosPoint:Integer;
  OracleObjList,OwnerList: TStrings;
  OwnerName: string;
begin
  if seOracle.Connected then
  begin
    if not NonDefaultRolesActivate(seOracle,SubSystemCode) then
    begin
      MessageDlg(CUnRegisteredUser,mtError,[mbOk],0);
      seOracle.Connected:= false;
      Application.Terminate;
      Exit;
    end;
    SetAppContext(seOracle);
    with quGetDefEnt do begin
      Execute;
      if not EOF then
        All_Departments_ID:= FieldAsInteger(0);
      Close;
    end;
    OracleObjList:= TStringList.Create;
    OwnerList:= TStringList.Create;
    for I:= 0 to ComponentCount-1 do
    begin
      if Components[I] is TASUPQuery then
      begin
      with Components[I] as TASUPQuery do
        if InBrack(seOracle.LogonUserName)<>ExtractOwner then
        begin
          OwnerList.Append(ExtractOwner);
          OracleObjList.AddObject(ExtractTable,Self.Components[I]);
        end
      end  
      else if Components[I] is TOraclePackage then
      with Components[I] as TOraclePackage do
      begin
        PosPoint:= Pos('.',PackageName);
        OwnerName:= Copy(PackageName,1,PosPoint-1);
        if OwnerName= seOracle.LogonUserName then
          Tag:= OP_EXECUTABLE
        else
        begin
          OwnerList.Append(InBrack(OwnerName));
          OracleObjList.AddObject( InBrack(Copy(PackageName,PosPoint+1,Length(PackageName)-PosPoint)),
                                   Self.Components[I]);
        end;
      end;
    end;
    SetAllPrivileges(OwnerList,OracleObjList);
    OracleObjList.Free;
    OwnerList.Free;
  end;
end;

const
  ENullRefMsg='Нет данных о подразделении верхнего уровня';

procedure TdmGlobal.CheckLevelBeforePost(DataSet: TDataSet);
begin
  if DataSet.FieldByName('MIPODR_ID').IsNull then
    raise Exception.Create(ENullRefMsg);
end;

procedure TdmGlobal.quMipodrMIPODR_IDChange(Sender: TField);
var
  Query: TOracleQuery;
begin
  if not Sender.IsNull  then
  begin
    Query:= TOracleQuery.Create(Sender);
    Query.Session:= (Sender.DataSet as TOracleDataSet).Session;
    Query.SQL.Add('SELECT TO_CHAR(KOD,'+''''+'09'+''''+')||'+''''+' '+''''+'||SNAIM,KOD,PNAIM');
    Query.SQL.Add('FROM MIPODR WHERE ID=:P1');
    Query.DeclareVariable('P1',otInteger);
    Query.SetVariable('P1',Sender.AsInteger);
    Query.Execute;
    Sender.DataSet.FieldByName('VERH_PODR').AsString:= Query.FieldAsString(0);
    Sender.DataSet.FieldByName('MIPODR_KOD').AsString:= Query.FieldAsString(1);
    Sender.DataSet.FieldByName('VERH_NAIM').AsString:= Query.FieldAsString(2);
    Query.Close;
    Query.Free;
  end
  else
  begin
    Sender.DataSet.FieldByName('VERH_PODR').Clear;
    Sender.DataSet.FieldByName('MIPODR_KOD').Clear;
    Sender.DataSet.FieldByName('VERH_NAIM').Clear;
  end;
end;

function NVL(Field:TField;const Value: Integer):Integer;
begin
  if not Field.IsNull then
    Result:= Field.AsInteger
  else Result:= Value;
end;

procedure RefreshDeptPath(AQuery: TOracleQuery;IDField,PathField: TField);
begin
  AQuery.SQL.Clear;
  AQuery.SQL.Append(
    'SELECT NODE_PATH(ID,MIUROVEN_KOD,2) FROM VPODR');
  AQuery.SQL.Append('WHERE ID = :P1');
  AQuery.DeclareVariable('P1',otInteger);
  AQuery.SetVariable( 'P1',IDField.AsInteger);
  AQuery.Execute;
  if not AQuery.EOF then PathField.AsString:= AQuery.FieldAsString(0)
  else PathField.AsString:= '';
end;

var
  Changing: boolean;

procedure TdmGlobal.MasPodrChange(Sender: TField);
var
  Query: TOracleQuery;
  tmpField: TField;
  tmpVal: Integer;
begin
  Query:= TOracleQuery.Create(Sender);
  try
    Query.Session:= (Sender.DataSet as TOracleDataSet).Session;
    if CompareText(Sender.FieldName,'MIUPDR_KOD')=0 then
    begin
      if not Changing then
      begin
        Changing:= true;
        AskSingleManual( Query,'VUPDR','KOD','ID',
                       Sender,Sender.DataSet.FieldByName('MIPODR_ID'));
        Sender.DataSet.FieldByName('MIPODR_KOD').Clear;
        Changing:= false;
      end;
      AskHim( Query,'VUPDR',Sender,
              Sender.DataSet.FieldByName('MIUPDR_NAIM'));
    end;
    if CompareText(Sender.FieldName,'MIPODR_KOD')=0 then
    begin
      tmpField:= Sender.DataSet.FieldByName('MIPODR_ID');
      if not Changing then
      begin
        Changing:= true;
        if Sender.IsNull then
        begin
          if not Sender.DataSet.FieldByName('MIUPDR_KOD').IsNull then
              AskSingleManual( Query,'VUPDR','KOD','ID',
                               Sender.DataSet.FieldByName('MIUPDR_KOD')
                               ,tmpField)
          else tmpField.Clear;
          Sender.DataSet.FieldByName('MIPODR_PNAIM').Clear;
          Sender.DataSet.FieldByName('MIPODR_SNAIM').Clear;
        end
        else
        begin
          tmpVal:= opConvert.CallIntegerFunction( 'STRINGTOID',
                   [Sender.AsString,SubSystemCode]);
          if tmpVal>0 then
          begin
            tmpField.AsInteger:= tmpVal;
            Sender.DataSet.FieldByName('MIUPDR_KOD').Clear;
            AskSingleManual( Query,'VPODR','ID','SNAIM',
                           tmpField,Sender.DataSet.FieldByName('MIPODR_SNAIM'));
            AskSingleManual( Query,'VPODR','ID','PNAIM',
                           tmpField,Sender.DataSet.FieldByName('MIPODR_PNAIM'));
          end
          else
          begin
            Sender.DataSet.FieldByName('MIPODR_PNAIM').Clear;
            Sender.DataSet.FieldByName('MIPODR_SNAIM').Clear;
            if Length(Sender.AsString)=0 then
            begin
              if Sender.DataSet.FieldByName('MIUPDR_KOD').IsNull then
                tmpField.Clear;
            end
            else
            begin
              Sender.FocusControl;
              try
                tmpField.Value:= No_Departments_ID;
              finally
                Changing:= false;
              end;
              raise Exception.Create(InvalidDeptMsg);
            end;
          end;
        end;
        Changing:= false;
      end
      else
      begin
        Sender.DataSet.FieldByName('MIPODR_PNAIM').Clear;
        Sender.DataSet.FieldByName('MIPODR_SNAIM').Clear;
      end;
    end;
    if not Changing and (CompareText(Sender.FieldName,'MIPODR_ID')=0) and
       not Sender.IsNull  then
    begin
      Query.SQL.Text:=
        'SELECT SUBSTR(PKOD,5) FROM MIPODR WHERE ID=:P1';
      Query.DeclareVariable('P1',otInteger);
      Query.SetVariable( 'P1',Sender.AsInteger);
      Query.Execute;
      if Query.EOF or (Length(Query.FieldAsString(0))=0) then
      begin
        Changing:= true;
        Sender.DataSet.FieldByName('MIPODR_KOD').Clear;
        AskSingleManual( Query,'VUPDR','ID','KOD',
                         Sender,Sender.DataSet.FieldByName('MIUPDR_KOD'));
        Changing:= false;
      end
      else
        Sender.DataSet.FieldByName('MIPODR_KOD').Value:= Query.FieldAsString(0);
      Query.Close;
    end;
  finally
    Query.Free;
  end;
end;


procedure TdmGlobal.quUsersAfterOpen(DataSet: TDataSet);
begin
  quUsers.Tag:= quUsers.Tag+1;
end;

procedure TdmGlobal.quUsersAfterClose(DataSet: TDataSet);
begin
  if quUsers.Tag>0 then
     quUsers.Tag:= quUsers.Tag-1;
end;

procedure TdmGlobal.quMiprava_AllBeforePost(DataSet: TDataSet);
begin
   if quMiprava_AllMIPODR_ID.IsNull  then
    quMiprava_AllMIPODR_ID.AsInteger:= All_Dept_RootId;
end;

function IsEmptyRecord( ADataSet: TDataSet;
                        const UnImportants:Array of TField):bool;
var
  I: Integer;

function InArray(Field:TField):bool;
var
  J: Integer;
begin
  J:= Low(UnImportants);
  Result:= false;
  while (J<= High(UnImportants)) and not Result do
  begin
    Result:= Field= UnImportants[J];
    Inc(J);
  end;
end;

begin
  I:= 0;
  while (I<ADataSet.FieldCount)
        and ( (ADataSet.Fields[I].FieldKind<> fkData) or
              ADataSet.Fields[I].IsNull or InArray(ADataSet.Fields[I])
              ) do Inc(I);
  Result:= I = ADataSet.FieldCount;
end;

procedure TdmGlobal.SetAppContext(ASession: TOracleSession);
begin
  with SetAppContextQuery do
  begin
    Session:= ASession;
    SetVariable('sys_admin_role', AdminRoleCode);
    SetVariable('module_name',ExtractFileName(Application.ExeName));
    with TVersionInfo.Create(Application.ExeName) do
    begin
      SetVariable('ver',FileVersion);
      Free;
    end;
    Execute;
    Session.Commit;
  end;
end;

procedure TdmGlobal.EntValidate(Sender: TField);
begin
  if not Sender.IsNull then
  begin
    if not odEnt.Active then odEnt.Open;
    if not odEnt.SearchRecord(
       'kod', Sender.AsInteger,
       [srFromBeginning]) then
      raise Exception.Create(InvalidEntMsg);
  end;
end;

procedure TdmGlobal.DataModuleCreate(Sender: TObject);
var
  sSys: String;
begin
  sSys:= IntToStr(SubSystemCode);
  quMiPravaMIPOLZ_MIPODSIS_KOD.DefaultExpression:= sSys;
  quMiPrava_AllMIPOLZ_MIPODSIS_KOD.DefaultExpression:= sSys;
  quMiPolzMIPODSIS_KOD.DefaultExpression:= sSys;
end;

procedure TdmGlobal.CloseAppSession(ASession: TOracleSession=nil);
begin
  with SetAppContextQuery do begin
    if Assigned(ASession) then
      Session:= ASession
    else Session:= seOracle;
    SetVariable('start_mode', 0);
    Execute;
    Session.Commit;
  end;
end;

initialization
  Changing:= false;
  DateFormatBoundary:= RR_DateFormatBoundary;
  IniStorageSection:= StorageSection;
  All_Departments_ID:= BK_id;

end.
