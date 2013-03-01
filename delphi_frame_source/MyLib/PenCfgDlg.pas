unit PenCfgDlg;

// %PenCfgDlg : 包含设置Pen属性的界面

(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin, CompGroup, Buttons;

type
  // TdlgPenCfg : 包含设置Pen属性的界面
  TdlgPenCfg = class(TForm)
    lbStyles: TListBox;
    ColorDialog1: TColorDialog;
    apPenColor: TAppearanceProxy;
    seWidth: TSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    cbbMode: TComboBox;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    GroupBox1: TGroupBox;
    pbSample: TPaintBox;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure lbStylesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure seWidthChange(Sender: TObject);
    procedure pbSamplePaint(Sender: TObject);
    procedure PenPropertyChange(Sender: TObject);
  private
    { Private declarations }
    Updating : boolean;
  public
    { Public declarations }
    function  Execute(Pen : TPen): boolean;
  end;

var
  dlgPenCfg: TdlgPenCfg;

implementation

{$R *.DFM}

procedure TdlgPenCfg.FormCreate(Sender: TObject);
var
  i : TPenStyle;
begin
  lbStyles.Items.Clear;
  for i:=psSolid to psInsideFrame do
    lbStyles.Items.Add(' ');
  lbStyles.ItemIndex := 0;
  cbbMode.ItemIndex := Integer(pmCopy);
end;

procedure TdlgPenCfg.lbStylesDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  XOff,YOff : integer;
begin
  with (Control as TListBox).Canvas do
	begin
	  FillRect(Rect);       { clear the rectangle }
    if TPenStyle(index)=psClear then
    begin
      Font := (Control as TListBox).Font;
      DrawText(handle,'Clear',length('Clear'),rect,
        DT_SINGLELINE or DT_VCENTER	or DT_CENTER);
    end
    else
    begin
      XOff := 2;
      YOff := (Control as TListBox).ItemHeight div 2;
      pen.width := 1;
      pen.Mode := pmCopy;
      pen.Style := TPenStyle(index);
      pen.Color := clRed;
      MoveTo(rect.left+XOff,rect.top+YOff);
      LineTo(rect.right-XOff,rect.top+YOff);
    end;
  end;
end;

procedure TdlgPenCfg.seWidthChange(Sender: TObject);
begin
  if seWidth.text<>'' then
    PenPropertyChange(Sender);
end;

procedure TdlgPenCfg.pbSamplePaint(Sender: TObject);
begin
  with pbSample.Canvas do
  begin
    {brush.color := pbSample.Color;
    brush.Style := bsSolid;
    FillRect(pbSample.ClientRect);}
    pen.width := seWidth.value;
    pen.Mode := TPenMode(cbbMode.ItemIndex);
    pen.Style := TPenStyle(lbStyles.Itemindex);
    pen.Color := apPenColor.Color;
    MoveTo(2,pbSample.height div 2);
    LineTo(pbSample.width-2,pbSample.height div 2);
  end;
end;

procedure TdlgPenCfg.PenPropertyChange(Sender: TObject);
begin
  if not Updating then
    pbSample.Refresh;
end;

function TdlgPenCfg.Execute(Pen: TPen): boolean;
begin
  assert(pen<>nil);
  Updating := true;
  with pen do
  begin
    seWidth.value := width;
    cbbMode.ItemIndex := integer(Mode);
    lbStyles.Itemindex := integer(Style);
    apPenColor.Color := Color;
  end;
  Updating := false;
  result := showmodal=mrOk;
  if result then
  begin
    pen.width := seWidth.value;
    pen.Mode := TPenMode(cbbMode.ItemIndex);
    pen.Style := TPenStyle(lbStyles.Itemindex);
    pen.Color := apPenColor.Color;
  end;
end;

end.
