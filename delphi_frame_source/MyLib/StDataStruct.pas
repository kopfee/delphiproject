unit StDataStruct;

interface

uses Sysutils,Classes;

type
  TStack = class(TList)
  public
    procedure Push(P : Pointer);
    function  Pop : Pointer;
    function  Top : Pointer;
  end;

  TStringObject = class
  public
    Value : string;
    constructor Create(AValue : string);
  end;

  TStringStack = class(TStringList)
  public
    procedure Push(P : String);
    function  Pop : String;
    function  Top : String;
  end;

implementation

{ TStack }

function TStack.Pop: Pointer;
begin
  result := Items[count-1];
  Delete(count-1);
end;

procedure TStack.Push(P: Pointer);
begin
  Add(p);
end;

function TStack.Top: Pointer;
begin
  result := Items[count-1];
end;

{ TStringObject }

constructor TStringObject.Create(AValue: string);
begin
  inherited Create;
  value := AValue;
end;

{ TStringStack }

function TStringStack.Pop: String;
begin
  result := Strings[count-1];
  Delete(count-1);
end;

procedure TStringStack.Push(P: String);
begin
  Add(p);
end;

function TStringStack.Top: String;
begin
  result := Strings[count-1];
end;

end.
