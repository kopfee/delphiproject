unit login;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TdlgLogin = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    edUserID: TEdit;
    edPassword: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TLoginDialogClass = class of TdlgLogin;
  
var
  dlgLogin: TdlgLogin;

implementation

{$R *.DFM}




end.
