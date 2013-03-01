unit prgform;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls;

type
  TProgform = class(TForm)
    ProgressBar1: TProgressBar;
    Lfilename: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Progform: TProgform;

implementation

{$R *.DFM}

end.
