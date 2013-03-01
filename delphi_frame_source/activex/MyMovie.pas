unit MyMovie;
{ have bug, not complete.
}
interface

uses Windows,Messages,classes,AMovie_TLB,ComWriUtils;

type
  TMyMovie = class(TComponent)
  private
    FPainted : boolean;
    FActiveMovie: TActiveMovie;
    //FSafeCall : TSafeProcCaller;
    procedure SetFileName(const Value: string);
    procedure AfterFirstPaint(sender : TObject);
    procedure SetActiveMovie(const Value: TActiveMovie);
    procedure WMPaint(var message: TWMPaint);
  protected
    FFileName : string;
    procedure   RealLoadFile;
  public
    constructor Create(AOwner : TComponent); override;
    procedure   LoadFromFile(const AFileName:string);
    property    Painted : boolean read FPainted ;
  published
    property  FileName : string read FFileName write SetFileName;
    property  ActiveMovie : TActiveMovie read FActiveMovie write SetActiveMovie;
  end;


implementation

{ TMyMovie }

procedure TMyMovie.AfterFirstPaint(sender: TObject);
begin
  FPainted := true;
end;

constructor TMyMovie.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPainted := false;
  FFileName := '';
  //FSafeCall := TSafeProcCaller.Create(self);
  FActiveMovie := nil;
end;

procedure TMyMovie.LoadFromFile(const AFileName: string);
begin
  FileName := AFileName;
end;

procedure TMyMovie.RealLoadFile;
begin
  //if FFileName<>'' then
  if ActiveMovie<>nil then
    ActiveMovie.FileName := FileName;
end;

procedure TMyMovie.SetActiveMovie(const Value: TActiveMovie);
begin
  if FActiveMovie <> Value then
  begin
    if FActiveMovie<>nil then UnHookShowFilter(FActiveMovie);
    FActiveMovie := Value;
    if FActiveMovie<>nil then
    begin
      ReferTo(FActiveMovie);
      HookShowFilter(FActiveMovie,AfterFirstPaint);
    end;
  end;
end;

procedure TMyMovie.SetFileName(const Value: string);
begin
  if FFileName <> Value then
  begin
    FFileName := Value;
    if Painted then RealLoadFile;
  end;
end;

procedure TMyMovie.WMPaint(var message: TWMPaint);
begin
  inherited ;
  if not FPainted then
  begin
    FPainted := true;
    if FFileName<>'' then
      FSafeCall.SafeProcEx(RealLoadFile);
  end;
end;

end.
