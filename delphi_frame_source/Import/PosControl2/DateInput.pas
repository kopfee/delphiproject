unit Dateinput;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask;

type
  TDateInput1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cancel: TButton;
    MaskEdit1: TMaskEdit;
    MaskEdit2: TMaskEdit;
    MaskEdit3: TMaskEdit;
    procedure FormCreate(Sender: TObject);
    procedure okClick(Sender: TObject);
    procedure cancelClick(Sender: TObject);
    procedure MaskEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    inputok: boolean;
  public
    { Public declarations }
    function OK: boolean;
    function GetDate : String;

  end;

var
  DateInput1: TDateInput1;

implementation

{$R *.DFM}

procedure TDateInput1.FormCreate(Sender: TObject);
begin
     inputok := false;
end;

procedure TDateInput1.okClick(Sender: TObject);
begin
     InputOk := true;
     try
        StrToDate(MaskEdit1.Text+DateSeparator+MaskEdit2.Text+'-'+MaskEdit3.Text);
        close;
     except
           showmessage('»’∆⁄ ‰»Î¥ÌŒÛ£°');
           MaskEdit1.SetFocus;
     end;

end;

function TDateInput1.OK: boolean;
begin
     Result := InputOk;
end;
function TDateInput1.GetDate: String;
begin
     Result := MaskEdit1.Text+'-'+MaskEdit2.Text+'-'+MaskEdit3.Text;
end;

procedure TDateInput1.cancelClick(Sender: TObject);
begin
     inputok := false;
     close;
end;

procedure TDateInput1.MaskEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
{
     if key = word(#13) then
        SendMessage(integer(self),
                         wm_keydown,word(#9),0);
}
end;

procedure TDateInput1.FormShow(Sender: TObject);
begin
     maskEdit1.SetFocus;
end;

end.
