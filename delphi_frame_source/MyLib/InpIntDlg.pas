unit InpIntDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Spin;

type
  TdlgInputInt = class(TForm)
    lbDescription: TLabel;
    seValue: TSpinEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure seValueKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    function execute(const acaption,aprompt:string;
              var value:integer;
              min:integer=0;max:integer=0): boolean;
  end;

var
  dlgInputInt: TdlgInputInt;

function InputInteger(const acaption,aprompt:string;
              var value:integer;
              min:integer=0;max:integer=0): boolean;

implementation

{$R *.DFM}

function InputInteger(const acaption,aprompt:string;
              var value:integer;
              min:integer=0;max:integer=0): boolean;
var
  dialog : TdlgInputInt;
begin
  dialog := TdlgInputInt.create(Application);
  try
    result := dialog.execute(acaption,aprompt,value,min,max);
  finally
    dialog.free;
  end;
end;

{ TdlgZoom }

function TdlgInputInt.execute(const acaption,aprompt:string;
              var value:integer;
              min:integer=0;max:integer=0): boolean;
begin
  Caption := acaption;
  lbDescription.Caption := aprompt;
  seValue.MinValue := min;
  seValue.MaxValue := max;
  seValue.value := value;
  result := showModal = mrOK;
  if result then value:=seValue.value;
end;

procedure TdlgInputInt.seValueKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=13) or (key=10) then
  begin
    ModalResult := mrOK;
  end;
end;

end.
