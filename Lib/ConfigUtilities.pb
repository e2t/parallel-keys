EnableExplicit

Procedure OpenPreferences_CreateIfNeed(PreferencesFile.s)
  If FileSize(PreferencesFile) < 0 
    ProcedureReturn CreatePreferences(PreferencesFile)
  EndIf
  ProcedureReturn OpenPreferences(PreferencesFile)
EndProcedure
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 1
; Folding = -
; EnableXP