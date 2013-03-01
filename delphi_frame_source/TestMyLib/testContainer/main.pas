unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses test, testf;

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var
  container : TMyContainer;
begin
  container := TMyContainer.Create(self);
  insertControl(container);
  container.align:=alleft;
  // the owner must be different from above, not share the same form
  // otherwise that will bring a name conflict
  // However, thay can share a same application, because i write
  // a FindGlobalComponent function to indicate the component is
  // a globe component which owner is application 
  container := TMyContainer.Create(application);
  insertControl(container);
  container.align:=alleft;
  container := TMyContainer.Create(application);
  insertControl(container);
  container.align:=alClient;
end;

end.
