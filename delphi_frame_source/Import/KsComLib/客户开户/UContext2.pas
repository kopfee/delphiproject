unit UContext2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, WVCommands;

type
  TdmContext = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FContext : TWVContext;
  public
    { Public declarations }
    property   Context : TWVContext read FContext;
  end;

var
  dmContext: TdmContext;

implementation

uses WVUtils, LogFile, DataTypes;

{$R *.DFM}

procedure TdmContext.DataModuleCreate(Sender: TObject);
var
  Filter : TWVLogFilter;
begin
  OpenLogFile('',False,True);
  FContext := TWVContext.Create;
  RegisterDecsriptorsAndProcessors(FContext);
  Filter := TWVLogFilter.Create(FContext);
  FContext.CommandBus.AddBeforeFilter(Filter);
  FContext.CommandBus.AddAfterFilter(Filter);
  FContext.AddParam('#营业部代码',kdtInteger);
  FContext.AddParam('#职工代码',kdtString);
  FContext.FindParamData('#营业部代码').SetInteger(101);
  FContext.FindParamData('#职工代码').SetString('001');
end;

procedure TdmContext.DataModuleDestroy(Sender: TObject);
begin
  FContext.Free;
end;

end.
