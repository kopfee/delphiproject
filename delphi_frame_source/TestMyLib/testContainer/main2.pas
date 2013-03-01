unit main2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Container;

type
  TForm1 = class(TForm)
    ContainerProxy1: TContainerProxy;
    ContainerProxy2: TContainerProxy;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Unit2;

{$R *.DFM}

end.
