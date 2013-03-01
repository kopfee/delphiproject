unit UCmdDefinitions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WVCmdTypeInfo;

type
  TdmCmdDefinitions = class(TDataModule)
    WVCommandTypeInfo1: TWVCommandTypeInfo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmCmdDefinitions: TdmCmdDefinitions;

implementation

{$R *.DFM}

end.
