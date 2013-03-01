unit CompEditors;

{$I KSConditions.INC }

interface

procedure Register;

implementation

uses windows,sysutils,classes,forms,u_dlgAddComp,compItems,CompGroup
{$ifdef VCL60_UP }
  ,DesignIntf, DesignEditors
{$else}
  ,dsgnintf
{$endif}
  ;


type
  TComponentGroupEditor = class(TComponentEditor)
  private

  protected

  public
    function  GetVerbCount: Integer; override;
    function  GetVerb(Index: Integer): string;override;
    procedure ExecuteVerb(Index: Integer); override;
  published

  end;

{ TComponentGroupEditor }

procedure TComponentGroupEditor.ExecuteVerb(Index: Integer);
var
  CompClassName : String;
  i : integer;
  CompCollect : TComponentCollection;
begin
  if index=0 then
  begin
    CompClassName := '';
    if QueryAddComponents(CompClassName) then
      if (CompClassName<>'') and (Component.owner<>nil) then
        //with Component as TComponentGroup do
        begin
          CompCollect := (Component as TComponentGroup).Components;
          for i:=0 to Component.owner.ComponentCount-1 do
            if Component.owner.Components[i].ClassNameIs(CompClassName) then
            begin
              CompCollect.AddComponent(Component.owner.Components[i]);
            end;
        end;
  end
  else
    inherited ExecuteVerb(Index);
end;

function TComponentGroupEditor.GetVerb(Index: Integer): string;
begin
  if index=0 then
    result := 'Add components';
end;

function TComponentGroupEditor.GetVerbCount: Integer;
begin
  result := 1;
end;

procedure Register;
begin
  //application.messageBox('registered.','Information',MB_OK);
  RegisterComponentEditor(TComponentGroup,
      TComponentGroupEditor);
end;

end.
