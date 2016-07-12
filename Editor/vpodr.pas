unit vpodr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  explorer, Db, DbASUP, Grids, DBGrids, ExtCtrls, StdCtrls,
  Buttons,pnlform, RXDBCtrl, RxPlacemnt;

const
  CNoDeptSel= 'Подразделение не выбрано';

type
  TfmExpPodr = class(TfmExplorer)
    bbGood: TBitBtn;
    bbCancel: TBitBtn;
    procedure DBGridKeyPress(Sender: TObject; var Key: Char);
              {Обработчик события OnKeyPress сетки DBGrid.
              Вызывает ButtonClick.}

    procedure ButtonClick(Sender: TObject);
              {Заполнение IdField идентификатором текущего
              подразделения, PathField -путем к нему}
  private
    FCantWrite: bool;
    procedure StepByStepMoving(const DeptID: Integer);
              {Раскрывает последовательно все справочники(начиная от
              подр. верхнего уровня и до DeptID, давая возможность
              движения в обратном направлении от DeptID к высшим подр.}

    { Private declarations }
  protected
    procedure UMOthers(var Message:TMessage);message UM_OTHERS;
              {Дополнительная обработка инструкции STEP_BY_STEP
              Вызов процедуры StepByStepMoving}
  public
    { Public declarations }
    IdField: TField;//Поле, содержащее идентификатор подр
    PathField: TField;//Поле, содержащее путь к  подразделению
    property CantWrite:bool read FCantWrite write FCantWrite;
  end;

var
  fmExpPodr: TfmExpPodr;

implementation
uses oracle, globals{,
prndept};
{$R *.DFM}

procedure TfmExpPodr.DBGridKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Ord(Key)=vk_Return then ButtonClick(DBGrid);
end;

procedure TfmExpPodr.ButtonClick(Sender: TObject);
begin
  if (Sender= bbGood) or (Sender=DBGrid) then
  begin
    if dsWork.DataSet.IsEmpty then
    begin
      Beep;
      MessageDlg(CNoDeptSel,mtError,[mbOk],0);
    end
    else
    begin
      IdField.Value:= dsWork.DataSet.FieldByName('ID').Value;
      if Assigned(PathField) then
        PathField.AsString:= dsWork.PathToDataSet('SNAIM');
      Close;  
    end;
  end
  else Close;
end;

procedure TfmExpPodr.StepByStepMoving(const DeptID: Integer);
var
  HigherDept: TList;
  Tech: TOracleQuery;
  I: Integer;
begin
  Screen.Cursor:= crSQLWait;
  Enabled:= false;
  dsWork.Enabled:= false;
  HigherDept:= TList.Create;
  Tech:= TOracleQuery.Create(Self);
  with Tech do
  begin
    Session:= dmGlobal.seOracle;
    SQL.Append('SELECT ID FROM P.MIPODR');
    SQL.Append('WHERE MIPODR_ID IS NOT NULL');
    SQL.Append('START WITH ID= :dept');
    SQL.Append('CONNECT BY PRIOR MIPODR_ID= ID');
    DeclareVariable('DEPT',otInteger);
    SetVariable('DEPT',DeptID);
    Execute;
    while not EOF do
    begin
      HigherDept.Insert(0,Pointer(FieldAsInteger(0)));
      Next;
    end;
    Free;
  end;
  dsWork.Start;
  I:= 0;
  while (I<HigherDept.Count) and dsWork.DataSet.Locate('ID',Integer(HigherDept[I]),[]) do
  begin
    Inc(I);
    if I<HigherDept.Count then dsWork.Next;
  end;
  HigherDept.Free;
  dsWork.Enabled:= true;
  Screen.Cursor:= crDefault;
  Enabled:= true;
end;

procedure TfmExpPodr.UMOthers(var Message:TMessage);
begin
  case Message.wParam of
    IN_STEP_BY_STEP: StepByStepMoving(Message.lParam);
    {IN_PRINT:
      with TfmPrintDept.Create(Self) do
      begin
        if dsWork.SelectedIndex<2 then
           rgStyle.ItemIndex:= dsWork.SelectedIndex
        else rgStyle.ItemIndex:= 2;
        ShowModal;
      end;}
    else inherited;
  end;
end;

end.
