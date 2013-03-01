unit UToolForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Contnrs, RPDesignInfo;

type
  TToolForm = class(TForm)
    procedure   FormCreate(Sender: TObject);
  private
    FReportInfo: TReportInfo;
    { Private declarations }
  public
    { Public declarations }
    procedure   BeforeLoad; virtual;
    procedure   AfterLoad; virtual;
    procedure   AfterFileOperation; virtual;
    procedure   Add(Obj : TObject); virtual;
    procedure   Changed(Obj : TObject); virtual;
    procedure   RefreshObjects; virtual;
    property    ReportInfo : TReportInfo read FReportInfo write FReportInfo;
  end;

var
  ToolForm: TToolForm;

implementation

uses UMain;

{$R *.DFM}

{ TToolForm }

procedure TToolForm.FormCreate(Sender: TObject);
begin
  ReportDesigner.InstallToolForm(Self);
end;

procedure TToolForm.AfterLoad;
begin

end;

procedure TToolForm.BeforeLoad;
begin

end;

procedure TToolForm.Changed(Obj: TObject);
begin

end;

procedure TToolForm.AfterFileOperation;
begin

end;

procedure TToolForm.Add(Obj: TObject);
begin

end;

procedure TToolForm.RefreshObjects;
begin

end;

end.
