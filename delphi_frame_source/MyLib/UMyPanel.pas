unit UMyPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TChildPanel = class(TCustomPanel)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
  published
    { Published declarations }
    property    Caption;
    property    Visible;
  end;

  TMyPanel = class(TPanel)
  private
    { Private declarations }
    FChild : TChildPanel;
    function GetChildVisible: Boolean;
    procedure SetChildVisible(const Value: Boolean);
    function GetChildCaption: string;
    procedure SetChildCaption(const Value: string);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
  published
    { Published declarations }
    property    ChildVisible : Boolean read GetChildVisible write SetChildVisible stored false;
    property    ChildCaption : string read GetChildCaption write SetChildCaption  stored false;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TMyPanel]);
end;

{ TChildPanel }

constructor TChildPanel.Create(AOwner: TComponent);
begin
  inherited;
  Align := alBottom;
  //Height := Parent.Height div 2;
  ControlStyle := ControlStyle + [csNoDesignVisible];
end;

{ TMyPanel }

constructor TMyPanel.Create(AOwner: TComponent);
begin
  inherited;
  FChild := TChildPanel.Create(Self);
  FChild.Parent := self;
  FChild.Height := Height div 2;
end;

destructor TMyPanel.Destroy;
begin
  //FChild.Free;
  inherited;
end;

function TMyPanel.GetChildCaption: string;
begin
  Result := FChild.Caption;
end;

function TMyPanel.GetChildVisible: Boolean;
begin
  Result := FChild.Visible;
end;

procedure TMyPanel.SetChildCaption(const Value: string);
begin
  FChild.Caption := Value;
end;

procedure TMyPanel.SetChildVisible(const Value: Boolean);
begin
  FChild.Visible := Value;
end;

initialization
  RegisterClass(TChildPanel);
end.
