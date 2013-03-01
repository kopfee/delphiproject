unit UDBEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  LookupControls, PDBEdit, PDBLookupEdit, PLookupEdit, PDBVendorEdit,
  PDBKindEdit, PDBStaffEdit, PDBCounterEdit;

type
  TForm1 = class(TForm)
    PDBEdit1: TPDBEdit;
    PDBEdit2: TPDBEdit;
    PDBEdit3: TPDBEdit;
    PDBEdit4: TPDBEdit;
    PDBCounterEdit1: TPDBCounterEdit;
    PDBStaffEdit1: TPDBStaffEdit;
    PDBKindEdit1: TPDBKindEdit;
    PDBVendorEdit1: TPDBVendorEdit;
    PLookupEdit1: TPLookupEdit;
    PDBLookupEdit1: TPDBLookupEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

end.
