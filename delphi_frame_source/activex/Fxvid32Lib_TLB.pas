unit Fxvid32Lib_TLB;

// ************************************************************************ //
// WARNING                                                                  //
// -------                                                                  //
// The types declared in this file were generated from data read from a     //
// Type Library. If this type library is explicitly or indirectly (via      //
// another type library referring to this type library) re-imported, or the //
// 'Refresh' command of the Type Library Editor activated while editing the //
// Type Library, the contents of this file will be regenerated and all      //
// manual modifications will be lost.                                       //
// ************************************************************************ //

// PASTLWTR : $Revision:   1.11.1.62  $
// File generated on 98-10-13 11:00:50 from Type Library described below.

// ************************************************************************ //
// Type Lib: E:\SETUP\FXVID432.OCX
// IID\LCID: {79002EE3-4773-11CF-BF88-0040956003D8}\0
// Helpfile: E:\SETUP\FXTLS400.HLP
// HelpString: ImageFX FXVid Control
// Version:    4.0
// ************************************************************************ //

interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, StdVCL, DbOleCtl;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:      //
//   Type Libraries     : LIBID_xxxx                                    //
//   CoClasses          : CLASS_xxxx                                    //
//   DISPInterfaces     : DIID_xxxx                                     //
//   Non-DISP interfaces: IID_xxxx                                      //
// *********************************************************************//
const
  LIBID_Fxvid32Lib: TGUID = '{79002EE3-4773-11CF-BF88-0040956003D8}';
  DIID__DFxvid32: TGUID = '{79002EE1-4773-11CF-BF88-0040956003D8}';
  DIID__DFxvid32Events: TGUID = '{79002EE2-4773-11CF-BF88-0040956003D8}';
  CLASS_FXVid: TGUID = '{79002EE0-4773-11CF-BF88-0040956003D8}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                  //
// *********************************************************************//
// enumVidBackStyle constants
type
  enumVidBackStyle = TOleEnum;
const
  Transparent = $00000000;
  Opaque = $00000001;

// enumEnvironment constants
type
  enumEnvironment = TOleEnum;
const
  Desktop = $00000000;
  Internet = $00000001;

// enumShowZoomed constants
type
  enumShowZoomed = TOleEnum;
const
  None = $00000000;
  TwoX = $00000001;
  ThreeX = $00000002;
  FourX = $00000003;
  HalfX = $00000004;
  ThirdX = $00000005;
  QuarterX = $00000006;

// enumFIFRes constants
type
  enumFIFRes = TOleEnum;
const
  FullScale = $00000000;
  HalfScale = $00000001;
  DoubleScale = $00000002;
  SetScale = $00000003;
  FastScale = $00000004;

// enumFIFPalette constants
type
  enumFIFPalette = TOleEnum;
const
  StaticColors = $00000000;
  DynamicColors = $00000001;
  FIFColors = $00000002;
  PALColors = $00000003;

// enumFIFFormat constants
type
  enumFIFFormat = TOleEnum;
const
  Bit16Colors = $00000000;
  TrueColor = $00000001;

// enumShpBackFill constants
type
  enumShpBackFill = TOleEnum;
const
  Screen = $00000000;
  CapturedImage = $00000001;
  SurroundColor = $00000002;

// enumAction constants
type
  enumAction = TOleEnum;
const
  Initialize = $00000000;
  MoveText = $00000001;

// enumMoveMode constants
type
  enumMoveMode = TOleEnum;
const
  Automatic = $00000000;
  Manual = $00000001;

// enumStartPosition constants
type
  enumStartPosition = TOleEnum;
const
  LeftTop = $00000000;
  LeftMiddle = $00000001;
  LeftBottom = $00000002;
  RightTop = $00000003;
  RightMiddle = $00000004;
  RightBottom = $00000005;
  CenterTop = $00000006;
  CenterBottom = $00000007;

// enumShapeTStyle constants
type
  enumShapeTStyle = TOleEnum;
const
  Solid = $00000000;
  HorizontalLine = $00000001;
  VerticalLine = $00000002;
  DownwardDiagonal = $00000003;
  UpwardDiagonal = $00000004;
  Cross = $00000005;
  DiagonalCross = $00000006;
  CapturedImage_ = $00000007;

// enumBorderStyle constants
type
  enumBorderStyle = TOleEnum;
const
  Transparent_ = $00000000;
  Solid_ = $00000001;
  Dash = $00000002;
  Dot = $00000003;
  DashDot = $00000004;
  DashDotDot = $00000005;

// enumShape constants
type
  enumShape = TOleEnum;
const
  Rectangle = $00000000;
  Square = $00000001;
  Oval = $00000002;
  Circle = $00000003;
  RoundedRectangle = $00000004;
  RoundedSquare = $00000005;
  Octagon = $00000006;
  Star = $00000007;
  TriangleEq = $00000008;
  TriangleRight = $00000009;
  TriangleUp = $0000000A;
  TriangleLeft = $0000000B;
  TriangleDown = $0000000C;
  Diamond = $0000000D;
  Pentagon = $0000000E;
  Hexagon = $0000000F;
  Polygon = $00000010;
  Line = $00000011;

// enumFillStyle constants
type
  enumFillStyle = TOleEnum;
const
  Solid__ = $00000000;
  Transparent__ = $00000001;
  HorizontalLine_ = $00000002;
  VerticalLine_ = $00000003;
  DownwardDiagonal_ = $00000004;
  UpwardDiagonal_ = $00000005;
  Cross_ = $00000006;
  DiagonalCross_ = $00000007;

// enumShadowStyle constants
type
  enumShadowStyle = TOleEnum;
const
  None_ = $00000000;
  DropShadow = $00000001;

// enumTextAlignment constants
type
  enumTextAlignment = TOleEnum;
const
  LeftJustify = $00000000;
  RightJustify = $00000001;
  Center = $00000002;

// enumDSCommand constants
type
  enumDSCommand = TOleEnum;
const
  DSCmd_None = $00000000;
  DSCmd_OpenDS = $00000001;
  DSCmd_OpenCh = $00000002;
  DSCmd_PlayCh = $00000003;
  DSCmd_StopCh = $00000004;
  DSCmd_CloseCh = $00000005;
  DSCmd_CloseAll = $00000006;
  DSCmd_CloseDS = $00000007;

// enumDSSpeaker constants
type
  enumDSSpeaker = TOleEnum;
const
  Mono = $00000000;
  Stereo = $00000001;

// enumCommand constants
type
  enumCommand = TOleEnum;
const
  Cmd_None = $00000000;
  Cmd_Close = $00000001;
  Cmd_Cue = $00000002;
  Cmd_Open = $00000003;
  Cmd_OpenCue = $00000004;
  Cmd_OpenPlay = $00000005;
  Cmd_Pause = $00000006;
  Cmd_Play = $00000007;
  Cmd_PlayFromStart = $00000008;
  Cmd_ResetMixer = $00000009;
  Cmd_Resume = $0000000A;
  Cmd_Stop = $0000000B;
  Cmd_SeekToEnd = $0000000C;
  Cmd_SeekToStart = $0000000D;
  Cmd_SeekTo = $0000000E;
  Cmd_PlayFromTo = $0000000F;
  Cmd_PlayFrom = $00000010;
  Cmd_PlayTo = $00000011;

// enumSoundType constants
type
  enumSoundType = TOleEnum;
const
  WavAudio = $00000000;
  MIDISequencer = $00000001;
  DirectSound = $00000002;
  UserDefined = $00000003;

// enumPicDesignStyle constants
type
  enumPicDesignStyle = TOleEnum;
const
  Transparent___ = $00000000;
  Opaque_ = $00000001;

// enumTransparentMode constants
type
  enumTransparentMode = TOleEnum;
const
  Update = $00000000;
  Overlay = $00000001;
  UpdateCap = $00000002;
  OverlayCap = $00000003;

// enumUpdateArea constants
type
  enumUpdateArea = TOleEnum;
const
  EntireControl = $00000000;
  UpdateRectangle = $00000001;

// enumPictureAlign constants
type
  enumPictureAlign = TOleEnum;
const
  LTop = $00000000;
  LMiddle = $00000001;
  LBottom = $00000002;
  RTop = $00000003;
  RMiddle = $00000004;
  RBottom = $00000005;
  CTop = $00000006;
  CMiddle = $00000007;
  CBottom = $00000008;

// enumForeStyle constants
type
  enumForeStyle = TOleEnum;
const
  Solid___ = $00000000;
  Translucent = $00000001;
  Gradient = $00000002;
  Transparent____ = $00000003;
  TileImage = $00000004;

// enumFont3D constants
type
  enumFont3D = TOleEnum;
const
  None__ = $00000000;
  RLShading = $00000001;
  RHShading = $00000002;
  ILShading = $00000003;
  IHShading = $00000004;
  DropShadow_ = $00000005;
  BlockShadow = $00000006;
  OutlineBlock = $00000007;

// enumLblCapture constants
type
  enumLblCapture = TOleEnum;
const
  None___ = $00000000;
  Capture = $00000001;
  DeleteCapture = $00000002;
  MemCapture = $00000003;
  CapPicture = $00000004;

// enumBackStyle constants
type
  enumBackStyle = TOleEnum;
const
  Transparent_____ = $00000000;
  Opaque__ = $00000001;
  Translucent_ = $00000002;
  Gradient_ = $00000003;
  TransGradient = $00000004;
  TileImage_ = $00000005;

// enumAlignment constants
type
  enumAlignment = TOleEnum;
const
  LJTop = $00000000;
  LJMiddle = $00000001;
  LJBottom = $00000002;
  RJTop = $00000003;
  RJMiddle = $00000004;
  RJBottom = $00000005;
  CJTop = $00000006;
  CJMiddle = $00000007;
  CJBottom = $00000008;

// enumPicDisplayMode constants
type
  enumPicDisplayMode = TOleEnum;
const
  TrueColor_ = $00000000;
  PaletteColor = $00000001;
  VGAColor = $00000002;

// enumDesignStyle constants
type
  enumDesignStyle = TOleEnum;
const
  Transparent______ = $00000000;
  Opaque___ = $00000001;

// enumGradient constants
type
  enumGradient = TOleEnum;
const
  LTR = $00000000;
  RTL = $00000001;
  TTB = $00000002;
  BTT = $00000003;
  OTC = $00000004;
  CTC = $00000005;
  DTLBR = $00000006;
  DBRTL = $00000007;
  DTRBL = $00000008;
  DBLTR = $00000009;
  DTLBRTC = $0000000A;
  DCTTLBR = $0000000B;
  DTRBLTC = $0000000C;
  DCTTRBL = $0000000D;
  ETC = $0000000E;
  EFC = $0000000F;
  HTC = $00000010;
  HFC = $00000011;
  VTC = $00000012;
  VFC = $00000013;

// MousePointerConstants constants
type
  MousePointerConstants = TOleEnum;
const
  Default = $00000000;
  Arrow = $00000001;
  Cross__ = $00000002;
  IBeam = $00000003;
  Icon = $00000004;
  Size = $00000005;
  SizeNESW = $00000006;
  SizeNS = $00000007;
  SizeNWSE = $00000008;
  SizeEW = $00000009;
  UpArrow = $0000000A;
  Hourglass = $0000000B;
  Boy = $0000000C;
  Brush = $0000000D;
  BPush = $0000000E;
  Clock = $0000000F;
  CHand1 = $00000010;
  CHand2 = $00000011;
  Girl = $00000012;
  Hand1 = $00000013;
  Hand2 = $00000014;
  Hand3 = $00000015;
  Hand4 = $00000016;
  Hand5 = $00000017;
  Hand6 = $00000018;
  Hand7 = $00000019;
  Help1 = $0000001A;
  Help2 = $0000001B;
  Key = $0000001C;
  Lightning = $0000001D;
  Magnify = $0000001E;
  Mouse = $0000001F;
  NoDrop1 = $00000020;
  NoDrop2 = $00000021;
  NoDrop3 = $00000022;
  Pencil1 = $00000023;
  Pencil2 = $00000024;
  Phone = $00000025;
  Question1 = $00000026;
  Question2 = $00000027;
  Wand = $00000028;
  ArrowHourglass = $00000029;
  ArrowQuestion = $0000002A;
  SizeAll = $0000002B;
  Custom = $00000063;

// enumBackFill constants
type
  enumBackFill = TOleEnum;
const
  Screen_ = $00000000;
  CapturedImage__ = $00000001;

// enumAutoSize constants
type
  enumAutoSize = TOleEnum;
const
  Crop = $00000000;
  ResizeControl = $00000001;
  ResizeImage = $00000002;
  Tile = $00000003;

// enumDitheredFXImage constants
type
  enumDitheredFXImage = TOleEnum;
const
  Nearest = $00000000;
  Floyd = $00000001;
  Ordered = $00000002;

// enumPaletteFXImage constants
type
  enumPaletteFXImage = TOleEnum;
const
  Optimized = $00000000;
  Fixed = $00000001;
  Gray = $00000002;

// enumDecompressMode constants
type
  enumDecompressMode = TOleEnum;
const
  Quality = $00000000;
  Speed = $00000001;

// enumPalette constants
type
  enumPalette = TOleEnum;
const
  Optimized_ = $00000000;
  Fixed_ = $00000001;
  Gray_ = $00000002;
  PalFile = $00000003;
  User = $00000004;

// enumCancelMode constants
type
  enumCancelMode = TOleEnum;
const
  None____ = $00000000;
  ESCKey = $00000001;
  EnterKey = $00000002;
  SpaceKey = $00000003;
  KeyPress = $00000004;
  MouseLeft = $00000005;
  MouseRight = $00000006;
  MouseMove = $00000007;
  KeyOrButtom = $00000008;
  KeyOrMove = $00000009;

// enumDithered constants
type
  enumDithered = TOleEnum;
const
  Nearest_ = $00000000;
  Floyd_ = $00000001;
  Ordered_ = $00000002;
  Fast = $00000003;

// enumRotated constants
type
  enumRotated = TOleEnum;
const
  None_____ = $00000000;
  R90 = $00000001;
  R180 = $00000002;
  R270 = $00000003;

// enumBStyle constants
type
  enumBStyle = TOleEnum;
const
  None______ = $00000000;
  Inset = $00000001;
  Raised = $00000002;

// enumThumbNail constants
type
  enumThumbNail = TOleEnum;
const
  None_______ = $00000000;
  SixtyFourth = $00000001;
  Sixteenth = $00000002;
  Fourth = $00000003;

// enumTStyle constants
type
  enumTStyle = TOleEnum;
const
  Solid____ = $00000000;
  HorizontalLine__ = $00000001;
  VerticalLine__ = $00000002;
  DownwardDiagonal__ = $00000003;
  UpwardDiagonal__ = $00000004;
  Cross___ = $00000005;
  DiagonalCross__ = $00000006;
  CapturedImage___ = $00000007;
  Gradient__ = $00000008;

// enumDissolve constants
type
  enumDissolve = TOleEnum;
const
  None________ = $00000000;
  SinglePass = $00000001;
  DoublePass = $00000002;
  TriplePass = $00000003;

// enumCapture constants
type
  enumCapture = TOleEnum;
const
  None_________ = $00000000;
  Capture_ = $00000001;
  DeleteCapture_ = $00000002;
  CapturePicture = $00000003;
  CaptureOnly = $00000004;
  ResizePicture = $00000005;

// enumMEffect constants
type
  enumMEffect = TOleEnum;
const
  NoEffect = $00000000;
  LeftToRight = $00000001;
  RightToLeft = $00000002;
  TopToBottom = $00000003;
  BottomToTop = $00000004;
  HorizWipeIn = $00000005;
  HorizWipeOut = $00000006;
  VertWipeIn = $00000007;
  VertWipeOut = $00000008;
  SlideUp = $00000009;
  SlideDown = $0000000A;
  PushUp = $0000000B;
  PushDown = $0000000C;
  DiagonalTLBR = $0000000D;
  DiagonalBLTR = $0000000E;
  DiagonalTRBL = $0000000F;
  DiagonalBRTL = $00000010;
  DoubleDiagTLBR = $00000011;
  DoubleDiagTRBL = $00000012;
  DiagonalOutTLBR = $00000013;
  DiagonalOutTRBL = $00000014;
  DiagonalQuad = $00000015;
  Explode = $00000016;
  Implode = $00000017;
  ZoomOut = $00000018;
  ZoomIn = $00000019;
  CornersOut = $0000001A;
  HorizInterlace = $0000001B;
  VertInterlace = $0000001C;
  HorizDoublePass2 = $0000001D;
  VertDoublePass2 = $0000001E;
  HorizDoublePass = $0000001F;
  VertDoublePass = $00000020;
  RandomLines = $00000021;
  HorizBlind = $00000022;
  VertBlind = $00000023;
  DoubleBlind = $00000024;
  SwirlIn = $00000025;
  SwirlOut = $00000026;
  RandomBlock = $00000027;
  Checkerboard = $00000028;
  VertDoubleWipe = $00000029;
  HorizDoubleWipe = $0000002A;
  Kaliedescope = $0000002B;
  DoubleWipeOut = $0000002C;
  DoubleWipeIn = $0000002D;
  VertSquash = $0000002E;
  VertPull = $0000002F;
  HorizSquash = $00000030;
  HorizPull = $00000031;
  Drip = $00000032;
  NoEffect1 = $00000033;
  SlideLeft = $00000034;
  SlideRight = $00000035;
  PushLeft = $00000036;
  PushRight = $00000037;
  DoubleDiagUp = $00000038;
  DoubleDiagDown = $00000039;
  DoubleDiagLeft = $0000003A;
  DoubleDiagRight = $0000003B;
  RandomBarsUp = $0000003C;
  RandomBarsDown = $0000003D;
  RandomBarsLeft = $0000003E;
  RandomBarsRight = $0000003F;
  SparkleUp = $00000040;
  SparkleDown = $00000041;
  SparkleLeft = $00000042;
  SparkleRight = $00000043;
  Clock_ = $00000044;
  Counterclock = $00000045;
  SemicircleRL = $00000046;
  SemicircleLR = $00000047;
  SemicircleIn = $00000048;
  SemicircleOut = $00000049;
  DoubleClock = $0000004A;
  CircularQuad = $0000004B;
  DiagonalSlideTLBR = $0000004C;
  DiagonalSlideTRBL = $0000004D;
  DiagonalSlideBLTR = $0000004E;
  DiagonalSlideBRTL = $0000004F;
  HorizDoubleSlide = $00000050;
  VertDoubleSlide = $00000051;
  RotateLeft = $00000052;
  RotateRight = $00000053;
  RotateTop = $00000054;
  RotateBottom = $00000055;
  HorizCenterStretch = $00000056;
  VertCenterStretch = $00000057;
  HorizStretchToCenter = $00000058;
  VertStretchToCenter = $00000059;
  BlocksTB = $0000005A;
  BlocksBT = $0000005B;
  BlocksLR = $0000005C;
  BlocksRL = $0000005D;
  GrowingBlindTB = $0000005E;
  GrowingBlindBT = $0000005F;
  GrowingBlindLR = $00000060;
  GrowingBlindRL = $00000061;
  RollTB = $00000062;
  RollBT = $00000063;
  RollLR = $00000064;
  RollRL = $00000065;
  DPLTR = $00000066;
  DPRTL = $00000067;
  DPTTB = $00000068;
  DPBTT = $00000069;
  DPHWI = $0000006A;
  DPHWO = $0000006B;
  DPVWI = $0000006C;
  DPVWO = $0000006D;
  DPI = $0000006E;
  DPE = $0000006F;
  HIS = $00000070;
  VIS = $00000071;

// enumDEffect constants
type
  enumDEffect = TOleEnum;
const
  NoEffect_ = $00000000;
  LeftToRight_ = $00000001;
  RightToLeft_ = $00000002;
  TopToBottom_ = $00000003;
  BottomToTop_ = $00000004;
  HorizWipeIn_ = $00000005;
  HorizWipeOut_ = $00000006;
  VertWipeIn_ = $00000007;
  VertWipeOut_ = $00000008;
  SlideUp_ = $00000009;
  SlideDown_ = $0000000A;
  NoEffect1_ = $0000000B;
  NoEffect2 = $0000000C;
  DiagonalTLBR_ = $0000000D;
  DiagonalBLTR_ = $0000000E;
  DiagonalTRBL_ = $0000000F;
  DiagonalBRTL_ = $00000010;
  DoubleDiagTLBR_ = $00000011;
  DoubleDiagTRBL_ = $00000012;
  DiagonalOutTLBR_ = $00000013;
  DiagonalOutTRBL_ = $00000014;
  DiagonalQuad_ = $00000015;
  Explode_ = $00000016;
  Implode_ = $00000017;
  NoEffect3 = $00000018;
  NoEffect4 = $00000019;
  CornersOut_ = $0000001A;
  HorizInterlace_ = $0000001B;
  VertInterlace_ = $0000001C;
  HorizDoublePass2_ = $0000001D;
  VertDoublePass2_ = $0000001E;
  HorizDoublePass_ = $0000001F;
  VertDoublePass_ = $00000020;
  RandomLines_ = $00000021;
  HorizBlind_ = $00000022;
  VertBlind_ = $00000023;
  DoubleBlind_ = $00000024;
  SwirlIn_ = $00000025;
  SwirlOut_ = $00000026;
  RandomBlock_ = $00000027;
  Checkerboard_ = $00000028;
  VertDoubleWipe_ = $00000029;
  HorizDoubleWipe_ = $0000002A;
  Kaliedescope_ = $0000002B;
  DoubleWipeOut_ = $0000002C;
  DoubleWipeIn_ = $0000002D;
  NoEffect5 = $0000002E;
  NoEffect6 = $0000002F;
  NoEffect7 = $00000030;
  NoEffect8 = $00000031;
  Drip_ = $00000032;
  NoEffect9 = $00000033;
  SlideLeft_ = $00000034;
  SlideRight_ = $00000035;
  NoEffect10 = $00000036;
  NoEffect11 = $00000037;
  DoubleDiagUp_ = $00000038;
  DoubleDiagDown_ = $00000039;
  DoubleDiagLeft_ = $0000003A;
  DoubleDiagRight_ = $0000003B;
  RandomBarsUp_ = $0000003C;
  RandomBarsDown_ = $0000003D;
  RandomBarsLeft_ = $0000003E;
  RandomBarsRight_ = $0000003F;
  SparkleUp_ = $00000040;
  SparkleDown_ = $00000041;
  SparkleLeft_ = $00000042;
  SparkleRight_ = $00000043;
  Clock__ = $00000044;
  Counterclock_ = $00000045;
  SemicircleRL_ = $00000046;
  SemicircleLR_ = $00000047;
  SemicircleIn_ = $00000048;
  SemicircleOut_ = $00000049;
  DoubleClock_ = $0000004A;
  CircularQuad_ = $0000004B;
  DiagonalSlideTLBR_ = $0000004C;
  DiagonalSlideTRBL_ = $0000004D;
  DiagonalSlideBLTR_ = $0000004E;
  DiagonalSlideBRTL_ = $0000004F;
  HorizDoubleSlide_ = $00000050;
  VertDoubleSlide_ = $00000051;
  RotateLeft_ = $00000052;
  RotateRight_ = $00000053;
  RotateTop_ = $00000054;
  RotateBottom_ = $00000055;
  HorizCenterStretch_ = $00000056;
  VertCenterStretch_ = $00000057;
  HorizStretchToCenter_ = $00000058;
  VertStretchToCenter_ = $00000059;
  BlocksTB_ = $0000005A;
  BlocksBT_ = $0000005B;
  BlocksLR_ = $0000005C;
  BlocksRL_ = $0000005D;
  GrowingBlindTB_ = $0000005E;
  GrowingBlindBT_ = $0000005F;
  GrowingBlindLR_ = $00000060;
  GrowingBlindRL_ = $00000061;
  RollTB_ = $00000062;
  RollBT_ = $00000063;
  RollLR_ = $00000064;
  RollRL_ = $00000065;
  DPLTR_ = $00000066;
  DPRTL_ = $00000067;
  DPTTB_ = $00000068;
  DPBTT_ = $00000069;
  DPHWI_ = $0000006A;
  DPHWO_ = $0000006B;
  DPVWI_ = $0000006C;
  DPVWO_ = $0000006D;
  DPI_ = $0000006E;
  DPE_ = $0000006F;
  HIS_ = $00000070;
  VIS_ = $00000071;

// enumVidAutoSize constants
type
  enumVidAutoSize = TOleEnum;
const
  Crop_ = $00000000;
  ResizeControl_ = $00000001;
  ResizeImage_ = $00000002;

// enumVideoType constants
type
  enumVideoType = TOleEnum;
const
  AVIVideo = $00000000;
  QuickTime = $00000001;
  UserVideo = $00000002;

// enumTimeFormat constants
type
  enumTimeFormat = TOleEnum;
const
  Frames = $00000000;
  Milliseconds = $00000001;

// enumCapture2 constants
type
  enumCapture2 = TOleEnum;
const
  None__________ = $00000000;
  Capture__ = $00000001;
  DeleteCapture__ = $00000002;

// enumVideoPalette constants
type
  enumVideoPalette = TOleEnum;
const
  VidPalette_Video = $00000000;
  VidPalette_System = $00000001;

type

// *********************************************************************//
// Forward declaration of interfaces defined in Type Library            //
// *********************************************************************//
  _DFxvid32 = dispinterface;
  _DFxvid32Events = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                     //
// (NOTE: Here we map each CoClass to its Default Interface)            //
// *********************************************************************//
  FXVid = _DFxvid32;


// *********************************************************************//
// DispIntf:  _DFxvid32
// Flags:     (4112) Hidden Dispatchable
// GUID:      {79002EE1-4773-11CF-BF88-0040956003D8}
// *********************************************************************//
  _DFxvid32 = dispinterface
    ['{79002EE1-4773-11CF-BF88-0040956003D8}']
    property FileName: WideString dispid 33;
    property AutoSize: enumVidAutoSize dispid 2;
    property VideoType: enumVideoType dispid 3;
    property ErrorMessage: WideString dispid 4;
    property ResultMessage: WideString dispid 5;
    property Error: Smallint dispid 6;
    property MCIString: WideString dispid 7;
    property Position: Integer dispid 8;
    property StartPosition: Integer dispid 9;
    property Mode: WideString dispid 10;
    property Length: Integer dispid 11;
    property NotifyValue: Smallint dispid 12;
    property BOuterStyle: enumBStyle dispid 13;
    property MDelay: Smallint dispid 14;
    property MGrain: Smallint dispid 15;
    property TDelay: Smallint dispid 16;
    property TGrain: Smallint dispid 17;
    property BOuterColor1: OLE_COLOR dispid 18;
    property BOuterWidth: Smallint dispid 19;
    property FXError: Smallint dispid 20;
    property BOuterColor2: OLE_COLOR dispid 21;
    property BorderWidth: Smallint dispid 22;
    property BorderColor: OLE_COLOR dispid 23;
    property BInnerStyle: enumBStyle dispid 24;
    property BInnerWidth: Smallint dispid 25;
    property BInnerColor1: OLE_COLOR dispid 26;
    property BInnerColor2: OLE_COLOR dispid 27;
    property WandWidth: Smallint dispid 28;
    property Speed: Smallint dispid 29;
    property From: Integer dispid 30;
    property To_: Integer dispid 31;
    property Silent: WordBool dispid 32;
    property Command: enumCommand dispid 34;
    property FXWidth: Integer dispid 35;
    property FXHeight: Integer dispid 36;
    property TimeFormat: enumTimeFormat dispid 37;
    property WaveVolume: Integer dispid 38;
    property BackColor: OLE_COLOR dispid 39;
    property FXCanceled: WordBool dispid 40;
    property TGStyle: enumGradient dispid 41;
    property TGSteps: Smallint dispid 42;
    property Capture: enumCapture2 dispid 43;
    property SavePicture: WordBool dispid 44;
    property SaveFileName: WideString dispid 45;
    property HFileName: WideString dispid 46;
    property HName: WideString dispid 47;
    property HID: Smallint dispid 48;
    property HPriority: Smallint dispid 49;
    property HTotal: Smallint dispid 50;
    property HEnable: Smallint dispid 51;
    property HDisable: Smallint dispid 52;
    property Palette: enumVideoPalette dispid 53;
    property DeviceType: WideString dispid 54;
    property Enabled: WordBool dispid -514;
    property TForeColor: OLE_COLOR dispid 55;
    property Wand: WordBool dispid 56;
    property MEffect: enumMEffect dispid 57;
    property DEffect1: enumDEffect dispid 58;
    property DEffect2: enumDEffect dispid 59;
    property DEffect3: enumDEffect dispid 60;
    property DMode: enumDissolve dispid 61;
    property TEnabled: WordBool dispid 62;
    property TGColor1: OLE_COLOR dispid 63;
    property TGColor2: OLE_COLOR dispid 64;
    property TBackColor: OLE_COLOR dispid 65;
    property TEffect: enumMEffect dispid 66;
    property Repeat_: WordBool dispid 67;
    property MousePointer: MousePointerConstants dispid 1;
    property MouseIcon: IPictureDisp dispid 68;
    property WandColor: OLE_COLOR dispid 69;
    property TStyle: enumTStyle dispid 70;
    property Preview: WordBool dispid 71;
    property Notify: WordBool dispid 72;
    property CancelMode: enumCancelMode dispid 73;
    property FXEnabled: WordBool dispid 74;
    property AutoPlay: WordBool dispid 75;
    property SignalEvery: Integer dispid 76;
    property SignalAt: Integer dispid 77;
    property Signal: WordBool dispid 78;
    property SignalPosition: Integer dispid 79;
    property BackStyle: enumVidBackStyle dispid 80;
    property Alias: WideString dispid 81;
    function hWnd: OLE_HANDLE; dispid -515;
    procedure Refresh; dispid -550;
    procedure AboutBox; dispid -552;
  end;

// *********************************************************************//
// DispIntf:  _DFxvid32Events
// Flags:     (4096) Dispatchable
// GUID:      {79002EE2-4773-11CF-BF88-0040956003D8}
// *********************************************************************//
  _DFxvid32Events = dispinterface
    ['{79002EE2-4773-11CF-BF88-0040956003D8}']
    procedure Notify; dispid 1;
    procedure Click; dispid -600;
    procedure DblClick; dispid -601;
    procedure MouseDown(Button: Smallint; Shift: Smallint; X: OLE_XPOS_PIXELS; Y: OLE_YPOS_PIXELS); dispid -605;
    procedure MouseMove(Button: Smallint; Shift: Smallint; X: OLE_XPOS_PIXELS; Y: OLE_YPOS_PIXELS); dispid -606;
    procedure MouseUp(Button: Smallint; Shift: Smallint; X: OLE_XPOS_PIXELS; Y: OLE_YPOS_PIXELS); dispid -607;
    procedure Signal; dispid 2;
    procedure GotFocus; dispid 3;
    procedure LostFocus; dispid 4;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TFXVid
// Help String      : FXVid Control
// Default Interface: _DFxvid32
// Def. Intf. DISP? : Yes
// Event   Interface: _DFxvid32Events
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TFXVid = class(TDBOleControl)
  private
    FOnNotify: TNotifyEvent;
    FOnSignal: TNotifyEvent;
    FOnGotFocus: TNotifyEvent;
    FOnLostFocus: TNotifyEvent;
    FIntf: _DFxvid32;
    function  GetControlInterface: _DFxvid32;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function hWnd: OLE_HANDLE;
    procedure Refresh;
    procedure AboutBox;
    property  ControlInterface: _DFxvid32 read GetControlInterface;
  published
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
    property  OnMouseUp;
    property  OnMouseMove;
    property  OnMouseDown;
    property  OnDblClick;
    property  OnClick;
    property FileName: WideString index 33 read GetWideStringProp write SetWideStringProp stored False;
    property AutoSize: TOleEnum index 2 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property VideoType: TOleEnum index 3 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property ErrorMessage: WideString index 4 read GetWideStringProp write SetWideStringProp stored False;
    property ResultMessage: WideString index 5 read GetWideStringProp write SetWideStringProp stored False;
    property Error: Smallint index 6 read GetSmallintProp write SetSmallintProp stored False;
    property MCIString: WideString index 7 read GetWideStringProp write SetWideStringProp stored False;
    property Position: Integer index 8 read GetIntegerProp write SetIntegerProp stored False;
    property StartPosition: Integer index 9 read GetIntegerProp write SetIntegerProp stored False;
    property Mode: WideString index 10 read GetWideStringProp write SetWideStringProp stored False;
    property Length: Integer index 11 read GetIntegerProp write SetIntegerProp stored False;
    property NotifyValue: Smallint index 12 read GetSmallintProp write SetSmallintProp stored False;
    property BOuterStyle: TOleEnum index 13 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property MDelay: Smallint index 14 read GetSmallintProp write SetSmallintProp stored False;
    property MGrain: Smallint index 15 read GetSmallintProp write SetSmallintProp stored False;
    property TDelay: Smallint index 16 read GetSmallintProp write SetSmallintProp stored False;
    property TGrain: Smallint index 17 read GetSmallintProp write SetSmallintProp stored False;
    property BOuterColor1: TColor index 18 read GetTColorProp write SetTColorProp stored False;
    property BOuterWidth: Smallint index 19 read GetSmallintProp write SetSmallintProp stored False;
    property FXError: Smallint index 20 read GetSmallintProp write SetSmallintProp stored False;
    property BOuterColor2: TColor index 21 read GetTColorProp write SetTColorProp stored False;
    property BorderWidth: Smallint index 22 read GetSmallintProp write SetSmallintProp stored False;
    property BorderColor: TColor index 23 read GetTColorProp write SetTColorProp stored False;
    property BInnerStyle: TOleEnum index 24 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property BInnerWidth: Smallint index 25 read GetSmallintProp write SetSmallintProp stored False;
    property BInnerColor1: TColor index 26 read GetTColorProp write SetTColorProp stored False;
    property BInnerColor2: TColor index 27 read GetTColorProp write SetTColorProp stored False;
    property WandWidth: Smallint index 28 read GetSmallintProp write SetSmallintProp stored False;
    property Speed: Smallint index 29 read GetSmallintProp write SetSmallintProp stored False;
    property From: Integer index 30 read GetIntegerProp write SetIntegerProp stored False;
    property To_: Integer index 31 read GetIntegerProp write SetIntegerProp stored False;
    property Silent: WordBool index 32 read GetWordBoolProp write SetWordBoolProp stored False;
    property Command: TOleEnum index 34 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property FXWidth: Integer index 35 read GetIntegerProp write SetIntegerProp stored False;
    property FXHeight: Integer index 36 read GetIntegerProp write SetIntegerProp stored False;
    property TimeFormat: TOleEnum index 37 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property WaveVolume: Integer index 38 read GetIntegerProp write SetIntegerProp stored False;
    property BackColor: TColor index 39 read GetTColorProp write SetTColorProp stored False;
    property FXCanceled: WordBool index 40 read GetWordBoolProp write SetWordBoolProp stored False;
    property TGStyle: TOleEnum index 41 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property TGSteps: Smallint index 42 read GetSmallintProp write SetSmallintProp stored False;
    property Capture: TOleEnum index 43 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property SavePicture: WordBool index 44 read GetWordBoolProp write SetWordBoolProp stored False;
    property SaveFileName: WideString index 45 read GetWideStringProp write SetWideStringProp stored False;
    property HFileName: WideString index 46 read GetWideStringProp write SetWideStringProp stored False;
    property HName: WideString index 47 read GetWideStringProp write SetWideStringProp stored False;
    property HID: Smallint index 48 read GetSmallintProp write SetSmallintProp stored False;
    property HPriority: Smallint index 49 read GetSmallintProp write SetSmallintProp stored False;
    property HTotal: Smallint index 50 read GetSmallintProp write SetSmallintProp stored False;
    property HEnable: Smallint index 51 read GetSmallintProp write SetSmallintProp stored False;
    property HDisable: Smallint index 52 read GetSmallintProp write SetSmallintProp stored False;
    property Palette: TOleEnum index 53 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property DeviceType: WideString index 54 read GetWideStringProp write SetWideStringProp stored False;
    property Enabled: WordBool index -514 read GetWordBoolProp write SetWordBoolProp stored False;
    property TForeColor: TColor index 55 read GetTColorProp write SetTColorProp stored False;
    property Wand: WordBool index 56 read GetWordBoolProp write SetWordBoolProp stored False;
    property MEffect: TOleEnum index 57 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property DEffect1: TOleEnum index 58 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property DEffect2: TOleEnum index 59 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property DEffect3: TOleEnum index 60 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property DMode: TOleEnum index 61 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property TEnabled: WordBool index 62 read GetWordBoolProp write SetWordBoolProp stored False;
    property TGColor1: TColor index 63 read GetTColorProp write SetTColorProp stored False;
    property TGColor2: TColor index 64 read GetTColorProp write SetTColorProp stored False;
    property TBackColor: TColor index 65 read GetTColorProp write SetTColorProp stored False;
    property TEffect: TOleEnum index 66 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property Repeat_: WordBool index 67 read GetWordBoolProp write SetWordBoolProp stored False;
    property MousePointer: TOleEnum index 1 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property MouseIcon: TPicture index 68 read GetTPictureProp write SetTPictureProp stored False;
    property WandColor: TColor index 69 read GetTColorProp write SetTColorProp stored False;
    property TStyle: TOleEnum index 70 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property Preview: WordBool index 71 read GetWordBoolProp write SetWordBoolProp stored False;
    property _DFxvid32_Notify: WordBool index 72 read GetWordBoolProp write SetWordBoolProp stored False;
    property CancelMode: TOleEnum index 73 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property FXEnabled: WordBool index 74 read GetWordBoolProp write SetWordBoolProp stored False;
    property AutoPlay: WordBool index 75 read GetWordBoolProp write SetWordBoolProp stored False;
    property SignalEvery: Integer index 76 read GetIntegerProp write SetIntegerProp stored False;
    property SignalAt: Integer index 77 read GetIntegerProp write SetIntegerProp stored False;
    property _DFxvid32_Signal: WordBool index 78 read GetWordBoolProp write SetWordBoolProp stored False;
    property SignalPosition: Integer index 79 read GetIntegerProp write SetIntegerProp stored False;
    property BackStyle: TOleEnum index 80 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property Alias: WideString index 81 read GetWideStringProp write SetWideStringProp stored False;
    property OnNotify: TNotifyEvent read FOnNotify write FOnNotify;
    property OnSignal: TNotifyEvent read FOnSignal write FOnSignal;
    property OnGotFocus: TNotifyEvent read FOnGotFocus write FOnGotFocus;
    property OnLostFocus: TNotifyEvent read FOnLostFocus write FOnLostFocus;
  end;

procedure Register;

implementation

uses ComObj;

procedure TFXVid.InitControlData;
const
  CEventDispIDs: array [0..3] of DWORD = (
    $00000001, $00000002, $00000003, $00000004);
  CTPictureIDs: array [0..0] of DWORD = (
    $00000044);
  CControlData: TControlData = (
    ClassID: '{79002EE0-4773-11CF-BF88-0040956003D8}';
    EventIID: '{79002EE2-4773-11CF-BF88-0040956003D8}';
    EventCount: 4;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil;
    Flags: $00000008;
    Version: 300;
    FontCount: 0;
    FontIDs: nil;
    PictureCount: 1;
    PictureIDs: @CTPictureIDs);
begin
  ControlData := @CControlData;
end;

procedure TFXVid.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as _DFxvid32;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TFXVid.GetControlInterface: _DFxvid32;
begin
  CreateControl;
  Result := FIntf;
end;

function TFXVid.hWnd: OLE_HANDLE;
begin
  Result := ControlInterface.hWnd;
end;

procedure TFXVid.Refresh;
begin
  ControlInterface.Refresh;
end;

procedure TFXVid.AboutBox;
begin
  ControlInterface.AboutBox;
end;

procedure Register;
begin
  RegisterComponents('ActiveX',[TFXVid]);
end;

end.
