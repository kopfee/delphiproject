unit UImages;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList;

type
  TdmImages = class(TDataModule)
    CommonImages: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmImages: TdmImages;

implementation

{$R *.DFM}

end.
