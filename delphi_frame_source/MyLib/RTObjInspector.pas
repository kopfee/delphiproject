unit RTObjInspector;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ZPropLst, ObjStructViews, ExtCtrls;

type
  TObjectInspector = class(TFrame)
    Splitter1: TSplitter;
    StructView: TObjStructViews;
    Properties: TZPropList;
    procedure   StructViewSelectedChanged(Sender: TObject);
  private
    FOnSelectedChanged: TNotifyEvent;
    { Private declarations }
    function    GetRoot: TObject;
    function    GetSelected: TObject;
    procedure   SetRoot(const Value: TObject);
    procedure   SetSelected(const Value: TObject);
  protected
    procedure   SelectedChanged; virtual;
  public
    { Public declarations }
    procedure   AddObject(Obj : TObject);
    property    Root : TObject read GetRoot write SetRoot;
    property    Selected : TObject read GetSelected write SetSelected;
  published
    property    OnSelectedChanged : TNotifyEvent read FOnSelectedChanged write FOnSelectedChanged;
  end;

implementation

uses ZPEdits, PicEdit, DsgnIntf;

{$R *.DFM}

{ TObjectInspector }

procedure TObjectInspector.AddObject(Obj: TObject);
begin
  StructView.AddObject(Obj);
end;

function TObjectInspector.GetRoot: TObject;
begin
  Result := StructView.Root;
end;

function TObjectInspector.GetSelected: TObject;
begin
  Result := Properties.CurObj;
end;

procedure TObjectInspector.SelectedChanged;
begin
  if Assigned(FOnSelectedChanged) then
    FOnSelectedChanged(Self);
end;

procedure TObjectInspector.SetRoot(const Value: TObject);
begin
  StructView.Root := Value;
  if Value is TComponent then
    Properties.Root := TComponent(Value) else
    Properties.Root := nil;
end;

procedure TObjectInspector.SetSelected(const Value: TObject);
begin
  if Selected<>Value then
  begin
    Properties.CurObj := Value;
    StructView.Selected := Value;
    SelectedChanged;
  end;
end;

procedure TObjectInspector.StructViewSelectedChanged(Sender: TObject);
begin
  Selected := StructView.Selected;
end;

initialization
  RegisterPropertyEditor(TypeInfo(TPicture),nil,'',TPictureProperty);
end.

