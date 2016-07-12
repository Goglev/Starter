unit spodr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Nsiform, Menus, Db, StdCtrls, Buttons, DbASUP, Mask, DBCtrls, ExtCtrls,
  pnlform, Oracle;

type
  TfmMipodr = class(TfmNSI)
            // Рабочая форма таблицы MIPODR
    tePodr: TDBText;
    Label4: TLabel;
    sbChoose: TSpeedButton;
    quAncestor: TOracleQuery;
    procedure FormShow(Sender: TObject);
    procedure sbChooseClick(Sender: TObject);
    procedure tePodrMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ForSQLPreparing(Sender: TASUPQuery; Field: TField;
       var SQLFrame: TSQLFrame; var Action: Boolean);
  private
    { Private declarations }
    FMetaSource: TMetaDataSource;
  protected
    procedure UMChangeMode(var Message:TMessage);message UM_CHANGEMODE;
    procedure UMInitialize(var Message:TMessage);message UM_INITIALIZE;
    function GetFreeCode(const AFieldName: string):string;override;
  public
    { Public declarations }
  end;

var
  fmMipodr: TfmMipodr;

implementation

{$R *.DFM}

uses Globals,srch,workform;

procedure TfmMipodr.UMChangeMode(var Message:TMessage);
begin
  if (Message.wParam in [IN_INSERT,IN_EDIT]) and
     not Assigned(ActiveControl) then ActiveControl:= deShort;
  TfmWorkForm(Self).UMChangeMode(Message);
  if Message.wParam=IN_INSERT then
  begin
    if (dsCurrent.DataSet as TASUPQuery).GetVariable('DEPT_LEVEL')= 1 then
     dsCurrent.DataSet.FieldByName('MIPODR_ID').AsInteger:= All_Departments_ID;
     deCode.Field.AsString:= GetFreeCode(deCode.DataField);
    if deCode.Field.IsNull then ActiveControl:= deCode;
  end;
  sbChoose.Enabled:= Message.wParam in [IN_INSERT,IN_QUERY,IN_EDIT];
end;

procedure TfmMipodr.UMInitialize(var Message:TMessage);
begin
  inherited;
  if Message.wParam= IN_SETDATASET then
  begin
    SearchingTable:= 'P.VPODR';
    FMetaSource:= dmGlobal.mdStruc;
  end;
end;

procedure TfmMipodr.FormShow(Sender: TObject);
begin
  inherited;
  paTop.Visible:= (WorkStyle=wsEdit) or (not Assigned((dsCurrent.DataSet as TASUPQuery).Master)
                  and (FMetaSource[0]<>dsCurrent.DataSet) );
  (dsCurrent.Dataset as TASUPQuery).OnSQLPreparing:= ForSQLPreparing;
end;

procedure TfmMipodr.sbChooseClick(Sender: TObject);
var
  SearchForm: TfmSearchList;
begin

  SearchForm:= TfmSearchList.Create(Self);
  with SearchForm do
    try
      qrSearch.SetVariable('CUR_LEVEL',TASUPQuery(dsCurrent.DataSet).GetVariable('DEPT_LEVEL')-1);
      quAncestor.SetVariable('DEPT',dsCurrent.DataSet.FieldByName('MIPODR_ID').Value);
      quAncestor.Execute;
      if not quAncestor.EOF and not quAncestor.FieldIsNull(0) then
        qrSearch.SetVariable('ANCESTOR',quAncestor.FieldAsInteger(0));
      quAncestor.Close;
      if ShowModal=mrOk then
        dsCurrent.DataSet.FieldByName('MIPODR_ID').Value:= qrSearchID.Value;
    finally
      Free;
    end;
end;

procedure TfmMipodr.tePodrMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  tePodr.Hint:= Concat(dsCurrent.DataSet.FieldByName('VERH_NAIM').AsString,'|');
end;

procedure TfmMipodr.ForSQLPreparing(Sender: TASUPQuery; Field: TField;
       var SQLFrame: TSQLFrame; var Action: Boolean);
begin
  if Field.FieldName= 'MIPODR_ID' then
  begin
    Action:= not Field.IsNull;
    SQLFrame.ExprType:= piTempVariable;
    if Action then
      SQLFrame.Content:= ' A.ID IN (SELECT ID FROM P.MIPODR WHERE DATAVIVOD IS NULL'+
                         ' START WITH ID=%s CONNECT BY PRIOR ID=MIPODR_ID)';
  end;
end;

function TfmMipodr.GetFreeCode(const AFieldName: string):string;
var
  Level: Integer;
begin
  Level:= TASUPQuery(dsCurrent.DataSet).GetVariable('DEPT_LEVEL');
  if Level>2 then
    Result:= inherited GetFreeCode(AFieldName)
  else
  with TOracleQuery.Create(Self) do
  begin
    Session:= dmGlobal.seOracle;
    SQL.Append('SELECT NVL(MIN(MASTER.KOD),0)+1 FROM P.VPODR MASTER');
    SQL.Append(Format( 'WHERE EXISTS (SELECT KOD FROM P.VPODR WHERE KOD=1 AND MIUROVEN_KOD=%d)'
                       ,[Level]));
    SQL.Append(Format( 'AND NOT EXISTS (SELECT DETAIL.KOD FROM P.VPODR DETAIL WHERE DETAIL.KOD=MASTER.KOD+1 AND DETAIL.MIUROVEN_KOD=%d)'
                       ,[Level]));
    Execute;
    Result:= FieldAsString(0);
    Close;
    Free;
  end;
end;

initialization
  RegisterClass(TfmMipodr);

finalization
  UnregisterClass(TfmMipodr);
end.
