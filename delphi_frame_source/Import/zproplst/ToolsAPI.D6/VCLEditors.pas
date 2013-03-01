
{*******************************************************}
{                                                       }
{       Borland Delphi Visual Component Library         }
{                                                       }
{       Copyright (c) 1995, 2001 Borland Software Corp. }
{                                                       }
{       Windows specific property editors               }
{                                                       }
{*******************************************************}

unit VCLEditors;

interface

uses
  Messages, Types, Classes, Graphics, Menus, Controls, Forms, StdCtrls,
  DesignIntf, DesignEditors, DesignMenus, ActnList;

{ Property Editors }

type
{ ICustomPropertyDrawing
  Implementing this interface allows a property editor to take over the object
  inspector's drawing of the name and the value. If paFullWidthName is returned
  by IProperty.GetAttributes then only PropDrawName will be called. Default
  implementation of both these methods are provided in DefaultPropDrawName
  and DefaultPropDrawValue in this unit. }
  ICustomPropertyDrawing = interface
    ['{E1A50419-1288-4B26-9EFA-6608A35F0824}']
    procedure PropDrawName(ACanvas: TCanvas; const ARect: TRect;
      ASelected: Boolean);
    procedure PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
      ASelected: Boolean);
  end;

{ ICustomPropertyDrawing
  Implemention this interface allows a property editor to take over the drawing
  of the drop down list box displayed by the property editor. This is only
  meaningful to implement if the property editor returns paValueList from
  IProperty.GetAttributes. The Value parameter is the result of
  IProperty.GetValue. The implementations ListMeasureWidth and ListMeasureHeight
  can be left blank since the var parameter is filled in to reasonable defaults
  by the object inspector. A default implementation of ListDrawValue is supplied
  in the DefaultPropertyListDrawValue procedure included in this unit }
  ICustomPropertyListDrawing = interface
    ['{BE2B8CF7-DDCA-4D4B-BE26-2396B969F8E0}']
    procedure ListMeasureWidth(const Value: string; ACanvas: TCanvas;
      var AWidth: Integer);
    procedure ListMeasureHeight(const Value: string; ACanvas: TCanvas;
      var AHeight: Integer);
    procedure ListDrawValue(const Value: string; ACanvas: TCanvas;
      const ARect: TRect; ASelected: Boolean);
  end;


{ TFontNameProperty
  Editor for the TFont.FontName property.  Displays a drop-down list of all
  the fonts known by Windows.  The following global variable will make
  this property editor actually show examples of each of the fonts in the
  drop down list.  We would have enabled this by default but it takes
  too many cycles on slower machines or those with a lot of fonts.  Enable
  it at your own risk. ;-}
var
  FontNamePropertyDisplayFontNames: Boolean = False;

type
  TFontNameProperty = class(TStringProperty, ICustomPropertyListDrawing)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;

    // ICustomPropertyListDrawing
    procedure ListMeasureHeight(const Value: string; ACanvas: TCanvas;
      var AHeight: Integer);
    procedure ListMeasureWidth(const Value: string; ACanvas: TCanvas;
      var AWidth: Integer);
    procedure ListDrawValue(const Value: string; ACanvas: TCanvas;
      const ARect: TRect; ASelected: Boolean);
  end;

{ TFontCharsetProperty
  Editor for the TFont.Charset property.  Displays a drop-down list of the
  character-set by Windows.}

  TFontCharsetProperty = class(TIntegerProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;

{ TImeNameProperty
  Editor for the TImeName property.  Displays a drop-down list of all
  the IME names known by Windows.}

  TImeNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

{ TColorProperty
  Property editor for the TColor type.  Displays the color as a clXXX value
  if one exists, otherwise displays the value as hex.  Also allows the
  clXXX value to be picked from a list. }

  TColorProperty = class(TIntegerProperty, ICustomPropertyDrawing,
    ICustomPropertyListDrawing)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;

    { ICustomPropertyListDrawing }
    procedure ListMeasureHeight(const Value: string; ACanvas: TCanvas;
      var AHeight: Integer);
    procedure ListMeasureWidth(const Value: string; ACanvas: TCanvas;
      var AWidth: Integer);
    procedure ListDrawValue(const Value: string; ACanvas: TCanvas;
      const ARect: TRect; ASelected: Boolean);

    { CustomPropertyDrawing }
    procedure PropDrawName(ACanvas: TCanvas; const ARect: TRect;
      ASelected: Boolean);
    procedure PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
      ASelected: Boolean); 
  end;

{ TBrushStyleProperty
  Property editor for TBrush's Style.  Simply provides for custom render. }

  TBrushStyleProperty = class(TEnumProperty, ICustomPropertyDrawing,
    ICustomPropertyListDrawing)
  public
    { ICustomPropertyListDrawing }
    procedure ListMeasureHeight(const Value: string; ACanvas: TCanvas;
      var AHeight: Integer);
    procedure ListMeasureWidth(const Value: string; ACanvas: TCanvas;
      var AWidth: Integer);
    procedure ListDrawValue(const Value: string; ACanvas: TCanvas;
      const ARect: TRect; ASelected: Boolean);

    { ICustomPropertyDrawing }
    procedure PropDrawName(ACanvas: TCanvas; const ARect: TRect;
      ASelected: Boolean);
    procedure PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
      ASelected: Boolean);
  end;

{ TPenStyleProperty
  Property editor for TPen's Style.  Simply provides for custom render. }

  TPenStyleProperty = class(TEnumProperty, ICustomPropertyDrawing,
    ICustomPropertyListDrawing)
  public
    { ICustomPropertyListDrawing }
    procedure ListMeasureHeight(const Value: string; ACanvas: TCanvas;
      var AHeight: Integer);
    procedure ListMeasureWidth(const Value: string; ACanvas: TCanvas;
      var AWidth: Integer);
    procedure ListDrawValue(const Value: string; ACanvas: TCanvas;
      const ARect: TRect; ASelected: Boolean);

    { ICustomPropertyDrawing }
    procedure PropDrawName(ACanvas: TCanvas; const ARect: TRect;
      ASelected: Boolean);
    procedure PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
      ASelected: Boolean);
  end;

{ TCursorProperty
  Property editor for the TCursor type.  Displays the cursor as a clXXX value
  if one exists, otherwise displays the value as hex.  Also allows the
  clXXX value to be picked from a list. }

  TCursorProperty = class(TIntegerProperty, ICustomPropertyListDrawing)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;

    { ICustomPropertyListDrawing }
    procedure ListMeasureHeight(const Value: string; ACanvas: TCanvas;
      var AHeight: Integer);
    procedure ListMeasureWidth(const Value: string; ACanvas: TCanvas;
      var AWidth: Integer);
    procedure ListDrawValue(const Value: string; ACanvas: TCanvas;
      const ARect: TRect; ASelected: Boolean); 
  end;

{ TFontProperty
  Property editor for the Font property.  Brings up the font dialog as well as
  allowing the properties of the object to be edited. }

  TFontProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

{ TModalResultProperty }

  TModalResultProperty = class(TIntegerProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;

{ TShortCutProperty
  Property editor the ShortCut property.  Allows both typing in a short
  cut value or picking a short-cut value from a list. }

  TShortCutProperty = class(TOrdinalProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;

{ TMPFilenameProperty
  Property editor for the TMediaPlayer.  Displays an File Open Dialog
  for the name of the media file.}

  TMPFilenameProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

{ TTabOrderProperty
  Property editor for the TabOrder property.  Prevents the property from being
  displayed when more than one component is selected. }

  TTabOrderProperty = class(TIntegerProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
  end;

{ TCaptionProperty
  Property editor for the Caption and Text properties.  Updates the value of
  the property for each change instead on when the property is approved. }

  TCaptionProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
  end;

function GetDisplayValue(const Prop: IProperty): string;
procedure DefaultPropertyDrawName(Prop: TPropertyEditor; Canvas: TCanvas;
  const Rect: TRect);
procedure DefaultPropertyDrawValue(Prop: TPropertyEditor; Canvas: TCanvas;
  const Rect: TRect);
procedure DefaultPropertyListDrawValue(const Value: string; Canvas: TCanvas;
  const Rect: TRect; Selected: Boolean);

type
{ ISelectionMessage }

{ If a selection editor implements this interface the form designer will ensure
  all windows message are first sent through this interface before handling
  them when the selection editor for the corresponding class is selected.

  IsSelectionMessage - Filter for all messages processed by the designer when
    this the implementing selection editor is active. Return True if the message
    is handled by the selection editor which causes the designer to ignore
    the message (as well as preventing the control from seeing the message)
    or False, allowing the designer to process the message normally.
      Sender   the control that received the original message.
      Message  the message sent by windows to the control. }
  ISelectionMessage = interface
    ['{58274878-BB87-406A-9220-904105C9E112}']
    function IsSelectionMessage(Sender: TControl;
      var Message: TMessage): Boolean;
  end;

  ISelectionMessageList = interface
    ['{C1360368-0099-4A7C-A4A8-7650503BA0C6}']
    function Get(Index: Integer): ISelectionMessage;
    function GetCount: Integer;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: ISelectionMessage read Get; default;
  end;

function SelectionMessageListOf(const SelectionEditorList: ISelectionEditorList): ISelectionMessageList;

{ Custom Module Types }

type

{ ICustomDesignForm
  Allows a custom module to create a different form for use by the designer
  as the base form.

    CreateDesignForm - Create a descendent of TCustomForm for use by the
      designer as the instance to design }
  ICustomDesignForm = interface
    ['{787195AF-C234-49DC-881B-221B69C0137A}']
    procedure CreateDesignerForm(const Designer: IDesigner; Root: TComponent;
      out DesignForm: TCustomForm; out ComponentContainer: TWinControl);
  end;

{ Clipboard utility functions }

var
  CF_COMPONENTS: Word;

procedure CopyStreamToClipboard(S: TMemoryStream);
function GetClipboardStream: TMemoryStream;

{ EditAction utility functions }

function EditActionFor(AEditControl: TCustomEdit; Action: TEditAction): Boolean;
function GetEditStateFor(AEditControl: TCustomEdit): TEditState;

{ Registry Information }

var
  BaseRegistryKey: string = '';

{ Action Registration }

type

  TNotifyActionListChange = procedure;

var

  NotifyActionListChange: TNotifyActionListChange = nil;

procedure RegActions(const ACategory: string;
  const AClasses: array of TBasicActionClass; AResource: TComponentClass);
procedure UnRegActions(const Classes: array of TBasicActionClass);
procedure EnumActions(Proc: TEnumActionProc; Info: Pointer);
function CreateAction(AOwner: TComponent; ActionClass: TBasicActionClass): TBasicAction;

implementation

uses Consts, RTLConsts, SysUtils, Windows, Math, Dialogs, Registry, TypInfo, 
     Clipbrd, ImgList, CommCtrl;

{ Registry Information }

type

  TBasicActionRecord = record
    ActionClass: TBasicActionClass;
    GroupId: Integer;
  end;

  TActionClassArray = array of TBasicActionRecord;

  TActionClassesEntry = record
    Category: string;
    Actions: TActionClassArray;
    Resource: TComponentClass;
  end;

  TActionClassesArray = array of TActionClassesEntry;

var
  DesignersList: TList = nil;
  ActionClasses: TActionClassesArray = nil;

{ Action Registration }

type
  THackAction = class(TCustomAction);

procedure RegActions(const ACategory: string;
  const AClasses: array of TBasicActionClass; AResource: TComponentClass);
var
  CategoryIndex, Len, I, J, NewClassCount: Integer;
  NewClasses: array of TBasicActionClass;
  Skip: Boolean;
  S: string;
begin
  { Determine whether we're adding a new category, or adding to an existing one }
  CategoryIndex := -1;
  for I := Low(ActionClasses) to High(ActionClasses) do
    if CompareText(ActionClasses[I].Category, ACategory) = 0 then
    begin
      CategoryIndex := I;
      Break;
    end;

  { Adding a new category }
  if CategoryIndex = -1 then
  begin
    CategoryIndex := Length(ActionClasses);
    SetLength(ActionClasses, CategoryIndex + 1);
  end;

  with ActionClasses[CategoryIndex] do
  begin
    SetLength(NewClasses, Length(AClasses));
    { Remove duplicate classes }
    NewClassCount := 0;
    for I := Low(AClasses) to High(AClasses) do
    begin
      Skip := False;
      for J := Low(Actions) to High(Actions) do
        if AClasses[I] = Actions[I].ActionClass then
        begin
          Skip := True;
          Break;
        end;
      if not Skip then
      begin
        NewClasses[Low(NewClasses) + NewClassCount] := AClasses[I];
        Inc(NewClassCount);
      end;
    end;

    { Pack NewClasses }
    SetLength(NewClasses, NewClassCount);

    SetString(S, PChar(ACategory), Length(ACategory));
    Category := S;
    Resource := AResource;
    Len := Length(Actions);
    SetLength(Actions, Len + Length(NewClasses));
    for I := Low(NewClasses) to High(NewClasses) do
    begin
      RegisterNoIcon([NewClasses[I]]);
      Classes.RegisterClass(NewClasses[I]);
      with Actions[Len + I] do
      begin
        ActionClass := NewClasses[I];
        GroupId := CurrentGroup;
      end;
    end;
  end;
  { Notify all available designers of new TAction class }
  if (DesignersList <> nil) and Assigned(NotifyActionListChange) then
    NotifyActionListChange;
end;

procedure UnRegActions(const Classes: array of TBasicActionClass);//! far;
begin
end;

procedure UnregisterActionGroup(AGroupId: Integer);
var
  I, J: Integer;
begin
  for I := Low(ActionClasses) to High(ActionClasses) do
    for J := Low(ActionClasses[I].Actions) to High(ActionClasses[I].Actions) do
      with ActionClasses[I].Actions[J] do
        if GroupId = AGroupId then
        begin
          ActionClass := nil;
          GroupId := -1;
        end;
  if Assigned(NotifyActionListChange) then
    NotifyActionListChange;
end;

procedure EnumActions(Proc: TEnumActionProc; Info: Pointer);
var
  I, J, Count: Integer;
  ActionClass: TBasicActionClass;
begin
  if ActionClasses <> nil then
    for I := Low(ActionClasses) to High(ActionClasses) do
    begin
      Count := 0;
      for J := Low(ActionClasses[I].Actions) to High(ActionClasses[I].Actions) do
      begin
        ActionClass := ActionClasses[I].Actions[J].ActionClass;
        if ActionClass = nil then
          Continue;
        Proc(ActionClasses[I].Category, ActionClass, Info);
        Inc(Count);
      end;
      if Count = 0 then
        SetLength(ActionClasses[I].Actions, 0);
    end;
end;

function CreateAction(AOwner: TComponent; ActionClass: TBasicActionClass): TBasicAction;
var
  I, J: Integer;
  Res: TComponentClass;
  Instance: TComponent;
  Action: TBasicAction;

  function FindComponentByClass(AOwner: TComponent; const AClassName: string): TComponent;
  var
    I: Integer;
  begin
    if (AClassName <> '') and (AOwner.ComponentCount > 0) then
      for I := 0 to AOwner.ComponentCount - 1 do
      begin
        Result := AOwner.Components[I];
        if CompareText(Result.ClassName, AClassName) = 0 then Exit;
      end;
    Result := nil;
  end;

  procedure CreateMaskedBmp(ImageList: TCustomImageList; ImageIndex: Integer;
    var Image, Mask: Graphics.TBitmap);
  begin
    Image := Graphics.TBitmap.Create;
    Mask := Graphics.TBitmap.Create;
    try
      with Image do
      begin
        Height := ImageList.Height;
        Width := ImageList.Width;
      end;
      with Mask do
      begin
        Monochrome := True;
        Height := ImageList.Height;
        Width := ImageList.Width;
      end;
      ImageList_Draw(ImageList.Handle, ImageIndex, Image.Canvas.Handle, 0, 0, ILD_NORMAL);
      ImageList_Draw(ImageList.Handle, ImageIndex, Mask.Canvas.Handle, 0, 0, ILD_MASK);
//!      Result.MaskHandle := Mask.ReleaseHandle;
    except
      Image.Free;
      Mask.Free;
      Image := nil;
      Mask := nil;
      raise;
    end;
  end;

begin
  Result := ActionClass.Create(AOwner);
  { Attempt to find the first action with the same class Type as ActionClass in
    the Resource component's resource stream, and use its property values as
    our defaults. }
  Res := nil;
  for I := Low(ActionClasses) to High(ActionClasses) do
    with ActionClasses[I] do
      for J := Low(Actions) to High(Actions) do
        if Actions[J].ActionClass = ActionClass then
        begin
          Res := Resource;
          Break;
        end;
  if Res <> nil then
  begin
    Instance := Res.Create(nil);    
    try
      Action := FindComponentByClass(Instance, ActionClass.ClassName) as TBasicAction;
      if Action <> nil then
      begin
        with Action as TCustomAction do
        begin
          TCustomAction(Result).Caption := Caption;
          TCustomAction(Result).Checked := Checked;
          TCustomAction(Result).Enabled := Enabled;
          TCustomAction(Result).HelpContext := HelpContext;
          TCustomAction(Result).Hint := Hint;
          TCustomAction(Result).ImageIndex := ImageIndex;
          TCustomAction(Result).ShortCut := ShortCut;
          TCustomAction(Result).Visible := Visible;
          if (ImageIndex > -1) and (ActionList <> nil) and
            (ActionList.Images <> nil) then
          begin
            THackAction(Result).FImage.Free;
            THackAction(Result).FMask.Free;
            CreateMaskedBmp(ActionList.Images, ImageIndex,
              Graphics.TBitmap(THackAction(Result).FImage),
              Graphics.TBitmap(THackAction(Result).FMask));
          end;
        end;
      end;
    finally
      Instance.Free;
    end;
  end;
end;

const
  { context ids for the Font editor and the Color Editor, etc. }
  hcDFontEditor       = 25000;
  hcDColorEditor      = 25010;
  hcDMediaPlayerOpen  = 25020;

function GetDisplayValue(const Prop: IProperty): string;
begin
  Result := '';
  if Assigned(Prop) and Prop.AllEqual then
    Result := Prop.GetValue;
end;

procedure DefaultPropertyDrawName(Prop: TPropertyEditor; Canvas: TCanvas;
  const Rect: TRect);
begin
  Canvas.TextRect(Rect, Rect.Left + 1, Rect.Top + 1, Prop.GetName);
end;

procedure DefaultPropertyDrawValue(Prop: TPropertyEditor; Canvas: TCanvas;
  const Rect: TRect);
begin
  Canvas.TextRect(Rect, Rect.Left + 1, Rect.Top + 1, Prop.GetVisualValue);
end;

procedure DefaultPropertyListDrawValue(const Value: string; Canvas: TCanvas;
  const Rect: TRect; Selected: Boolean);
begin
  Canvas.TextRect(Rect, Rect.Left + 1, Rect.Top + 1, Value);
end;

{ TFontNameProperty }
{ Owner draw code has been commented out, see the interface section's for info. }

function TFontNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paSortList, paRevertable];
end;

procedure TFontNameProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
begin
  for I := 0 to Screen.Fonts.Count - 1 do Proc(Screen.Fonts[I]);
end;

procedure TFontNameProperty.ListDrawValue(const Value: string;
  ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);
var
  OldFontName: string;
begin
  if FontNamePropertyDisplayFontNames then
    with ACanvas do
    begin
      // save off things
      OldFontName := Font.Name;

      // set things up and do work
      Font.Name := Value;
      TextRect(ARect, ARect.Left + 2, ARect.Top + 1, Value);

      // restore things
      Font.Name := OldFontName;
    end
  else
    DefaultPropertyListDrawValue(Value, ACanvas, ARect, ASelected);
end;

procedure TFontNameProperty.ListMeasureHeight(const Value: string;
  ACanvas: TCanvas; var AHeight: Integer);
var
  OldFontName: string;
begin
  if FontNamePropertyDisplayFontNames then
    with ACanvas do
    begin
      // save off things
      OldFontName := Font.Name;

      // set things up and do work
      Font.Name := Value;
      AHeight := TextHeight(Value) + 2;

      // restore things
      Font.Name := OldFontName;
    end;
end;

procedure TFontNameProperty.ListMeasureWidth(const Value: string;
  ACanvas: TCanvas; var AWidth: Integer);
var
  OldFontName: string;
begin
  if FontNamePropertyDisplayFontNames then
    with ACanvas do
    begin
      // save off things
      OldFontName := Font.Name;

      // set things up and do work
      Font.Name := Value;
      AWidth := TextWidth(Value) + 4;

      // restore things
      Font.Name := OldFontName;
    end;
end;

{ TFontCharsetProperty }

function TFontCharsetProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paSortList, paValueList];
end;

function TFontCharsetProperty.GetValue: string;
begin
  if not CharsetToIdent(TFontCharset(GetOrdValue), Result) then
    FmtStr(Result, '%d', [GetOrdValue]);
end;

procedure TFontCharsetProperty.GetValues(Proc: TGetStrProc);
begin
  GetCharsetValues(Proc);
end;

procedure TFontCharsetProperty.SetValue(const Value: string);
var
  NewValue: Longint;
begin
  if IdentToCharset(Value, NewValue) then
    SetOrdValue(NewValue)
  else inherited SetValue(Value);
end;

{ TImeNameProperty }

function TImeNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

procedure TImeNameProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
begin
  for I := 0 to Screen.Imes.Count - 1 do Proc(Screen.Imes[I]);
end;

{ TMPFilenameProperty }

procedure TMPFilenameProperty.Edit;
var
  MPFileOpen: TOpenDialog;
begin
  MPFileOpen := TOpenDialog.Create(Application);
  MPFileOpen.Filename := GetValue;
  MPFileOpen.Filter := SMPOpenFilter;
  MPFileOpen.HelpContext := hcDMediaPlayerOpen;
  MPFileOpen.Options := MPFileOpen.Options + [ofShowHelp, ofPathMustExist,
    ofFileMustExist];
  try
    if MPFileOpen.Execute then SetValue(MPFileOpen.Filename);
  finally
    MPFileOpen.Free;
  end;
end;

function TMPFilenameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paRevertable];
end;

{ TColorProperty }

procedure TColorProperty.Edit;
var
  ColorDialog: TColorDialog;
  IniFile: TRegIniFile;

  procedure GetCustomColors;
  begin
    if BaseRegistryKey = '' then Exit;
    IniFile := TRegIniFile.Create(BaseRegistryKey);
    try
      IniFile.ReadSectionValues(SCustomColors, ColorDialog.CustomColors);
    except
      { Ignore errors reading values }
    end;
  end;

  procedure SaveCustomColors;
  var
    I, P: Integer;
    S: string;
  begin
    if IniFile <> nil then
      with ColorDialog do
        for I := 0 to CustomColors.Count - 1 do
        begin
          S := CustomColors.Strings[I];
          P := Pos('=', S);
          if P <> 0 then
          begin
            S := Copy(S, 1, P - 1);
            IniFile.WriteString(SCustomColors, S,
              CustomColors.Values[S]);
          end;
        end;
  end;

begin
  IniFile := nil;
  ColorDialog := TColorDialog.Create(Application);
  try
    GetCustomColors;
    ColorDialog.Color := GetOrdValue;
    ColorDialog.HelpContext := hcDColorEditor;
    ColorDialog.Options := [cdShowHelp];
    if ColorDialog.Execute then SetOrdValue(ColorDialog.Color);
    SaveCustomColors;
  finally
    IniFile.Free;
    ColorDialog.Free;
  end;
end;

function TColorProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paDialog, paValueList, paRevertable];
end;

function TColorProperty.GetValue: string;
begin
  Result := ColorToString(TColor(GetOrdValue));
end;

procedure TColorProperty.GetValues(Proc: TGetStrProc);
begin
  GetColorValues(Proc);
end;

procedure TColorProperty.PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
  ASelected: Boolean);
begin
  if GetVisualValue <> '' then
    ListDrawValue(GetVisualValue, ACanvas, ARect, True{ASelected})
  else
    DefaultPropertyDrawValue(Self, ACanvas, ARect);
end;

procedure TColorProperty.ListDrawValue(const Value: string; ACanvas: TCanvas;
  const ARect: TRect; ASelected: Boolean);
  function ColorToBorderColor(AColor: TColor): TColor;
  type
    TColorQuad = record
      Red,
      Green,
      Blue,
      Alpha: Byte;
    end;
  begin
    if (TColorQuad(AColor).Red > 192) or
       (TColorQuad(AColor).Green > 192) or
       (TColorQuad(AColor).Blue > 192) then
      Result := clBlack
    else if ASelected then
      Result := clWhite
    else
      Result := AColor;
  end;
var
  Right: Integer;
  OldPenColor, OldBrushColor: TColor;
begin
  Right := (ARect.Bottom - ARect.Top) {* 2} + ARect.Left;
  with ACanvas do
  begin
    // save off things
    OldPenColor := Pen.Color;
    OldBrushColor := Brush.Color;

    // frame things
    Pen.Color := Brush.Color;
    Rectangle(ARect.Left, ARect.Top, Right, ARect.Bottom);

    // set things up and do the work
    Brush.Color := StringToColor(Value);
    Pen.Color := ColorToBorderColor(ColorToRGB(Brush.Color));
    Rectangle(ARect.Left + 1, ARect.Top + 1, Right - 1, ARect.Bottom - 1);

    // restore the things we twiddled with
    Brush.Color := OldBrushColor;
    Pen.Color := OldPenColor;
    DefaultPropertyListDrawValue(Value, ACanvas, Rect(Right, ARect.Top, ARect.Right,
      ARect.Bottom), ASelected);
  end;
end;

procedure TColorProperty.ListMeasureWidth(const Value: string;
  ACanvas: TCanvas; var AWidth: Integer);
begin
  AWidth := AWidth + ACanvas.TextHeight('M') {* 2};
end;

procedure TColorProperty.SetValue(const Value: string);
var
  NewValue: Longint;
begin
  if IdentToColor(Value, NewValue) then
    SetOrdValue(NewValue)
  else
    inherited SetValue(Value);
end;

procedure TColorProperty.ListMeasureHeight(const Value: string;
  ACanvas: TCanvas; var AHeight: Integer);
begin
  // No implemenation necessary
end;

procedure TColorProperty.PropDrawName(ACanvas: TCanvas; const ARect: TRect;
  ASelected: Boolean);
begin
  DefaultPropertyDrawName(Self, ACanvas, ARect);
end;

{ TBrushStyleProperty }

procedure TBrushStyleProperty.PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
  ASelected: Boolean);
begin
  if GetVisualValue <> '' then
    ListDrawValue(GetVisualValue, ACanvas, ARect, ASelected)
  else
    DefaultPropertyDrawValue(Self, ACanvas, ARect);
end;

procedure TBrushStyleProperty.ListDrawValue(const Value: string;
  ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);
var
  Right: Integer;
  OldPenColor, OldBrushColor: TColor;
  OldBrushStyle: TBrushStyle;
begin
  Right := (ARect.Bottom - ARect.Top) {* 2} + ARect.Left;
  with ACanvas do
  begin
    // save off things
    OldPenColor := Pen.Color;
    OldBrushColor := Brush.Color;
    OldBrushStyle := Brush.Style;

    // frame things
    Pen.Color := Brush.Color;
    Brush.Color := clWindow;
    Rectangle(ARect.Left, ARect.Top, Right, ARect.Bottom);

    // set things up
    Pen.Color := clWindowText;
    Brush.Style := TBrushStyle(GetEnumValue(GetPropInfo^.PropType^, Value));

    // bsClear hack
    if Brush.Style = bsClear then
    begin
      Brush.Color := clWindow;
      Brush.Style := bsSolid;
    end
    else
      Brush.Color := clWindowText;

    // ok on with the show
    Rectangle(ARect.Left + 1, ARect.Top + 1, Right - 1, ARect.Bottom - 1);

    // restore the things we twiddled with
    Brush.Color := OldBrushColor;
    Brush.Style := OldBrushStyle;
    Pen.Color := OldPenColor;
    DefaultPropertyListDrawValue(Value, ACanvas, Rect(Right, ARect.Top,
      ARect.Right, ARect.Bottom), ASelected);
  end;
end;

procedure TBrushStyleProperty.ListMeasureWidth(const Value: string;
  ACanvas: TCanvas; var AWidth: Integer);
begin
  AWidth := AWidth + ACanvas.TextHeight('A') {* 2};
end;

procedure TBrushStyleProperty.ListMeasureHeight(const Value: string;
  ACanvas: TCanvas; var AHeight: Integer);
begin
  // No implementation necessary
end;

procedure TBrushStyleProperty.PropDrawName(ACanvas: TCanvas;
  const ARect: TRect; ASelected: Boolean);
begin
  DefaultPropertyDrawName(Self, ACanvas, ARect);
end;

{ TPenStyleProperty }

procedure TPenStyleProperty.PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
  ASelected: Boolean);
begin
  if GetVisualValue <> '' then
    ListDrawValue(GetVisualValue, ACanvas, ARect, ASelected)
  else
    DefaultPropertyDrawValue(Self, ACanvas, ARect);
end;

procedure TPenStyleProperty.ListDrawValue(const Value: string;
  ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);
var
  Right, Top: Integer;
  OldPenColor, OldBrushColor: TColor;
  OldPenStyle: TPenStyle;
begin
  Right := (ARect.Bottom - ARect.Top) * 2 + ARect.Left;
  Top := (ARect.Bottom - ARect.Top) div 2 + ARect.Top;
  with ACanvas do
  begin
    // save off things
    OldPenColor := Pen.Color;
    OldBrushColor := Brush.Color;
    OldPenStyle := Pen.Style;

    // frame things
    Pen.Color := Brush.Color;
    Rectangle(ARect.Left, ARect.Top, Right, ARect.Bottom);

    // white out the background
    Pen.Color := clWindowText;
    Brush.Color := clWindow;
    Rectangle(ARect.Left + 1, ARect.Top + 1, Right - 1, ARect.Bottom - 1);

    // set thing up and do work
    Pen.Color := clWindowText;
    Pen.Style := TPenStyle(GetEnumValue(GetPropInfo^.PropType^, Value));
    MoveTo(ARect.Left + 1, Top);
    LineTo(Right - 1, Top);
    MoveTo(ARect.Left + 1, Top + 1);
    LineTo(Right - 1, Top + 1);

    // restore the things we twiddled with
    Brush.Color := OldBrushColor;
    Pen.Style := OldPenStyle;
    Pen.Color := OldPenColor;
    DefaultPropertyListDrawValue(Value, ACanvas, Rect(Right, ARect.Top,
      ARect.Right, ARect.Bottom), ASelected);
  end;
end;

procedure TPenStyleProperty.ListMeasureWidth(const Value: string;
  ACanvas: TCanvas; var AWidth: Integer);
begin
  AWidth := AWidth + ACanvas.TextHeight('X') * 2;
end;

procedure TPenStyleProperty.ListMeasureHeight(const Value: string;
  ACanvas: TCanvas; var AHeight: Integer);
begin
  // No implementation necessary
end;

procedure TPenStyleProperty.PropDrawName(ACanvas: TCanvas;
  const ARect: TRect; ASelected: Boolean);
begin
  DefaultPropertyDrawName(Self, ACanvas, ARect);
end;

{ TCursorProperty }

function TCursorProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paSortList, paRevertable];
end;

function TCursorProperty.GetValue: string;
begin
  Result := CursorToString(TCursor(GetOrdValue));
end;

procedure TCursorProperty.GetValues(Proc: TGetStrProc);
begin
  GetCursorValues(Proc);
end;

procedure TCursorProperty.SetValue(const Value: string);
var
  NewValue: Longint;
begin
  if IdentToCursor(Value, NewValue) then
    SetOrdValue(NewValue)
  else inherited SetValue(Value);
end;

procedure TCursorProperty.ListDrawValue(const Value: string;
  ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);
var
  Right: Integer;
  CursorIndex: Integer;
  CursorHandle: THandle;
begin
  Right := ARect.Left + GetSystemMetrics(SM_CXCURSOR) + 4;
  with ACanvas do
  begin
    if not IdentToCursor(Value, CursorIndex) then
      CursorIndex := StrToInt(Value);
    ACanvas.FillRect(ARect);
    CursorHandle := Screen.Cursors[CursorIndex];
    if CursorHandle <> 0 then
      DrawIconEx(ACanvas.Handle, ARect.Left + 2, ARect.Top + 2, CursorHandle,
        0, 0, 0, 0, DI_NORMAL or DI_DEFAULTSIZE);
    DefaultPropertyListDrawValue(Value, ACanvas, Rect(Right, ARect.Top,
      ARect.Right, ARect.Bottom), ASelected);
  end;
end;

procedure TCursorProperty.ListMeasureWidth(const Value: string;
  ACanvas: TCanvas; var AWidth: Integer);
begin
  AWidth := AWidth + GetSystemMetrics(SM_CXCURSOR) + 4;
end;

procedure TCursorProperty.ListMeasureHeight(const Value: string;
  ACanvas: TCanvas; var AHeight: Integer);
begin
  AHeight := Max(ACanvas.TextHeight('Wg'), GetSystemMetrics(SM_CYCURSOR) + 4);
end;

{ TFontProperty }

procedure TFontProperty.Edit;
var
  FontDialog: TFontDialog;
begin
  FontDialog := TFontDialog.Create(Application);
  try
    FontDialog.Font := TFont(GetOrdValue);
    FontDialog.HelpContext := hcDFontEditor;
    FontDialog.Options := FontDialog.Options + [fdShowHelp, fdForceFontExist];
    if FontDialog.Execute then SetOrdValue(Longint(FontDialog.Font));
  finally
    FontDialog.Free;
  end;
end;

function TFontProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paSubProperties, paDialog, paReadOnly];
end;

{ TModalResultProperty }

const
  ModalResults: array[mrNone..mrYesToAll] of string = (
    'mrNone',
    'mrOk',
    'mrCancel',
    'mrAbort',
    'mrRetry',
    'mrIgnore',
    'mrYes',
    'mrNo',
    'mrAll',
    'mrNoToAll',
    'mrYesToAll');

function TModalResultProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paRevertable];
end;

function TModalResultProperty.GetValue: string;
var
  CurValue: Longint;
begin
  CurValue := GetOrdValue;
  case CurValue of
    Low(ModalResults)..High(ModalResults):
      Result := ModalResults[CurValue];
  else
    Result := IntToStr(CurValue);
  end;
end;

procedure TModalResultProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
begin
  for I := Low(ModalResults) to High(ModalResults) do Proc(ModalResults[I]);
end;

procedure TModalResultProperty.SetValue(const Value: string);
var
  I: Integer;
begin
  if Value = '' then
  begin
    SetOrdValue(0);
    Exit;
  end;
  for I := Low(ModalResults) to High(ModalResults) do
    if CompareText(ModalResults[I], Value) = 0 then
    begin
      SetOrdValue(I);
      Exit;
    end;
  inherited SetValue(Value);
end;

{ TShortCutProperty }

const
  ShortCuts: array[0..108] of TShortCut = (
    scNone,
    Byte('A') or scCtrl,
    Byte('B') or scCtrl,
    Byte('C') or scCtrl,
    Byte('D') or scCtrl,
    Byte('E') or scCtrl,
    Byte('F') or scCtrl,
    Byte('G') or scCtrl,
    Byte('H') or scCtrl,
    Byte('I') or scCtrl,
    Byte('J') or scCtrl,
    Byte('K') or scCtrl,
    Byte('L') or scCtrl,
    Byte('M') or scCtrl,
    Byte('N') or scCtrl,
    Byte('O') or scCtrl,
    Byte('P') or scCtrl,
    Byte('Q') or scCtrl,
    Byte('R') or scCtrl,
    Byte('S') or scCtrl,
    Byte('T') or scCtrl,
    Byte('U') or scCtrl,
    Byte('V') or scCtrl,
    Byte('W') or scCtrl,
    Byte('X') or scCtrl,
    Byte('Y') or scCtrl,
    Byte('Z') or scCtrl,
    Byte('A') or scCtrl or scAlt,
    Byte('B') or scCtrl or scAlt,
    Byte('C') or scCtrl or scAlt,
    Byte('D') or scCtrl or scAlt,
    Byte('E') or scCtrl or scAlt,
    Byte('F') or scCtrl or scAlt,
    Byte('G') or scCtrl or scAlt,
    Byte('H') or scCtrl or scAlt,
    Byte('I') or scCtrl or scAlt,
    Byte('J') or scCtrl or scAlt,
    Byte('K') or scCtrl or scAlt,
    Byte('L') or scCtrl or scAlt,
    Byte('M') or scCtrl or scAlt,
    Byte('N') or scCtrl or scAlt,
    Byte('O') or scCtrl or scAlt,
    Byte('P') or scCtrl or scAlt,
    Byte('Q') or scCtrl or scAlt,
    Byte('R') or scCtrl or scAlt,
    Byte('S') or scCtrl or scAlt,
    Byte('T') or scCtrl or scAlt,
    Byte('U') or scCtrl or scAlt,
    Byte('V') or scCtrl or scAlt,
    Byte('W') or scCtrl or scAlt,
    Byte('X') or scCtrl or scAlt,
    Byte('Y') or scCtrl or scAlt,
    Byte('Z') or scCtrl or scAlt,
    VK_F1,
    VK_F2,
    VK_F3,
    VK_F4,
    VK_F5,
    VK_F6,
    VK_F7,
    VK_F8,
    VK_F9,
    VK_F10,
    VK_F11,
    VK_F12,
    VK_F1 or scCtrl,
    VK_F2 or scCtrl,
    VK_F3 or scCtrl,
    VK_F4 or scCtrl,
    VK_F5 or scCtrl,
    VK_F6 or scCtrl,
    VK_F7 or scCtrl,
    VK_F8 or scCtrl,
    VK_F9 or scCtrl,
    VK_F10 or scCtrl,
    VK_F11 or scCtrl,
    VK_F12 or scCtrl,
    VK_F1 or scShift,
    VK_F2 or scShift,
    VK_F3 or scShift,
    VK_F4 or scShift,
    VK_F5 or scShift,
    VK_F6 or scShift,
    VK_F7 or scShift,
    VK_F8 or scShift,
    VK_F9 or scShift,
    VK_F10 or scShift,
    VK_F11 or scShift,
    VK_F12 or scShift,
    VK_F1 or scShift or scCtrl,
    VK_F2 or scShift or scCtrl,
    VK_F3 or scShift or scCtrl,
    VK_F4 or scShift or scCtrl,
    VK_F5 or scShift or scCtrl,
    VK_F6 or scShift or scCtrl,
    VK_F7 or scShift or scCtrl,
    VK_F8 or scShift or scCtrl,
    VK_F9 or scShift or scCtrl,
    VK_F10 or scShift or scCtrl,
    VK_F11 or scShift or scCtrl,
    VK_F12 or scShift or scCtrl,
    VK_INSERT,
    VK_INSERT or scShift,
    VK_INSERT or scCtrl,
    VK_DELETE,
    VK_DELETE or scShift,
    VK_DELETE or scCtrl,
    VK_BACK or scAlt,
    VK_BACK or scShift or scAlt);

function TShortCutProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paRevertable];
end;

function TShortCutProperty.GetValue: string;
var
  CurValue: TShortCut;
begin
  CurValue := GetOrdValue;
  if CurValue = scNone then
    Result := srNone else
    Result := ShortCutToText(CurValue);
end;

procedure TShortCutProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
begin
  Proc(srNone);
  for I := 1 to High(ShortCuts) do Proc(ShortCutToText(ShortCuts[I]));
end;

procedure TShortCutProperty.SetValue(const Value: string);
var
  NewValue: TShortCut;
begin
  NewValue := 0;
  if (Value <> '') and (AnsiCompareText(Value, srNone) <> 0) then
  begin
    NewValue := TextToShortCut(Value);
    if NewValue = 0 then
      raise EPropertyError.CreateRes(@SInvalidPropertyValue);
  end;
  SetOrdValue(NewValue);
end;

{ TTabOrderProperty }

function TTabOrderProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [];
end;

{ TCaptionProperty }

function TCaptionProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paAutoUpdate, paRevertable];
end;

{ Clipboard routines }

procedure CopyStreamToClipboard(S: TMemoryStream);
var
  T: TMemoryStream;
  I: TValueType;
  V: Integer;

  procedure CopyToClipboard(Format: Word; S: TMemoryStream);
  var
    Handle: THandle;
    Mem: Pointer;
  begin
    Handle := GlobalAlloc(GMEM_MOVEABLE, S.Size);
    Mem := GlobalLock(Handle);
    Move(S.Memory^, Mem^, S.Size);
    GlobalUnlock(Handle);
    Clipboard.SetAsHandle(Format, Handle);
  end;

begin
  Clipboard.Open;
  try
    CopyToClipboard(CF_COMPONENTS, S);
    S.Position := 0;
    T := TMemoryStream.Create;
    try
      repeat
        S.Read(I, SizeOf(I));
        S.Seek(-SizeOf(I), 1);
        if I = vaNull then Break;
        ObjectBinaryToText(S, T);
      until False;
      V := 0;
      T.Write(V, 1);
      CopyToClipboard(CF_TEXT, T);
    finally
      T.Free;
    end;
  finally
    Clipboard.Close;
  end;
end;

function GetClipboardStream: TMemoryStream;
var
  S, T: TMemoryStream;
  Handle: THandle;
  Mem: Pointer;
  Format: Word;
  V: TValueType;

  function AnotherObject(S: TStream): Boolean;
  var
    Buffer: array[0..255] of Char;
    Position: Integer;
  begin
    Position := S.Position;
    Buffer[S.Read(Buffer, SizeOf(Buffer))-1] := #0;
    S.Position := Position;
    Result := PossibleStream(Buffer);
  end;

begin
  Result := TMemoryStream.Create;
  try
    if Clipboard.HasFormat(CF_COMPONENTS) then
      Format := CF_COMPONENTS else
      Format := CF_TEXT;
    Clipboard.Open;
    try
      Handle := Clipboard.GetAsHandle(Format);
      Mem := GlobalLock(Handle);
      try
        Result.Write(Mem^, GlobalSize(Handle));
      finally
        GlobalUnlock(Handle);
      end;
    finally
      Clipboard.Close;
    end;
    Result.Position := 0;
    if Format = CF_TEXT then
    begin
      S := TMemoryStream.Create;
      try
        while AnotherObject(Result) do ObjectTextToBinary(Result, S);
        V := vaNull;
        S.Write(V, SizeOf(V));
        T := Result;
        Result := nil;
        T.Free;
      except
        S.Free;
        raise;
      end;
      Result := S;
      Result.Position := 0;
    end;
  except
    Result.Free;
    raise;
  end;
end;

type
  TSelectionMessageList = class(TInterfacedObject, ISelectionMessageList)
  private
    FList: IInterfaceList;
  protected
    procedure Add(AEditor: ISelectionMessage);
  public
    constructor Create;
    function Get(Index: Integer): ISelectionMessage;
    function GetCount: Integer;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: ISelectionMessage read Get; default;
  end;

{ TSelectionMessageList }

procedure TSelectionMessageList.Add(AEditor: ISelectionMessage);
begin
  FList.Add(AEditor);
end;

constructor TSelectionMessageList.Create;
begin
  inherited;
  FList := TInterfaceList.Create;
end;

function TSelectionMessageList.Get(Index: Integer): ISelectionMessage;
begin
  Result := FList[Index] as ISelectionMessage;
end;

function TSelectionMessageList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function SelectionMessageListOf(const SelectionEditorList: ISelectionEditorList): ISelectionMessageList;
var
  SelectionMessage: ISelectionMessage;
  I: Integer;
  R: TSelectionMessageList;
begin
  R := TSelectionMessageList.Create;
  for I := 0 to SelectionEditorList.Count - 1 do
    if Supports(SelectionEditorList[I], ISelectionMessage, SelectionMessage) then
      R.Add(SelectionMessage);
  Result := R;
end;

{ EditAction utility functions }

function EditActionFor(AEditControl: TCustomEdit; Action: TEditAction): Boolean;
begin
  Result := True;
  case Action of
    eaUndo:      AEditControl.Undo;
    eaCut:       AEditControl.CutToClipboard;
    eaCopy:      AEditControl.CopyToClipboard;
    eaDelete:    AEditControl.ClearSelection;
    eaPaste:     AEditControl.PasteFromClipboard;
    eaSelectAll: AEditControl.SelectAll;
  else
    Result := False;
  end;
end;

function GetEditStateFor(AEditControl: TCustomEdit): TEditState;
begin
  Result := [];
  if AEditControl.CanUndo then
    Include(Result, esCanUndo);
  if AEditControl.SelLength > 0 then
  begin
    Include(Result, esCanCut);
    Include(Result, esCanCopy);
    Include(Result, esCanDelete);
  end;
  if Clipboard.HasFormat(CF_TEXT) then
    Include(Result, esCanPaste);
  if AEditControl.SelLength < Length(AEditControl.Text) then
    Include(Result, esCanSelectAll);
end;

initialization
  CF_COMPONENTS := RegisterClipboardFormat('Delphi Components');
  NotifyGroupChange(UnregisterActionGroup);

finalization
  UnNotifyGroupChange(UnregisterActionGroup);

end.
