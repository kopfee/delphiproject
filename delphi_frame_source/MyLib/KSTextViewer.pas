unit KSTextViewer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TdlgTextView = class(TForm)
    mmText: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Execute(const AText : string);
    procedure ViewTextFile(const AFileName : string);
  end;

var
  dlgTextView: TdlgTextView;

procedure ShowText(const AText : string);

procedure ViewTextFile(const AFileName : string);

implementation

{$R *.dfm}

procedure ShowText(const AText : string);
var
  Dialog : TdlgTextView;
begin
  Dialog := TdlgTextView.Create(Application);
  try
    Dialog.Execute(AText);
  finally
    Dialog.Free;
  end;
end;

procedure ViewTextFile(const AFileName : string);
var
  Dialog : TdlgTextView;
begin
  Dialog := TdlgTextView.Create(Application);
  try
    Dialog.ViewTextFile(AFileName);
  finally
    Dialog.Free;
  end;
end;

{ TdlgTextView }

procedure TdlgTextView.Execute(const AText: string);
begin
  mmText.Text := AText;
  Caption := 'Text';
  ShowModal;
end;

procedure TdlgTextView.ViewTextFile(const AFileName: string);
begin
  mmText.Lines.LoadFromFile(AFileName);
  Caption := AFileName;
  ShowModal;
end;

end.
