unit UPlugin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList;

type
  // Report Design System Plugin
  TRDSPlugIn = class(TDataModule)
    ActionList: TActionList;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure   BeforeLoad; virtual;
    procedure   AfterLoad; virtual;
    procedure   Changed(Obj : TObject); virtual;
  end;

var
  RDSPlugIn: TRDSPlugIn;

implementation

{$R *.DFM}

{ TRDSPlugIn }

procedure TRDSPlugIn.AfterLoad;
begin

end;

procedure TRDSPlugIn.BeforeLoad;
begin

end;

procedure TRDSPlugIn.Changed(Obj: TObject);
begin

end;

end.
