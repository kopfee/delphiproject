unit RepInfoIntf;

(*****   Code Written By Huang YanLai   *****)

interface

uses classes;

type
  TReportCatalog = (rcNormal,rcNoChanges,rcChanges,rcWarning,rcError);

  IReport = interface
    procedure addInfo(const s:string;catalog:TReportCatalog=rcNormal);
    procedure addInfos(const s:TStrings;catalog:TReportCatalog=rcNormal);
    procedure clearInfo;
  end;

implementation

end.
 