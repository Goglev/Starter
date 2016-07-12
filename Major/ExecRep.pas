unit ExecRep;

interface
uses classes,windows;

const
// There is where reports are:
{ Better put reports files into clients $ORACLE_HOME\BIN directory
  and call them by simple names e.g.
  REP_ITR     = 'itr.rep';
  REP_RAB     = 'rab.rep';
  REP_ITR_IZM = 'itr_izm.rep';
  REP_RAB_IZM = 'rab_izm.rep';
}
// Replace these lines with correct values!!!

//------------------------------------------------

  OR_LANDSCAPE='LANDSCAPE';
  OR_PORTRAIT= 'PORTRAIT';
  PS_A4LANDSCAPE='29.7x21';
  PS_A4PORTRAIT='21x29.7';

type
  TUserID = record
     Name     : String;
     Password : String;
     DBName   : String;
  end;

const
  RepHasBeenStarted= 'Дождитесь завершения формирования отчета';
  BreakRepConfirm='Прервать формирование отчета?';
  HostDir = 'D:\APP\PJ\';

function GetReportTitle(const AReport : String) : String;
function RunReport( const AUserID : TUserID; const AReport,Orientation,PageSize,ParamStr: String;
                    var ProcessInfo: TProcessInformation) : Boolean;overload;
function RunReport( const AUserID : TUserID; const AReport,Orientation,ParamStr: String;
                    var ProcessInfo: TProcessInformation) : Boolean; overload;
function ErMsgRep(const ErCode: Integer): string;

var
  ReportPath: string;//Path to report file
  RgetExePath: string;// Path to rget.exe

implementation

uses Messages, SysUtils, Utils, globals, OracleData;

function GetReportTitle(const AReport : String) : String;
begin
  Result := '';
  with dmGlobal do begin
  
    if not odRepTitle.Active then odRepTitle.Open;
    if odRepTitle.SearchRecord(
       'rname', AReport, [srFromBeginning, srIgnoreCase]) then
       Result:= odRepTitleRTITLE.AsString;

  end;
end;

function RunReport( const AUserID : TUserID; const AReport,Orientation,
                    ParamStr: String;
                    var ProcessInfo: TProcessInformation) : Boolean;
var
  PageSize: string;
begin
  if Orientation=OR_LANDSCAPE then PageSize:=PS_A4LANDSCAPE
  else PageSize:= PS_A4PORTRAIT;
  Result:= RunReport( AUserID,AReport,Orientation,PageSize,
                      ParamStr,ProcessInfo);
end;

function RunReport( const AUserID : TUserID; const AReport,Orientation,
                    PageSize, ParamStr: String;
                    var ProcessInfo: TProcessInformation) : Boolean;
{---------------------Return Value----------------------------------------------

If the function succeeds, the return value is greater than 31.
If the function fails, the return value is one of the following error values:

Value	                Meaning
--------------------------------------------------------------------------------
-1                      One instance of report is already running
 0	                The system is out of memory or resources.
ERROR_BAD_FORMAT	The .EXE file is invalid (non-Win32 .EXE or error in .EXE image).
ERROR_FILE_NOT_FOUND	The specified file was not found.
ERROR_PATH_NOT_FOUND	The specified path was not found.
--------------------------------------------------------------------------------}
var CmdLine : String;
    //S : String;
    StartUpInfo: TStartUpInfo;
    vPageSize: string;
begin
 //S := GetReportTitle(AReport);
 if RepServerRun then

   CmdLine := RgetExePath+'rget.exe'+ ' '+
            'nls_date_format="DD.MM.YYYY" '+
            'REP_SERVER=report.kali:9002 '+
            'TEMP_DIR=' + ReportPath + 'Temp\ '+
            'MODULE=' + HostDir+ AReport + ' ' +
            'USERID=' + AUserID.Name + '/'
                      + AuserID.Password + '@'
                      + AUserID.DBName + ' ' +
            RoleArgument +
            'COPIES=1 ' +
            Format('ORIENTATION=%s ',[Orientation]) +
            'BLANKPAGES=YES ' + ParamStr
 else
 begin
   if Length(PageSize)=0 then
     if Orientation=OR_LANDSCAPE then vPageSize:=PS_A4LANDSCAPE
     else vPageSize:= PS_A4PORTRAIT
   else vPageSize:= PageSize;
   CmdLine := 'rwrun60.exe ' +
              'MODULE=' + ReportPath+ AReport + ' ' +
              'USERID=' + AUserID.Name + '/'
                        + AuserID.Password + '@'
                        + AUserID.DBName + ' ' +
              'PARAMFORM=NO ' +
              RoleArgument +
             // 'DESTYPE=PREVIEW ' +
             // 'DESNAME=printer ' +
              'COPIES=1 ' +
              'READONLY=YES ' +
              Format('ORIENTATION=%s ',[Orientation]) +
              Format('PAGESIZE=%s ',[vPageSize]) +
              'PRINTJOB=YES ' +
              'BLANKPAGES=YES ' +
              'MAXIMIZE=YES ' +
              'DISABLEPRINT=NO ' +
              'DISABLEMAIL=YES ' +
              'DISABLEFILE=YES ' +
              'DISABLENEW=YES ' +ParamStr;
 end;
  with StartUpInfo do
  begin
    cb:= SizeOf(TStartUpInfo);
    lpReserved:= nil;
    lpDeskTop:= nil;
    lpTitle:= nil;
    if RepServerRun then begin
      dwFlags:= STARTF_USESHOWWINDOW;
      wShowWindow:= SW_HIDE;
    end
    else dwFlags:= 0;
    cbReserved2:= 0;
    lpReserved2:= nil;
  end;
  
  Result:= CreateProcess( nil,PChar(CmdLine),nil,nil,false,0,nil,nil,
                        StartUpInfo,ProcessInfo);
  if Result then CloseHandle(ProcessInfo.hThread);
end;

function ErMsgRep(const ErCode: Integer): string;
begin
  Result:= '';
  case ErCode of
    -1: Result:= 'Отчет уже запущен.';
    ERROR_FILE_NOT_FOUND: Result:= 'Не найдена программа просмотра отчетов.';
    ERROR_PATH_NOT_FOUND: Result:= 'Неверно указан путь к программе просмотра отчетов.';
    else if ErCode<=31 then Result:= 'Ошибка при формировании отчета.';
  end;
end;

initialization
  RoleArgument:= '';
end.

