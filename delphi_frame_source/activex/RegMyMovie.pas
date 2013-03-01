unit RegMyMovie;

interface

uses Sysutils,classes;

procedure Register;

implementation

uses MyMovie;

procedure Register;
begin
  RegisterComponents('ActiveX',[TMyMovie]);
end;

end.
