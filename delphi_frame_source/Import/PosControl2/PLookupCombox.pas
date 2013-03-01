unit PLookupCombox;

interface

uses
  Windows,  Messages, SysUtils, Classes, Graphics, Controls, Forms,     Dialogs,
  stdctrls, dbtables, extctrls, RxCtrls, dbctrls,  db,       SelectDlg, PLabelPanel,
  buttons, LookupControls;

type
  TPLookupCombox = class(TPLookupControl)
  private
    { Private declarations }
    FCompanyList: TStrings;
    FComboBox: TComboBox;
    //FParentFont: Boolean;
  protected
    { Protected declarations }
    function FindCurrent(var LabelText: string):Boolean;override;
    {function GetComboBoxFont:TFont;
    function GetComboBoxWidth:integer;
    function GetLabelFont: TFont;}
    function GetRdOnly:Boolean; override;
    function GetText:string;override;

    //procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure ControlEnter(Sender: TObject);override;
    procedure FillComboBox;
    procedure Loaded;override;
    //procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    //procedure Paint;override;
    procedure SetActive(Value: Boolean);override;
    {procedure SetComboBoxFont(Value: TFont);
    procedure SetComboBoxWidth(Value: integer);}
    procedure SetFilter(Value: string);override;
    //procedure SetLabelFont(Value: TFont);
    procedure SetLookField(Value: string);override;
    procedure SetLookSubField(Value: string);override;
    //procedure SetParentFont(Value: Boolean);override;
    procedure SetRdOnly(Value: Boolean);
    procedure SetText(Value : string);override;
    procedure   CreateEditCtrl; override;
  public
     { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
  published
    property Active;
    property Caption;
    {property ComboBoxFont:TFont read GetComboBoxFont write SetComboBoxFont;
    property ComboBoxWidth:integer read GetComboBoxWidth write SetComboBoxWidth;}
    property DatabaseName;
    property Filter;
    property KeyField;
    //property LabelFont: TFont read GetLabelFont write SetLabelFont;
    property LabelStyle;
    property ListField;
    property ListFieldControl;
    property RdOnly: Boolean read GetRdOnly write SetRdOnly;
    //property ParentFont : Boolean read FParentFont write SetParentFont;
    property TableName;
    property TabOrder;
    property TabStop;
  end;

procedure Register;

implementation

function TPLookupCombox.GetRdOnly:Boolean;
begin
     Result := not FComboBox.Enabled;
end;

procedure TPLookupCombox.SetRdOnly(Value: Boolean);
begin
     FComboBox.Enabled := not Value;
     if Value then
        FComboBox.Color := clSilver
     else
         FComboBox.Color := clWhite;
end;
{
function TPLookupCombox.GetComboBoxWidth:integer;
begin
     Result := FComboBox.Width;
end;

procedure TPLookupCombox.SetComboBoxWidth(Value: integer);
begin
     FComboBox.Width := Value;
     FComboBox.Left := Width-Value;
     FLabel.Width := FComboBox.Left;
end;

function TPLookupCombox.GetLabelFont: TFont;
begin
     Result := FLabel.Font;
end;

procedure TPLookupCombox.SetLabelFont(Value: TFont);
begin
     FLabel.Font := Value;
end;

function TPLookupCombox.GetComboBoxFont:TFont;
begin
     Result := FComboBox.Font;
end;

procedure TPLookupCombox.SetComboBoxFont(Value: TFont);
begin
     FComboBox.Font.Assign(Value);
     FLabel.Font.Assign(Value);
     FLabel.Height := FComboBox.Height;
     Height := FComboBox.Height;
     SetLabelStyle(LabelStyle);
end; }

procedure TPLookupCombox.FillComboBox;
begin
     FComboBox.Items.Clear;
     FCompanyList.Clear;
     if not FQuery.IsEmpty then
     begin
          FQuery.First;
          while not FQuery.EOF do
          begin
               FCompanyList.Add(FQuery.FieldByName(FKeyField).AsString);
               if FListField <> '' then
                  FComboBox.Items.Add(FQuery.FieldByName(FListField).AsString)
               else
                   FCompanyList.Add('');
               FQuery.Next;
          end;
     end;
end;
{
procedure TPLookupCombox.Paint;
begin
     FLabel.Height := FComboBox.Height;
     Height := FComboBox.Height;
     FComboBox.Left := Width-FComboBox.Width;
     FLabel.Width := FComboBox.Left;
     SetLabelStyle(LabelStyle);
     inherited Paint;
end; }

procedure TPLookupCombox.Loaded;
begin
     inherited Loaded;
     if Active then
        FillComboBox;
end;

procedure TPLookupCombox.SetActive(Value: Boolean);
begin
     if csLoading in ComponentState then
        FActive := Value
     else
     if Value <> FActive then
     begin
          if Value then
          begin
               OpenQuery;
               FillComboBox;
          end
          else
          begin
               FComboBox.Items.Clear;
               FCompanyList.Clear;
          end;
          FActive := Value;
     end;
end;

procedure TPLookupCombox.SetText(Value : string);
begin
     if FComboBox.Text <> Value then
     begin
        FComboBox.Text := Value;
        controlchange(self);
     end;
end;

function TPLookupCombox.GetText: string;
begin
     Result := FComboBox.Text;
end;

procedure TPLookupCombox.SetLookField(Value: string);
begin
     if FKeyField <> Value then
     begin
          FKeyField := Value;
          if (not (csLoading in ComponentState)) and FActive then
          FillComboBox;
     end;
end;

procedure TPLookupCombox.SetLookSubField(Value: string);
begin
     if FListField <> Value then
     begin
          FListField := Value;
          if (not (csLoading in ComponentState)) and FActive then
          FillComboBox;
     end;
end;

procedure TPLookupCombox.SetFilter(Value: string);
begin
     if FFilter <> Value then
     begin
          inherited SetFilter(Value);
          FillComboBox;
     end;
end;

function TPLookupCombox.FindCurrent(var LabelText: string):Boolean;
var  idx: integer;
begin
     with FComboBox do
     begin
          idx := Items.IndexOf(Text);
          if idx >= 0 then
          begin
               Result := True;
               LabelText := text;
               Text := FCompanyList.Strings[idx];
          end
          else
          begin
               Result := False;
               LabelText := '';
          end;
     end;
end;

procedure TPLookupCombox.ControlEnter(Sender: TObject);
begin
 {    if Active then
     begin
          inherited ControlEnter(Sender);
          FillComboBox;
     end; }
  inherited ControlEnter(Sender);
  if Active then FillComboBox;
end;

constructor TPLookupCombox.Create (AOwner: TComponent);
begin
     inherited Create(AOwner);
     {FComboBox := TComboBox.Create(Self);
     FComboBox.Parent := Self;
     FComboBox.Visible := True;
     FComboBox.Font.Size := 9;
     FComboBox.Font.Name := 'ËÎÌו';
     FComboBox.ParentFont := False;
     FComboBox.OnChange := ControlChange;
     FComboBox.OnEnter := ControlEnter;
     FComboBox.OnExit := ControlExit;

     FLabel.FocusControl := FComboBox;

     FLabel.Height := FComboBox.Height;
     Height := FComboBox.Height;

     FLabel.Width := 60;
     FComboBox.Width :=120;
     FComboBox.Left:=60;
     Width := FLabel.Width+FComboBox.Width;

     TabStop := True;
     ParentFont := False;
     }
     FCompanyList := TStringList.Create;
end;

destructor TPLookupCombox.Destroy;
begin
     //FComboBox.Free;
     FCompanyList.Free;
     inherited Destroy;
end;

{
procedure TPLookupCombox.SetParentFont(Value: Boolean);
begin
     inherited;
     FComboBox.ParentFont := Value;
     Flabel.ParentFont := Value;
     FParentFont := Value;
end;}
{
procedure TPLookupCombox.CMFocusChanged(var Message: TCMFocusChanged);
begin
    if Message.Sender.name = self.Name  then
      FComboBox.SetFocus ;
end; }
{
procedure TPLookupCombox.Notification(AComponent: TComponent; Operation: TOperation);
begin
     if (Operation = opRemove) and (Acomponent = FSubFieldControl) then
        FSubFieldControl := nil;
end; }

procedure Register;
begin
     RegisterComponents('PosControl', [TPLookupCombox]);
end;

procedure TPLookupCombox.CreateEditCtrl;
begin
  FComboBox := TComboBox.Create(Self);
  FComboBox.OnChange := ControlChange;
  FEditCtrl := FComboBox;
  FHelp.visible := false;
end;

end.
