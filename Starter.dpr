program Starter;

uses
  Forms,
  Controls,
  Windows,
  SysUtils,
  classes,
  dialogs,
  Dbform in '..\STAFF\KERNEL\FORMS\Dbform.pas' {fmDatabaseForm},
  editform in '..\STAFF\KERNEL\FORMS\editform.pas' {fmDBEditForm},
  cgrdform in '..\STAFF\KERNEL\FORMS\cgrdform.pas' {fmControlGridForm},
  workform in '..\STAFF\KERNEL\FORMS\workform.pas' {fmWorkForm},
  Gridform in '..\STAFF\KERNEL\FORMS\Gridform.pas' {fmDBGridForm},
  explorer in '..\STAFF\KERNEL\FORMS\explorer.pas' {fmExplorer},
  enter in '..\STAFF\KERNEL\FORMS\enter.pas' {fmEnter},
  Nsiform in '..\STAFF\KERNEL\Forms\Nsiform.pas' {fmNSI},
  spodr in 'Editor\spodr.pas' {fmMipodr},
  utils in '..\COMPS\SFI\Comps\utils.pas',
  MENUGnrl in 'Major\MENUGnrl.pas' {fmMainMenu},
  vpodr in 'Editor\vpodr.pas' {fmExpPodr},
  maspodr in '..\STAFF\KERNEL\Forms\maspodr.pas' {fmWorkDept},
  srch in '..\STAFF\KERNEL\Forms\srch.pas' {fmSearchList},
  wuser in '..\STAFF\KERNEL\Forms\wuser.pas' {fmMiPolz},
  wroles in '..\STAFF\KERNEL\Forms\wroles.pas' {fmMiRol},
  wprava in '..\STAFF\KERNEL\Forms\wprava.pas' {fmMiPrava},
  ExecRep in 'Major\ExecRep.pas',
  erights in '..\STAFF\KERNEL\Forms\erights.pas' {fmMipravaView},
  wpv_all in '..\STAFF\KERNEL\Forms\wpv_all.pas' {fmMiprava_All},
  deptrep in 'Major\deptrep.pas' {dmRepDept: TDataModule},
  expdpt in 'Major\expdpt.pas' {fmExpDept},
  about in 'Major\about.pas' {fmAboutBox},
  Duserpw in '..\STAFF\KERNEL\Forms\Duserpw.pas' {fmUserPassword},
  nsi20 in '..\STAFF\KERNEL\Forms\nsi20.pas' {fmNSI20},
  globals in 'Major\globals.pas' {dmGlobal: TDataModule},
  wstar in '..\Staff\KERNEL\Forms\wstar.pas' {fmStarLink},
  savqmod in '..\Staff\KERNEL\Forms\savqmod.pas' {dmSaveRptQuery: TDataModule},
  fastmod in '..\Staff\KERNEL\Forms\fastmod.pas' {dmFastReport: TDataModule},
  aboutb in '..\Staff\KERNEL\Forms\aboutb.pas' {fmAboutBoxBase},
  prndlg in '..\Staff\KERNEL\Forms\prndlg.pas' {fmPrintDialog},
  prndlgc in '..\Staff\KERNEL\Forms\prndlgc.pas' {fmPrnDlgCom},
  repdet in '..\Staff\KERNEL\Forms\repdet.pas' {fmRepDetails},
  rptopen in '..\Staff\KERNEL\Forms\rptopen.pas' {fmRepOpenDialog},
  exprpt0 in '..\Staff\KERNEL\Forms\exprpt0.pas' {fmExpRpt0},
  exprpt in 'Major\exprpt.pas' {fmExpRpt},
  qumod in '..\Staff\KERNEL\Forms\qumod.pas' {dmRptQuery: TDataModule},
  wrpt in '..\Staff\KERNEL\Forms\wrpt.pas' {fmWorkRpt},
  pnlform in '..\Staff\KERNEL\Forms\pnlform.pas' {fmPanelForm},
  Eyes in '..\COMPS\SFI\Comps\Eyes.pas' {fmSearch},
  EXECWORD in '..\COMPS\SFI\Units\EXECWORD.PAS',
  fclient in '..\Staff\KERNEL\Forms\fclient.pas',
  inpdiag in '..\Staff\KERNEL\Forms\inpdiag.pas' {fmInput},
  inpd1 in '..\Staff\KERNEL\Forms\inpd1.pas',
  inpd2 in '..\Staff\KERNEL\Forms\inpd2.pas',
  inpdb in '..\Staff\KERNEL\Forms\inpdb.pas' {fmInputDB},
  mainf in '..\Staff\KERNEL\Forms\mainf.pas' {fmMain},
  longrunq in '..\Staff\KERNEL\Forms\longrunq.pas' {fmLongRunQuery},
  baserep in '..\Staff\KERNEL\Forms\baserep.pas' {fmBaseRep},
  wtree in '..\Staff\KERNEL\Forms\wtree.pas' {fmTreeLink},
  mgrd in '..\Staff\KERNEL\Forms\mgrd.pas' {fmMasterGrid},
  anyrep in '..\Staff\KERNEL\Forms\anyrep.pas' {fmxAnyReport},
  userrep in '..\Staff\KERNEL\Forms\userrep.pas' {fmxUserReport},
  stdrep in '..\Staff\KERNEL\Forms\stdrep.pas' {fmxStdRep},
  fastrep in '..\Staff\KERNEL\Forms\fastrep.pas' {fmFastRep};

{$R *.RES}
const
  SemaphoreName= 'SOFTWARE_BELARUSKALI_STARTER';
  SApp_Already_Run= 'Приложение уже запущено.';
  iInvalidIndex= -1;
var
   Idx: Integer;

procedure SetProgParams;
var
  I: Integer;
begin
  for I:= 1 to ParamCount do
    ProgParams.Add(UpperCase(ParamStr(I)));
end;

procedure CheckSemaphore(const UserId: string= '');
var
  Len: Integer;
begin
  Len:= Length(UserId);
  if Len>0 then
     Application.Tag:= CreateSemaphore(
                  nil,0,1,
                  PChar(SemaphoreName+UpperCase(Copy(UserId,Pos('@',UserId),Len)))
                  )
  else Application.Tag:= CreateSemaphore(nil,0,1,SemaphoreName);
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    MessageDlg(SApp_Already_Run,mtWarning,[mbOk],0);
    Halt(1);
  end;
  Application.Initialize;
  dmGlobal:= TdmGlobal.Create(nil);
end;

begin
  // http://www.delphikingdom.com/asp/answer.asp?idanswer=69184
  // защита от переключения на default раскладку клавиатуры при потере фокуса после LoadKeyboardLayout
  // проблема наблюдается на win7
  {$IFDEF UNICODE}
   PInteger(@Screen.DefaultKbLayout)^:= -1;
  {$ENDIF}
  ProgParams:= TStringList.Create;
  if ParamCount>0 then
  begin
    SetProgParams;
    Idx:= ProgParams.IndexOfName('USERID');
  end
  else Idx:= iInvalidIndex;
  if Idx>=0 then
  begin
    CheckSemaphore(ProgParams.Values['USERID']);
    dmGlobal.seOracle.LogonUsername:= ProgParams.Values['USERID'];
    try
      dmGlobal.seOracle.Connected:= true;
      InitPath;
      Application.CreateForm(TfmMainMenu, fmMainMenu);
      Application.Run;
    except
      on E:Exception do
      begin
        MessageDlg(E.Message,mtError,[mbOk],0);
        dmGlobal.Free;
        CloseHandle(Application.Tag);
        Application.Terminate;
      end;
    end;
  end
  else
  begin
    CheckSemaphore;
    fmEnter:= TfmEnter.Create(nil);
    fmEnter.OraSession:= dmGlobal.seOracle;
    if fmEnter.ShowModal=mrOK then
    begin
      Application.CreateForm(TfmMainMenu, fmMainMenu);
      Application.Run;
    end
    else
    begin
      dmGlobal.Free;
      CloseHandle(Application.Tag);
      Application.Terminate
    end;
  end;
end.
