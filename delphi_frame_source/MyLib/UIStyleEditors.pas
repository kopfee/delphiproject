unit UIStyleEditors;

{$I KSConditions.INC }

interface

uses sysUtils,classes, TypInfo, UIStyles, ImagesMan
  {$ifdef VCL60_UP }
    ,DesignIntf, DesignEditors
  {$else}
    ,dsgnintf
  {$endif}
;

type
  TItemNameProperty = class(TStringProperty)
  private
    FItemClass: TUICustomStyleItemClass;
  public
    //procedure Initialize; override; must set FItemClass here
    property  ItemClass : TUICustomStyleItemClass read FItemClass;
    function  GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TStyleItemNameProperty = class(TItemNameProperty)
  public
    procedure Initialize; override;
  end;

  TCommandNameProperty = class(TItemNameProperty)
  public
    procedure Initialize; override;
  end;

  TImageStyleNameProperty = class(TItemNameProperty)
  public
    procedure Initialize; override;
  end;

  (*
  TStylesEditor = class(TUseDefaultPropertyEditor)
  protected
    procedure   Init; override;
  end;
  *)
implementation

{ TItemNameProperty }

function TItemNameProperty.GetAttributes: TPropertyAttributes;
begin
  result := (inherited GetAttributes) + [paValueList];
end;

procedure TItemNameProperty.GetValues(Proc: TGetStrProc);
var
  i,j : integer;
  Style : TUICustomStyle;
begin
  if (UIStyleManager<>nil) and not (GetComponent(0) is TUICustomStyleItem) then
  for i:=0 to UIStyleManager.Styles.count-1 do
  begin
    Style := TUICustomStyle(UIStyleManager.Styles[i]);
    if Style.Active and Style.GetItemClass.InheritsFrom(ItemClass) then
      for j:=0 to Style.Items.count-1 do
        Proc(TUIStyleItem(Style.Items.items[j]).Name);
  end;
end;

{ TStyleItemNameProperty }

procedure TStyleItemNameProperty.Initialize;
begin
  inherited;
  FItemClass :=TUIStyleItem;
end;

{ TCommandNameProperty }

procedure TCommandNameProperty.Initialize;
begin
  inherited;
  FItemClass := TCommandImage;
end;

(*
{ TStylesEditor }

procedure TStylesEditor.Init;
begin
  FPropName := 'Items';
  FMenuCaption := 'Edit Items...';
end;
*)
{ TImageStyleNameProperty }

procedure TImageStyleNameProperty.Initialize;
begin
  inherited;
  FItemClass := TUIImageItem;
end;

end.
