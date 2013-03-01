unit UContext;

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

uses WVUtils;

{$R *.DFM}

procedure TdmContext.DataModuleCreate(Sender: TObject);
begin
  FContext := TWVContext.Create;
  RegisterDecsriptorsAndProcessors(FContext);
end;

procedure TdmContext.DataModuleDestroy(Sender: TObject);
begin
  FContext.Free;
end;

end.
