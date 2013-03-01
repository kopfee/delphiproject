unit PPageControl;

{$DEFINE hyl}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, PBevel;

type
  TPPageControl = class(TPageControl)
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure Change; override;
    procedure InternalChange;
    procedure Loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure SelectPage(APage: TTabSheet);
  published
    { Published declarations }
    property Align default alClient;
  end;

procedure Register;

implementation

constructor TPPageControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Align := alClient;
end;

procedure TPPageControl.SelectPage(APage: TTabSheet);
begin
  ActivePage := APage;
  InternalChange;
end;

procedure TPPageControl.Loaded;
var
  i: integer;
begin
  inherited Loaded;
  for i := 0 to PageCount-1 do
    if csDesigning in ComponentState then
      Pages[i].TabVisible := True
    else
      Pages[i].TabVisible := False;
  InternalChange;
end;

procedure TPPageControl.Change ;
begin
  inherited Change;
  InternalChange;
end;

{$ifndef hyl}

procedure TPPageControl.InternalChange;
var i: integer;
    deltax, deltay: integer;
    tmpBevel : TPBevel;
    tmpForm : TForm;
begin
  with ActivePage do
  begin
     tmpForm := TForm(Owner);

     for i := 0 to ControlCount-1 do
      if Controls[i] is TPBevel then
      begin
        tmpBevel := TPBevel(Controls[i]);
        deltax := Width-2*tmpBevel.Left-tmpBevel.Width;
        deltay := Height-2*tmpBevel.Top-tmpBevel.Height;
        tmpForm.Width := tmpForm.Width-deltax;
        tmpForm.Height := tmpForm.Height-deltay;
        break;
      end;

     TForm(tmpForm).Position := poScreenCenter;
     tmpForm.Refresh;
  end;
end;

{$else}

procedure TPPageControl.InternalChange;
var
   i: integer;
    //deltax, deltay: integer;
    tmpBevel : TPBevel;
    tmpForm : TForm;
    x,y,w,h : integer;
    Found : boolean;
begin
  with ActivePage do
  begin
     tmpForm := TForm(Owner);
     Found := false;
     for i := 0 to ControlCount-1 do
      if Controls[i] is TPBevel then
      begin
        tmpBevel := TPBevel(Controls[i]);
        w:=tmpBevel.width+tmpForm.width-width;
        h:=tmpBevel.height+tmpForm.height-height;
        Found := true;
        break;
      end;

     if found then
     begin
       if csDesigning in componentState then
       begin
         x:=tmpForm.left;
         y:=tmpForm.Top;
       end
       else
       begin
         x:=(screen.width-w)div 2;
         y:=(screen.height-h)div 2;
       end;

       tmpForm.setBounds(x,y,w,h);
       //TForm(tmpForm).Position := poScreenCenter;
       //tmpForm.Refresh;
     end;
  end;
end;

{$endif}

procedure Register;
begin
  RegisterComponents('PosControl', [TPPageControl]);
end;

end.
