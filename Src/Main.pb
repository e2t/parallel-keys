XIncludeFile "..\Lib\GUIUtilities.pb"
XIncludeFile "..\Lib\ConfigUtilities.pb"
XIncludeFile "Calculate.pb"

EnableExplicit

Global TextAbout.s = "Расчет на смятие:  Lp = (2 * M) / (d * K * [G])" + ~"\n" +
                     ~"\n" +
                     "Расчет на срез:  Lp = (2 * M) / (b * (d + K) * [T])" + ~"\n" +
                     ~"\n" +
                     "Lp — рабочая длина шпонки (минимальная)" + ~"\n" +
                     "М — крутящий момент на валу" + ~"\n" +
                     "d — диаметр вала" + ~"\n" +
                     "b — ширина шпонки" + ~"\n" +
                     "K — выступ шпонки над валом" + ~"\n" +
                     "[G] — допускаемое напряжение на смятие" + ~"\n" +
                     "[T] — допускаемое напряжение на срез"

Global MainWindow
Global SG_Torque, SG_ShaftDiam, SG_BearingStress, SG_ShearStress, EG_Result, B_Run, B_Help,
       PG_Panel, SG_Force, CMG_Key, FG_Frame

Enumeration
  #TabShaft
  #TabPlate
EndEnumeration

Procedure ShowText(Message.s)
  SetGadgetText(EG_Result, Message)
EndProcedure

Procedure ShowTextAndSelect(Message.s, Gadget)
  ShowText(Message)
  SelectGadgetText(Gadget)
EndProcedure

Procedure EventButtonRun(EventType)  
  #Error_PositiveNumberExpected = "Ожидается число больше нуля."  
  #MinDiam = 0.006  ; включительно      
  Define MaxDiam.d = ParallelKeysTable(ArraySize(ParallelKeysTable()))\MaxDiam
  Define Error_ShaftDiamRangeExpected.s = "Ожидается число от " + StrD(ConvertTo_mm(#MinDiam)) + " до " + StrD(ConvertTo_mm(MaxDiam)) + " мм."
  
  Define Torque.d, ShaftDiam.d, BearingStress.d, ShearStress.d, Force.d, Key.ParallelKey
  Define CanContinue = #False
  
  If GetGadgetState(PG_Panel) = #TabShaft
    If Not GetGadgetNumber(SG_Torque, @Torque) Or Torque <= 0
      ShowTextAndSelect("Крутящий момент: " + #Error_PositiveNumberExpected, SG_Torque)
    ElseIf Not GetGadgetNumber(SG_ShaftDiam, @ShaftDiam, @ConvertFrom_mm()) Or ShaftDiam < #MinDiam Or ShaftDiam > MaxDiam
      ShowTextAndSelect("Диаметр вала: " + Error_ShaftDiamRangeExpected, SG_ShaftDiam)
    Else
      CanContinue = #True
    EndIf
  Else
    If Not GetGadgetNumber(SG_Force, @Force) Or Force <= 0
      ShowTextAndSelect("Сдвигающая сила: " + #Error_PositiveNumberExpected, SG_Force)
    Else      
      Key = ParallelKeysTable(GetGadgetState(CMG_Key))
      CanContinue = #True
    EndIf
  EndIf
  
  If CanContinue 
    If Not GetGadgetNumber(SG_BearingStress, @BearingStress, @ConvertFrom_MPa()) Or BearingStress <= 0
      ShowTextAndSelect("Напряжение смятия: " + #Error_PositiveNumberExpected, SG_BearingStress) 
    ElseIf Not GetGadgetNumber(SG_ShearStress, @ShearStress, @ConvertFrom_MPa()) Or ShearStress <= 0
      ShowTextAndSelect("Напряжение среза: " + #Error_PositiveNumberExpected, SG_ShearStress)
    ElseIf GetGadgetState(PG_Panel) = #TabShaft
      ShowText(CalculateByTorque(Torque, ShaftDiam, BearingStress, ShearStress))
    Else
      ShowText(CalculateByForce(Force, Force, @Key, BearingStress, ShearStress))
    EndIf
  EndIf
EndProcedure

Procedure LabelAbove(Parent, Text.s, Width)
  ProcedureReturn TextGadget(#PB_Any, GadgetX(Parent), GadgetY(Parent) - 18, Width, 20, Text)
EndProcedure

Procedure LabelOnLeft(Parent, Text.s, Width)
  ProcedureReturn TextGadget(#PB_Any, GadgetX(Parent) - Width, GadgetY(Parent) + 3, Width, 20, Text)
EndProcedure

Procedure.i ToEndGadget(Parent)
  ProcedureReturn GadgetX(Parent) + GadgetWidth(Parent)
EndProcedure

MainWindow = OpenWindow(#PB_Any, 0, 0, 470, 295, 
                        #PB_Editor_FileDescription + " (v" + #PB_Editor_ProductVersion + ")", 
                        #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)

PG_Panel = PanelGadget(#PB_Any, 10, 10, 240, 95)

AddGadgetItem(PG_Panel, #TabShaft, "Вал")
SG_Torque = StringGadget(#PB_Any, 145, 10, 80, 21, "")
LabelOnLeft(SG_Torque, "Крутящий момент (Нм):", 140)
SG_ShaftDiam = StringGadget(#PB_Any, GadgetX(SG_Torque), GadgetY(SG_Torque) + 30, 80, 21, "")
LabelOnLeft(SG_ShaftDiam, "Диаметр вала (мм):", 140)

AddGadgetItem(PG_Panel, #TabPlate, "Плоскость")
SG_Force = StringGadget(#PB_Any, 145, 10, 80, 21, "")
LabelOnLeft(SG_Force, "Сдвигающая сила (Н):", 140)
CMG_Key = ComboBoxGadget(#PB_Any, GadgetX(SG_Force), GadgetY(SG_Force) + 30, 80, 21)
LabelOnLeft(CMG_Key, "Сечение шпонки (мм):", 140)
Define I.i
For I = 0 To ArraySize(ParallelKeysTable())
  AddGadgetItem(CMG_Key, -1, Str(ConvertTo_mm(ParallelKeysTable(I)\Width)) + "x" + 
                             Str(ConvertTo_mm(ParallelKeysTable(I)\Height)))
Next
SetGadgetState(CMG_Key, 0)

CloseGadgetList()
SetActiveGadget(SG_Torque)

FG_Frame = FrameGadget(#PB_Any, 260, 24, 200, 81, "Допускаемое напряжение (МПа)")
SG_BearingStress = StringGadget(#PB_Any, GadgetX(FG_Frame) + 75, 43, 80, 21, "", #PB_Text_Right)
LabelOnLeft(SG_BearingStress, "На смятие:", 65)
SG_ShearStress = StringGadget(#PB_Any, GadgetX(FG_Frame) + 75, GadgetY(SG_BearingStress) + 30, 80, 21, "", #PB_Text_Right)
LabelOnLeft(SG_ShearStress, "На срез:", 65)

EG_Result = EditorGadget(#PB_Any, 10, 115, ToEndGadget(FG_Frame) - 10, 140, #PB_Editor_ReadOnly | #PB_Editor_WordWrap)
B_Run = ButtonGadget(#PB_Any, GadgetX(EG_Result) + GadgetWidth(EG_Result) - 75, GadgetY(EG_Result) + GadgetHeight(EG_Result) + 10, 75, 23, "Рассчитать")
B_Help = ButtonGadget(#PB_Any, GadgetX(EG_Result), GadgetY(B_Run), 75, 23, "Справка")

Define PreferencesFile.s = GetPathPart(ProgramFilename()) + "ParallelKeys.ini"
#PrefKeyBearingStress = "BearingStress"
#PrefKeyShearStress = "ShearStress"
#PrefGroupWindow = "MainWindow"

If FileSize(PreferencesFile) < 0 
  If Not CreatePreferences(PreferencesFile)
    ShowText("Невозможно создать файл настроек.")
  EndIf
ElseIf Not OpenPreferences(PreferencesFile)
  ShowText("Невозможно открыть файл настроек.")
EndIf
PreferenceGroup(#PrefGroupWindow)
SetGadgetText(SG_BearingStress, ReadPreferenceString(#PrefKeyBearingStress, "210"))
SetGadgetText(SG_ShearStress, ReadPreferenceString(#PrefKeyShearStress, "85"))
ClosePreferences()

Enumeration
  #PressedReturn
  #PressedEscape
EndEnumeration

AddKeyboardShortcut(MainWindow, #PB_Shortcut_Return, #PressedReturn)
AddKeyboardShortcut(MainWindow, #PB_Shortcut_Escape, #PressedEscape)

Define Quit = #False
Repeat
  Define Event = WaitWindowEvent()
  Select Event
    Case #PB_Event_CloseWindow
      Quit = #True
      
    Case #PB_Event_Menu
      Select EventMenu()
        Case #PressedReturn
          EventButtonRun(EventType())
        Case #PressedEscape
          Quit = #True
      EndSelect

    Case #PB_Event_Gadget
      Select EventGadget()
        Case B_Run
          EventButtonRun(EventType())
        Case B_Help
          MessageRequester("Справка", TextAbout, #PB_MessageRequester_Info)
        Case SG_BearingStress
          If EventType() = #PB_EventType_Change
            If OpenPreferences_CreateIfNeed(PreferencesFile)
              PreferenceGroup(#PrefGroupWindow)
              WritePreferenceString(#PrefKeyBearingStress, GetGadgetText(SG_BearingStress))
              ClosePreferences()
            EndIf
          EndIf
        Case SG_ShearStress
          If EventType() = #PB_EventType_Change
            If OpenPreferences_CreateIfNeed(PreferencesFile)
              PreferenceGroup(#PrefGroupWindow)
              WritePreferenceString(#PrefKeyShearStress, GetGadgetText(SG_ShearStress))
              ClosePreferences()
            EndIf
          EndIf
   
      EndSelect
  EndSelect
Until Quit

If OpenPreferences_CreateIfNeed(PreferencesFile)
  PreferenceGroup(#PrefGroupWindow)
  WritePreferenceString(#PrefKeyBearingStress, GetGadgetText(SG_BearingStress))
  WritePreferenceString(#PrefKeyShearStress, GetGadgetText(SG_ShearStress))
  ClosePreferences()
EndIf
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 3
; Folding = --
; EnableXP