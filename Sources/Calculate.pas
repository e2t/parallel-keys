unit Calculate;

{$mode objfpc}{$H+}

interface

uses
  Classes, Math, SysUtils, DryConversion;

{ ГОСТ 23360-78
  От - включительно
  До - включительно
  Свыше - НЕвключительно }

type
  TParallelKey = record
    MaxDiameter: Extended;
    Width: Extended;
    Height: Extended;
    ShaftDepth: Extended;
    BushingDepth: Extended;
    MinRadius: Extended;
    MaxRadius: Extended;
    Tolerance: Extended;
  end;

const
  ParallelKeysTableCount = 26;

  ParallelKeysTable: array [0..ParallelKeysTableCount - 1] of TParallelKey = (
    (MaxDiameter: 0.008; Width: 0.002; Height: 0.002; ShaftDepth: 0.0012; BushingDepth: 0.001;  MinRadius: 0.00008; MaxRadius: 0.00016; Tolerance: 0.0001),
    (MaxDiameter: 0.01;  Width: 0.003; Height: 0.003; ShaftDepth: 0.0018; BushingDepth: 0.0014; MinRadius: 0.00008; MaxRadius: 0.00016; Tolerance: 0.0001),
    (MaxDiameter: 0.012; Width: 0.004; Height: 0.004; ShaftDepth: 0.0025; BushingDepth: 0.0018; MinRadius: 0.00008; MaxRadius: 0.00016; Tolerance: 0.0001),
    (MaxDiameter: 0.017; Width: 0.005; Height: 0.005; ShaftDepth: 0.003;  BushingDepth: 0.0023; MinRadius: 0.00016; MaxRadius: 0.00025; Tolerance: 0.0001),
    (MaxDiameter: 0.022; Width: 0.006; Height: 0.006; ShaftDepth: 0.0035; BushingDepth: 0.0028; MinRadius: 0.00016; MaxRadius: 0.00025; Tolerance: 0.0001),
    (MaxDiameter: 0.03;  Width: 0.008; Height: 0.007; ShaftDepth: 0.004;  BushingDepth: 0.0033; MinRadius: 0.00016; MaxRadius: 0.00025; Tolerance: 0.0002),
    (MaxDiameter: 0.038; Width: 0.01;  Height: 0.008; ShaftDepth: 0.005;  BushingDepth: 0.0033; MinRadius: 0.00025; MaxRadius: 0.0004;  Tolerance: 0.0002),
    (MaxDiameter: 0.044; Width: 0.012; Height: 0.008; ShaftDepth: 0.005;  BushingDepth: 0.0033; MinRadius: 0.00025; MaxRadius: 0.0004;  Tolerance: 0.0002),
    (MaxDiameter: 0.05;  Width: 0.014; Height: 0.009; ShaftDepth: 0.0055; BushingDepth: 0.0038; MinRadius: 0.00025; MaxRadius: 0.0004;  Tolerance: 0.0002),
    (MaxDiameter: 0.058; Width: 0.016; Height: 0.01;  ShaftDepth: 0.006;  BushingDepth: 0.0043; MinRadius: 0.00025; MaxRadius: 0.0004;  Tolerance: 0.0002),
    (MaxDiameter: 0.065; Width: 0.018; Height: 0.011; ShaftDepth: 0.007;  BushingDepth: 0.0044; MinRadius: 0.00025; MaxRadius: 0.0004;  Tolerance: 0.0002),
    (MaxDiameter: 0.075; Width: 0.02;  Height: 0.012; ShaftDepth: 0.0075; BushingDepth: 0.0049; MinRadius: 0.0004;  MaxRadius: 0.0006;  Tolerance: 0.0002),
    (MaxDiameter: 0.085; Width: 0.022; Height: 0.014; ShaftDepth: 0.009;  BushingDepth: 0.0054; MinRadius: 0.0004;  MaxRadius: 0.0006;  Tolerance: 0.0002),
    (MaxDiameter: 0.095; Width: 0.025; Height: 0.014; ShaftDepth: 0.009;  BushingDepth: 0.0054; MinRadius: 0.0004;  MaxRadius: 0.0006;  Tolerance: 0.0002),
    (MaxDiameter: 0.11;  Width: 0.028; Height: 0.016; ShaftDepth: 0.01;   BushingDepth: 0.0064; MinRadius: 0.0004;  MaxRadius: 0.0006;  Tolerance: 0.0002),
    (MaxDiameter: 0.13;  Width: 0.032; Height: 0.018; ShaftDepth: 0.011;  BushingDepth: 0.0074; MinRadius: 0.0004;  MaxRadius: 0.0006;  Tolerance: 0.0002),
    (MaxDiameter: 0.15;  Width: 0.036; Height: 0.02;  ShaftDepth: 0.012;  BushingDepth: 0.0084; MinRadius: 0.0007;  MaxRadius: 0.001;   Tolerance: 0.0003),
    (MaxDiameter: 0.17;  Width: 0.04;  Height: 0.022; ShaftDepth: 0.013;  BushingDepth: 0.0094; MinRadius: 0.0007;  MaxRadius: 0.001;   Tolerance: 0.0003),
    (MaxDiameter: 0.2;   Width: 0.045; Height: 0.025; ShaftDepth: 0.015;  BushingDepth: 0.01;   MinRadius: 0.0007;  MaxRadius: 0.001;   Tolerance: 0.0003),
    (MaxDiameter: 0.23;  Width: 0.05;  Height: 0.028; ShaftDepth: 0.017;  BushingDepth: 0.0114; MinRadius: 0.0007;  MaxRadius: 0.001;   Tolerance: 0.0003),
    (MaxDiameter: 0.26;  Width: 0.056; Height: 0.032; ShaftDepth: 0.02;   BushingDepth: 0.0124; MinRadius: 0.0012;  MaxRadius: 0.0016;  Tolerance: 0.0003),
    (MaxDiameter: 0.29;  Width: 0.063; Height: 0.032; ShaftDepth: 0.02;   BushingDepth: 0.0124; MinRadius: 0.0012;  MaxRadius: 0.0016;  Tolerance: 0.0003),
    (MaxDiameter: 0.33;  Width: 0.07;  Height: 0.036; ShaftDepth: 0.022;  BushingDepth: 0.0144; MinRadius: 0.0012;  MaxRadius: 0.0016;  Tolerance: 0.0003),
    (MaxDiameter: 0.38;  Width: 0.08;  Height: 0.04;  ShaftDepth: 0.025;  BushingDepth: 0.0154; MinRadius: 0.002;   MaxRadius: 0.0025;  Tolerance: 0.0003),
    (MaxDiameter: 0.44;  Width: 0.09;  Height: 0.045; ShaftDepth: 0.028;  BushingDepth: 0.0174; MinRadius: 0.002;   MaxRadius: 0.0025;  Tolerance: 0.0003),
    (MaxDiameter: 0.5;   Width: 0.1;   Height: 0.05;  ShaftDepth: 0.031;  BushingDepth: 0.0195; MinRadius: 0.002;   MaxRadius: 0.0025;  Tolerance: 0.0003)
    { Альтернативные типоразмеры:
    (0.03,  0.007, 0.007, 0.004, 0.0033, 0.00025)
    (0.095, 0.024, 0.014, 0.009, 0.0054, 0.0006) }
  );

  KeyLengthCount = 36;

  KeyLength: array [0..KeyLengthCount - 1] of Extended = (
    0.006, 0.008, 0.01, 0.012, 0.014, 0.016, 0.018, 0.02, 0.022, 0.025, 0.028,
    0.032, 0.036, 0.04, 0.045, 0.05,  0.056, 0.063, 0.07, 0.08,  0.09,  0.1,
    0.11,  0.125, 0.14, 0.16,  0.18,  0.2,   0.22,  0.25, 0.28,  0.32,  0.36,
    0.4,   0.45,  0.5);

function CreateOutputFromForce(const BearingForce, ShearForce: Extended;
  const Key: TParallelKey;
  const MaxBearingStress, MaxShearStress: Extended): string;

function CreateOutputFromTorque(
  const Torque, ShaftDiam, MaxBearingStress, MaxShearStress: Extended): string;

implementation

{ Выступ шпонки над пазом }
function CalcKeyAboveShaft(const Key: TParallelKey): Extended;
begin
  Result := Key.Height - Key.ShaftDepth;
end;

{ Сила смятия }
function CalcBearingForce(const Torque, ShaftDiam: Extended): Extended;
begin
  Result := 2 * Torque / ShaftDiam;
end;

{ Сила среза }
function CalcShearForce(
  const Torque, ShaftDiam, KeyAboveShaft: Extended): Extended;
begin
  Result := 2 * Torque / (ShaftDiam + KeyAboveShaft);
end;

{ Рабочая длина шпонки (смятие) }
function CalcWorkingLengthFromBearing(
  const BearingForce, KeyAboveShaft, MaxBearingStress: Extended): Extended;
begin
  Result := BearingForce / KeyAboveShaft / MaxBearingStress;
end;

{ Рабочая длина шпонки (срез) }
function CalcWorkingLengthFromShear(
  const ShearForce, KeyWidth, MaxShearStress: Extended): Extended;
begin
  Result := ShearForce / KeyWidth / MaxShearStress;
end;

{ Рабочая длина шпонки (максимальная) }
function CalcWorkingLength(const BearingForce, ShearForce: Extended;
  const Key: TParallelKey;
  const MaxBearingStress, MaxShearStress: Extended): Extended;
var
  KeyAboveShaft: Extended;
begin
  KeyAboveShaft := CalcKeyAboveShaft(Key);
  Result := Max(
    CalcWorkingLengthFromBearing(BearingForce, KeyAboveShaft, MaxBearingStress),
    CalcWorkingLengthFromShear(ShearForce, Key.Width, MaxShearStress));
end;

{ Полная длина шпонки }
function CalcFullLength(const WorkingLength, KeyWidth: Extended): Extended;
var
  I: Integer = 0;
begin
  Result := WorkingLength + KeyWidth;
  if Result < KeyLength[KeyLengthCount - 1] then
  begin
    while Result > KeyLength[I] do
      Inc(I);
    Result := KeyLength[I];
  end;
end;

function CreateOutputFromForce(const BearingForce, ShearForce: Extended;
  const Key: TParallelKey;
  const MaxBearingStress, MaxShearStress: Extended): string;
const
  RatioForDouble = 0.5;
var
  SingleWorkingLength, SingleFullLength: Extended;
  DoubleWorkingLength, DoubleFullLength: Extended;
begin
  SingleWorkingLength := CalcWorkingLength(BearingForce, ShearForce, Key,
    MaxBearingStress, MaxShearStress);
  DoubleWorkingLength := CalcWorkingLength(BearingForce * RatioForDouble,
    ShearForce * RatioForDouble, Key, MaxBearingStress, MaxShearStress);
  SingleFullLength := CalcFullLength(SingleWorkingLength, Key.Width);
  DoubleFullLength := CalcFullLength(DoubleWorkingLength, Key.Width);
  Result := 'Шпонка ' + FormatFloat(',0.#', ToMm(Key.Width)) +
    'x' + FormatFloat(',0.#', ToMm(Key.Height)) + sLineBreak + sLineBreak +

    'Длина 1 шпонки:'#9'Lр = ' + FormatFloat(',0.0', ToMm(SingleWorkingLength)) +
    ' min → L = ' +
    FormatFloat(',0.#', ToMm(SingleFullLength)) + sLineBreak +

    'Длина 2 шпонок:'#9'Lр = ' + FormatFloat(',0.0', ToMm(DoubleWorkingLength)) +
    ' min → L = ' +
    FormatFloat(',0.#', ToMm(DoubleFullLength)) + sLineBreak + sLineBreak +

    'Глубина паза на валу:'#9 + FormatFloat(',0.0#', ToMm(Key.ShaftDepth)) +
    ' (+' + FormatFloat(',0.0#', ToMm(Key.Tolerance)) + ')' + sLineBreak +

    'Глубина паза втулки: '#9 + FormatFloat(',0.0#', ToMm(Key.BushingDepth)) +
    ' (+' + FormatFloat(',0.0#', ToMm(Key.Tolerance)) + ')' + sLineBreak +

    'Радиус закругления:  '#9 + FormatFloat(',0.0#', ToMm(Key.MinRadius)) + '...' +
    FormatFloat(',0.0#', ToMm(Key.MaxRadius));
end;

function CreateOutputFromTorque(
  const Torque, ShaftDiam, MaxBearingStress, MaxShearStress: Extended): string;
var
  Key: TParallelKey;
  I: Integer = 0;
  BearingForce, ShearForce: Extended;
begin
  while ParallelKeysTable[I].MaxDiameter < ShaftDiam do
    Inc(I);
  Key := ParallelKeysTable[I];
  BearingForce := CalcBearingForce(Torque, ShaftDiam);
  ShearForce := CalcShearForce(Torque, ShaftDiam, CalcKeyAboveShaft(Key));
  Result := CreateOutputFromForce(BearingForce, ShearForce, Key,
    MaxBearingStress, MaxShearStress);
end;

end.

