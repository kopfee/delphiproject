unit UCopyChildren;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, CheckLst;

type
  TdlgCopyChildren = class(TForm)
    lsCtrls: TCheckListBox;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Execute(AParent : TWinControl);
  end;

var
  dlgCopyChildren: TdlgCopyChildren;

procedure CopyChildren(AParent : TWinControl);

implementation

uses CompUtils, RPCtrls, UTools;

{$R *.DFM}

procedure CopyChildren(AParent : TWinControl);
var
  dialog : TdlgCopyChildren;
begin
  dialog := TdlgCopyChildren.Create(Application);
  try
    dialog.Execute(AParent);
  finally
    dialog.Free;
  end;
end;

{ TdlgCopyChildren }

procedure TdlgCopyChildren.Execute(AParent: TWinControl);
var
  i : integer;
  Ctrl : TControl;
  List : TList;
  AOwner : TComponent;
begin
  AOwner := AParent.Owner;
  lsCtrls.Items.Clear;
  for i:=0 to AParent.ControlCount-1 do
  begin
    Ctrl := AParent.Controls[i];
    lsCtrls.Items.AddObject(GetDesignObjectName(Ctrl),Ctrl);
    lsCtrls.Checked[lsCtrls.Items.Count-1]:=True;
  end;
  if ShowModal =  mrOk then
  begin
    List := TList.Create;
    try
      for i:=0 to AParent.ControlCount-1 do
        if lsCtrls.Checked[i] then
        begin
          Ctrl := TControl(lsCtrls.Items.Objects[i]);
          List.Add(Ctrl);
        end;
      if List.Count>0 then
        CopyComponents(AOwner,List);  
    finally
      List.Free;
    end;
  end;
end;

end.
