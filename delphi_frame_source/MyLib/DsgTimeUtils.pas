unit DsgTimeUtils;

interface

uses Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms,dsgnintf,TypInfo,XForms,FrtEndLog;

type
  TStartPropEditor=class
  private
    FComponents: TComponentList;
    FDesigner: IFormDesigner;
    FPropName: string;
    FComponent: TComponent;
    FFilter: TTypeKinds;
    procedure   HandleEditor(Prop: TPropertyEditor);
  public
    constructor Create(ADesigner : IFormDesigner;
      AComponent : TComponent;
      APropName : string;
      AFilter: TTypeKinds);
    destructor  destroy; override;
    property    Designer : IFormDesigner read FDesigner;
    property    Component : TComponent read FComponent;
    property    PropName : string read FPropName;
    property    Filter: TTypeKinds read FFilter;
    procedure   Start;
  end;

implementation

{ TStartPropEditor }

constructor TStartPropEditor.Create(ADesigner: IFormDesigner;
  AComponent: TComponent; APropName: string; AFilter: TTypeKinds);
begin
  inherited Create;
  FDesigner :=  ADesigner;
  FComponent := AComponent;
  FPropName :=  APropName;
  FFilter :=  AFilter;
  FComponents:= TComponentList.Create;
  FComponents.Add(FComponent);
end;

destructor TStartPropEditor.destroy;
begin
  FComponents.free;
  inherited destroy;
end;

procedure TStartPropEditor.Start;
begin
  GetComponentProperties(FComponents,
    FFilter,
    FDesigner,
    HandleEditor);
end;

procedure TStartPropEditor.HandleEditor(Prop: TPropertyEditor);
begin
  try
    if CompareText(Prop.GetName,FPropName)=0 then
      Prop.Edit;
  finally
    Prop.Free;
  end;
end;

end.
