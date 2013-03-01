unit Progress;

interface

uses Windows,sysutils,classes,controls,forms,comctrls,
  ProgDlg;

type
  TProgress = class;

  // if process done, return true.
  TProgressMethod = function (Sender : TProgress; var step : integer):boolean of object;

  TProgressThread = class(TThread)
  private
    { Private declarations }
    Progress : TProgress;
  protected
    procedure   Execute; override;
  public
    constructor Create(AProgress : TProgress);
  end;

  TProgress = class(TComponent)
  private
    dlgProgress: TdlgProgress;
    FOnProcess: TProgressMethod;
    FProcessDone : boolean;
    First : boolean;
    Thread : TProgressThread;
    function GetCaption: string;
    function GetMax: integer;
    function GetMin: integer;
    function GetPos: integer;
    function GetTitle: string;
    procedure SetCaption(const Value: string);
    procedure SetMax(const Value: integer);
    procedure SetMin(const Value: integer);
    procedure SetPos(const Value: integer);
    procedure SetTitle(const Value: string);
    function  Done:boolean ;
    procedure FormShow(Sender: TObject);
  protected
    procedure GoAStep;
  public
    constructor Create(AOwner : TComponent); override;
    //destructor  destroy; override;
    // when user canceled, return false
    function    Execute : boolean;
  published
    property Title    : string read GetTitle   write SetTitle;
    property Caption  : string read GetCaption write SetCaption;
    property Min      : integer read GetMin    write SetMin;
    property Max      : integer read GetMax    write SetMax;
    property Pos      : integer read GetPos    write SetPos;
    property OnProcess: TProgressMethod read FOnProcess write FOnProcess;
  end;

implementation

{ TProgress }

constructor TProgress.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  dlgProgress:=TdlgProgress.Create(self);
  dlgProgress.OnShow := FormShow
end;
{
destructor TProgress.destroy;
begin
  inherited destroy;
end;
}

function TProgress.GetCaption: string;
begin
  result :=  dlgProgress.lbCaption.Caption;
end;

procedure TProgress.SetCaption(const Value: string);
begin
  dlgProgress.lbCaption.Caption := value;
  //dlgProgress.Invalidate;
  dlgProgress.Update;
  //
end;

function TProgress.GetMax: integer;
begin
  result := dlgProgress.ProgressBar.Max;
end;

procedure TProgress.SetMax(const Value: integer);
begin
  dlgProgress.ProgressBar.Max := value;
end;

function TProgress.GetMin: integer;
begin
  result := dlgProgress.ProgressBar.Min;
end;

procedure TProgress.SetMin(const Value: integer);
begin
  dlgProgress.ProgressBar.Min := value;
end;

function TProgress.GetPos: integer;
begin
  result := dlgProgress.ProgressBar.Position;
end;

procedure TProgress.SetPos(const Value: integer);
begin
  dlgProgress.ProgressBar.Position := value;
end;

function TProgress.GetTitle: string;
begin
  result := dlgProgress.Caption;
end;

procedure TProgress.SetTitle(const Value: string);
begin
  dlgProgress.Caption := value;
end;

function TProgress.Execute: boolean;
begin
  if not assigned(FOnProcess) then
    result := false
  else
  begin
    pos :=  0;
    FProcessDone := false;
    Thread := TProgressThread.Create(self);
    try
      //Thread.Resume;
      First := true;
      dlgProgress.Execute;
      result := FProcessDone;
    finally
      //dlgProgress.close;
      //dlgProgress.ModalResult := mrYes;
      Thread.free;
    end;
  end;
end;

procedure TProgress.GoAStep;
var
  Step : integer;
begin
  step:=  1;
  FProcessDone := FOnProcess(self,step);
  pos := pos + step;
  {if FProcessDone then
    dlgProgress.ModalResult := mrOK;}
end;

function TProgress.Done: boolean;
begin
  result := FProcessDone or dlgProgress.canceled;
end;

procedure TProgress.FormShow(Sender: TObject);
begin
  if first then
  begin
    first := false;
    Thread.Resume;
  end;
end;

{ TProgressThread }

constructor TProgressThread.Create(AProgress: TProgress);
begin
  inherited Create(true);
  Progress:=AProgress;
end;

procedure TProgressThread.Execute;
begin
  repeat
    Application.ProcessMessages;
    Synchronize(Progress.GoAStep);
    // for test
    // sleep(3000);
  until Progress.Done;
  Progress.dlgProgress.ModalResult := mrYes;
end;

end.
