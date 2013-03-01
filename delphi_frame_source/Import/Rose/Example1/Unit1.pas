unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RationalRose;

type
  TForm1 = class(TForm)
    btnCreate: TButton;
    mmResults: TMemo;
    btnList: TButton;
    btnStart: TButton;
    procedure btnCreateClick(Sender: TObject);
    procedure btnListClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
  private
    { Private declarations }
    procedure Print(const s:string);
    procedure PrintClasses(colCls : IRoseClassCollection);
  public
    { Public declarations }
    RoseApp : IRoseApplication;
    RoseModel : IRoseModel;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnCreateClick(Sender: TObject);
var
  objCat,objCat2 : IRoseCategory;
  objCls,objCls2,objCls3 : IRoseClass;
  colCls: IRoseClassCollection;
begin
  // Build a package, class, nested class structure.
  objCls := RoseModel.RootUseCaseCategory.AddClass('LedgerSystem');
  objCls.Stereotype := 'Actor';
  objCls2 := objCls.AddNestedClass ('PayablesSystem');
  objCls2.Stereotype := 'Actor';
  objCls2 := objCls.AddNestedClass ('ReceivablesSystem');

  objCls2.Stereotype := 'Actor';
  objCls := RoseModel.RootCategory.AddClass ('BufferedIO');
  objCls2 := objCls.AddNestedClass ('BufferedInput');
  objCls2 := objCls.AddNestedClass ('BufferedOutput');
  objCat := RoseModel.RootCategory.AddCategory ('Hardware');
  objCls := objCat.AddClass('Computer');
  objCls2 := objCls.AddNestedClass('Monitor');
  objCls2 := objCls.AddNestedClass('Case');
  objCls3 := objCls2.AddNestedClass('Motherboard');

  objCls3 := objCls2.AddNestedClass('Power Supply');
  objCls3 := objCls2.AddNestedClass('Video Card');
  objCls2 :=  objCat.AddClass('Printer');
  objCat2 := objCat.AddCategory('Software');
  objCls := objCat2.AddClass('MyOfficeSuite');
  objCls2 := objCls.AddNestedClass('AWordProcessor');
  objCls2 := objCls.AddNestedClass('ASpreadSheetPackage');
  objCls2 := objCls.AddNestedClass('AContactManager');
  objCls := objCat2.AddClass('MyDevelopmentSuiteOfTools');

  objCls2 := objCls.AddNestedClass('ARequirementsTool');
  objCls2 := objCls.AddNestedClass('AVisualModelingTool');
  objCls3 := objCls2.AddNestedClass('Basic Add-In');
  objCls3 := objCls2.AddNestedClass('C++ Add-In');
  objCls2 := objCls.AddNestedClass('ADefectTrackingTool');

  // Print the classes from each possible variation for the arguments for GetAllClassesEx

  Print(':=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=');

  Print('Recursive := FALSE; Nested := FALSE');
  colCls := RoseApp.CurrentModel.GetAllClassesEx(FALSE, FALSE);
  PrintClasses(colCls);

  Print('');
  Print(':=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=');
  Print('Recursive := FALSE; Nested := TRUE');
  colCls := RoseApp.CurrentModel.GetAllClassesEx(FALSE, TRUE);
  PrintClasses(colCls);

  Print('');
  Print(':=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=');
  Print('Recursive := TRUE; Nested := FALSE');
  colCls := RoseApp.CurrentModel.GetAllClassesEx(TRUE, FALSE);
  PrintClasses(colCls);

  Print('');
  Print(':=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=');
  Print('Recursive := TRUE; Nested := TRUE');
  colCls := RoseApp.CurrentModel.GetAllClassesEx(TRUE, TRUE);
  PrintClasses(colCls);
end;

procedure TForm1.Print(const s: string);
begin
  mmResults.Lines.Add(s);
end;

procedure TForm1.PrintClasses(colCls: IRoseClassCollection);
var
  i : integer;
  objCls : IRoseClass;
begin
  for i := 1 to colCls.Count do
  begin
    objCls := colCls.GetAt(i);
    Print(objCls.Name);
  end;
end;

procedure TForm1.btnListClick(Sender: TObject);
var
  colCls: IRoseClassCollection;
begin
  Print('');
  Print(':=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=');
  Print('Recursive := TRUE; Nested := TRUE');
  colCls := RoseApp.CurrentModel.GetAllClassesEx(TRUE, TRUE);
  PrintClasses(colCls);
end;

procedure TForm1.btnStartClick(Sender: TObject);
begin
  RoseApp := CoRoseApplication.Create;
  RoseApp.Visible := true;
  RoseModel := RoseApp.CurrentModel;
  btnCreate.Enabled := true;
  btnList.Enabled := true;
  btnStart.Enabled := false;
end;

end.
