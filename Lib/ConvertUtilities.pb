EnableExplicit

Procedure IsNumeric(InString.s, DecimalCharacter.c = '.')
  #NotNumeric = #False
  #IsNumeric = #True
 
  InString = Trim(InString)
  Protected IsDecimal, CaughtDecimal, CaughtE
  Protected IsSignPresent, IsSignAllowed = #True, CountNumeric
  Protected *CurrentChar.Character = @InString
 
  While *CurrentChar\c
    Select *CurrentChar\c
      Case '0' To '9'
        CountNumeric + 1
        IsSignAllowed = #False
      Case DecimalCharacter
        If CaughtDecimal Or CaughtE Or CountNumeric = 0
          ProcedureReturn #NotNumeric
        EndIf
 
        CountNumeric = 0
        CaughtDecimal = #True
        IsDecimal = #True
      Case  '-', '+'
        If IsSignPresent Or Not IsSignAllowed: ProcedureReturn #NotNumeric: EndIf 
        IsSignPresent = #True
      Case 'E', 'e'
        If CaughtE Or CountNumeric = 0
          ProcedureReturn #NotNumeric
        EndIf
 
        CaughtE = #True
        CountNumeric = 0
        CaughtDecimal = #False
        IsSignPresent = #False
        IsSignAllowed = #True
      Default
        ProcedureReturn #NotNumeric
    EndSelect
    *CurrentChar + SizeOf(Character)
  Wend
 
  If CountNumeric = 0: ProcedureReturn #NotNumeric: EndIf
  ProcedureReturn #IsNumeric
EndProcedure

Prototype.d Convert(Value.d)

Procedure.d ConvertFrom_mm(mm.d)
  ProcedureReturn mm / 1e3
EndProcedure

Procedure.d ConvertTo_mm(Meters.d)
  ProcedureReturn Meters * 1e3
EndProcedure

Procedure.d ConvertFrom_MPa(MPa.d)
  ProcedureReturn MPa * 1e6
EndProcedure
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 59
; FirstLine = 9
; Folding = -
; EnableXP