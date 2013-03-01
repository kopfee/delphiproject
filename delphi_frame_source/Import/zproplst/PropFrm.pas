unit PropFrm;

interface

uses
{ !!! In Delphi 5 you may need to compile Delphi5\Source\Toolsapi\DsgnIntf.pas
  and put resulting DCU in Delphi5\Lib folder }
  Windows, Forms, ZPropLst, TypInfo,
  DsgnIntf, Graphics, ZPEdits, Messages, ExtCtrls, StdCtrls, Controls,
  Classes, ComCtrls;

type
  TForm1 = class(TForm)
    ZPropList1: TZPropList;
    Panel1: TPanel;
    ComboBox1: TComboBox;
    TabControl1: TTabControl;
    Timer1: TTimer;
    procedure TabControl1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FHeightOk: Boolean;
    procedure SetupHeight;
    procedure GetComponentList;
    procedure AddComponent(Root: TComponent);
    procedure WMSizing(var Message: TMessage); message WM_SIZING;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.TabControl1Change(Sender: TObject);
begin
  if TabControl1.TabIndex = 0 then ZPropList1.Filter := tkProperties
    else ZPropList1.Filter := tkMethods;
end;

type
  THComponent = class(TComponent) end;

procedure TForm1.AddComponent(Root: TComponent);
begin
  ComboBox1.Items.AddObject(Root.Name + ': ' + Root.ClassName, Root);
  THComponent(Root).GetChildren(AddComponent{$IFNDEF VER90}, Self{$ENDIF});
end;

procedure TForm1.GetComponentList;
begin
  with ComboBox1, Items do
  begin
    BeginUpdate;
    try
      Clear;
      AddComponent(Self);
      ItemIndex := 0;
      OnChange(ComboBox1);
    finally
      EndUpdate;
    end;
  end;
end;

procedure TForm1.SetupHeight;
var
  HRow, HOverhead: Integer;
begin
  HRow := ZPropList1.RowHeight;
  if HRow > 0 then
  begin
    HOverhead := Height - ZPropList1.ClientHeight;
    Height := HOverhead + ZPropList1.ClientHeight div HRow * HRow;
  end;
  FHeightOk := True;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  SetupHeight;
  GetComponentList;
end;

procedure TForm1.WMSizing(var Message: TMessage);
var
  HRow, NewHeight, Diff: Integer;
  R: PRect;
begin
  if FHeightOk then
  begin
    R := PRect(Message.LParam);
    HRow := ZPropList1.RowHeight;
    NewHeight := R.Bottom - R.Top;
    if NewHeight < 128 then NewHeight := 128;
    if HRow > 0 then
    begin
      Diff := NewHeight - Height;
      if Abs(Diff) <= HRow shr 1 then Diff := 0;
      NewHeight := Height + (Diff shl 1) div HRow * HRow;;
    end;

    if Message.WParam in [WMSZ_BOTTOM, WMSZ_BOTTOMLEFT, WMSZ_BOTTOMRIGHT] then
      R.Bottom := R.Top + NewHeight
    else
      R.Top := R.Bottom - NewHeight;
  end;
end;
                   
procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  with ComboBox1 do
    ZPropList1.CurObj := Items.Objects[ItemIndex];
end;

procedure TForm1.Timer1Timer(Sender: TObject);
const
  SMod: array [Boolean] of string = ('Unchanged', 'Modified');
begin
  Caption := 'Object Inspector - ' + SMod[ZPropList1.Modified];
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  ComboBox1.Width := Panel1.Width - 2;
end;


end.
 