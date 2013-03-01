unit DQueryEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DsgnIntf, DbTables, DBLists, DB, EditorForm, QueryDialog, DQueryDialog ;


procedure Register;

implementation

{ TMasterProperty }


type
  TMasterProperty = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetValue: string; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

procedure TMasterProperty.Edit;
var i: integer;
    EditForm: TfrmDisplayEditor;
begin
     with GetComponent(0) as TDQueryDialog do
     begin
          if MasterTransTable.Count > 0 then
          begin
               EditForm := TfrmDisplayEditor.Create(Application);
               EditForm.InternalList := TList.Create;
               for i := 0 to MasterTransTable.Count-1 do
               begin
                    EditForm.InternalList.Add(TFieldInfo.Create);
                    TFieldInfo(EditForm.InternalList.Items[i]).FieldName := MasterTransTable.Items[i].FieldName;
                    TFieldInfo(EditForm.InternalList.Items[i]).DisplayName := MasterTransTable.Items[i].DisplayName;
                    TFieldInfo(EditForm.InternalList.Items[i]).FieldType := MasterTransTable.Items[i].FieldType;
                    TFieldInfo(EditForm.InternalList.Items[i]).PickList := TStringList.Create;
                    TFieldInfo(EditForm.InternalList.Items[i]).PickList.Assign(MasterTransTable.Items[i].PickList);
               end;
               EditForm.grdName.RowCount := MasterTransTable.Count+1;
               if EditForm.ShowModal=mrOK then
               begin
                    Designer.Modified;
                    for i := 0 to MasterTransTable.Count-1 do
                    begin
                         MasterTransTable.Items[i].FieldName:=
                         TFieldInfo(EditForm.InternalList.Items[i]).FieldName;
                         MasterTransTable.Items[i].DisplayName:= TFieldInfo(EditForm.InternalList.Items[i]).DisplayName;
                         MasterTransTable.Items[i].FieldType:= TFieldInfo(EditForm.InternalList.Items[i]).FieldType;
                         MasterTransTable.Items[i].PickList.Assign(TFieldInfo(EditForm.InternalList.Items[i]).PickList);
                    end;
               end;
               for i := 0 to EditForm.InternalList.Count-1 do
               begin
                    TFieldInfo(EditForm.InternalList.Items[i]).PickList.Free;
                    TFieldInfo(EditForm.InternalList.Items[i]).Free;
               end;
               EditForm.InternalList.Free;
               EditForm.Free;
          end;
     end;
end;

function TMasterProperty.GetValue: string;
begin
     Result := '[MasterTable]';
end;

function TMasterProperty.GetAttributes: TPropertyAttributes;
begin
     Result := [paDialog,paReadOnly];
end;

{ TDetailProperty }
type
  TDetailProperty = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetValue: string; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

procedure TDetailProperty.Edit;
var i: integer;
    EditForm : TfrmDisplayEditor;
begin
     with GetComponent(0) as TDQueryDialog do
     begin
          if DetailTransTable.Count > 0 then
          begin
               EditForm := TfrmDisplayEditor.Create(Application);
               EditForm.InternalList := TList.Create;
               for i := 0 to DetailTransTable.Count-1 do
               begin
                    EditForm.InternalList.Add(TFieldInfo.Create);
                    TFieldInfo(EditForm.InternalList.Items[i]).FieldName := DetailTransTable.Items[i].FieldName;
                    TFieldInfo(EditForm.InternalList.Items[i]).DisplayName := DetailTransTable.Items[i].DisplayName;
                    TFieldInfo(EditForm.InternalList.Items[i]).FieldType := DetailTransTable.Items[i].FieldType;
                    TFieldInfo(EditForm.InternalList.Items[i]).PickList := TStringList.Create;
                    TFieldInfo(EditForm.InternalList.Items[i]).PickList.Assign(DetailTransTable.Items[i].PickList);
               end;
               EditForm.grdName.RowCount := DetailTransTable.Count+1;
               if EditForm.ShowModal=mrOK then
               begin
                    Designer.Modified;
                    for i := 0 to DetailTransTable.Count-1 do
                    begin
                         DetailTransTable.Items[i].FieldName:=
                         TFieldInfo(EditForm.InternalList.Items[i]).FieldName;
                         DetailTransTable.Items[i].DisplayName:= TFieldInfo(EditForm.InternalList.Items[i]).DisplayName;
                         DetailTransTable.Items[i].FieldType:= TFieldInfo(EditForm.InternalList.Items[i]).FieldType;
                         DetailTransTable.Items[i].PickList.Assign(TFieldInfo(EditForm.InternalList.Items[i]).PickList);
                    end;
               end;
               for i := 0 to EditForm.InternalList.Count-1 do
               begin
                    TFieldInfo(EditForm.InternalList.Items[i]).PickList.Free;
                    TFieldInfo(EditForm.InternalList.Items[i]).Free;
               end;
               EditForm.InternalList.Free;
               EditForm.Free;
          end;
     end;
end;

function TDetailProperty.GetValue: string;
begin
     Result := '[DetailTable]';
end;

function TDetailProperty.GetAttributes: TPropertyAttributes;
begin
     Result := [paDialog,paReadOnly];
end;

procedure Register;
begin
     RegisterPropertyEditor(TypeInfo(TTransTable),TDQueryDialog, 'MasterTransTable', TMasterProperty);
     RegisterPropertyEditor(TypeInfo(TTransTable),TDQueryDialog, 'DetailTransTable', TDetailProperty);
end;

end.

