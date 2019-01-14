XIncludeFile "ConvertUtilities.pb"

EnableExplicit

Procedure SelectGadgetText(Gadget, StartPos.i = 0, Length.i = -1)
  SendMessage_(GadgetID(Gadget), #EM_SETSEL, StartPos, Length)  ; Yes, must be GadgetID
  SetActiveGadget(Gadget)
EndProcedure

Procedure GetGadgetNumber(Gadget, *Number.Double, ConvertFrom.Convert = #Null)
  Define Text.s = GetGadgetText(Gadget)
  Define IsNumber = IsNumeric(Text)  
  If IsNumber
    *Number\d = ValD(Text)
    If ConvertFrom <> #Null
      *Number\d = ConvertFrom(*Number\d)
    EndIf
  EndIf
  ProcedureReturn IsNumber
EndProcedure
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 2
; Folding = -
; EnableXP