unit PageControl1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls,extctrls;

type
  TPageControl1 = class(TPageControl)
  private
         { Private declarations }
         procedure InsertPage(Page: TTabSheet);
  protected
    { Protected declarations }

  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Additional', [TPageControl1]);
end;


procedure TPageControl1.InsertPage (Page: TTabSheet);
var  MyPanel: TPanel;
begin
     inherited;
     showmessage('This is first step.');

     MyPanel:=TPanel.Create(self);
     //MyPanel.Parent:=page;

end;



end.
