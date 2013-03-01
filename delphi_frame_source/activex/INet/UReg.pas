unit UReg;

interface

procedure Register;

implementation

uses Classes,InetCtlsObjects_TLB;

procedure Register;
begin
  RegisterComponents('ActiveX',[TInet]);
end;

end.
 