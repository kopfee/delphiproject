unit TestReg;

interface

uses Classes;

procedure Register;

implementation

uses TreeItems;

procedure Register;
begin
  RegisterComponents('users', [TFolderView]);
end;

end.
