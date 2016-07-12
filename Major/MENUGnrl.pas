unit MENUGnrl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  pnlform, Menus, ExtCtrls ,dbASUP,WORKFORM, Buttons, DB,StdCtrls,dbform,
  ComCtrls, ToolWin,utils, TB97Ctls, ImgList, mainf, RxPlacemnt;

const
  ConfirmExitMsg= 'Вы уверены, что хотите выйти из программы';
  SUserConn = 'Подключен как %s';

type

  TfmMainMenu = class(TfmMain)
    GuideItem: TMenuItem;
    vpStrukPodr: TMenuItem;
    vpMiuroven: TMenuItem;
    hpAdmin: TMenuItem;
    vpMipolz: TMenuItem;
    vpMirol: TMenuItem;
    vpMiprava: TMenuItem;
    vpSep: TMenuItem;
    hpReport: TMenuItem;
    vpSepRep2: TMenuItem;
    vpRepSrvRun: TMenuItem;
    {Обработчик события OnCreate. "Гасит" все кнопки
    на панели инструментов, а также настраивает свойства
    объекта Application}

    procedure UserClick(Sender: TObject);
    {Обработчик события OnClick опций меню, связанных
    с пользователем: открытия таблиц,
    запуски процедур, отчетов и т.п.}

    procedure SubMenuClick(Sender: TObject);
    {Обработчик события OnDestroy.Выполняет подготовительные
    работы перед закрытием главной формы: закрывает все дочерние
    окна, все запущенные отчеты.}

    procedure FormShow(Sender: TObject);
    {Обработчик события OnShow. Настраивает опции меню,
    согласно правам, выданным пользователю}

    procedure NonParamReportRun(_Sender: TObject);
    procedure vpRepSrvRunClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private

    procedure FillDeptMenu;
    {Создание и заполение подпунктов меню
    опции Справочники\Структурные подразделения.
    Используется таблица "P.MIUROVEN"}

    procedure AddToStructure(MetaSrc: TMetaDataSource;const Index: Integer;const DataSetName: string);
    {Создает объект типа TASUPQuery, нацеленый на справочник подразделений
    и добавляет его в список компонента dmGlobal.mdStruc,
    учитывая необходимые связи}

    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  end;

procedure RemoveConflictWin;
{Удаляет дочернее окно у Application.MainForm, отображающее
справочник подразделений. Выполняется перед созданием
нового дочернего окна справочника подразделений}

{Формирование протоколов в WinWord}

var
  fmMainMenu: TfmMainMenu;//Главная форма приложения

implementation

uses Oracle, OracleData, Globals, explorer,
enter, vpodr, erights,
expDpt,ExecRep, registry,
about, exprpt, krconsts, fclient;

{$R *.DFM}

procedure TfmMainMenu.UserClick(Sender: TObject);
var
  ChildWin: TForm;
begin
   ChildWin:= GetChildWindow(Self,Sender);
  if not Assigned(ChildWin) then begin
      if Sender= vpOpenQuery then
        FormChildWindow(TfmExpRpt,Sender,dmGlobal.quRptQuery)
      else inherited
  end
  else SetMDIFocus(Self,ChildWin);
end;

procedure TfmMainMenu.SubMenuClick(Sender: TObject);
var
  ChildWin: TForm;
begin
  if Sender is TMenuItem then
    with Sender as TMenuItem do
    begin
      ChildWin:= GetChildWindow(Self,Parent);
      if not Assigned(ChildWin) then begin
        if Parent = vpStrukPodr then begin
          RemoveConflictWin;
          FormingTypeList(TfmExpDept,Parent,dmGlobal.mdStruc.DataSetList)
        end;
        PopUpItemClick(Sender);
      end
      else begin
        SetMDIFocus(Self,ChildWin);
        PopUpItemClick(Sender);
      end;
    end;
end;


procedure TfmMainMenu.AddToStructure(MetaSrc: TMetaDataSource;const Index: Integer;const DataSetName:string);
var
  quStructure: TASUPQuery;
begin
  quStructure:= TASUPQuery.Create(dmGlobal);
  with quStructure do
  begin
    Name:= Format('%s%d',[MetaSrc[0].Name,Index]);
    quStructure.Assign(MetaSrc[0]);
    quStructure.Caption:= DataSetName;
    CreateFieldTemplates(MetaSrc[0],quStructure);
    MetaSrc.AddToList(quStructure);
    quStructure.BeforePost:= dmGlobal.CheckLevelBeforePost;
    quStructure.MasterFields:= 'ID';
    quStructure.DetailFields:= 'MIPODR_ID';
    quStructure.SetVariable('DEPT_LEVEL',MetaSrc.Count);
    if MetaSrc.Count>1 then
      Master:= TOracleDataSet(MetaSrc[MetaSrc.Count-2]);
  end;
end;

procedure TfmMainMenu.FillDeptMenu;
var
  quMenu: TOracleQuery;
  I: Integer;
  
procedure CreateSubMenu(Main: TMenuItem);
var
  SubMenuItem: TMenuItem;
begin
  SubMenuItem:= TMenuItem.Create(Self);
  SubMenuItem.Caption:= quMenu.FieldAsString(1);
  SubMenuItem.OnClick:= SubMenuClick;
  Main.Add(SubMenuItem);
end;

procedure SetUppers(DataSet: TDataSet);
begin
  with DataSet as TASUPQuery do
  begin
    FieldByName('VERH_PODR').Visible:= false;
    FieldByName('VERH_NAIM').Visible:= false;
    FieldByName('VERH_PODR').Tag:= NOTVISIBLE_FIELDTAG;
    FieldByName('VERH_NAIM').Tag:= NOTVISIBLE_FIELDTAG;
    Order:= 'A.KOD ASC';
  end;
end;

begin
  quMenu:= TOracleQuery.Create(Self);
  with quMenu do
  begin
    Session:= dmGlobal.seOracle;
    SQL.Text:= 'SELECT KOD,INITCAP(PNAIM) FROM MIUROVEN WHERE KOD > 0 ORDER BY KOD';
    Execute;
    while not EOF do
    begin
      if vpStrukPodr.Visible then
      begin
        CreateSubMenu(vpStrukPodr);
        if FieldAsInteger(0)>1 then
           AddToStructure(dmGlobal.mdStruc,FieldAsInteger(0),FieldAsString(1))
        else dmGlobal.quMipodr.Caption:= FieldAsString(1);
      end;
      Next;
    end;
    Close;
    Free;
  end;
  for I:= 0 to 1 do
    if I < dmGlobal.mdStruc.Count then SetUppers(dmGlobal.mdStruc[I]);
end;

procedure TfmMainMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  dmGlobal.CloseAppSession;
end;

procedure TfmMainMenu.FormShow(Sender: TObject);
var
  I: Integer;

begin
  inherited;
  with dmGlobal do
  begin
    SetMenuItems([vpStrukPodr],[quMipodr]);
    SetMenuItems([vpMipolz,vpMirol,vpMiprava],
                 [quMiPolz,quMiRol,quMiPrava]
                 ,[{aqEditing}aqQuerying]
                 );
    hpAdmin.Visible:= vpMipolz.Visible or vpMirol.Visible;
      
    //Справочники
    if vpStrukPodr.Visible then FillDeptMenu;

    //Списки

    // установка флага запуска отчетов на сервере
    vpRepSrvRun.Checked:= RepServerRun;
    // удаление файлов из temp-директория
    DropFiles(ReportPath + 'Temp\');
  end;
end;

procedure RemoveConflictWin;
var
  WinConflict: TForm;
begin
  WinConflict:= GetWinByType(Application.MainForm,TfmExpPodr);
  if not Assigned(WinConflict) then
    WinConflict:= GetChildWindow(Application.MainForm,fmMainMenu.vpStrukPodr);
  WinConflict.Free;
end;

procedure TfmMainMenu.NonParamReportRun(_Sender: TObject);
{var
  UserID: TUserID;
  RepName: string;
  Orientation: string;
  PrcInfo: TProcessInformation;
  RepItem: TRepItem;}
begin
  {Orientation:= OR_LANDSCAPE;

  if _Sender= vpComRpt then RepName:= REP_OSNOV
  else if _Sender= DOMRItem1 then RepName:= REP_DOM1
  else if _Sender= DOMRItemK then RepName:= REP_DOMK
  else if _Sender= vpComRptOB then RepName:= REP_OSNOVOB;

  NoPrmFormRepRun(_Sender as TMenuItem, RepName, Orientation);}
end;


procedure TfmMainMenu.vpRepSrvRunClick(Sender: TObject);
begin
  vpRepSrvRun.Checked:= not vpRepSrvRun.Checked;
  RepServerRun:= vpRepSrvRun.Checked;
end;

end.
