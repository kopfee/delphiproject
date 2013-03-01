unit HelpBtns;

interface

USES SysUtils,Classes,Controls,Forms,Buttons,PDataHelper;

type
  THelpButton = class;

  TAfterHelpEvent = procedure (Sender : THelpButton; Helper : TCustomDataHelper) of object;
  TBeforeHelpEvent = procedure (Sender : THelpButton) of object;

  THelpButton = class(TBitBtn)
  private
    FHelpStr: string;
    FDataCtrl: TControl;
    FAfterHelp: TAfterHelpEvent;
    FValues: TList;
    FTextValue: string;
    FBeforeHelp: TBeforeHelpEvent;
    procedure SetDataCtrl(const Value: TControl);
  protected
    procedure Click; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    property    Values : TList read FValues;
    property    TextValue : string read FTextValue write FTextValue;
  published
    property  HelpStr : string read FHelpStr write FHelpStr;
    property  DataCtrl : TControl read FDataCtrl write SetDataCtrl;
    property  AfterHelp : TAfterHelpEvent read FAfterHelp write FAfterHelp;
    property  BeforeHelp : TBeforeHelpEvent read FBeforeHelp write FBeforeHelp;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples',[THelpButton]);
end;

{ THelpButton }

procedure THelpButton.Click;
var
  DataHelper : TCustomDataHelper;
  r : integer;
begin
  inherited Click;
  if HelpStr<>'' then
  begin
    Values.Clear;
    if Assigned(FBeforeHelp) then
      FBeforeHelp(self);
    if FDataCtrl=nil then
      r:=TDataHelpManager.ExecuteHelp(self,HelpStr,FTextValue,Values,DataHelper)
    else
      r:=TDataHelpManager.ExecuteHelp(FDataCtrl,HelpStr,FTextValue,Values,DataHelper);
    if (r>0) and Assigned(FAfterHelp) then
      FAfterHelp(self,DataHelper);
  end;
end;

constructor THelpButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FValues := TList.Create;
end;

destructor THelpButton.Destroy;
begin
  FValues.free;
  inherited Destroy;
end;

procedure THelpButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (AComponent=FDataCtrl) and (Operation=opRemove) then
    FDataCtrl:=nil;
end;

procedure THelpButton.SetDataCtrl(const Value: TControl);
begin
  if FDataCtrl<>value then
  begin
    FDataCtrl := Value;
    if FDataCtrl<>nil then
      FDataCtrl.FreeNotification(self);
  end;
end;

end.
 