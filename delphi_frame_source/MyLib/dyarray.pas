unit dyarray;

interface

uses SysUtils;

type
  TBasetype = real;
  PBasetype = ^TBasetype;

  TBaseFunc = function (x,y:TBaseType):TBasetype;

function BaseAdd(x,y:TBaseType):TBasetype;
function BaseSub(x,y:TBaseType):TBasetype;

const
  MaxLength = $FFFF;

type
  TOneArray = array[0..MaxLength] of TBasetype;
  POneArray = ^TOneArray;

  EArrayError = class(Exception);
  EArrayOutofIndex = class(EArrayError);
  EArrayOperatorError = class(EArrayError);

  TDOnearray = class
  private
    function Getvalues(index : integer):TBasetype;
    procedure Setvalues(index : integer; value:TBasetype);
    procedure CheckIndex(index : integer);
  protected
    FMemory : POneArray;
    FMemorySize : integer;
    FSize : integer;
    FBrowse : PBasetype;
    FLastMemory : PBasetype;
    //PBrowseIndex : Integer;
  public
    constructor Create(n:integer);
    destructor  destroy; override;
    // you can use Memory to access freely without range check
    property Memory : POneArray read FMemory;
    property MemorySize : integer read FMemorySize;
    property Size : integer read FSize;
    // safely access , checking index range;
    property values[index : integer] : TBasetype
      read Getvalues write Setvalues;
    { you can browse the array like this:
        First;
        while not eof do begin
          //access Pvalue^
          next;
        end;
      note : there is not range check!
    }
    property pvalue : PBaseType read FBrowse;
    procedure First;
    procedure Last;
    procedure Next;
    procedure Previous;
    function  Eof:boolean;
    function  Bof:boolean;
  end;

procedure RaiseArrayException(const s:string);
procedure RaiseOutofIndex;
procedure RaiseOperatorError;

{ Note : array1 and array2 must be different objects,
  but resultArray can be array1 or array2
}
procedure Array1Add(array1,array2,resultArray : TDOneArray);
procedure Array1Sub(array1,array2,resultArray : TDOneArray);
procedure Array1Operator(array1,array2,resultArray : TDOneArray;
  BaseFunc : TBaseFunc);
function InnerMul(array1,array2 : TDOneArray):TBaseType;

type
  TDTwoArray = class
  private
    function Getvalues(row,col : integer):TBasetype;
    procedure Setvalues(row,col : integer; value:TBasetype);
    procedure CheckIndex(row,col : integer);
    function  GetRow(row:integer):POneArray;
  protected
    FMemory : Pointer;
    FMemorySize : integer;
    FRowMemorySize : integer;
    FCols,FRows : integer;
    FBrowse : PBasetype;
    FLastMemory : PBasetype;
  public
    constructor Create(row,col:integer);
    destructor  destroy; override;
    // you can use Memory to access freely without range check
    property Memory : Pointer read FMemory;
    property MemorySize : integer read FMemorySize;
    property Cols : integer read FCols;
    property Rows : integer read FRows;
    property RowMemory[row : integer] : POneArray read GetRow;
    // safely access , checking index range;
    property values[row,col : integer] : TBasetype
      read Getvalues write Setvalues;
    { you can browse the array like this:
        First;
        while not eof do begin
          //access Pvalue^
          next;
        end;
      note : there is not range check!
    }
    property pvalue : PBaseType read FBrowse;
    function  Eof:boolean;
    function  Bof:boolean;
    procedure First;
    procedure FirstCol(col : integer);
    procedure FirstRow(row : integer);
    procedure LastCol(col : integer);
    procedure LastRow(row : integer);
    procedure Last;
    procedure Next;
    procedure Previous;
    procedure NextRow;
    procedure PreviousRow;
  end;

{ Note : array1 and array2 must be different objects,
  but resultArray can be array1 or array2
}
procedure Array2Add(array1,array2,resultArray : TDTwoArray);
procedure Array2Sub(array1,array2,resultArray : TDTwoArray);
procedure Array2Operator(array1,array2,resultArray : TDTwoArray;
  BaseFunc : TBaseFunc);

{ note :
    array1 ,array2 and ResultArray must be different objects.
}

procedure Array2Mul(array1,array2,resultArray : TDTwoArray);
function  GetArrayMul(array1,array2: TDTwoArray) : TDTwoArray;

implementation

function BaseAdd(x,y:TBaseType):TBasetype;
begin
  result := x+y;
end;

function BaseSub(x,y:TBaseType):TBasetype;
begin
  result := x-y;
end;


procedure RaiseArrayException(const s:string);
begin
  Raise EArrayError.create(s);
end;

procedure RaiseOutofIndex;
begin
  Raise EArrayOutofIndex.create('Out of array index');
end;

procedure RaiseOperatorError;
begin
  Raise EArrayOperatorError.create('Cannot perform the operator');
end;

// TDOnearray

constructor TDOnearray.Create(n:integer);
begin
  FSize := n;
  FMemorySize := sizeof(TBasetype)*n;
  if FMemorySize<=0 then RaiseArrayException('Invalid value');
  GetMem(FMemory,FMemorySize);
  FLastMemory := PBasetype(longint(FMemory)+FMemorySize-sizeof(TBasetype));
end;

destructor  TDOnearray.destroy;
begin
  Freemem(FMemory,FMemorySize);
end;

function TDOnearray.Getvalues(index : integer):TBasetype;
begin
  CheckIndex(index);
  result := FMemory^[index];
end;

procedure TDOnearray.Setvalues(index : integer; value:TBasetype);
begin
  CheckIndex(index);
  FMemory^[index] := value;
end;

procedure TDOnearray.CheckIndex;
begin
  if (index<0) or (index>=size)
    then RaiseOutofIndex;
end;

function  TDOnearray.Eof:boolean;
begin
  result := longint(FBrowse)>longint(FLastMemory);
end;

function  TDOnearray.Bof:boolean;
begin
  result := longint(FBrowse)<longint(FMemory);
end;

procedure TDOnearray.First;
begin
  FBrowse := PBasetype(FMemory);
end;

procedure TDOnearray.Last;
begin
  FBrowse := FLastMemory;
end;

procedure TDOnearray.Next;
begin
  inc(longint(FBrowse),sizeof(TBaseType));
end;

procedure TDOnearray.Previous;
begin
  dec(longint(FBrowse),sizeof(TBaseType));
end;

procedure Array1Operator(array1,array2,resultArray : TDOneArray;
  BaseFunc : TBaseFunc);
var
  i : integer;
begin
  if (array1.size<>array2.size) or (array1.size<>resultarray.size)
    then raiseOperatorError;
  array1.first;
  array2.first;
  for i:=0 to array1.size-1 do begin
    { Note : resultarray cannot use browse methods
      because it may be array1 or array2
    }
    resultArray.memory^[i]:=BaseFunc(array1.pvalue^,array2.pvalue^);
    array1.next;
    array2.next;
  end;
end;

procedure Array1Add(array1,array2,resultArray : TDOneArray);
begin
  Array1Operator(array1,array2,resultArray,BaseAdd);
end;

procedure Array1Sub(array1,array2,resultArray : TDOneArray);
begin
  Array1Operator(array1,array2,resultArray,BaseSub);
end;

function InnerMul(array1,array2 : TDOneArray):TBaseType;
begin
  if (array1.size<>array2.size)
    then raiseOperatorError;
  array1.first;
  array2.first;
  result := 0;
  while not array1.eof do begin
    result := result + array1.pvalue^ * array2.pvalue^;
    array1.next;
    array2.next;
  end;
end;


// TDTwoArray

constructor TDTwoArray.Create(row,col:integer);
begin
  FCols := col;
  FRows := row;
  FMemorySize := sizeof(TBasetype)*col*row;
  if FMemorySize<=0 then RaiseArrayException('Invalid value');
  GetMem(FMemory,FMemorySize);
  FLastMemory := PBasetype(longint(FMemory)+FMemorySize-sizeof(TBasetype));
  FRowMemorySize := sizeof(TBasetype)*col;
end;

destructor  TDTwoArray.destroy;
begin
  Freemem(FMemory,FMemorySize);
end;

function TDTwoArray.Getvalues(row,col : integer):TBasetype;
begin
  CheckIndex(row,col);
  result := PBasetype(longint(FMemory)
   + row * FRowMemorySize
   + col * sizeof(TBasetype))^;
end;

procedure TDTwoArray.Setvalues(row,col : integer; value:TBasetype);
begin
  CheckIndex(row,col);
  PBasetype(longint(FMemory)
   + row * FRowMemorySize
   + col * sizeof(TBasetype))^ := value;
end;

procedure TDTwoArray.CheckIndex;
begin
  if (row<0) or (row>=FRows)
    or (row<0) or (row>=FCols)
    then RaiseOutofIndex;
end;

function  TDTwoArray.Eof:boolean;
begin
  result := longint(FBrowse)>longint(FLastMemory);
end;

function  TDTwoArray.Bof:boolean;
begin
  result := longint(FBrowse)<longint(FMemory);
end;

procedure TDTwoArray.First;
begin
  FBrowse := PBasetype(FMemory);
end;

procedure TDTwoArray.Last;
begin
  FBrowse := FLastMemory;
end;

procedure TDTwoArray.Next;
begin
  inc(longint(FBrowse),sizeof(TBaseType));
end;

procedure TDTwoArray.Previous;
begin
  dec(longint(FBrowse),sizeof(TBaseType));
end;

function  TDTwoArray.GetRow(row:integer):POneArray;
begin
  result := POneArray(longint(FMemory)
    + row * FRowMemorysize);
end;

procedure TDTwoArray.FirstCol(col : integer);
begin
  FBrowse := PBaseType(longint(FMemory)
    + col * sizeof(TBasetype));
end;

procedure TDTwoArray.FirstRow(row : integer);
begin
  FBrowse := PBaseType(RowMemory[row]);
end;

procedure TDTwoArray.LastCol(col : integer);
begin
  FBrowse := PBaseType(longint(FMemory)
    + col * sizeof(TBasetype)
    + (FRows-1) * FRowMemorySize );
end;


procedure TDTwoArray.LastRow(row : integer);
begin
  FBrowse := PBaseType(longint(FMemory)
    + (Fcols-1) * sizeof(TBasetype)
    + Row * FRowMemorySize );
end;

procedure TDTwoArray.NextRow;
begin
  inc(longint(FBrowse),FRowMemorySize);
end;

procedure TDTwoArray.PreviousRow;
begin
  dec(longint(FBrowse),FRowMemorySize);
end;

procedure Array2Operator(array1,array2,resultArray : TDTwoArray;
  BaseFunc : TBaseFunc);
var
  i,j : integer;
begin
  if (array1.Cols<>array2.Cols)
  or (array1.Rows<>array2.rows)
  or (array1.Cols<>Resultarray.Cols)
  or (array1.Rows<>Resultarray.rows)
    then raiseOperatorError;
  array1.first;
  array2.first;
  for i:=0 to array1.Rows-1 do
    for j:=0 to array1.cols-1 do
  begin
    { Note : resultarray cannot use browse methods
      because it may be array1 or array2
    }
    resultArray.Values[i,j]:=BaseFunc(array1.pvalue^,array2.pvalue^);
    array1.next;
    array2.next;
  end;
end;

procedure Array2Add(array1,array2,resultArray : TDTwoArray);
begin
  Array2Operator(array1,array2,resultArray,BaseAdd);
end;

procedure Array2Sub(array1,array2,resultArray : TDTwoArray);
begin
  Array2Operator(array1,array2,resultArray,BaseSub);
end;

procedure Array2Mul(array1,array2,resultArray : TDTwoArray);
var
  i,j,k : integer;
  result : TBasetype;
begin
  if (array1.Cols<>array2.rows)
  or (array2.Cols<>Resultarray.Cols)
  or (array1.Rows<>Resultarray.rows)
    then raiseOperatorError;
  resultarray.first;
  for i:=0 to Resultarray.rows-1 do
    for j:=0 to Resultarray.Cols-1 do
  begin
    result := 0;
    array1.firstrow(i);
    array2.firstcol(j);
    for k:=0 to array1.Cols-1 do begin
      result := result + array1.pvalue^ * array2.pvalue^;
      array1.next;
      array2.nextrow;
    end;
    resultarray.pvalue^ := result;
    resultarray.next;
  end;
end;

function  GetArrayMul(array1,array2: TDTwoArray) : TDTwoArray;
begin
  if (array1.Cols<>array2.rows)
    then raiseOperatorError;
  result := TDTwoArray.create(array1.rows,array2.cols);
  Array2Mul(array1,array2,result);
end;

end.
