unit UQuickLinkCtrls;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UToolForm, ComCtrls, ToolWin, Buttons;

type
  TfmQuickLinkCtrls = class(TToolForm)
    btnNone: TSpeedButton;
    btnLeftAlign: TSpeedButton;
    btnLeftRightAlign: TSpeedButton;
    btnTopAlign: TSpeedButton;
    btnTopBottomAlign: TSpeedButton;
    btnLeftToRight: TSpeedButton;
    btnLeftToRight2: TSpeedButton;
    btnTopToBottom: TSpeedButton;
    btnTopToBottom2: TSpeedButton;
    procedure btnNoneClick(Sender: TObject);
    procedure btnLeftAlignClick(Sender: TObject);
    procedure btnLeftRightAlignClick(Sender: TObject);
    procedure btnTopAlignClick(Sender: TObject);
    procedure btnTopBottomAlignClick(Sender: TObject);
    procedure btnLeftToRightClick(Sender: TObject);
    procedure btnLeftToRight2Click(Sender: TObject);
    procedure btnTopToBottomClick(Sender: TObject);
    procedure btnTopToBottom2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmQuickLinkCtrls: TfmQuickLinkCtrls;

implementation

{$R *.DFM}

uses UTools, RPCtrls;

procedure TfmQuickLinkCtrls.btnNoneClick(Sender: TObject);
begin
  inherited;
  LinkControls(DesignSelection,lsNone);
end;

procedure TfmQuickLinkCtrls.btnLeftAlignClick(Sender: TObject);
begin
  inherited;
  LinkControls(DesignSelection,lsLeftAlign);
end;

procedure TfmQuickLinkCtrls.btnLeftRightAlignClick(Sender: TObject);
begin
  inherited;
  LinkControls(DesignSelection,lsLeftRightAlign);
end;

procedure TfmQuickLinkCtrls.btnTopAlignClick(Sender: TObject);
begin
  inherited;
  LinkControls(DesignSelection,lsTopAlign);
end;

procedure TfmQuickLinkCtrls.btnTopBottomAlignClick(Sender: TObject);
begin
  inherited;
  LinkControls(DesignSelection,lsTopBottomAlign);
end;

procedure TfmQuickLinkCtrls.btnLeftToRightClick(Sender: TObject);
begin
  inherited;
  LinkControls(DesignSelection,lsLeftToRight);
end;

procedure TfmQuickLinkCtrls.btnLeftToRight2Click(Sender: TObject);
begin
  inherited;
  LinkControls(DesignSelection,lsLeftToRight2);
end;

procedure TfmQuickLinkCtrls.btnTopToBottomClick(Sender: TObject);
begin
  inherited;
  LinkControls(DesignSelection,lsTopToBottom);
end;

procedure TfmQuickLinkCtrls.btnTopToBottom2Click(Sender: TObject);
begin
  inherited;
  LinkControls(DesignSelection,lsTopToBottom2);
end;

end.
