unit History;

interface

uses sysutils,classes,ComWriUtils,SafeCode;

type
  TAfterProcMethod = procedure (Sender : TObject; Successful : boolean) of object;
  
  THistory = class
  private

  protected
    FPosition: integer;
    function 	GetCount: integer; virtual; abstract;
    procedure SetPosition(const Value: integer); virtual; abstract;
  public
    property	count : integer read GetCount;
    property	Position	: integer read FPosition write SetPosition;
    // return if successful
    function	Back:boolean;
    function	Foreward:boolean;
    procedure Clear; virtual; abstract;
    procedure GetCurrentValue(var Value); virtual; abstract;
    procedure Add(const Value); virtual; abstract;
    function 	Bof:boolean ;
    function 	Eof:boolean ;
  end;

  TStringHistory = class(THistory)
  private
    FStrings : TStringList;
    FMaxCount: integer;
    function GetCurValue: string;
  protected
    function 		GetCount: integer; override;
    procedure 	SetPosition(const Value: integer); override;
  public
    constructor Create(AMaxCount : integer);
    destructor 	destroy; override;
    property		MaxCount : integer read FMaxCount;
    procedure 	Clear; override;
    procedure 	GetCurrentValue(var Value); override;
    procedure 	Add(const Value); override;
    property    Items : TStringList read FStrings;
    property		CurValue : string read GetCurValue;
  end;

  TFileOpenHistory = class(TStringHistory)
  private
    FAfterFileOpen: TAfterProcMethod;
  public
    FileOpen : IFileView;
    function		OpenFile(const Filename:string):boolean;
    // if now is first , return false
    // if file open error return false
    function		Back:boolean;
    // if now is last , return false
    // if file open error return false
    function		Foreward:boolean;
    property		AfterFileOpen : TAfterProcMethod read FAfterFileOpen write FAfterFileOpen;
  end;

implementation

{ THistory }

function THistory.Back: boolean;
begin
  result := not bof;
  if result then position := position -1;
end;

function THistory.Bof: boolean;
begin
  result := Position<=0;
end;

function THistory.Eof: boolean;
begin
  result := (Position>=count-1) or (Position<0);
end;

function THistory.Foreward: boolean;
begin
  result := not eof;
  if result then position := position+1;
end;

{ TStringHistory }

constructor TStringHistory.Create(AMaxCount : integer);
begin
  inherited Create;
  FStrings := TStringList.Create;
  FPosition := -1;
  FMaxCount := AMaxCount;
end;

destructor TStringHistory.destroy;
begin
  FStrings.free;
  inherited destroy;
end;

procedure TStringHistory.Add(const Value);
var
  AddStr : string;
begin
  inc(FPosition);
  if FPosition=count then
  begin
    AddStr := String(value);
    FStrings.Add(String(value));
    if count>FMaxCount then
    begin
      FStrings.Delete(0);
      FPosition:=count-1;
    end;
  end
  else
    FStrings[FPosition]:=String(value);
end;

procedure TStringHistory.Clear;
begin
  FStrings.Clear;
  FPosition := -1;
end;


function TStringHistory.GetCount: integer;
begin
  result := FStrings.count;
end;

procedure TStringHistory.GetCurrentValue(var Value);
begin
  String(Value):=FStrings[FPosition];
end;

procedure TStringHistory.SetPosition(const Value: integer);
begin
  if (value<0) or (value>=count) then
  	RaiseIndexOutOfRange
  else
	  FPosition := value;
end;

function TStringHistory.GetCurValue: string;
begin
  GetCurrentValue(result);
end;

{ TFileOpenHistory }

function TFileOpenHistory.Back: boolean;
begin
  result := inherited Back;
  if result and assigned(FileOpen) then
  begin
  	result := FileOpen.LoadFromFile(CurValue);
    if Assigned(FAfterFileOpen) then
  	  FAfterFileOpen(self,result);
  end;
end;

function TFileOpenHistory.Foreward: boolean;
begin
  result := inherited Foreward;
  if result and assigned(FileOpen) then
  begin
  	result := FileOpen.LoadFromFile(CurValue);
    if Assigned(FAfterFileOpen) then
  	  FAfterFileOpen(self,result);
  end;
end;


function TFileOpenHistory.OpenFile(const Filename:string):boolean;
var
  RealFileName : string;
begin
  RealFileName :=ExpandFileName(FileName);
  //RealFileName :=FileName;
  result := FileOpen.LoadFromFile(RealFilename);
  if result  then Add(RealFileName);
  if Assigned(FAfterFileOpen) then
  	  FAfterFileOpen(self,result);
end;

end.
