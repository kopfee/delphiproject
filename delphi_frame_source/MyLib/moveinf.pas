unit MoveInf;

interface

uses Windows,messages;

Type
  TDirectory = (dirNone,dirUp,dirDown,dirleft,dirRight);
  TMoveInfo = record
    dx,dy : shortInt;
  end;

const
  MoveInfos : array[TDirectory] of TMoveInfo
    = ((dx : 0;dy : 0),(dx : 0;dy : -1),(dx : 0;dy : 1),
       (dx : -1; dy : 0),(dx : 1;dy : 0));

function KeyToDir(key : word):TDirectory;

procedure MoveByDir(dir : TDirectory; var x,y:integer);

function GetContrary(dir : TDirectory): TDirectory;

function isContrary(dir1,dir2 : TDirectory):boolean;

implementation

function KeyToDir(key : word):TDirectory;
begin
  case Key of
    VK_left  : result := dirLeft;
    VK_right : result := dirRight;
    VK_up    : result := dirUp;
    VK_down  : result := dirDown;
  else         result := dirNone;
  end;
end;

procedure MoveByDir(dir : TDirectory; var x,y:integer);
begin
  inc(x,MoveInfos[dir].dx);
  inc(y,MoveInfos[dir].dy);
end;

function GetContrary(dir : TDirectory): TDirectory;
begin
  case dir of
    dirNone : result := dirNone;
    dirUp   : result := dirDown;
    dirDown : result := dirUp;
    dirleft : result := dirRight;
    dirRight: result := dirleft;
  end;
end;

function isContrary(dir1,dir2 : TDirectory):boolean;
begin
  result := (dir2=GetContrary(dir1)) and (dir1<>dirNone);
end;

end.
