unit KSCtrls;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,ExtCtrls,Buttons,db,dbctrls,dbgrids,mask;

type
  TKSLabel = class(TLabel)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

  TKSDBLabel = class(TDBText)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

  TKSButton = class(TBitBtn)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

  TKSPanel  = class(TPanel)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

  TKSEdit = class(TMaskEdit)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

  TKSDateEdit = class(TKSEdit)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

  TKSSwitchEdit = class(TKSEdit)
  private
    FItems: TStrings;
    procedure SetItems(const Value: TStrings);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
  published
    { Published declarations }
    property  Items : TStrings read FItems write SetItems;
  end;

  TKSListEdit = class(TKSEdit)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

  TKSCheckBox =class(TCheckBox)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

  TKSComboBox = class(TComboBox)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

  TKSDBGrid = class(TDBGrid)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

  TKSMemo = class(TMemo)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

  TKSDBMemo = class(TDBMemo)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

  TKSNotebook = class(TNotebook)
  private

  protected

  public
    constructor Create(AOwner : TComponent); override;
  published 

  end;

  TKSForm = class(TForm)

  end;

implementation

{ TKSSwitchEdit }

constructor TKSSwitchEdit.Create(AOwner: TComponent);
begin
  inherited;
  FItems:=TStringList.create;
end;

destructor TKSSwitchEdit.Destroy;
begin
  FItems.free;
  inherited;
end;

procedure TKSSwitchEdit.SetItems(const Value: TStrings);
begin
  FItems.Assign(Value);
end;

{ TKSNotebook }

constructor TKSNotebook.Create(AOwner: TComponent);
begin
  inherited;
  Include(FComponentStyle, csInheritable);
end;

end.
