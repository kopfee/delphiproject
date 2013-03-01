unit PDBGrid;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids,Menus,PutExcel,db,Dsgnintf;


type
  TMenuOption = set of (moMax,moPrnRep,excel,hidecolumn);

  TMenuOptionElementproperty = class(TSetElementProperty)
    FDesigner: TFormDesigner;
    FElement: integer;
  protected
    FPropList: PInstPropList;
  public
    constructor Create(ADesigner: TFormDesigner; APropList: PInstPropList;
      APropCount: Integer; AElement: Integer);
  end;

  TMenuOptionProperty = class(TSetProperty)
  protected
    FPropList: PInstPropList;
  public
    function GetAttributes:TPropertyAttributes;override;
    procedure GetProperties(Proc: TGetPropEditProc);override;
  end;

  TPDBGrid = class(TCustomDBGrid)
  private
    { Private declarations }
    FAlignList: TStrings;
    FClickTitle: string;
    FHideList: TStrings;
    FHideCount: integer;
    FIsMax : Boolean;
    FMenuOption: TMenuOption;
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
    property MenuOption: TMenuOption read FMenuOption write FMenuOption;
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

procedure TPDBGrid.ClearHide;
var i: integer;
begin
     for i:= 1 to FHideCount do
         FPopUpMenu.Items.Delete(FPopUpMenu.Items.Count-1);
     FHideCount := 0;
     FHideList.Clear;
end;

constructor TPDBGrid.Create(AOwner: TComponent);
var  i: Integer;
     PopUpItem: TMenuItem;
     ItemCaptions: TStringList;
begin
     inherited Create(AOwner);
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
     ItemCaptions.Add('隐藏当前列');
     ItemCaptions.Add('-');
     for i:=0 to 5 do
     begin
          PopUpItem:=TMenuItem.Create(Self);
          PopUpItem.Caption:=ItemCaptions[i];
          PopUpItem.OnClick:=PopupItemHandler;
          FPopUpMenu.Items.Add(PopUpItem);
     end;
     ItemCaptions.Free;
     PopupMenu:=FPopUpMenu;
     FClickTitle := '';
     FClickTitle := FClickTitle;
end;

destructor TPDBGrid.Destroy;
begin
     ClearHide;
     FHideList.Free;
     FPopUpMenu.Free;
     inherited Destroy;
end;

procedure TPDBGrid.PopupItemHandler(Sender: TObject);
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
          if DataSource <> nil then
          begin
               ExcelFrm := TfrmExcel.Create(self);
               ExcelFrm.ShowForm( DataSource.DataSet);
          end;
     end;

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

procedure TPDBGrid.ShowColumnHandler(Sender: TObject);
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

procedure TPDBGrid.OnPopupHandler(Sender: TObject);
var i: word;
begin
     with TPopUpMenu(Sender) do
     begin
          for i:=0 to Items.Count-1 do Items[i].Enabled:=TRUE;
          if DataSource = nil then
             MenuOption := MenuOption - [HideColumn] - [Excel];

          if FIsMax then
             Items[1].Enabled:=FALSE
          else
              Items[0].Enabled:=FALSE;

          if not (moMax in MenuOption) then
          begin
              items[0].Enabled := False;
              items[1].Enabled := False;
          end;

          if moPrnRep in MenuOption then
             items[2].Enabled := True
          else
              items[2].Enabled := False;

          if Excel in MenuOption then
             items[3].Enabled := True
          else
              items[3].Enabled := False;

          if hidecolumn in MenuOption then
             items[4].Enabled := True
          else
              items[4].Enabled := False;
     end;
end;

procedure TPDBGrid.DrawDataCell(const Rect: TRect; Field: TField;
      State: TGridDrawState);
begin
     if (Field.DataSet.RecNo mod 2) = 0  then
     begin
          if ( gdSelected in State ) then
          begin
             canvas.brush.color := clwhite;//clBlue;
             canvas.font.color := clBlack;
          end
          else
          begin
               canvas.brush.color := $00FFF8F0;
               canvas.font.color := clBlack;
          end;
     end
     else
     begin
          if ( gdSelected in State ) then
          begin
               canvas.brush.color := clwhite;//clBlue;
               canvas.font.color := clBlack;
          end
          else
          begin
               canvas.brush.color := $00E4969A;//clBlue;
               canvas.font.color := clYellow;
          end;
     end;   { draw the cell }
     canvas.textrect(rect,rect.left+2,rect.top+2,field.asString);
end;

function TMenuOptionProperty.GetAttributes :TPropertyAttributes;
begin
     Result := inherited GetAttributes + [paSubProperties] - [paMultiselect];
end;

procedure TMenuOptionProperty.GetProperties(Proc: TGetPropEditProc);
var index: integer;
begin
     for index := 0 to 2 do
         proc( TMenuOptionElementproperty.Create(Designer,FPropList,PropCount,index));
end;

constructor TMenuOptionElementproperty.Create(ADesigner: TFormDesigner; APropList: PInstPropList;
      APropCount: Integer; AElement: Integer);
begin
     FDesigner := ADesigner;
//     FPropCount := 1;

     FElement := AElement;
end;

procedure Register;
begin
     RegisterComponents('PosControl2', [TPDBGrid]);
end;

end.
