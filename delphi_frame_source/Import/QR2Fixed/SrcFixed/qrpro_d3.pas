{ :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: QuickReport 2.0 for Delphi 1.0/2.0/3.0                  ::
  ::                                                         ::
  :: QRPRO_D3.PAS - QuickReport Pro registration unit        ::
  :: for Delphi 3                                            ::
  ::                                                         ::
  :: Copyright (c) 1997 QuSoft AS                            ::
  :: All Rights Reserved                                     ::
  ::                                                         ::
  :: web: http://www.qusoft.no   mail: support@qusoft.no     ::
  ::                             fax: +47 22 41 74 91        ::
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: }

(*{$define proversion}*)

unit qrpro_d3;

interface

uses QRExtra;

procedure Register;

implementation

uses classes;
{ Register components and property editors }

procedure Register;
begin
{$ifdef ver100}
  RegisterComponents('QReport',[TQREditor]);
{$endif}
end;

end.
