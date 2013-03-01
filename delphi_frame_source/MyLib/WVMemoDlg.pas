unit WVMemoDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TdlgMemo = class(TForm)
    mmMemos: TMemo;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    function GetMemo: TStrings;
    { Private declarations }
  public
    { Public declarations }
    function  Execute(const Title:string) : Boolean;
    property  Memo : TStrings read GetMemo;
  end;

var
  dlgMemo: TdlgMemo;

implementation

{$R *.DFM}

{ TdlgAddWorkViewField }

function TdlgMemo.Execute(const Title:string): Boolean;
begin
  Memo.Clear;
  Caption := Title;
  Result := ShowModal=mrOk;
end;

function TdlgMemo.GetMemo: TStrings;
begin
  Result := mmMemos.Lines;
end;

end.
