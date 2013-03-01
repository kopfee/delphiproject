unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ImageCtrls, ExtCtrls, UICtrls, KSActions, ActnList, ImagesMan,
  UIStyles;

type
  TForm1 = class(TForm)
    NormalStyle: TUIStyle;
    DefaultButtons: TCommandImages;
    ActionList1: TActionList;
    KSListDelete1: TKSListDelete;
    KSListMoveDown1: TKSListMoveDown;
    KSListMoveUp1: TKSListMoveUp;
    UIPanel1: TUIPanel;
    lsMenuIDs: TListBox;
    btnOk: TImageButton;
    btnCancel: TImageButton;
    btnUp: TImageButton;
    btnDown: TImageButton;
    btnDelete: TImageButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

end.
