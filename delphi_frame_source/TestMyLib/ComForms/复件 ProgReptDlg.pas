unit ProgReptDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TdlgProgressReport = class(TForm)
    btnCancel: TBitBtn;
    mmInfo: TMemo;
    btnOK: TBitBtn;
    btnSaveReport: TBitBtn;
    SaveDialog1: TSaveDialog;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnSaveReportClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FCanceled : boolean;
    First : boolean;
    FOnExecute: TNotifyEvent;
    procedure SetCanceled(const Value: boolean);
  public
    { Public declarations }
    CancelConfirm   : boolean;
    ConfirmCaption  : string;
    procedure Start;
    property  Canceled : boolean read FCanceled write SetCanceled;
    procedure ShowInfo(const Info:string);
    procedure AddInfo(const Info:string);
    procedure ClearInfo;
    procedure Complete;
    procedure Done;
    // show dialog to confirm user to cancel
    // if cancel, return true
    function  ConfirmUserToCancel:boolean;
    property  OnExecute : TNotifyEvent
                read FOnExecute write FOnExecute;
  end;

var
  dlgProgressReport: TdlgProgressReport;

implementation

{$R *.DFM}

{ TdlgProgress }

procedure TdlgProgressReport.AddInfo(const Info: string);
begin
  mmInfo.Lines.add(Info);
  update;
end;

procedure TdlgProgressReport.Done;
begin
  //close;
  Complete;
end;

procedure TdlgProgressReport.ShowInfo(const Info: string);
begin
  mmInfo.Lines.clear;
  AddInfo(Info);
end;

procedure TdlgProgressReport.Start;
begin
  FCanceled := false;
  btnOK.Enabled := false;
  btnSaveReport.Enabled := false;
  btnCancel.Enabled := true;
  ShowModal;
  //update;
end;

procedure TdlgProgressReport.btnCancelClick(Sender: TObject);
begin
  { Old version
  Canceled := true;
  }
  // new version
  Canceled := not CancelConfirm
    or ConfirmUserToCancel;
end;

procedure TdlgProgressReport.btnOKClick(Sender: TObject);
begin
  close;
end;

procedure TdlgProgressReport.Complete;
begin
  btnOK.Enabled := true;
  btnSaveReport.Enabled := true;
  btnCancel.Enabled := false;
end;

procedure TdlgProgressReport.btnSaveReportClick(Sender: TObject);
begin
  if saveDialog1.execute then
    try
      mmInfo.lines.SaveToFile(saveDialog1.FileName);
    except
      MessageDlg(format('不能保存文件(%s).',
        [saveDialog1.FileName]),
        mtError,[mbOK],0);
    end;
end;

procedure TdlgProgressReport.ClearInfo;
begin
  mmInfo.Lines.clear;
end;

procedure TdlgProgressReport.FormCreate(Sender: TObject);
begin
  First := true;
  CancelConfirm := false;
  ConfirmCaption := 'Are you sure to cancel this process?';
end;

procedure TdlgProgressReport.SetCanceled(const Value: boolean);
begin
  FCanceled := Value;
  if FCanceled=true then
    Done;
end;

procedure TdlgProgressReport.FormActivate(Sender: TObject);
begin
  if first then
  begin
    First := false;
    if Assigned(FOnExecute) then
      FOnExecute(self);
  end;
end;

function TdlgProgressReport.ConfirmUserToCancel: boolean;
begin
  result := MessageDlg(ConfirmCaption,
              mtConfirmation,
              mbYesNoCancel,0)=mrYes;
end;

end.
