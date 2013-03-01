unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, CoolCtrls, StdCtrls, ComWriUtils, AbilityManager, Grids,
  DBGrids, Db, DBTables;

type
  TForm1 = class(TForm)
    Table1: TTable;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    aupRight: TSimpleAuthorityProvider;
    apRead: TAbilityProvider;
    amRead: TAbilityManager;
    apWrite: TAbilityProvider;
    amWrite: TAbilityManager;
    apInspect: TAbilityProvider;
    amInspect: TAbilityManager;
    apCorrect: TAbilityProvider;
    amCorrect: TAbilityManager;
    CoolButton1: TCoolButton;
    CoolButton2: TCoolButton;
    CoolButton3: TCoolButton;
    CoolButton4: TCoolButton;
    CoolButton5: TCoolButton;
    CoolButton6: TCoolButton;
    ButtonOutlook1: TButtonOutlook;
    ImageList1: TImageList;
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  aupRight.AuthorityAsString :=  Table1.FieldByName('Right').AsString;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Table1.open;
end;

end.
 