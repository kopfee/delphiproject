unit UTools;

interface

uses SysUtils, Classes, Controls, RPCtrls, IntfUtils, checklst;

function  GetDesignObjectName(Obj : TObject; const DefaultName : string='') : string;

type
  TGetDesignObjectNameFunc = function  (Obj : TObject; const DefaultName : string='') : string;

var
  GetDesignObjectNameFunc : TGetDesignObjectNameFunc;

type
  ISimpleSelection = interface
    function  GetCount : Integer;
    function  GetSelectedComponent(Index : Integer) : TComponent;
    function  Checked(Index : Integer) : Boolean;
  end;

  ISelection = interface(ISimpleSelection)
    procedure ClearSelection;
    procedure AddSelected;
    procedure RemoveSelected;
    procedure AddSelectedComponent(Comp : TComponent);
    procedure RemoveSelectedComponent(Comp : TComponent);
  end;

  TSimpleSelectionForCheckListBox = class(TVCLDelegateObject)
  private
    FCheckListBox : TCheckListBox;
  public
    constructor Create(AOwner : TObject; ACheckListBox : TCheckListBox);
    function    GetCount : Integer;
    function    GetSelectedComponent(Index : Integer) : TComponent;
    function    Checked(Index : Integer) : Boolean;
  end;

  TEnumCompProc = procedure (AComponent : TComponent; Extra1 : Pointer; Extra2 : Pointer);
  TEnumCompProc2 = procedure (AComponent : TComponent; Extra1 : Pointer; Extra2 : Pointer) of object;

procedure EnumComponent(const Selection : ISimpleSelection;
  ComponentClass : TComponentClass;
  Proc : TEnumCompProc;
  Extra1 : Pointer;
  Extra2 : Pointer); overload;

procedure EnumComponent(const Selection : ISimpleSelection;
  ComponentClass : TComponentClass;
  Proc : TEnumCompProc2;
  Extra1 : Pointer;
  Extra2 : Pointer); overload;

procedure LinkControls(const Selection : ISimpleSelection; AStyle : TRDPosLinkStyle);

procedure CopySelectionToClipboard(const Selection : ISimpleSelection);

var
  DesignSelection : ISelection = nil;

implementation

uses CompUtils;

function  GetDesignObjectName(Obj : TObject; const DefaultName : string='') : string;
begin
  Assert(Obj<>nil);
  if Assigned(GetDesignObjectNameFunc) then
    Result := GetDesignObjectNameFunc(Obj,DefaultName)
  else if Obj is TControl then
    Result := GetCtrlName(TControl(Obj),DefaultName)
  else
    Result := Obj.ClassName;
end;

procedure EnumComponent(const Selection : ISimpleSelection;
  ComponentClass : TComponentClass;
  Proc : TEnumCompProc;
  Extra1 : Pointer;
  Extra2 : Pointer); overload;
var
  I : Integer;
  Count : Integer;
  Comp : TComponent;
begin
  if Selection<>nil then
  begin
    Count := Selection.GetCount;
    for I:=0 to Count-1 do
      if Selection.Checked(I) then
      begin
        Comp := Selection.GetSelectedComponent(I);
        if Comp is TComponentClass then
          Proc(Comp, Extra1, Extra2);
      end;
  end;
end;

procedure EnumComponent(const Selection : ISimpleSelection;
  ComponentClass : TComponentClass;
  Proc : TEnumCompProc2;
  Extra1 : Pointer;
  Extra2 : Pointer); overload;
var
  I : Integer;
  Count : Integer;
  Comp : TComponent;
begin
  if Selection<>nil then
  begin
    Count := Selection.GetCount;
    for I:=0 to Count-1 do
      if Selection.Checked(I) then
      begin
        Comp := Selection.GetSelectedComponent(I);
        if Comp is TComponentClass then
          Proc(Comp, Extra1, Extra2);
      end;
  end;
end;


procedure DoLinkCtrl(AComponent : TComponent; Extra1 : Pointer; Extra2 : Pointer);
var
  RDCtrl, LastCtrl, LinkCtrl : TRDCustomControl;
  AStyle: TRDPosLinkStyle;
begin
  LastCtrl := TRDCustomControl(Extra1^);
  RDCtrl := TRDCustomControl(AComponent);
  AStyle := TRDPosLinkStyle(Extra2);
  if AStyle=lsNone then
    LinkCtrl := nil else
    LinkCtrl := LastCtrl;
  if LastCtrl<>nil then
    RDCtrl.Link.SetValue(AStyle,LinkCtrl)
  else if AStyle=lsNone then
    RDCtrl.Link.SetValue(AStyle,nil);
  TRDCustomControl(Extra1^) := RDCtrl;
end;

procedure LinkControls(const Selection : ISimpleSelection; AStyle : TRDPosLinkStyle);
var
  LastCtrl : TRDCustomControl;
begin
  LastCtrl := nil;
  EnumComponent(Selection, TRDCustomControl, DoLinkCtrl, @LastCtrl, Pointer(AStyle));
end;

procedure DoCopy(AComponent : TComponent; Extra1 : Pointer; Extra2 : Pointer);
var
  List : TList;
begin
  List := TList(Extra1);
  List.Add(AComponent);
end;

procedure CopySelectionToClipboard(const Selection : ISimpleSelection);
var
  List : TList;
begin
  List := TList.Create;
  try
    EnumComponent(Selection,TComponent,DoCopy,Pointer(List),nil);
    if List.Count>0 then
      CopyComponents(TComponent(List[0]).Owner,List);
  finally
    List.Free;
  end;
end;

{ TSimpleSelectionForCheckListBox }

constructor TSimpleSelectionForCheckListBox.Create(AOwner: TObject;
  ACheckListBox: TCheckListBox);
begin
  Assert(ACheckListBox<>nil);
  inherited Create(AOwner);
  FCheckListBox := ACheckListBox;
end;

function TSimpleSelectionForCheckListBox.Checked(Index: Integer): Boolean;
begin
  Result := FCheckListBox.Checked[Index];
end;

function TSimpleSelectionForCheckListBox.GetCount: Integer;
begin
  Result := FCheckListBox.Items.Count;
end;

function TSimpleSelectionForCheckListBox.GetSelectedComponent(
  Index: Integer): TComponent;
begin
  Result := TComponent(FCheckListBox.Items.Objects[Index]);
end;

end.
