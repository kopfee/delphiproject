unit URegDBLib;

interface

procedure Register;

implementation

uses Classes, MSSQLAcs;

const
  page = 'HDB';

procedure Register;
begin
  RegisterComponents(page,[TMSSQLDatabase]);
end;

end.
