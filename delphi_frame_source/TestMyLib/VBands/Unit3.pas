unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VBands, StdCtrls, Mask, DBCtrls, Db, DBTables, ExtCtrls, ComWriUtils,
  MDBCtrls;

type
  TForm1 = class(TForm)
    VMainBand1: TVMainBand;
    VBand1: TVBand;
    Label1: TLabel;
    Table1: TTable;
    DataSource1: TDataSource;
    VRowBand1: TVRowBand;
    Table1SpeciesNo: TFloatField;
    Table1Category: TStringField;
    Table1Common_Name: TStringField;
    Table1SpeciesName: TStringField;
    Table1Lengthcm: TFloatField;
    Table1Length_In: TFloatField;
    Table1Notes: TMemoField;
    Table1Graphic: TGraphicField;
    VBand2: TVBand;
    DBImage1: TDBImage;
    VBand3: TVBand;
    VBand4: TVBand;
    VRowBand2: TVRowBand;
    Label2: TLabel;
    DBEdit1: TDBEdit;
    Label3: TLabel;
    DBEdit2: TDBEdit;
    VRowBand3: TVRowBand;
    Label4: TLabel;
    DBEdit3: TDBEdit;
    VRowBand4: TVRowBand;
    Label5: TLabel;
    DBEdit4: TDBEdit;
    Label6: TLabel;
    DBEdit5: TDBEdit;
    Label7: TLabel;
    DBMemo1: TDBMemo;
    Label8: TLabel;
    Panel1: TPanel;
    DBNavigator1: TDBNavigator;
    DBBevelStyles1: TDBBevelStyles;
    procedure DataSource1StateChange(Sender: TObject);
  private
    { Private declarations }
    OldActiveControl : TControl;
    //procedure SetEditMode(Editing : boolean);
  protected
    //procedure ActiveChanged; override;
    function SetFocusedControl(Control: TWinControl): Boolean; override;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

//function 	Editing(DataSource: TDataSource): boolean;

//procedure SetFocusFrame(Control : TControl; AFocused : boolean);

implementation

{$R *.DFM}
{
function 	Editing(DataSource: TDataSource): boolean;
begin
  result := DataSource.State
  	in [dsEdit,dsInsert];
end;

type
	TEditAccess = class(TcustomEdit);

{
procedure TForm1.ActiveChanged;
begin
  inherited ActiveChanged;
  if OldActiveControl<>nil then
	  SetFocusFrame(OldActiveControl,false);
	OldActiveControl := ActiveControl;
  if OldActiveControl<>nil then
		SetFocusFrame(OldActiveControl,
    	Editing(DataSource1));
end;
}
procedure TForm1.DataSource1StateChange(Sender: TObject);
begin
  {SetFocusFrame(OldActiveControl,
  	Editing(DataSource1));}
end;
{
procedure TForm1.SetEditMode(Editing: boolean);
var
	i : integer;
begin

  for i:=0 to ComponentCount-1 do
  	if Components[i] is TCustomEdit then
    	with TEditAccess(Components[i]) do
      	if Editing then
          BorderStyle := bsSingle
        else
        	BorderStyle := bsNone;


end;

procedure SetFocusFrame(Control: TControl; AFocused: boolean);
begin
  if control=nil then exit;
  if Control is TCustomEdit then
  with TEditAccess(Control) do
    if AFocused then
			BevelKind := bkSoft
    else
			BevelKind := bkNone;
end;
}
function TForm1.SetFocusedControl(Control: TWinControl): Boolean;
begin
  result := inherited SetFocusedControl(Control);
  (*if OldActiveControl is TWinControl then
    DBBevelStyles1.SetCtrlBevelEx(TWinControl(OldActiveControl));
	//OldActiveControl := ActiveControl;
  OldActiveControl := Control;
  if OldActiveControl is TWinControl then
    DBBevelStyles1.SetCtrlBevelEx(TWinControl(OldActiveControl));
  *)
  DBBevelStyles1.UpdateFocusCtrl;
end;

end.
