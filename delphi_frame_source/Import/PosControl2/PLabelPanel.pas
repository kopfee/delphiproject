unit PLabelPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RxCtrls, Extctrls, stdCtrls;

type
  TPLabelPanel = class(TCustomControl)
  private
    { Private declarations }
    FLabel: TRxLabel;
    FPanel: TPanel;
    FSpace: integer;
    //FParentFont: Boolean;
    function GetAlignment : TAlignment;
    function GetBevelInner:TPanelBevel;
    function GetBevelOuter:TPanelBevel;
    function GetBevelWidth:TBevelWidth;
    function GetCaption:TCaption;
    function GetLabelCaption:TCaption;
    function GetLabelFont: TFont;
    function GetPanelFont:TFont;
    //function GetPanelWidth:integer;

    //procedure Paint;override;
    procedure SetAlignment(Value: TAlignment);
    procedure SetBevelInner(Value:TPanelBevel);
    procedure SetBevelOuter(Value:TPanelBevel);
    procedure SetBevelWidth(Value:TBevelWidth);
    procedure SetCaption(Value:TCaption);
    procedure SetLabelCaption(Value:TCaption);
    procedure SetLabelFont(Value: TFont);
    //procedure SetPanelWidth(Value: integer);
    procedure SetPanelFont(Value:TFont);
    //procedure SetParentFont(Value: Boolean);
    procedure UpdateCtrlSizes;
    function  GetCaptionWidth: integer;
    procedure SetCaptionWidth(const Value: integer);
    procedure SetSpace(const Value: integer);
    function  GetLabelAlignment: TAlignment;
    procedure SetLabelAlignment(const Value: TAlignment);
    //map text to the caption of panel
    procedure WMGETTEXTLENGTH(var Message:TMessage); message WM_GETTEXTLENGTH;
    procedure WMGetText(var Message:TMessage); message WM_GetText;
    procedure WMSetText(var Message:TMessage); message WM_SetText;
  protected
    { Protected declarations }

    procedure   SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
  published
    { Published declarations }
    property Alignment: TAlignment read GetAlignment write SetAlignment default taLeftJustify;
    property LabelAlignment: TAlignment read GetLabelAlignment write SetLabelAlignment default taLeftJustify;
    property BevelInner:TPanelBevel read GetBevelInner write SetBevelInner default bvRaised;
    property BevelOuter:TPanelBevel read GetBevelOuter write SetBevelOuter default bvLowered;
    property BevelWidth:TBevelWidth read GetBevelWidth write SetBevelWidth default 2;
    property Caption:TCaption read GetCaption write SetCaption;
    property LabelCaption:TCaption read GetLabelCaption write SetLabelCaption;
    property LabelFont: TFont read GetLabelFont write SetLabelFont;
    //property PanelWidth:integer read GetPanelWidth write SetPanelWidth;
    property PanelFont:TFont read GetPanelFont write SetPanelFont;
    //property ParentFont : Boolean read FParentFont write SetParentFont;
    //property ParentFont;
    property  Space : integer read FSpace write SetSpace default 0;
    property  CaptionWidth : integer read GetCaptionWidth write SetCaptionWidth;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('PosControl2', [TPLabelPanel]);
end;

constructor TPLabelPanel.Create (AOwner: TComponent);
begin
     inherited Create(AOwner);

     FLabel := TRxLabel.Create(Self);
     FLabel.Parent := Self;
     FLabel.ShadowSize := 0;
     FLabel.Layout := tlCenter;
     FLabel.AutoSize := False;
     FLabel.Visible := True;
     FLabel.Font.Size := 9;
     FLabel.Font.Name := 'ËÎÌו';
     FLabel.ParentFont := False;
     FLabel.AlignMent := taLeftJustify;

     FPanel := TPanel.Create(Self);
     FPanel.Parent := Self;
     FPanel.ControlStyle := FPanel.ControlStyle -[csAcceptsControls];
     FPanel.Font.Size := 11;
     FPanel.Font.Name := 'ËÎÌו';
     FPanel.ParentFont := False;
     FPanel.AlignMent := taLeftJustify;

     Height := 20;
     FLabel.Height := Height;
     FPanel.Height := Height;

     Width := 200;
     FPanel.Width := 140;
     FLabel.Width := Width-FPanel.Width;
     FPanel.Left := FLabel.Width;

     BevelInner := bvRaised;
     BevelOuter := bvLowered;
     BevelWidth := 1;
     Alignment := taLeftJustify;
     ParentFont := False;
end;
{
procedure TPLabelPanel.SetParentFont(Value: Boolean);
begin
     inherited;
     FPanel.ParentFont := Value;
     Flabel.ParentFont := Value;
     FParentFont := Value;
end; }

destructor TPLabelPanel.Destroy;
begin
     FPanel.Free;
     FLabel.Free;
     inherited Destroy;
end;

function TPLabelPanel.GetLabelFont: TFont;
begin
     Result := FLabel.Font;
end;

procedure TPLabelPanel.SetLabelFont(Value: TFont);
begin
     FLabel.Font := Value;
end;
{
procedure TPLabelPanel.Paint;
begin
     inherited Paint;
     FLabel.Height := Height;
     FPanel.Height := Height;
     FLabel.Width := Width-FPanel.Width;
     FPanel.Left := FLabel.Width;
end; }

function TPLabelPanel.GetLabelCaption:TCaption;
begin
     Result := FLabel.Caption;
end;

procedure TPLabelPanel.SetLabelCaption(Value:TCaption);
begin
     FLabel.Caption := Value;
end;

function TPLabelPanel.GetCaption:TCaption;
begin
     Result := FPanel.Caption;
end;

procedure TPLabelPanel.SetCaption(Value:TCaption);
begin
     FPanel.Caption := Value;
end;
{
function TPLabelPanel.GetPanelWidth:integer;
begin
     Result := FPanel.Width;
end;

procedure TPLabelPanel.SetPanelWidth(Value: integer);
begin
     FPanel.Width := Value;
     FPanel.Left := Width-Value;
     FLabel.Width := FPanel.Left;
end; }

function TPLabelPanel.GetPanelFont:TFont;
begin
     Result := FPanel.Font;
end;

procedure TPLabelPanel.SetPanelFont(Value:TFont);
begin
     FPanel.Font.Assign(Value);
     //FLabel.Font.Assign(Value);
end;

function TPLabelPanel.GetBevelInner:TPanelBevel;
begin
     Result := FPanel.BevelInner ;
end;

function TPLabelPanel.GetBevelOuter:TPanelBevel;
begin
     Result := FPanel.BevelOuter;
end;

function TPLabelPanel.GetBevelWidth:TBevelWidth;
begin
     Result := FPanel.BevelWidth;
end;

procedure TPLabelPanel.SetBevelInner(Value:TPanelBevel);
begin
     FPanel.BevelInner := Value;
end;

procedure TPLabelPanel.SetBevelOuter(Value:TPanelBevel);
begin
     FPanel.BevelOuter := Value;
end;

procedure TPLabelPanel.SetBevelWidth(Value:TBevelWidth);
begin
     FPanel.BevelWidth := Value;
end;

function TPLabelPanel.GetAlignment : TAlignment;
begin
  Result := FPanel.Alignment;
end;

procedure TPLabelPanel.SetAlignment(Value: TAlignment);
begin
  FPanel.Alignment := value;
end;

procedure TPLabelPanel.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  UpdateCtrlSizes;
end;

procedure TPLabelPanel.UpdateCtrlSizes;
begin
  FLabel.Height := Height;
  {FPanel.Height := Height;
  FPanel.Width := Width-FLabel.Width-FSpace;
  FPanel.Left := FLabel.Width+FSpace;}
  FPanel.SetBounds(FLabel.Width+FSpace,0,Width-FLabel.Width-FSpace,Height);
end;

function TPLabelPanel.GetCaptionWidth: integer;
begin
  result := FLabel.Width;
end;

procedure TPLabelPanel.SetCaptionWidth(const Value: integer);
begin
  FLabel.Width := value;
  UpdateCtrlSizes;
end;

procedure TPLabelPanel.SetSpace(const Value: integer);
begin
  if FSpace <> Value then
  begin
    FSpace := Value;
    UpdateCtrlSizes;
  end;
end;

function TPLabelPanel.GetLabelAlignment: TAlignment;
begin
  result := FLabel.Alignment;
end;

procedure TPLabelPanel.SetLabelAlignment(const Value: TAlignment);
begin
  FLabel.Alignment := Value;
end;

procedure TPLabelPanel.WMGetText(var Message: TMessage);
begin
  FPanel.Dispatch(Message);
end;

procedure TPLabelPanel.WMSetText(var Message: TMessage);
begin
  FPanel.Dispatch(Message);
  Invalidate;
end;

procedure TPLabelPanel.WMGETTEXTLENGTH(var Message: TMessage);
begin
  FPanel.Dispatch(Message);
end;

end.

