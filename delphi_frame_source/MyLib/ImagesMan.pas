unit ImagesMan;


{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>ImagesMan
   <What>管理图像资源
   <Written By> Huang YanLai
   <History>
**********************************************}


interface

uses SysUtils, Classes, UIStyles, Controls, extctrls, Buttons, Graphics;

const
  BtnDefaultWidth = 75;
  BtnDefaultHeight = 25;

type
  TCommandImages = class;

  TCommandImage = class(TUICustomStyleItem)
  private
    FCaption: String;
    FCommandImages: TCommandImages;
    FImageIndex: integer;
    FHeight: Integer;
    FWidth: Integer;
    FHint: string;
    procedure   SetCaption(const Value: String);
    procedure   SetImageIndex(const Value: integer);
    function    GetImageAvailable: Boolean;
    procedure   SetHeight(const Value: Integer);
    procedure   SetWidth(const Value: Integer);
  protected

  public
    constructor Create(Collection: TCollection); override;
    property    CommandImages : TCommandImages read FCommandImages;
    property    ImageAvailable : Boolean read GetImageAvailable;
  published
    property    ImageIndex : integer read FImageIndex write SetImageIndex default -1;
    property    Caption : String read FCaption write SetCaption;
    property    Width : Integer read FWidth write SetWidth default BtnDefaultWidth;
    property    Height : Integer read FHeight write SetHeight default BtnDefaultHeight;
    property    Hint : string read FHint write FHint;
  end;

  TCommandImages = class(TUICustomStyle)
  private
    FImages: TImageList;
    FFrameColor: TColor;
    FBackgroundColor: TColor;
    FShadowColor: TColor;
    FDisabledColor: TColor;
    FBrightColor: TColor;
    FFont: TFont;
    procedure   SetImages(const Value: TImageList);
    procedure   SetBackgroundColor(const Value: TColor);
    procedure   SetDisabledColor(const Value: TColor);
    procedure   SetFrameColor(const Value: TColor);
    procedure   SetShadowColor(const Value: TColor);
    procedure   SetBrightColor(const Value: TColor);
    procedure   SetFont(const Value: TFont);
    procedure   FontChanged(Sender : TObject);
  protected
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner : TComponent); override;
    class function GetItemClass : TUICustomStyleItemClass; override;
  published
    property    Items;
    property    Images : TImageList read FImages write SetImages;
    property    FrameColor : TColor read FFrameColor write SetFrameColor default clWindowFrame;
    property    BackgroundColor : TColor read FBackgroundColor write SetBackgroundColor default clBtnFace;
    property    ShadowColor : TColor read FShadowColor write SetShadowColor default clBtnShadow;
    property    DisabledColor : TColor read FDisabledColor write SetDisabledColor default clBtnHighlight;
    property    BrightColor : TColor read FBrightColor write SetBrightColor default clBtnHighlight;
    property    Font : TFont read FFont write SetFont;
  end;

  TCommandImageLink = class(TUICustomStyleItemLink)
  private
    function    GetImageAvailable: Boolean;
    function    GetCommandImage: TCommandImage;
    procedure   SetCommandImage(const Value: TCommandImage);
  protected

  public
    constructor Create;
    property    ImageAvailable : Boolean read GetImageAvailable;
    property    CommandImage : TCommandImage read GetCommandImage write SetCommandImage;
  end;

  TUIImages = class;

  TUIImageItem = class(TUICustomStyleItem)
  private
    FPicture: TPicture;
    FImages: TUIImages;
    procedure   SetPicture(const Value: TPicture);
    procedure   PictureChanged(Sender : TObject);
  protected

  public
    constructor Create(Collection: TCollection); override;
    destructor  Destroy;override;
    property    Images : TUIImages read FImages;
  published
    property    Picture : TPicture read FPicture write SetPicture;
  end;

  TUIImages = class(TUICustomStyle)
  private

  protected

  public
    class function GetItemClass : TUICustomStyleItemClass; override;
  published
    property    Items;
  end;

  TUIImageLink = class(TUICustomStyleItemLink)
  private
    function    GetImage: TUIImageItem;
    procedure   SetImage(const Value: TUIImageItem);
  protected

  public
    constructor Create;
    property    Image : TUIImageItem read GetImage write SetImage;
  end;

implementation

uses Windows;

{ TCommandImage }

constructor TCommandImage.Create(Collection: TCollection);
begin
  inherited;
  assert(Style is TCommandImages);
  FCommandImages := TCommandImages(Style);
  FImageIndex := -1;
  FHeight := BtnDefaultHeight;
  FWidth := BtnDefaultWidth;
end;

function TCommandImage.GetImageAvailable: Boolean;
begin
  Assert(FCommandImages is TCommandImages);
  if FCommandImages.Images<>nil then
    OutputDebugString(Pchar(IntToStr(FCommandImages.Images.Count)));
  Result := (FCommandImages.Images<>nil) and (FImageIndex>=0)
    and (FImageIndex<FCommandImages.Images.Count);
end;

procedure TCommandImage.SetCaption(const Value: String);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Changed(false);
  end;
end;

procedure TCommandImage.SetHeight(const Value: Integer);
begin
  if FHeight <> Value then
  begin
    FHeight := Value;
    Changed(false);
  end;
end;

procedure TCommandImage.SetImageIndex(const Value: integer);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    Changed(false);
  end;
end;

procedure TCommandImage.SetWidth(const Value: Integer);
begin
  if FWidth <> Value then
  begin
    FWidth := Value;
    Changed(false);
  end;
end;

{ TCommandImages }

constructor TCommandImages.Create(AOwner: TComponent);
begin
  inherited;
  FImages := nil;
  FFrameColor := clWindowFrame;
  FBackgroundColor := clBtnFace;
  FShadowColor := clBtnShadow;
  FDisabledColor := clBtnHighlight;
  FBrightColor := clBtnHighlight;
  FFont := TFont.Create;
  FFont.OnChange := FontChanged;
end;

procedure TCommandImages.FontChanged(Sender: TObject);
begin
  UIStyleChanged(Self);
end;

class function TCommandImages.GetItemClass: TUICustomStyleItemClass;
begin
  Result := TCommandImage;
end;

procedure TCommandImages.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent=FImages) and (Operation=opRemove) then
    Images := nil;
end;

procedure TCommandImages.SetBackgroundColor(const Value: TColor);
begin
  if FBackgroundColor <> Value then
  begin
    FBackgroundColor := Value;
    UIStyleChanged(Self);
  end;
end;

procedure TCommandImages.SetBrightColor(const Value: TColor);
begin
  if FBrightColor <> Value then
  begin
    FBrightColor := Value;
    UIStyleChanged(Self);
  end;
end;

procedure TCommandImages.SetDisabledColor(const Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    UIStyleChanged(Self);
  end;
end;

procedure TCommandImages.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TCommandImages.SetFrameColor(const Value: TColor);
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    UIStyleChanged(Self);
  end;
end;

procedure TCommandImages.SetImages(const Value: TImageList);
begin
  if FImages <> Value then
  begin
    FImages := Value;
    if FImages<>nil then FImages.FreeNotification(self);
  end;
end;

procedure TCommandImages.SetShadowColor(const Value: TColor);
begin
  if FShadowColor <> Value then
  begin
    FShadowColor := Value;
    UIStyleChanged(Self);
  end;
end;

{ TCommandImageLink }

constructor TCommandImageLink.Create;
begin
  inherited Create(TCommandImage);
end;

function TCommandImageLink.GetImageAvailable: Boolean;
begin
  Result := IsAvailable and CommandImage.ImageAvailable;
end;

function TCommandImageLink.GetCommandImage: TCommandImage;
begin
  Result := TCommandImage(StyleItem);
end;

procedure TCommandImageLink.SetCommandImage(const Value: TCommandImage);
begin
  StyleItem := Value;
end;

{ TUIImageItem }

constructor TUIImageItem.Create(Collection: TCollection);
begin
  inherited;
  assert(Style is TUIImages);
  FImages := TUIImages(Style);
  FPicture := TPicture.Create;
  FPicture.OnChange := PictureChanged;
end;

destructor TUIImageItem.Destroy;
begin
  FPicture.OnChange := nil;
  FreeAndNil(FPicture);
  inherited;
end;

procedure TUIImageItem.PictureChanged(Sender: TObject);
begin
  UIStyleChanged(Self);
end;

procedure TUIImageItem.SetPicture(const Value: TPicture);
begin
  FPicture.Assign(Value);
end;

{ TUIImages }

class function TUIImages.GetItemClass: TUICustomStyleItemClass;
begin
  Result := TUIImageItem;
end;

{ TUIImageLink }

constructor TUIImageLink.Create;
begin
  inherited Create(TUIImageItem);
end;

function TUIImageLink.GetImage: TUIImageItem;
begin
  Result := TUIImageItem(StyleItem);
end;

procedure TUIImageLink.SetImage(const Value: TUIImageItem);
begin
  StyleItem := Value;
end;

end.
