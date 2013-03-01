unit RegLexi;

interface

procedure Register;

implementation

uses Classes, LXScanner;

procedure Register;
begin
  RegisterComponents('Users', [TLXScanner]);
end;

end.
