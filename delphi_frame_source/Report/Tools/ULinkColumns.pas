unit ULinkColumns;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, RPCtrls, ActnList;

type
  TdlgLinkColumns = class(TForm)
    lsSimpleBands: TListBox;
    Label1: TLabel;
    btnSetHeader: TBitBtn;
    btnSetDetail: TBitBtn;
    btnApply: TBitBtn;
    BitBtn4: TBitBtn;
    lsHeaderCtrls: TListBox;
    lsDetailCtrls: TListBox;
    btnHeaderUp: TSpeedButton;
    btnHeaderDown: TSpeedButton;
    btnDetailUp: TSpeedButton;
    btnDetailDown: TSpeedButton;
    btnHeaderDelete: TSpeedButton;
    btnDetailDelete: TSpeedButton;
    alHeader: TActionList;
    alDetail: TActionList;
    ActionList3: TActionList;
    acHeaderUp: TAction;
    acHeaderDown: TAction;
    acHeaderDelete: TAction;
    acDetailUp: TAction;
    acDetailDown: TAction;
    acDetailDelete: TAction;
    acApply: TAction;
    procedure alHeaderUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure alDetailUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure acHeaderUpExecute(Sender: TObject);
    procedure acHeaderDownExecute(Sender: TObject);
    procedure acHeaderDeleteExecute(Sender: TObject);
    procedure acDetailDeleteExecute(Sender: TObject);
    procedure acDetailDownExecute(Sender: TObject);
    procedure acDetailUpExecute(Sender: TObject);
    procedure btnSetHeaderClick(Sender: TObject);
    procedure btnSetDetailClick(Sender: TObject);
    procedure acApplyExecute(Sender: TObject);
    procedure ActionList3Update(Action: TBasicAction;
      var Handled: Boolean);
  private
    { Private declarations }
    FModified : Boolean;
    procedure GetAllSimpleBands(GroupBand : TRDCustomGroupBand);
    procedure AddCtrls(Band : TRDSimpleBand; List : TStrings);
  public
    { Public declarations }
    function  Execute(AReport : TRDReport): Boolean;
  end;

var
  dlgLinkColumns: TdlgLinkColumns;

function LinkColumns(AReport : TRDReport): Boolean;

implementation

uses UTools;

{$R *.DFM}

function LinkColumns(AReport : TRDReport): Boolean;
var
  dialog : TdlgLinkColumns;
begin
  dialog := TdlgLinkColumns.Create(Application);
  try
    Result := dialog.Execute(AReport);
  finally
    dialog.Free;
  end;
end;

{ TdlgLinkColumns }

function TdlgLinkColumns.Execute(AReport: TRDReport): Boolean;
begin
  Assert(AReport<>nil);
  FModified := False;
  lsHeaderCtrls.Items.Clear;
  lsDetailCtrls.Items.Clear;
  lsSimpleBands.Items.Clear;
  GetAllSimpleBands(AReport);
  ShowModal;
  Result := FModified;
end;

procedure TdlgLinkColumns.alHeaderUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  Handled := True;
  acHeaderUp.Enabled := lsHeaderCtrls.ItemIndex>0;
  acHeaderDown.Enabled := (lsHeaderCtrls.ItemIndex>=0) and (lsHeaderCtrls.ItemIndex<lsHeaderCtrls.Items.Count-1);
  acHeaderDelete.Enabled := lsHeaderCtrls.ItemIndex>=0;
end;

procedure TdlgLinkColumns.alDetailUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  Handled := True;
  acDetailUp.Enabled := lsDetailCtrls.ItemIndex>0;
  acDetailDown.Enabled := (lsDetailCtrls.ItemIndex>=0) and (lsDetailCtrls.ItemIndex<lsDetailCtrls.Items.Count-1);
  acDetailDelete.Enabled := lsDetailCtrls.ItemIndex>=0;
end;

procedure TdlgLinkColumns.acHeaderUpExecute(Sender: TObject);
begin
  if lsHeaderCtrls.ItemIndex>0 then
    lsHeaderCtrls.Items.Exchange(lsHeaderCtrls.ItemIndex,lsHeaderCtrls.ItemIndex-1);
end;

procedure TdlgLinkColumns.acHeaderDownExecute(Sender: TObject);
begin
  if (lsHeaderCtrls.ItemIndex>=0) and (lsHeaderCtrls.ItemIndex<lsHeaderCtrls.Items.Count-1) then
    lsHeaderCtrls.Items.Exchange(lsHeaderCtrls.ItemIndex,lsHeaderCtrls.ItemIndex+1);
end;

procedure TdlgLinkColumns.acHeaderDeleteExecute(Sender: TObject);
begin
  if (lsHeaderCtrls.ItemIndex>=0) then
    lsHeaderCtrls.Items.Delete(lsHeaderCtrls.ItemIndex);
end;

procedure TdlgLinkColumns.acDetailUpExecute(Sender: TObject);
begin
  if lsDetailCtrls.ItemIndex>0 then
    lsDetailCtrls.Items.Exchange(lsDetailCtrls.ItemIndex,lsDetailCtrls.ItemIndex-1);
end;

procedure TdlgLinkColumns.acDetailDownExecute(Sender: TObject);
begin
  if (lsDetailCtrls.ItemIndex>=0) and (lsDetailCtrls.ItemIndex<lsDetailCtrls.Items.Count-1) then
    lsDetailCtrls.Items.Exchange(lsDetailCtrls.ItemIndex,lsDetailCtrls.ItemIndex+1);
end;

procedure TdlgLinkColumns.acDetailDeleteExecute(Sender: TObject);
begin
  if (lsDetailCtrls.ItemIndex>=0) then
    lsDetailCtrls.Items.Delete(lsDetailCtrls.ItemIndex);
end;

procedure TdlgLinkColumns.GetAllSimpleBands(GroupBand: TRDCustomGroupBand);
var
  i : integer;
  Band : TRDCustomBand;
begin
  for i:=0 to GroupBand.Children.Count-1 do
  begin
    Band := TRDCustomBand(GroupBand.Children[i]);
    if Band is TRDCustomGroupBand then
      GetAllSimpleBands(TRDCustomGroupBand(Band))
    else if Band is TRDSimpleBand then
      lsSimpleBands.Items.AddObject(GetCtrlName(Band),Band);
  end;
end;

procedure TdlgLinkColumns.btnSetHeaderClick(Sender: TObject);
begin
  if lsSimpleBands.ItemIndex>=0 then
    AddCtrls(TRDSimpleBand(lsSimpleBands.Items.Objects[lsSimpleBands.ItemIndex]),lsHeaderCtrls.Items);
end;

procedure TdlgLinkColumns.btnSetDetailClick(Sender: TObject);
begin
  if lsSimpleBands.ItemIndex>=0 then
    AddCtrls(TRDSimpleBand(lsSimpleBands.Items.Objects[lsSimpleBands.ItemIndex]),lsDetailCtrls.Items);
end;

procedure TdlgLinkColumns.AddCtrls(Band: TRDSimpleBand; List: TStrings);
var
  i : integer;
  Ctrl : TControl;
begin
  List.Clear;
  for i:=0 to Band.ControlCount-1 do
  begin
    Ctrl := Band.Controls[i];
    if Ctrl is TRDCustomControl then
      List.AddObject(GetDesignObjectName(Ctrl),Ctrl);
  end;
end;

procedure TdlgLinkColumns.acApplyExecute(Sender: TObject);
var
  i : integer;
  Ctrl1, Ctrl2 : TRDCustomControl;
begin
  if (lsHeaderCtrls.Items.Count>0)
    and (lsHeaderCtrls.Items.Count=lsDetailCtrls.Items.Count) then
  begin
    for i:=0 to lsHeaderCtrls.Items.Count-1 do
    begin
      Ctrl1 := TRDCustomControl(lsHeaderCtrls.Items.Objects[i]);
      Ctrl2 := TRDCustomControl(lsDetailCtrls.Items.Objects[i]);
      Ctrl2.Link.SetValue(lsLeftRightAlign,Ctrl1);
    end;
    FModified := True;
  end;
end;

procedure TdlgLinkColumns.ActionList3Update(Action: TBasicAction;
  var Handled: Boolean);
begin
  acApply.Enabled := (lsHeaderCtrls.Items.Count>0)
    and (lsHeaderCtrls.Items.Count=lsDetailCtrls.Items.Count);
end;

end.
