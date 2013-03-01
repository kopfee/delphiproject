unit ContainerModule;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons,Container;

type
  TMyContainer = class(TContainer)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MyContainer : TMyContainer;

implementation

{$R *.DFM}

initialization

registerClass(TMyContainer);

end.
