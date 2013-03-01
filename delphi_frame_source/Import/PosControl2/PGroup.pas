unit PGroup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, extctrls;

type

 { TPCheckGroup }

  TPCheckGroup = class(TCustomGroupBox)
  private
    { Private declarations }
    FEnable : TStrings;
    FTitle : TCheckBox;
  protected
    { Protected declarations }
    function GetChecked:Boolean;
    function GetTitle:TCaption;

    procedure Change(Sender: TObject);
    procedure Loaded;override;
    procedure Paint;override;
    procedure SetChecked(Value: Boolean);
    procedure SetTitle(Value: TCaption);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Align;
    property Title:TCaption read GetTitle write SetTitle;
    property Checked:Boolean read GetChecked write SetChecked;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

 { TPRadioGroup }

  TPRadioGroup = class(TCustomGroupBox)
  private
    { Private declarations }
    FEnable : TStrings;
    FTitle : TRadioButton;
    FPanel : TPanel;
  protected
    { Protected declarations }
    function GetChecked:Boolean;
    function GetTitle:TCaption;

    procedure Change(Sender: TObject);
    procedure Loaded;override;
    procedure Paint;override;
    procedure SetTitle(Value: TCaption);
    procedure SetChecked(Value: Boolean);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Align;
    property Title:TCaption read GetTitle write SetTitle;
    property Checked:Boolean read GetChecked write SetChecked;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

procedure Register;

implementation

uses
  PRadioButton;

 { TPCheckGroup }

constructor TPCheckGroup.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);

     FTitle := TCheckBox.Create(Self);
     FTitle.Parent := Self;
     FTitle.Caption := '';
     FTitle.Left := 10;
     FTitle.Top := 0;
     FTitle.Width := 24;
     FTitle.Font.Size := 11;
     FTitle.Font.Name := 'ËÎÌו';
     FEnable := TStringList.Create;
     self.Font.Size := 11;
     Self.Font.Name := 'ËÎÌו';
     self.ParentColor := False;
end;

destructor TPCheckGroup.Destroy;
var i: integer;
begin
     FEnable.Free;
     FTitle.OnClick := nil;
     FTitle.Free;
     inherited Destroy;
end;

procedure TPCheckGroup.Loaded;
begin
     inherited Loaded;
     if not (csDesigning in ComponentState) then
     begin
          if not Checked then
             Change(FTitle);
          FTitle.OnClick := Change;
     end;
end;

function TPCheckGroup.GetTitle:TCaption;
begin
     Result := FTitle.Caption;
end;

procedure TPCheckGroup.SetTitle(Value: TCaption);
begin
     if Value <> FTitle.Caption then
     begin
          FTitle.Caption := Value;
          FTitle.Width := Canvas.TextWidth(Value)+24;
          FTitle.Height := Canvas.TextHeight('0');
     end;
end;

function TPCheckGroup.GetChecked:Boolean;
begin
     Result := FTitle.Checked;
end;

procedure TPCheckGroup.SetChecked(Value: Boolean);
begin
     if Value <> FTitle.Checked then
        FTitle.Checked := Value;
end;

procedure TPCheckGroup.Paint;
begin
     Caption := '';
     FTitle.Height := Canvas.TextHeight('0');
     inherited Paint;
end;

procedure TPCheckGroup.Change(Sender: TObject);
var i: integer;
begin
     if FTitle.Checked then
     begin
          for i := 0 to ControlCount-1 do
          begin
               if Controls[i] <> FTitle then
               begin
                    if FEnable.IndexOfObject(Controls[i])<>-1 then
                       Controls[i].Enabled := True
                    else
                        Controls[i].Enabled := False;
               end;
          end;
          FEnable.Clear;
     end
     else
     begin
          FEnable.Clear;
          for i := 0 to ControlCount-1 do
          begin
               if Controls[i] <> FTitle then
               begin
                    if Controls[i].Enabled then
                       FEnable.AddObject('',Controls[i]);
                    Controls[i].Enabled := False;
               end;
          end;
     end;
end;

 { TPRadioGroup }

constructor TPRadioGroup.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);

     FPanel := TPanel.Create(Self);
     FPanel.Parent := Self;
     FPanel.Left := 10;
     FPanel.Top := 0;
     FPanel.Width := 24;

     FTitle := TRadioButton.Create(Self);
     FTitle.Parent := FPanel;
     FTitle.Caption := '';
     FTitle.Left := 0;
     FTitle.Top := 0;
     FTitle.Width := FPanel.Width;

     FEnable := TStringList.Create;
end;

destructor TPRadioGroup.Destroy;
begin
     FEnable.Free;
     FTitle.OnClick := nil;
     FTitle.Free;
     FPanel.Free;
     inherited Destroy;
end;

procedure TPRadioGroup.Loaded;
begin
     inherited Loaded;
     if not (csDesigning in ComponentState) then
     begin
          if not Checked then
          Change(FTitle);
          FTitle.OnClick := Change;
     end;
end;

function TPRadioGroup.GetTitle:TCaption;
begin
     Result := FTitle.Caption;
end;

procedure TPRadioGroup.SetTitle(Value: TCaption);
begin
     if Value <> FTitle.Caption then
     begin
          FTitle.Caption := Value;
          FPanel.Width := Canvas.TextWidth(Value)+24;
          FTitle.Width := FPanel.Width;
          FPanel.Height := Canvas.TextHeight('0');
          FTitle.Height := FPanel.Height;
     end;
end;

function TPRadioGroup.GetChecked:Boolean;
begin
     Result := FTitle.Checked;
end;

procedure TPRadioGroup.SetChecked(Value: Boolean);
var i: integer;
begin
     if Value <> FTitle.Checked then
     begin
          FTitle.Checked := Value;
          if (not Value) and Assigned(FTitle.OnClick) then Change(Self);
          if not (csLoading in ComponentState) and (csDesigning in ComponentState) then
          begin
               if Value then
               begin
                    for i := 0 to Parent.ControlCount-1 do
                    begin
                         if (Parent.Controls[i] is TPRadioGroup) and (Parent.Controls[i] <> Self) then
                         begin
                              if (Parent.Controls[i] as TPRadioGroup).Checked then
                                 (Parent.Controls[i] as TPRadioGroup).Checked := False;
                         end
                         else
                             if (Parent.Controls[i] is TPRadioButton) then
                             begin
                                  if (Parent.Controls[i] as TPRadioButton).Checked then
                                     (Parent.Controls[i] as TPRadioButton).Checked := False;
                             end;
                    end;
               end;
          end;
     end;
end;

procedure TPRadioGroup.Paint;
begin
     Caption := '';
     FPanel.Height := Canvas.TextHeight('0');
     FTitle.Height := FPanel.Height;
     inherited Paint;
end;

procedure TPRadioGroup.Change(Sender: TObject);
var i: integer;
begin
     if FTitle.Checked then
     begin
          for i := 0 to ControlCount-1 do
          begin
               if (Controls[i] <> FTitle) and (Controls[i] <> FPanel) then
               begin
                    if FEnable.IndexOfObject(Controls[i])<>-1 then
                       Controls[i].Enabled := True
                    else
                    Controls[i].Enabled := False;
               end;
          end;
          for i := 0 to Parent.ControlCount-1 do
          begin
               if (Parent.Controls[i] is TPRadioGroup) and (Parent.Controls[i] <> Self) then
               begin
                    if (Parent.Controls[i] as TPRadioGroup).Checked then
                       (Parent.Controls[i] as TPRadioGroup).Checked := False;
               end
               else
                   if (Parent.Controls[i] is TPRadioButton) then
                   begin
                        if (Parent.Controls[i] as TPRadioButton).Checked then
                           (Parent.Controls[i] as TPRadioButton).Checked := False;
                   end;
          end;
          FEnable.Clear;
     end
     else
     begin
          FEnable.Clear;
          for i := 0 to ControlCount-1 do
          begin
               if (Controls[i] <> FTitle) and (Controls[i] <> FPanel) then
               begin
                    if Controls[i].Enabled then
                       FEnable.AddObject('',Controls[i]);
                    Controls[i].Enabled := False;
               end;
          end;
     end;
end;


procedure Register;
begin
     RegisterComponents('PosControl2', [TPCheckGroup]);
     RegisterComponents('PosControl2', [TPRadioGroup]);
end;

end.
