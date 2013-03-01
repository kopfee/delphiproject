{ :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: QuickReport 2.0 Delphi 1.0/2.0/3.0                      ::
  ::                                                         ::
  :: QRALIAS - Table selection dialog                        ::
  ::                                                         ::
  :: Copyright (c) 1997 QuSoft AS                            ::
  :: All Rights Reserved                                     ::
  ::                                                         ::
  :: web: http://www.qusoft.no   mail: support@qusoft.no     ::
  ::                          fax: +47 22 41 74 91           ::
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: }

unit qralias;

interface

uses
{$ifdef win32}
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, DB, ExtCtrls, ComCtrls, QR2Const;
{$else}
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, DB, ExtCtrls, QR2Const;
{$endif}

type
  TQRTableSelect = class(TForm)
    Alias: TComboBox;
    Table: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    OK: TButton;
    Cancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure AliasChange(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure OKClick(Sender: TObject);
  public
    strTable, strAlias : string;
  end;

implementation

{$R *.DFM}

procedure TQRTableSelect.FormCreate(Sender: TObject);
begin
  Screen.Cursor := crHourglass;
  try
    Session.GetAliasNames(Alias.Items);
    Alias.ItemIndex := 0;
  finally
    Screen.Cursor := crDefault;
  end;
  AliasChange(nil);
end;

procedure TQRTableSelect.AliasChange(Sender: TObject);
begin
  Screen.Cursor := crHourglass;
  try
    with Alias do
      Session.GetTableNames(Items[ItemIndex],'', TRUE, FALSE, Table.Items );
    Table.Items.Insert(0, '<' + LoadStr(SqrNone) + '>');
    Table.ItemIndex := 0;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TQRTableSelect.CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TQRTableSelect.OKClick(Sender: TObject);
begin
  if Table.ItemIndex = 0 then
    Exit;
  strAlias := Alias.Items[Alias.ItemIndex];
  strTable := Table.Items[Table.ItemIndex];
  ModalResult := mrOK;
end;

end.
