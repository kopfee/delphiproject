// KSConditions.INC

{ Kingstar Delphi Library Compile Conditions }

{ Borland Delphi 6.0 }
{$IFDEF VER140}
  {$DEFINE VCL10_up}
  {$DEFINE VCL20_up}
  {$DEFINE VCL30_up}
  {$DEFINE VCL35_up}
  {$DEFINE VCL40_up}
  {$DEFINE VCL50_up}
  {$DEFINE VCL60_up}
  {$DEFINE VCL60}
{$ENDIF VER140}

{ Borland Delphi 5.0 and Borland C++Builder 5.0 }
{$IFDEF VER130}
  {$DEFINE VCL10_up}
  {$DEFINE VCL20_up}
  {$DEFINE VCL30_up}
  {$DEFINE VCL35_up}
  {$DEFINE VCL40_up}
  {$DEFINE VCL50_up}
  {$DEFINE VCL50}
{$ENDIF VER130}

{ Borland C++Builder 4.0 }
{$IFDEF VER125}
  {$DEFINE VCL10_up}
  {$DEFINE VCL20_up}
  {$DEFINE VCL30_up}
  {$DEFINE VCL35_up}
  {$DEFINE VCL40_up}
  {$DEFINE VCL40}
{$ENDIF VER125}

{ Borland Delphi 4.0 }
{$IFDEF VER120}
  {$DEFINE VCL10_up}
  {$DEFINE VCL20_up}
  {$DEFINE VCL30_up}
  {$DEFINE VCL35_up}
  {$DEFINE VCL40_up}
  {$DEFINE VCL40}
{$ENDIF VER120}

{ Borland C++Builder 3.0 }
{$IFDEF VER110}
  {$DEFINE VCL10_up}
  {$DEFINE VCL20_up}
  {$DEFINE VCL30_up}
  {$DEFINE VCL35_up}
  {$DEFINE VCL30}
  {$DEFINE VCL40_prior}
{$ENDIF VER110}

{ Borland Delphi 3.0 }
{$IFDEF VER100}
  {$DEFINE VCL10_up}
  {$DEFINE VCL20_up}
  {$DEFINE VCL30_up}
  {$DEFINE VCL30}
  {$DEFINE VCL40_prior}
{$ENDIF VER100}

{$IFDEF VER90}
  {$DEFINE VCL10_up}
  {$DEFINE VCL20_up}
  {$DEFINE VCL20}
  {$DEFINE VCL40_prior}
{$ENDIF VER90}
