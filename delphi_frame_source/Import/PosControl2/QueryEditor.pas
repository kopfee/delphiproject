unit QueryEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DsgnIntf, DbTables, DBLists, DB, EditorForm, QueryDialog;


procedure Register;

implementation


{ TQueryDialogProperty }


type
  TQueryDialogProperty = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetValue: string; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

procedure TQueryDialogProperty.Edit;
var
  i : integer;
  EditForm : TfrmDisplayEditor;
begin
  with GetComponent(0) as TQueryDialog do
  begin
    if TransTable.Count > 0 then
    begin
      EditForm := TfrmDisplayEditor.Create(Application);
      EditForm.InternalList := TList.Create;
      for i := 0 to TransTable.Count-1 do
      begin
        EditForm.InternalList.Add(TFieldInfo.Create);
        TFieldInfo(EditForm.InternalList.Items[i]).FieldName :=
           TransTable.Items[i].FieldName;
        TFieldInfo(EditForm.InternalList.Items[i]).DisplayName :=
           TransTable.Items[i].DisplayName;
        TFieldInfo(EditForm.InternalList.Items[i]).FieldType :=
           TransTable.Items[i].FieldType;
        TFieldInfo(EditForm.InternalList.Items[i]).PickList :=
           TStringList.Create;
        TFieldInfo(EditForm.InternalList.Items[i]).PickList.Assign(
           TransTable.Items[i].PickList);
      end;
      EditForm.grdName.RowCount := TransTable.Count+1;
      if EditForm.ShowModal=mrOK then
      begin
         Designer.Modified;
         for i := 0 to TransTable.Count-1 do
         begin
           TransTable.Items[i].FieldName:=
               TFieldInfo(EditForm.InternalList.Items[i]).FieldName;
           TransTable.Items[i].DisplayName:=
               TFieldInfo(EditForm.InternalList.Items[i]).DisplayName;
           TransTable.Items[i].FieldType:=
               TFieldInfo(EditForm.InternalList.Items[i]).FieldType;
           TransTable.Items[i].PickList.Assign(
               TFieldInfo(EditForm.InternalList.Items[i]).PickList);
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

function TQueryDialogProperty.GetValue: string;
begin
  Result := '[DisplayName]';
end;

function TQueryDialogProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog,paReadOnly];
end;


{ TQueryDialogEditor}

type
 TQueryDialogEditor = class(TComponentEditor)
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;



function TQueryDialogEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

function TQueryDialogEditor.GetVerb(index: Integer): string;
begin
  case index of
    0: Result := 'DisplayCaption Editor';
  end;
end;

procedure TQueryDialogEditor.ExecuteVerb (index: integer);
var
  i : integer;
  EditForm : TfrmDisplayEditor;
begin
  case index of
    0: begin
         with Component as TQueryDialog do
         begin
           if TransTable.Count > 0 then
           begin
             EditForm := TfrmDisplayEditor.Create(Application);
             EditForm.InternalList := TList.Create;
             for i := 0 to TransTable.Count-1 do
             begin
               EditForm.InternalList.Add(TFieldInfo.Create);
               TFieldInfo(EditForm.InternalList.Items[i]).FieldName :=
                  TransTable.Items[i].FieldName;
               TFieldInfo(EditForm.InternalList.Items[i]).DisplayName :=
                  TransTable.Items[i].DisplayName;
               TFieldInfo(EditForm.InternalList.Items[i]).FieldType :=
                  TransTable.Items[i].FieldType;
               TFieldInfo(EditForm.InternalList.Items[i]).PickList :=
                  TStringList.Create;
               TFieldInfo(EditForm.InternalList.Items[i]).PickList.Assign(
                  TransTable.Items[i].PickList);
             end;
             EditForm.grdName.RowCount := TransTable.Count+1;
             if EditForm.ShowModal=mrOK then
             begin
                Designer.Modified;
                for i := 0 to TransTable.Count-1 do
                begin
                  TransTable.Items[i].FieldName:=
                    TFieldInfo(EditForm.InternalList.Items[i]).FieldName;
                  TransTable.Items[i].DisplayName:=
                    TFieldInfo(EditForm.InternalList.Items[i]).DisplayName;
                  TransTable.Items[i].FieldType:=
                    TFieldInfo(EditForm.InternalList.Items[i]).FieldType;
                  TransTable.Items[i].PickList.Assign(
                    TFieldInfo(EditForm.InternalList.Items[i]).PickList);
                end;
             end;
             for i := 0 to EditForm.InternalList.Count-1 do
             begin
               TFieldInfo(EditForm.InternalList.Items[i]).PickList.Free;
               TFieldInfo(EditForm.InternalList.Items[i]).Free;
             end;
             EditForm.InternalList.Free;
           end;
         end;
       end;
  end;
end;

procedure TQueryDialogEditor.Edit;
begin
  ExecuteVerb(0);
end;

procedure Register;
begin
  RegisterComponentEditor(TQueryDialog,TQueryDialogEditor);
  RegisterPropertyEditor(TypeInfo(TTransTable),TQueryDialog, 'TransTable',
    TQueryDialogProperty);
end;

end.
