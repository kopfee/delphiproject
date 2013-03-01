unit FileCopyOptCnt;

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms,container, CompGroup,ExtUtils, AbilityManager,
  ComWriUtils;

type
  TctFileCopyOptions = class(TContainer)
    cbAlwaysReplace: TCheckBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    cbSNewer: TComboBox;
    Label2: TLabel;
    cbSOlder: TComboBox;
    Label3: TLabel;
    cbSizeDif: TComboBox;
    Label4: TLabel;
    cbEqual: TComboBox;
    amChoices: TGroupAbilityManager;
    Label5: TLabel;
    cbNoDestDir: TComboBox;
    Label6: TLabel;
    cbRetry: TCheckBox;
    procedure cbAlwaysReplaceClick(Sender: TObject);
    procedure ctFileCopyOptionsCreate(Sender: TObject);
  private

  public
    procedure SetCopyOptions(const options : TCopyAgentOptions);
    procedure GetCopyOptions(var options : TCopyAgentOptions);
  end;

var
  ctFileCopyOptions: TctFileCopyOptions;

implementation

{$R *.DFM}

{ TctFileCopyOptions }

procedure TctFileCopyOptions.GetCopyOptions(
  var options: TCopyAgentOptions);
begin
  with options do
  begin
    AlwaysReplace := cbAlwaysReplace.Checked;
    TimeNewer := TCopyAgentAction(cbSNewer.ItemIndex);
    TimeOlder := TCopyAgentAction(cbSOlder.ItemIndex);
    SizeDif := TCopyAgentAction(cbSizeDif.ItemIndex);
    SameAttr := TCopyAgentAction(cbEqual.ItemIndex);
    NoDestDir := TCopyAgentAction(cbNoDestDir.ItemIndex);
    Retry := cbRetry.Checked;
  end;
end;

procedure TctFileCopyOptions.SetCopyOptions(
  const options: TCopyAgentOptions);
begin
  with options do
  begin
    cbAlwaysReplace.Checked := AlwaysReplace;
    cbSNewer.ItemIndex := ord(TimeNewer);
    cbSOlder.ItemIndex := ord(TimeOlder);
    cbSizeDif.ItemIndex := ord(SizeDif);
    cbEqual.ItemIndex := ord(SameAttr);
    cbNoDestDir.ItemIndex := ord(NoDestDir);
    cbRetry.Checked := Retry;
  end;
  cbAlwaysReplaceClick(self);
end;

procedure TctFileCopyOptions.cbAlwaysReplaceClick(Sender: TObject);
begin
  amChoices.enabled := not cbAlwaysReplace.Checked;
end;

procedure TctFileCopyOptions.ctFileCopyOptionsCreate(Sender: TObject);
begin
  SetCopyOptions(caoDefault);
end;

initialization

registerClass(TctFileCopyOptions);

end.
