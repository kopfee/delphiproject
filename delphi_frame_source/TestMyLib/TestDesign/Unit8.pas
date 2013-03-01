unit Unit8;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Design, StdCtrls, ExtCtrls, Buttons;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Designer1: TDesigner;
    Label1: TLabel;
    lbCtrl: TLabel;
    btnNormal: TSpeedButton;
    btnLabel: TSpeedButton;
    btnButton: TSpeedButton;
    btnPanel: TSpeedButton;
    btnEdit: TSpeedButton;
    cbDesign: TCheckBox;
    procedure Designer1DesignCtrlChanged(DesignCtrl: TControl);
    procedure btnLabelClick(Sender: TObject);
    procedure btnButtonClick(Sender: TObject);
    procedure Designer1PlaceNewCtrl(PlaceOn: TWinControl; x, y: Integer);
    procedure btnNormalClick(Sender: TObject);
    procedure btnPanelClick(Sender: TObject);
    procedure Designer1Delete(DeleteCtrl: TControl);
    procedure cbDesignClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
  private
    { Private declarations }
    NewCtrlClass : TControlClass;
    count : integer;
  public
    { Public declarations }
    procedure NewCtrl(CtrlClass : TControlClass);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses TypUtils;

procedure TForm1.Designer1DesignCtrlChanged(DesignCtrl: TControl);
var
  s:string;
begin
  if DesignCtrl=nil then lbCtrl.Caption:='nil'
 	else
  begin
  	s:='';
    if GetStringProperty(DesignCtrl,'Caption',s) then
	    lbCtrl.Caption:=DesignCtrl.ClassName + ':' + s
    else  lbCtrl.Caption:=DesignCtrl.ClassName;
  end;
end;

procedure TForm1.btnLabelClick(Sender: TObject);
begin
  NewCtrl(TLabel);
end;

procedure TForm1.btnButtonClick(Sender: TObject);
begin
  NewCtrl(TButton);
end;

procedure TForm1.NewCtrl(CtrlClass: TControlClass);
begin
  NewCtrlClass := CtrlClass;
  Designer1.PlaceNewCtrl := true;
  if not Designer1.PlaceNewCtrl then btnNormal.down := true;
end;

procedure TForm1.Designer1PlaceNewCtrl(PlaceOn: TWinControl; x,
  y: Integer);
var
  Ctrl : TControl;
begin
  Ctrl:=NewCtrlClass.Create(self);
  ctrl.left := x;
  ctrl.Top := y;
  inc(count);
  SetStringProperty(ctrl,'Caption',IntToStr(count));
  ctrl.parent := PlaceOn;
  btnNormal.down := true;
end;

procedure TForm1.btnNormalClick(Sender: TObject);
begin
  Designer1.PlaceNewCtrl := false;
end;

procedure TForm1.btnPanelClick(Sender: TObject);
begin
  NewCtrl(TPanel);
end;

procedure TForm1.Designer1Delete(DeleteCtrl: TControl);
begin
  if not (DeleteCtrl is TWinControl)
  	or ((DeleteCtrl as TWinControl).controlCount=0)
  then DeleteCtrl.free;
end;

procedure TForm1.cbDesignClick(Sender: TObject);
begin
  Designer1.Designed := cbDesign.Checked;
end;

procedure TForm1.btnEditClick(Sender: TObject);
begin
  NewCtrl(TEdit);
end;

end.
