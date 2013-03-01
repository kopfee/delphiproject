unit RegObjView;

interface

procedure Register;

implementation

uses Classes, ObjStructViews;

procedure Register;
begin
  RegisterComponents('UserCtrls',[TObjStructViews]);
end;

end.
