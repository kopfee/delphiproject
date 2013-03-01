unit PDateEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ToolEdit,DateInput,dsgnintf,base_delphi_utils;

type
    TPDateEditDatePropertyEdit = Class (TComponentProperty)
         DateValue: TDateTime;
         procedure Edit; override;
         function GetAttributes : TPropertyAttributes; override;
         function GetValue : String ; override;
    end;


type
  TPDateEdit = class(TDateEdit)
  private
    FCheckResult: Boolean ;
    FDateStr: string;
    FMaxDate: TDateTime;
    FMinDate: TDateTime;
  protected
    function GetRdOnly:Boolean;
    procedure Check ;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure SetMinDate(value: TDateTime);
    procedure SetMaxDate(Value: TDateTime);
    procedure SetRdOnly(Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    property CheckResult: Boolean read FCheckResult write FCheckResult;
    property DateStr: string read FDateStr;
  published
    property EditMask;
    property MinDate: TDateTime read FMinDate write SetMinDate;
    property MaxDate: TDateTime read FMaxDate write SetMaxDate;
    property RdOnly: Boolean read GetRdOnly write SetRdOnly;
    property  DefaultToday default false;
  end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents('Poscontrol2', [TPDateEdit]);
     RegisterPropertyEditor( TypeInfo(TDateTime), TPDateEdit, 'MaxDate',
                             TPDateEditDatePropertyEdit);
     RegisterPropertyEditor( TypeInfo(TDateTime), TPDateEdit, 'MinDate',
                             TPDateEditDatePropertyEdit);
end;


constructor TPDateEdit.Create(AOwner: TComponent);
begin
     inherited;
     YearDigits := dyFour;
     shortdateformat := 'mm/dd/yyyy';
     Text := DateToStr(now());
     Font.Size := 9;
     Font.Name := '宋体';
     ParentFont := False;
     DefaultToday := false;
     Text := '';
end;

procedure TPDateEditDatePropertyEdit.Edit;
var DateInput: TDateInput1;
begin
     DateInput := TDateInput1.Create(Application);
     DateInput.showmodal;
     try
        if DateInput.ok then
        begin
             StrToDate(DateInput.GetDate);
             DateValue := StrToDate(Dateinput.GetDate);
        end
     finally
            DateInput.Free;
     end;
end;

function TPDateEditDatePropertyEdit.GetAttributes : TPropertyAttributes;
begin
     Result:=[ paDialog, paAutoUpdate];
end;


function TPDateEditDatePropertyEdit.GetValue: string;
begin
     shortDateformat := 'yyyy/mm/dd';
     Result := DateToStr(DateValue);
end;

procedure TPDateEdit.SetMaxDate(value : TDateTime);
begin
     if Value < FMinDate then
        ShowMessage('最大日期不能小于最小日期！')
     else
         FMaxDate := value;
end;

procedure TPDateEdit.SetMinDate(value : TDateTime);
begin
     if Value > FMinDate then
        ShowMessage('最小日期不能大于最大日期！')
     else
         FMinDate := value;
end;

procedure TPDateEdit.Check ;
begin
     shortdateformat := 'mm/dd/yyyy';
     if (text = '  -  -    ') or ( text = '  /  /    ') then
     begin
          FCheckResult := False;
          exit;
     end;

     try
        shortdateformat := 'mm/dd/yyyy';
        FDateStr := Text;
        if dateformat(FDateStr,'/') =  False then
            FCheckResult := False
        else
            FCheckResult := True;
     except
           FCheckResult := False
     end;
end;

function TPDateEdit.GetRdOnly:Boolean;
begin
     Result := ReadOnly;
end;

procedure TPDateEdit.SetRdOnly(Value: Boolean);
begin
     ReadOnly := Value;
     if Value then
        Color := clSilver
     else
         Color := clWhite;
end;

procedure TPDateEdit.CMExit(var Message: TCMExit);
begin
     check;
     shortdateformat := 'mm/dd/yyyy';
     inherited;
     shortdateformat := 'mm/dd/yyyy';
end;

end.

