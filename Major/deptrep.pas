unit deptrep;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, OracleData, Oracle;

type
  TdmRepDept = class(TDataModule)
    quUpperDept: TOracleDataSet;
    quUpperDeptKOD: TIntegerField;
    quUpperDeptSNAIM: TStringField;
    quUpperDeptPNAIM: TStringField;
    quUpperDeptSOSTAV: TStringField;
    quUpperDeptID: TFloatField;
    quUpperTech: TOracleQuery;
    quWorkShop: TOracleDataSet;
    quWorkShopKOD: TIntegerField;
    quWorkShopSNAIM: TStringField;
    quWorkShopPNAIM: TStringField;
    quDept: TOracleDataSet;
    quWorkShopID: TFloatField;
    procedure quUpperDeptCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmRepDept: TdmRepDept;

implementation
uses globals;
{$R *.DFM}

procedure TdmRepDept.quUpperDeptCalcFields(DataSet: TDataSet);
var
  Result: string;
begin
  with quUpperTech do
  begin
    SetVariable('up_id',quUpperDeptID.Value);
    Execute;
    Result:= '';
    while not EOF do
    begin
      if Length(Result)=0 then
        Result:= FieldAsString(0)
      else Result:= Concat(Result,', ',FieldAsString(0));
      Next;
    end;
    quUpperDeptSOSTAV.AsString:= Result;
    Close;
  end;
end;

end.
