unit RegCool;

interface

const
  CoolEntry = 'Cool';

procedure Register;

implementation

uses Classes,AppearUtils,CoolCtrls,ImageFXs,VBands;

procedure Register;
begin
  RegisterComponents(CoolEntry, [TAppearances]);
  RegisterComponents(CoolEntry,
    [TCoolLabel,
    TCoolLabelX,TLabelOutlook,
    TCoolButton,TButtonOutlook,
    TPenExample,
    TAniButtonOutlook,
    TAniCoolButton]);
  RegisterComponents(CoolEntry,
    [TImageFX,TFXScalePainter,TFXStripPainter,TFXDualPainter]);
  RegisterComponents(CoolEntry,
  	[TVBand,TVMainBand,TVRowBand,TVColBand]);
end;

end.
