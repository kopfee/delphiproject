unit PGoodsEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stdctrls, dbtables, extctrls, RxCtrls, dbctrls, db, SelectDlg, PLabelPanel,
  LookupControls;

type

  TDisplayLevel = (dlNone,dlGoods,dlStock,dlStockCode);

  TPGoodsEdit = class(TCustomControl)
  private
    { Private declarations }
    FCheck: Boolean;
    FDatabaseName: string;
    FDisplayLevel: TDisplayLevel;
    FEdit: TEdit;
    FFormatIsOk: Boolean;
    FGoods: string;
    FGoodsLen: integer;
    FIsInDataBase: Boolean;
    FLabel: TRxLabel;
    FLabelStyle: TLabelStyle;
    FLookField: string;
    FLookFieldCaption: string;
    FLookSubField: string;
    FLookSubFieldCaption: string;
    FParentFont: Boolean;
    FStock: string;
    FStockCode: string;
    FStockCodeLen: integer;
    FStockLen: integer;
    FSubFieldControl: TPLabelPanel;
    FTableName: string;
    FQuery: TQuery;
  protected
    { Protected declarations }
    function GetCaption:TCaption;
    function GetEditFont:TFont;
    function GetEditWidth:integer;
    function GetGoods:string;
    function GetLabelFont: TFont;
    function GetRdOnly:Boolean;
    function DefaultString(ALen:integer):string;
    function ExtendText:boolean;
    function FindCurrent(var LabelText: string):Boolean;
    function GetStock:string;
    function GetStockCode:string;
    function GetText: string;

    procedure ControlExit(Sender: TObject);
    procedure ControlDblClick(Sender: TObject);
    procedure SetDisplayLevel(Value: TDisplayLevel);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure Paint;override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetCaption(Value: TCaption);
    procedure SetDataBaseName(Value: string);
    procedure SetEditWidth(Value: integer);
    procedure SetEditFont(Value: TFont);
    procedure SetLabelFont(Value: TFont);
    procedure SetLabelStyle(Value: TLabelStyle);
    procedure SetRdOnly(Value: Boolean);
    procedure SetParentFont(Value: Boolean);
    procedure SetText(Value: string);
    procedure TextChange(Sendor: TObject);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    function CheckExist: Boolean;
    property FormatIsOk: Boolean read FFormatIsOk write FFormatIsOk;
    property Goods:string read GetGoods;
    property GoodsLen:integer read FGoodsLen;
    property IsInDataBase: Boolean read FIsInDataBase write FIsInDataBase;
    property StockLen:integer read FStockLen;
    property StockCodeLen:integer read FStockCodeLen;
    property Stock:string read GetStock;
    property StockCode:string read GetStockCode;
 published
    { Published declarations }
    property Caption:TCaption read GetCaption write SetCaption;
    property Check: Boolean read FCheck write FCheck;
    property DatabaseName: string read FDatabaseName write SetDatabaseName;
    property DisplayLevel:TDisplayLevel read FDisplayLevel write SetDisplayLevel;
    property EditFont:TFont read GetEditFont write SetEditFont;
    property EditWidth:integer read GetEditWidth write SetEditWidth;
    property LabelFont: TFont read GetLabelFont write SetLabelFont;
    property LabelStyle: TLabelStyle read FLabelStyle write SetLabelStyle default Normal;
    property LookFieldCaption:string read FLookFieldCaption write FLookFieldCaption;
    property LookSubFieldCaption:string read FLookSubFieldCaption write FLookSubFieldCaption;
    property ParentFont : Boolean read FParentFont write SetParentFont;
    property RdOnly: Boolean read GetRdOnly write SetRdOnly;
    property SubFieldControl: TPLabelPanel read FSubFieldControl write FSubFieldControl;
    property TabOrder;
    property Text: string read GetText write SetText;
  end;

procedure Register;

implementation

constructor TPGoodsEdit.Create (AOwner: TComponent);
begin
     inherited Create(AOwner);

     FLabel := TRxLabel.Create(Self);
     FLabel.Parent := Self;
     FLabel.ShadowSize := 0;
     FLabel.Layout := tlCenter;
     FLabel.AutoSize := False;
     FLabel.Visible := True;
     FLabel.ParentFont := False;
     FLabel.Font.Size := 11;
     FLabel.Font.Name := '宋体';

     FEdit := TEdit.Create(Self);
     FEdit.Parent := Self;
     FEdit.Visible := True;
     FEdit.Font.Size := 9;
     FEdit.Font.Name := '宋体';
     FEdit.OnExit := ControlExit;
     FEdit.OnDblClick := ControlDblClick;
     FEdit.OnKeyPress := EditKeyPress;
     FEdit.OnChange := TextChange;

     FLabel.FocusControl := FEdit;

     Height := 20;
     FLabel.Height := Height;
     FEdit.Height := Height;

     Width := 200;
     FEdit.Width := 140;
     FLabel.Width := Width-FEdit.Width;
     FEdit.Left := FLabel.Width;

     FQuery := TQuery.Create(Self);

     LabelStyle := Normal;

     FTableName := 'tbGoods';
     FLookField := 'STOCKCODE';
     FLookSubField := 'STK_NAME';

     FGoodsLen := 4;
     FStockLen := 9;
     FStockCodeLen := 13;

     ParentFont := False;
     FIsInDataBase := False;
     FFormatIsOk := False;
end;

destructor TPGoodsEdit.Destroy;
begin
     FEdit.Free;
     FQuery.Free;
     FLabel.Free;
     inherited Destroy;
end;

function TPGoodsEdit.GetLabelFont: TFont;
begin
     Result := FLabel.Font;
end;

procedure TPGoodsEdit.SetLabelFont(Value: TFont);
begin
     FLabel.Font := Value;
end;

function TPGoodsEdit.CheckExist: Boolean;
var LabelText : string;
begin
     Result := False;
     LabelText := '';

     if Check then
     begin
          if not ExtendText then
             Result := True
          else
              if not FindCurrent(LabelText) then
                 Result := False;
     end
     else
     begin
          if not ExtendText then
             Result := True;
             FindCurrent(LabelText);
     end;

     if LabelText <> '' then
        FIsInDataBase := True
     else
         FIsInDataBase :=  False;

     if FSubFieldControl <> nil then
        (FSubFieldControl as TPLabelPanel).Caption := LabelText;
end;

function TPGoodsEdit.ExtendText:boolean;
var TextLen: integer;
begin
     Result := True;
     FFormatIsOk := True;
     TextLen := Length(FEdit.Text);

     case FDisplayLevel of
     dlNone :
            if (TextLen<>0) and (TextLen <> FGoodsLen) and (TextLen <> FStockLen) and (TextLen <> FStockCodeLen) then
            begin
                 Result := False;
                 FFormatIsOk := False;
                 Exit;
            end;
     dlGoods :
            if TextLen <> FGoodsLen then
            begin
                 Result := False;
                 FFormatIsOk :=  False;
                 Exit;
            end;
     dlStock :
            if TextLen <> FStockLen then
            begin
                 Result := False;
                 FFormatIsOk := False;
                 Exit;
            end;
     dlStockCode :
            if TextLen <> FStockCodeLen then
            begin
                 Result := False;
                 FFormatIsOk := False;
                 Exit;
            end;
     end;

     if TextLen=0 then
     begin
          FGoods := '';
          FStock := '';
          FStockCode := '';
     end
     else
         if TextLen=FGoodsLen then
         begin
              FGoods := FEdit.Text;
              FStock := FGoods+DefaultString(FStockLen-FGoodsLen);
              FStockCode := FStock+DefaultString(FStockCodeLen-FStockLen);
         end
         else
             if TextLen=FStockLen  then
             begin
                  FGoods := Copy(FEdit.Text,1,FGoodsLen);
                  FStock := FEdit.Text;
                  FStockCode := FStock+DefaultString(FStockCodeLen-FStockLen);
             end
             else
                 if TextLen=FStockCodeLen then
                 begin
                      FGoods := Copy(FEdit.Text,1,FGoodsLen);
                      FStock := Copy(FEdit.Text,1,FStockLen);
                      FStockCode := FEdit.Text;
                 end;
end;

function TPGoodsEdit.FindCurrent(var LabelText: string):Boolean;
begin
     if (DisplayLevel = dlNone) and (FEdit.Text = '') then
     begin
          LabelText := '';
          Result := True;
          Exit;
     end;

     FQuery.DatabaseName := FDatabaseName;
     FQuery.SQL.Clear;
     FQuery.SQL.Add('Select * from '+FTableName + ' where stockcode = ''' + FStockCode +'''');
     FQuery.Open;

     if not FQuery.Locate(FLookField, FStockCode,[]) then
     begin
          Result := False;
          LabelText := '';
     end
     else
     begin
          Result := True;
          LabelText := FQuery.FieldByName(FLookSubField).AsString;
     end;

     FQuery.Close;
end;

function TPGoodsEdit.GetCaption:TCaption;
begin
     Result := FLabel.Caption;
end;

function TPGoodsEdit.DefaultString(ALen:integer):string;
var i: integer;
begin
     if ALen<1 then
          Result := ''
     else
     begin
          Result := '';
          for i := 1 to ALen-1 do
              Result := Result + '0';
          Result := Result + '1';
     end;
end;

function TPGoodsEdit.GetEditFont:TFont;
begin
     Result := FEdit.Font;
end;

function TPGoodsEdit.GetEditWidth:integer;
begin
     Result := FEdit.Width;
end;

function TPGoodsEdit.GetGoods:string;
var LabelText: string;
begin
     if ExtendText then
     begin
          Result := FGoods;
     end
     else
     begin
          FGoods := Copy(FEdit.Text,1,FGoodsLen);
          FStock := Copy(FEdit.Text,1,FStockLen);
          FStockCode := Copy(FEdit.Text,1,FStockcodeLen);
          Result := FGoods;
     end;
end;

function TPGoodsEdit.GetRdOnly:Boolean;
begin
     Result := FEdit.ReadOnly;
end;

function TPGoodsEdit.GetStock:string;
var LabelText: string;
begin
     if ExtendText then
     begin
          Result := FStock;
     end
     else
     begin
          FGoods := Copy(FEdit.Text,1,FGoodsLen);
          FStock := Copy(FEdit.Text,1,FStockLen);
          FStockCode := Copy(FEdit.Text,1,FStockcodeLen);
          Result := FStock;
     end;
end;

function TPGoodsEdit.GetStockCode:string;
var LabelText : string;
begin
     if ExtendText then
     begin
          Result := FStockCode;
     end
     else
     begin
          FGoods := Copy(FEdit.Text,1,FGoodsLen);
          FStock := Copy(FEdit.Text,1,FStockLen);
          FStockCode := Copy(FEdit.Text,1,FStockcodeLen);
          Result := FStockCode;
     end;
end;

function TPGoodsEdit.GetText: string;
begin
     Result := FEdit.Text ;
end;

procedure TPGoodsEdit.ControlDblClick(Sender: TObject);
var SltDlg: TfrmSelectDlg;
begin
     FQuery.DatabaseName := FDatabaseName;
     FQuery.SQL.Clear;
     FQuery.SQL.Add('Select * from '+FTableName);
     FQuery.Open;

     if (not RdOnly) and (not FQuery.IsEmpty) then
     begin
          SltDlg := TfrmSelectDlg.Create(Self);
          with SltDlg do
          begin
               SelectDataSource.DataSet := FQuery;
               grdSelect.Columns.Clear;
               grdSelect.Columns.Add;
               grdSelect.Columns.Items[0].FieldName := FLookField;
               grdSelect.Columns.Items[0].Title.Caption := FLookFieldCaption;
               grdSelect.Columns.Items[0].Title.Font.Size := 10;
               grdSelect.Columns.Add;
               grdSelect.Columns.Items[1].FieldName := FLookSubField;
               grdSelect.Columns.Items[1].Title.Caption := FLookSubFieldCaption;
               grdSelect.Columns.Items[1].Title.Font.Size := 10;
          end;

          if SltDlg.ShowModal=mrOK then
          begin
               FEdit.Text := FQuery.FieldByName(FLookField).AsString;
               if FSubFieldControl<>nil then
                  (FSubFieldControl as TPLabelPanel).Caption := FQuery.FieldByName(FLookSubField).AsString;
          end;

          SltDlg.Free;
     end;

     FQuery.Close;
end;

procedure TPGoodsEdit.ControlExit;
begin

end;

procedure TPGoodsEdit.EditKeyPress(Sender: TObject; var Key: Char);
var LabelText : string;
    fgError : Boolean;
begin
     if Key = #13 then
     begin
          fgError := False;
          LabelText := '';

          if Check then
          begin
               if not ExtendText then
                  fgError := True
               else
                   if not FindCurrent(LabelText) then
                      fgError := True;
          end
          else
          begin
               if not ExtendText then
                  fgError := True;
               FindCurrent(LabelText);
          end;

          if fgError then
             Application.MessageBox('输入不合法！','错误',MB_OK);

          if FSubFieldControl <> nil then
             (FSubFieldControl as TPLabelPanel).Caption := LabelText;

     end;
end;

procedure TPGoodsEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
     if AHeight < 20 then
        AHeight := 20;
     if AHeight >50 then
        AHeight := 50;
     inherited;
     FEdit.Height := AHeight;
     FLabel.Height := AHeight;
end;

procedure TPGoodsEdit.SetCaption(Value: TCaption);
begin
     FLabel.Caption := Value;
end;

procedure TPGoodsEdit.SetDataBaseName(Value: string);
begin
     FDataBaseName := Value;
     if Value = '' then
     begin
        Check := False;
     end;
end;

procedure TPGoodsEdit.SetDisplayLevel(Value : TDisplayLevel);
begin
     FEdit.Text := '';
     FDisplayLevel := Value;
     Case Value of
          dlNone : FEdit.MaxLength := FStockCodeLen;
          dlGoods : FEdit.MaxLength := FGoodsLen;
          dlStock : FEdit.MaxLength := FStockLen;
          dlStockCode : FEdit.MaxLength := FStockCodeLen;
     end;
end;

procedure TPGoodsEdit.SetEditFont(Value: TFont);
begin
     FEdit.Font.Assign(Value);
     FLabel.Height := FEdit.Height;
     Height := FEdit.Height;
end;

procedure TPGoodsEdit.SetEditWidth(Value: integer);
begin
     FEdit.Width := Value;
     FEdit.Left := Width-Value;
     FLabel.Width := FEdit.Left;
end;

procedure TPGoodsEdit.SetLabelStyle (Value: TLabelStyle);
begin
     FLabelStyle := Value;
     case Value of
     Conditional:
           begin
                FLabel.Font.Color := clBlack;
                FLabel.Font.Style := [fsUnderline];
           end;
     Normal:
           begin
                FLabel.Font.Color := clBlack;
                FLabel.Font.Style := [];
           end;
     NotnilAndConditional:
           begin
                FLabel.Font.Color := clTeal;
                FLabel.Font.Style := [fsUnderline];
           end;
     Notnil:
           begin
                FLabel.Font.Color := clTeal;
                FLabel.Font.Style := [];
           end;
     end;
end;

procedure TPGoodsEdit.SetParentFont(Value: Boolean);
begin
     inherited;
     FEdit.ParentFont := Value;
     Flabel.ParentFont := Value;
     FParentFont := Value;
end;

procedure TPGoodsEdit.SetRdOnly(Value: Boolean);
begin
     FEdit.ReadOnly := Value;
     if Value then
        FEdit.Color := clSilver
     else
         FEdit.Color := clWhite;
end;

procedure TPGoodsEdit.SetText(Value: string);
begin
     FEdit.Text := Value;
end;

procedure TPGoodsEdit.Paint;
begin
     FLabel.Height := Height;
     FEdit.Height := Height;
     FLabel.Width := Width-FEdit.Width;
     FEdit.Left := FLabel.Width;
     SetLabelStyle(LabelStyle);
     inherited Paint;
end;

procedure TPGoodsEdit.TextChange(Sendor: TObject);
begin
     FFormatIsOk := ExtendText;
end;

procedure Register;
begin
     RegisterComponents('PosControl2', [TPGoodsEdit]);
end;

end.

