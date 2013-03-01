unit IDESpyMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls,ExptIntf;

type
  TdlgIDESpyMain = class(TForm)
    Panel1: TPanel;
    Tree: TTreeView;
    BitBtn1: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    function  GetCompDescription(Comp : TComponent): string;
    procedure AddComp(ParentNode : TTreeNode; Ctrl : TComponent);
    procedure initTree;
  public
    { Public declarations }
    procedure Execute;
  end;

var
  dlgIDESpyMain: TdlgIDESpyMain;

type
  TIDESpy = class(TIExpert)
  public
    { Expert UI strings }
    function GetName: string; Override;
    function GetAuthor: string; Override;
    function GetComment: string; Override;
    function GetPage: string; Override;
    function GetGlyph: HICON; Override;
    function GetStyle: TExpertStyle; Override;
    function GetState: TExpertState; Override;
    function GetIDString: string; Override;
    function GetMenuText: string; Override;
    { Launch the Expert }
    procedure Execute; Override;
  end;

procedure Register;

implementation

{$R *.DFM}

procedure Register;
begin
  RegisterLibraryExpert(TIDESpy.Create);
end;

{ TIDESpy }

procedure TIDESpy.Execute;
var
  Dialog : TdlgIDESpyMain;
begin
  Dialog := TdlgIDESpyMain.create(nil);
  try
    Dialog.Execute;
  finally
    Dialog.free;
  end;
end;

function TIDESpy.GetAuthor: string;
begin
  result := 'HYL';
end;

function TIDESpy.GetComment: string;
begin
  result := 'IDE Spy';
end;

function TIDESpy.GetGlyph: HICON;
begin
  result := 0;
end;

function TIDESpy.GetIDString: string;
begin
  result := 'HYL.IDESPY';
end;

function TIDESpy.GetMenuText: string;
begin
  result := 'IDESPY';
end;

function TIDESpy.GetName: string;
begin
  result := 'IDESPY';
end;

function TIDESpy.GetPage: string;
begin
  result := '';
end;

function TIDESpy.GetState: TExpertState;
begin
  result := [esEnabled];
end;

function TIDESpy.GetStyle: TExpertStyle;
begin
  result := esStandard;
end;

const
  MainFormName = 'AppBuilder';
  HeightDelta = 10;

procedure SetMultiLine(B: boolean);
var
  AppBuilder : TCustomForm;
  i : integer;
  WinCtrl : TWinControl;
  Delta : integer;
  RowSize : integer;
  CtrlPanel : TWinControl;
  CtrlBar : TControlBar;
begin
  AppBuilder := nil;
  for i:=0 to Screen.CustomFormCount-1 do
    if CompareText(Screen.CustomForms[i].name,MainFormName)=0 then
    begin
      AppBuilder := Screen.CustomForms[i];
      break;
    end;
  if AppBuilder<>nil then
  for i:=0 to AppBuilder.ComponentCount-1 do
    if AppBuilder.Components[i] is TTabControl then
    with TTabControl(AppBuilder.Components[i]) do
    begin
      if b and not MultiLine then
      begin
        MultiLine:=b;
        //WinCtrl := Parent;
        Delta := 1;
        //WinCtrl.Height := WinCtrl.Height + HeightDelta;
        //AppBuilder.Height := AppBuilder.Height + HeightDelta;
      end
      else if not b and MultiLine then
      begin
        MultiLine:=b;
        //WinCtrl := Parent;
        Delta := -1;
        //WinCtrl.Height := WinCtrl.Height - HeightDelta;
        //AppBuilder.Height := AppBuilder.Height - HeightDelta;
      end
      else Delta:=0;
      if Delta <> 0 then
      begin
        CtrlPanel := Parent;
        WinCtrl := CtrlPanel;
        RowSize := HeightDelta;
        CtrlBar := nil;
        // ajust the delta
        while WinCtrl<>nil do
        begin
          {WinCtrl.Height := WinCtrl.Height + Delta;
          WinCtrl := WinCtrl.Parent;}
          if WinCtrl is TControlBar then
          begin
            CtrlBar := TControlBar(WinCtrl);
            RowSize := CtrlBar.RowSize;
            //TControlBar(WinCtrl).RowSnap := not MultiLine;
            break;
          end
          else WinCtrl := WinCtrl.Parent;
        end;
        //CtrlPanel.Height := CtrlPanel.Height+RowSize*Delta;
        if CtrlBar<>nil then
        begin
          CtrlBar.RowSize := CtrlBar.RowSize + Delta*7;
          CtrlBar.StickControls;
          CtrlBar.Height := CtrlBar.Height + 3 * Delta*7;
          AppBuilder.Height := AppBuilder.Height + 3 * Delta*7;
          //ShowMessage(IntToStr(RowSize*Delta));
          {if CtrlBar.AutoSize then
            ShowMessage('AutoSize');}
        end;
      end;
      break;
    end;
end;

{ TForm1 }
procedure TdlgIDESpyMain.FormCreate(Sender: TObject);
begin
  if Owner=Application then initTree;
end;

procedure TdlgIDESpyMain.Execute;
begin
  initTree;
  ShowModal;
end;

procedure TdlgIDESpyMain.AddComp(ParentNode: TTreeNode; Ctrl: TComponent);
var
  Node : TTreeNode;
  i : integer;
begin
  Node := Tree.Items.AddChild(ParentNode,GetCompDescription(Ctrl));
  if Ctrl is TWinControl then
  with Ctrl as TWinControl do
  begin
    for i:=0 to ControlCount-1 do
      AddComp(Node,Controls[i]);
  end;
  for i:=0 to Ctrl.ComponentCount-1 do
      if not (Ctrl.Components[i] is TControl) then
        Tree.Items.AddChild(Node,GetCompDescription(Ctrl.Components[i]));
end;

function TdlgIDESpyMain.GetCompDescription(Comp: TComponent): string;
begin
  result := format('%s:%s',[Comp.Name,Comp.ClassName]);
end;

procedure TdlgIDESpyMain.initTree;
var
  i : integer;
  Node : TTreeNode;
begin
  Tree.Items.Clear;
  Node := Tree.Items.Add(nil,'TApplication');
  for i:=0 to Application.ComponentCount-1 do
  begin
    AddComp(Node,Application.Components[i]);
  end;
  //Tree.Items[0].Expand(true);
end;


procedure TdlgIDESpyMain.Button1Click(Sender: TObject);
begin
  SetMultiLine(true);
end;


procedure TdlgIDESpyMain.Button2Click(Sender: TObject);
begin
  SetMultiLine(false);
end;

{
procedure TdlgIDESpyMain.SetMultiLine(B: boolean);
var
  AppBuilder : TCustomForm;
  i : integer;
  WinCtrl : TWinControl;
  Delta : integer;
begin
  AppBuilder := nil;
  for i:=0 to Screen.CustomFormCount-1 do
    if CompareText(Screen.CustomForms[i].name,MainFormName)=0 then
    begin
      AppBuilder := Screen.CustomForms[i];
      break;
    end;
  if AppBuilder<>nil then
  for i:=0 to AppBuilder.ComponentCount-1 do
    if AppBuilder.Components[i] is TTabControl then
    with TTabControl(AppBuilder.Components[i]) do
    begin
      if b and not MultiLine then
      begin
        MultiLine:=b;
        //WinCtrl := Parent;
        Delta := HeightDelta;
        //WinCtrl.Height := WinCtrl.Height + HeightDelta;
        //AppBuilder.Height := AppBuilder.Height + HeightDelta;
      end
      else if not b and MultiLine then
      begin
        MultiLine:=b;
        //WinCtrl := Parent;
        Delta := -HeightDelta;
        //WinCtrl.Height := WinCtrl.Height - HeightDelta;
        //AppBuilder.Height := AppBuilder.Height - HeightDelta;
      end
      else Delta:=0;
      if Delta > 0 then
      begin
        WinCtrl := Parent;
        while WinCtrl<>nil do
        begin
          WinCtrl.Height := WinCtrl.Height + Delta;
          WinCtrl := WinCtrl.Parent;
        end;
      end;
      break;
    end;
end;
}

initialization
  //SetMultiLine(true);
end.
