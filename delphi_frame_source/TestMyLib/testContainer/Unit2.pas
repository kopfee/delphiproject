unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons,Container, AbilityManager;

type
  TContainer1 = class(TContainer)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    SimpleAuthorityProvider1: TSimpleAuthorityProvider;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Container1 : TContainer1;

implementation

{$R *.DFM}

procedure TContainer1.BitBtn1Click(Sender: TObject);
begin
  label2.caption := '1';
end;

procedure TContainer1.BitBtn2Click(Sender: TObject);
begin
  label2.caption := '2';
end;

initialization
  registerClass(TContainer1);
end.
 