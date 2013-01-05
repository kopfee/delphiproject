unit phtIfRepalce;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, ExtCtrls, JPEG;

type
    TphtReply = (rpNone, rpReplace, rpAllReplace, rpSkip, rpCancel);

    TfrmIfRepalce = class(TForm)
        grp1: TGroupBox;
        Label1: TLabel;
        Label4: TLabel;
        lblNum: TLabel;
        Label3: TLabel;
        Label2: TLabel;
        Label5: TLabel;
        imgNew: TImage;
        imgOld: TImage;
        grp2: TGroupBox;
        btnReplace: TButton;
        btnAllReplace: TButton;
        btnSkip: TButton;
        btnCancel: TButton;
        procedure btnReplaceClick(Sender: TObject);
        procedure btnAllReplaceClick(Sender: TObject);
        procedure btnSkipClick(Sender: TObject);
        procedure btnCancelClick(Sender: TObject);
    private
        { Private declarations }
        FphtReply: TphtReply;
    public
        { Public declarations }
        function GetReply(sNum: string; OldJPEG, NewJPEG: TJPEGImage): TphtReply;
    end;

var
    frmIfRepalce: TfrmIfRepalce;

implementation

{$R *.DFM}

{ TfrmIfRepalce }

function TfrmIfRepalce.GetReply(sNum: string; OldJPEG, NewJPEG: TJPEGImage): TphtReply;
begin
    lblNum.Caption := '"' + sNum + '"';
    imgOld.Picture.Graphic := OldJPEG;
    imgNew.Picture.Graphic := NewJPEG;
    Self.ShowModal;

    Result := FphtReply;
end;

procedure TfrmIfRepalce.btnReplaceClick(Sender: TObject);
begin
    FphtReply := rpReplace;
    Close;
end;

procedure TfrmIfRepalce.btnAllReplaceClick(Sender: TObject);
begin
    FphtReply := rpAllReplace;
    Close;
end;

procedure TfrmIfRepalce.btnSkipClick(Sender: TObject);
begin
    FphtReply := rpSkip;
    Close;
end;

procedure TfrmIfRepalce.btnCancelClick(Sender: TObject);
begin
    FphtReply := rpCancel;
    Close;
end;

end.
