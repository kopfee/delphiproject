unit UZoom;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Spin;

type
  TdlgZoom = class(TForm)
    Label1: TLabel;
    seZoom: TSpinEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
    function execute(var Zoom:integer): boolean;
  end;

var
  dlgZoom: TdlgZoom;

implementation

{$R *.DFM}

{ TdlgZoom }

function TdlgZoom.execute(var Zoom: integer): boolean;
begin
  seZoom.value := zoom;
  result := showModal = mrOK;
  if result then zoom:=seZoom.value;
end;

end.
