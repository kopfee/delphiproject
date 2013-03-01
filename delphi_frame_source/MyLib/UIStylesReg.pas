unit UIStylesReg;

{$I KSConditions.INC }

interface

procedure Register;

implementation

uses classes,UIStyles,UIStyleEditors,UICtrls,DesignUtils, ImagesMan, ImageCtrls
  {$ifdef VCL60_UP }
    ,DesignIntf, DesignEditors
  {$else}
    ,dsgnintf
  {$endif}
  ;

const
  Page = 'KSStyles';

procedure Register;
begin
  RegisterComponents(Page,[TCtrlStyleGroup,TUIStyle,TUIStyleLink, TCommandImages, TUIImages]);
  RegisterComponents(Page,[TUIPanel,TUILabel, TImageButton, TUIImage]);
  RegisterPropertyEditor(TypeInfo(TUIStyleItemName),nil,'StyleItemName',TStyleItemNameProperty);
  RegisterPropertyEditor(TypeInfo(TCommandName),nil,'CommandName',TCommandNameProperty);
  RegisterPropertyEditor(TypeInfo(TUIStyleItemName),TUIImage,'StyleItemName',TImageStyleNameProperty);

  //RegisterComponentEditor(TUICustomStyle,TStylesEditor);
  //RegisterComponentEditor(TComponent,TStylesEditor);
  RegisterComponentEditor(TUICustomStyle,TCollectionEditor);
  RegisterEditModule(TUIFrame,',UICtrls');
end;

end.
