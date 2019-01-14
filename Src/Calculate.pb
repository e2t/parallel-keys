EnableExplicit

; ГОСТ 23360-78
; От - включительно
; До - включительно
; Свыше - НЕвключительно

Structure ParallelKey
  MaxDiam.d
  Width.d
  Height.d
  ShaftDepth.d
  BushingDepth.d
  MinRadius.d
  MaxRadius.d
  Tolerance.d
EndStructure

Global Dim ParallelKeysTable.ParallelKey(25)

Macro TableRow(I, aMaxDiam, aWidth, aHeight, aShaftDepth, aBushingDepth, aMinRadius, aMaxRadius, aTolerance)
  ParallelKeysTable(I)\MaxDiam = aMaxDiam
  ParallelKeysTable(I)\Width = aWidth
  ParallelKeysTable(I)\Height = aHeight
  ParallelKeysTable(I)\ShaftDepth = aShaftDepth
  ParallelKeysTable(I)\BushingDepth = aBushingDepth
  ParallelKeysTable(I)\MinRadius = aMinRadius
  ParallelKeysTable(I)\MaxRadius = aMaxRadius
  ParallelKeysTable(I)\Tolerance = aTolerance
EndMacro  

TableRow( 0, 0.008, 0.002, 0.002, 0.0012, 0.001,  0.00008, 0.00016, 0.0001)
TableRow( 1, 0.01,  0.003, 0.003, 0.0018, 0.0014, 0.00008, 0.00016, 0.0001)
TableRow( 2, 0.012, 0.004, 0.004, 0.0025, 0.0018, 0.00008, 0.00016, 0.0001)
TableRow( 3, 0.017, 0.005, 0.005, 0.003,  0.0023, 0.00016, 0.00025, 0.0001)
TableRow( 4, 0.022, 0.006, 0.006, 0.0035, 0.0028, 0.00016, 0.00025, 0.0001)
TableRow( 5, 0.03,  0.008, 0.007, 0.004,  0.0033, 0.00016, 0.00025, 0.0002)
TableRow( 6, 0.038, 0.01,  0.008, 0.005,  0.0033, 0.00025, 0.0004,  0.0002)
TableRow( 7, 0.044, 0.012, 0.008, 0.005,  0.0033, 0.00025, 0.0004,  0.0002)
TableRow( 8, 0.05,  0.014, 0.009, 0.0055, 0.0038, 0.00025, 0.0004,  0.0002)
TableRow( 9, 0.058, 0.016, 0.01,  0.006,  0.0043, 0.00025, 0.0004,  0.0002)
TableRow(10, 0.065, 0.018, 0.011, 0.007,  0.0044, 0.00025, 0.0004,  0.0002)
TableRow(11, 0.075, 0.02,  0.012, 0.0075, 0.0049, 0.0004,  0.0006,  0.0002)
TableRow(12, 0.085, 0.022, 0.014, 0.009,  0.0054, 0.0004,  0.0006,  0.0002)
TableRow(13, 0.095, 0.025, 0.014, 0.009,  0.0054, 0.0004,  0.0006,  0.0002)
TableRow(14, 0.11,  0.028, 0.016, 0.01,   0.0064, 0.0004,  0.0006,  0.0002)
TableRow(15, 0.13,  0.032, 0.018, 0.011,  0.0074, 0.0004,  0.0006,  0.0002)
TableRow(16, 0.15,  0.036, 0.02,  0.012,  0.0084, 0.0007,  0.001,   0.0003)
TableRow(17, 0.17,  0.04,  0.022, 0.013,  0.0094, 0.0007,  0.001,   0.0003)
TableRow(18, 0.2,   0.045, 0.025, 0.015,  0.01,   0.0007,  0.001,   0.0003)
TableRow(19, 0.23,  0.05,  0.028, 0.017,  0.0114, 0.0007,  0.001,   0.0003)
TableRow(20, 0.26,  0.056, 0.032, 0.02,   0.0124, 0.0012,  0.0016,  0.0003)
TableRow(21, 0.29,  0.063, 0.032, 0.02,   0.0124, 0.0012,  0.0016,  0.0003)
TableRow(22, 0.33,  0.07,  0.036, 0.022,  0.0144, 0.0012,  0.0016,  0.0003)
TableRow(23, 0.38,  0.08,  0.04,  0.025,  0.0154, 0.002,   0.0025,  0.0003)
TableRow(24, 0.44,  0.09,  0.045, 0.028,  0.0174, 0.002,   0.0025,  0.0003)
TableRow(25, 0.5,   0.1,   0.05,  0.031,  0.0195, 0.002,   0.0025,  0.0003)
; Альтернативные типоразмеры:
; TableRow( 5, 0.03,  0.007, 0.007, 0.004, 0.0033, 0.00025)
; TableRow(13, 0.095, 0.024, 0.014, 0.009, 0.0054, 0.0006)

Global Dim KeyLength.d(35)

KeyLength(0) = 0.006
KeyLength(1) = 0.008
KeyLength(2) = 0.01
KeyLength(3) = 0.012
KeyLength(4) = 0.014
KeyLength(5) = 0.016
KeyLength(6) = 0.018
KeyLength(7) = 0.02
KeyLength(8) = 0.022
KeyLength(9) = 0.025
KeyLength(10) = 0.028
KeyLength(11) = 0.032
KeyLength(12) = 0.036
KeyLength(13) = 0.04
KeyLength(14) = 0.045
KeyLength(15) = 0.05
KeyLength(16) = 0.056
KeyLength(17) = 0.063
KeyLength(18) = 0.07
KeyLength(19) = 0.08
KeyLength(20) = 0.09
KeyLength(21) = 0.1
KeyLength(22) = 0.11
KeyLength(23) = 0.125
KeyLength(24) = 0.14
KeyLength(25) = 0.16
KeyLength(26) = 0.18
KeyLength(27) = 0.2
KeyLength(28) = 0.22
KeyLength(29) = 0.25
KeyLength(30) = 0.28
KeyLength(31) = 0.32
KeyLength(32) = 0.36
KeyLength(33) = 0.4
KeyLength(34) = 0.45
KeyLength(35) = 0.5

; Выступ шпонки над пазом
Procedure.d CalculateKeyAboveShaft(*Key.ParallelKey)
  ProcedureReturn *Key\Height - *Key\ShaftDepth
EndProcedure

; Сила смятия
Procedure.d CalculateForce_Bearing(Torque.d, ShaftDiam.d)
  ProcedureReturn 2 * Torque / ShaftDiam
EndProcedure

; Сила срезания
Procedure.d CalculateForce_Shear(Torque.d, ShaftDiam.d, KeyAboveShaft.d)
  ProcedureReturn 2 * Torque / (ShaftDiam + KeyAboveShaft)
EndProcedure

; Рабочая длина шпонки (смятие)
Procedure.d CalculateSupportingKeyLength_Bearing(BearingForce.d, KeyAboveShaft.d, MaxBearingStress.d)
  ProcedureReturn BearingForce / KeyAboveShaft / MaxBearingStress
EndProcedure

; Рабочая длина шпонки (срезание)
Procedure.d CalculateSupportingKeyLength_Shear(ShearForce.d, *Key.ParallelKey, MaxShearStress.d)
  ProcedureReturn ShearForce / *Key\Width / MaxShearStress
EndProcedure

; Рабочая длина шпонки (максимальная)
Procedure.d CalculateSupportingKeyLength(BearingForce.d, ShearForce.d, *Key.ParallelKey, MaxBearingStress.d, MaxShearStress.d)
  Define KeyAboveShaft.d = CalculateKeyAboveShaft(*Key)
  Define Length1.d = CalculateSupportingKeyLength_Bearing(BearingForce, KeyAboveShaft, MaxBearingStress)
  Define Length2.d = CalculateSupportingKeyLength_Shear(ShearForce, *Key.ParallelKey, MaxShearStress)
  If Length1 > Length2
    ProcedureReturn Length1
  EndIf
  ProcedureReturn Length2
EndProcedure

; Полная длина шпонки
Procedure.d CalculateFullKeyLength(SupportingKeyLength.d, KeyWidth.d)
  Define FullLength.d = SupportingKeyLength + KeyWidth
  Define I.i
  For I = 0 To ArraySize(KeyLength())
    If KeyLength(I) >= FullLength
      ProcedureReturn KeyLength(I)
    EndIf
  Next
  ProcedureReturn FullLength
EndProcedure

; 
Procedure.s CalculateByForce(BearingForce.d, ShearForce.d, *Key.ParallelKey, MaxBearingStress.d, MaxShearStress.d)
  #KDouble = 2.0
  Define SingleSupportingLength.d = CalculateSupportingKeyLength(BearingForce, ShearForce, *Key, MaxBearingStress, MaxShearStress)  
  Define DoubleSupportingLength.d = CalculateSupportingKeyLength(BearingForce / #KDouble, ShearForce / #KDouble, *Key, MaxBearingStress, MaxShearStress)
  Define SingleFullLength.d = CalculateFullKeyLength(SingleSupportingLength, *Key\Width)
  Define DoubleFullLength.d = CalculateFullKeyLength(DoubleSupportingLength, *Key\Width)
  ProcedureReturn "Шпонка " + StrD(ConvertTo_mm(*Key\Width)) + "x" + StrD(ConvertTo_mm(*Key\Height)) + ~"\n" + ~"\n" +
"Длина 1 шпонки: Lp = " + StrD(ConvertTo_mm(SingleSupportingLength), 1) + " min " + Chr($2192) + " L = " + StrD(ConvertTo_mm(SingleFullLength), 0) + ~"\n" +
"Длина 2 шпонок: Lp = " + StrD(ConvertTo_mm(DoubleSupportingLength), 1) + " min " + Chr($2192) + " L = " + StrD(ConvertTo_mm(DoubleFullLength), 0) + ~"\n" + ~"\n" +
"Глубина паза на валу: " + StrD(ConvertTo_mm(*Key\ShaftDepth), 1) + " (+" + StrD(ConvertTo_mm(*Key\Tolerance)) + ")" + ~"\n" +
"Глубина паза втулки: " + StrD(ConvertTo_mm(*Key\BushingDepth), 1) + " (+" + StrD(ConvertTo_mm(*Key\Tolerance)) + ")" + ~"\n" +
"Радиус закругления " + StrD(ConvertTo_mm(*Key\MinRadius)) + "..." + StrD(ConvertTo_mm(*Key\MaxRadius))  
EndProcedure

Procedure.s CalculateByTorque(Torque.d, ShaftDiam.d, MaxBearingStress.d, MaxShearStress.d)
  Define I.i
  For I = 0 To ArraySize(ParallelKeysTable())
    Define Key.ParallelKey = ParallelKeysTable(I)
    If Key\MaxDiam >= ShaftDiam
      Break
    EndIf
  Next
  Define BearingForce.d = CalculateForce_Bearing(Torque, ShaftDiam)
  Define ShearForce.d = CalculateForce_Shear(Torque, ShaftDiam, CalculateKeyAboveShaft(@Key))
  ProcedureReturn CalculateByForce(BearingForce, ShearForce, @Key, MaxBearingStress, MaxShearStress)
EndProcedure
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; Folding = --
; EnableXP