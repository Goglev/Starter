unit expdpt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  explorer, Db, DbASUP, Grids, DBGrids, RXDBCtrl, ExtCtrls,
  pnlform, RxPlacemnt;

type
  TfmExpDept = class(TfmExplorer)
  private
    { Private declarations }
  protected
    procedure UMOTHERS(var Message:TMessage);message UM_OTHERS;
              {Расширенная обработка инструкции IN_PRINT
              (Укруп.подр, цехи или участки с бригадами) }
  public
    { Public declarations }
  end;

var
  fmExpDept: TfmExpDept;

implementation

{$R *.DFM}

procedure TfmExpDept.UMOTHERS(var Message:TMessage);
begin
  {case Message.wParam of
    IN_PRINT:
      with TfmPrintDept.Create(Self) do
      begin
        if dsWork.SelectedIndex<2 then
           rgStyle.ItemIndex:= dsWork.SelectedIndex
        else rgStyle.ItemIndex:= 2;
        ShowModal;
      end;
    else inherited;
  end;
  }
  inherited;
end;

end.
