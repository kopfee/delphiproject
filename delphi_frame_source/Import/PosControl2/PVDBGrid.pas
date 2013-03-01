unit PVDBGrid;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBVGrids, PutExcel,DB,menus;

type
  TPVDBGrid = class(TVDBGrid)
  private
    { Private declarations }
    FHideList:TStrings;
    FHideCount:integer;
    FIsMax : Boolean;
    FOldAlign : TAlign;
    FPopUpMenu : TPopUpMenu;
    RealLeft:integer;
    RealTop:integer;
    RealHeight:integer;
    RealWidth:integer;
  protected
    { Protected declarations }
    procedure ClearHide;
    procedure DrawDataCell(const Rect: TRect; Field: TField;State: TGridDrawState); override; { obsolete }
    procedure OnPopupHandler(Sender: TObject);
    procedure PopupItemHandler(Sender: TObject);
    procedure ShowColumnHandler(Sender: TObject);
    procedure TitleClick(Column: TColumn); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    property Canvas;
    property SelectedRows;
  published
    { Published declarations }
    property Align;
    property BorderStyle;
    property Color;
    property Columns stored False;
    property Ctl3D;
    property DataSource;
    property DefaultDrawing;
    property DragCursor;
    property DragMode;
    property Enabled;
    property FixedColor;
    property Font;
    property ImeMode;
    property ImeName;
    property Options;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property TitleFont;
    property Visible;

    property OnCellClick;
    property OnColEnter;
    property OnColExit;
    property OnColumnMoved;
    property OnDrawDataCell;
    property OnDrawColumnCell;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditButtonClick;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnStartDrag;
    property OnTitleClick;

  end;

procedure Register;

implementation

procedure TPVDBGrid.ClearHide;
var i: integer;
begin
     for i:= 1 to FHideCount do
         FPopUpMenu.Items.Delete(FPopUpMenu.Items.Count-1);
     FHideCount := 0;
     FHideList.Clear;
end;

constructor TPVDBGrid.Create(AOwner: TComponent);
var  i: Integer;
     PopUpItem: TMenuItem;
     ItemCaptions: TStringList;
begin
     inherited Create(AOwner);
     Vertical := False;
     FHideCount := 0;
     FHideList := TStringList.Create;
     Options:=[dgTitles,dgIndicator,dgColumnResize,dgColLines,dgRowLines,dgTabs];
     TabStop:=False;
     FIsMax:=False;
     FPopUpMenu:=TPopUpMenu.Create(self);
     FPopUpMenu.OnPopup:=OnPopUpHandler;
     ItemCaptions:=TStringList.Create;
     ItemCaptions.Add('还原');
     ItemCaptions.Add('最大化');
     ItemCaptions.Add('报表打印');
     ItemCaptions.Add('导入Excel');
     ItemCaptions.Add('横向显示列');
     ItemCaptions.Add('隐藏当前列');
     ItemCaptions.Add('-');
     for i:=0 to 6 do
     begin
          PopUpItem:=TMenuItem.Create(Self);
          PopUpItem.Caption:=ItemCaptions[i];
          PopUpItem.OnClick:=PopupItemHandler;
          FPopUpMenu.Items.Add(PopUpItem);
     end;
     ItemCaptions.Free;
     PopupMenu:=FPopUpMenu;
end;

destructor TPVDBGrid.Destroy;
begin
     ClearHide;
     FHideList.Free;
     FPopUpMenu.Free;
     inherited Destroy;
end;

procedure TPVDBGrid.PopupItemHandler(Sender: TObject);
var PopUpItem: TMenuItem;
    ExcelFrm: TfrmExcel;
begin
     if TMenuItem(Sender).Caption='还原' then
     begin
          TForm(owner).windowstate:=wsNormal;
          Align:=FOldAlign;
          Left:=RealLeft;
          Top:=RealTop;
          Height:=RealHeight;
          Width:=RealWidth;
          FIsMax:=FALSE;
     end;

     if TMenuItem(Sender).Caption='最大化' then
     begin
          RealLeft:=Left;
          RealTop:=Top;
          RealHeight:=Height;
          RealWidth:=Width;
          TForm(owner).windowstate:=wsMaximized;
          FOldAlign := Align;
          Align:=alClient;
          Left := 1;
          Top := 1;
          Height := TForm(Owner).Height -10;
          Width := TForm(Owner).Width -10;
          BringToFront;
          FIsMax:=TRUE;
     end;

     if TMenuItem(Sender).Caption='报表打印' then
     begin

     end;

     if TMenuItem(Sender).Caption='导入Excel' then
     begin
          ExcelFrm := TfrmExcel.Create(self);
          ExcelFrm.ShowForm( DataSource.DataSet);
     end;

     if TMenuItem(Sender).Caption='横向显示列' then
     begin
          Vertical := not Vertical;
     end;
{
     if TMenuItem(Sender).Caption='横向显示列' then
     begin
          Vertical := True;
          TMenuItem(Sender).Caption := '竖向显示列';
     end
     else
     if TMenuItem(Sender).Caption = '竖向显示列' then
     begin
          Vertical := False;
          TMenuItem(Sender).Caption :='横向显示列';
     end;
}
     if TMenuItem(Sender).Caption='隐藏当前列' then
     begin
          if Assigned(DataSource) then
          if Assigned(DataSource.DataSet) then
             if (DataSource.DataSet.Active) then
             begin
                  PopUpItem:=TMenuItem.Create(Self);
                  PopUpItem.Caption:='显示 '+Columns.Items[Col-IndicatorOffset].Title.Caption;
                  PopUpItem.OnClick:=ShowColumnHandler;
                  FPopUpMenu.Items.Add(PopUpItem);
                  FHideList.AddObject(Columns.Items[Col-IndicatorOffset].Field.FieldName,
                              TObject(PopUpItem));
                  Columns.Items[Col-IndicatorOffset].Field.Visible := False;
                  FHideCount := FHideCount + 1;
             end;
     end;
end;

procedure TPVDBGrid.ShowColumnHandler(Sender: TObject);
var  PopUpItem: TMenuItem;
     i,j: integer;
begin
     if Assigned(DataSource) then
        if Assigned(DataSource.DataSet) then
           if (DataSource.DataSet.Active) then
           begin
                PopUpItem := TMenuItem(Sender);
                for j := 0 to FHideList.Count-1 do
                begin
                     if TMenuItem(FHideList.Objects[j])=PopUpItem then
                     begin
                          for i := 0 to DataSource.DataSet.FieldCount-1 do
                          begin
                               if DataSource.DataSet.Fields[i].FieldName = FHideList.Strings[j] then
                               begin
                                    DataSource.DataSet.Fields[i].Visible := True;
                                    break;
                               end;
                          end;
                          FHideList.Delete(j);
                          break;
                     end;
                end;
                FPopUpMenu.Items.Remove(PopUpItem);
                FHideCount := FHideCount - 1;
           end;
end;

procedure TPVDBGrid.OnPopupHandler(Sender: TObject);
var i: word;
begin
     with TPopUpMenu(Sender) do
     begin
          for i:=0 to Items.Count-1 do Items[i].Enabled:=TRUE;
          if FIsMax then
             Items[1].Enabled:=FALSE
          else
              Items[0].Enabled:=FALSE;
     end;
end;

procedure TPVDBGrid.DrawDataCell(const Rect: TRect; Field: TField;
      State: TGridDrawState);
begin
     if (Field.DataSet.RecNo mod 2) = 0  then
     begin  { white on red }
            canvas.font.color := clBlack;
            canvas.brush.color := $00FFF8F0;
     end
     else
     begin  { black on white }
        canvas.brush.color := $00E4969A;//clBlue;
        canvas.font.color := clYellow;
     end;   { draw the cell }
     canvas.textrect(rect,rect.left+2,rect.top+2,field.asString);
end;

procedure TPVDBGrid.TitleClick(Column: TColumn);
begin
     inherited;
//     Column.FieldName ;
end;

procedure Register;
begin
     RegisterComponents('PosControl2', [TPVDBGrid]);
end;

end.
