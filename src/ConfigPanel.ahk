#NoEnv
#SingleInstance Force
#NoTrayIcon
SetWorkingDir %A_ScriptDir%

; --- CONFIGURATION ---
IniFile := "SkillTimers.ini"
LuaFile := "BuffLogic.lua"
SkinName := "SkillTimer"
TemplatePath := A_ScriptDir . "\Templates\"
ImagePath := A_ScriptDir . "\@Resources\Images\"
Global LoadedTemplateFile := ""

; --- Tooltip Setup ---
Global ToolTipMap := {}
Global MyGuiHwnd := 0
Global ControlBounds := {}
Global ControlIDs := {}
Global g_ToolTipTargetID := ""
Global LastHoveredID := ""
Global SettingsMap := {}

; --- Find Rainmeter Path Dynamically ---
try {
    RegRead, RainmeterExe, HKLM, SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Rainmeter, DisplayIcon
    StringReplace, RainmeterExe, RainmeterExe, ",, All
} catch {
    RainmeterExe := "C:\Program Files\Rainmeter\Rainmeter.exe"
}

; Create Templates directory if it doesn't exist
If !FileExist(TemplatePath)
    FileCreateDir, %TemplatePath%

; --- READ INITIAL VALUES FROM MAIN INI ---
GoSub, ReadSettingsFromIni

; --- POPULATE INITIAL TEMPLATE LIST ---
InitialTemplateList := ""
Loop, Files, % TemplatePath . "*.ini"
{
    InitialTemplateList .= A_LoopFileName . "|"
}
StringTrimRight, InitialTemplateList, InitialTemplateList, 1

; --- FINAL GUI CREATION ---
Gui, Font, s9, Segoe UI
Gui, +HwndMyGuiHwnd

; --- Global Settings Section ---
Gui, Add, GroupBox, x10 y10 w980 h70, Global Settings
Gui, Add, Text, x30 y35, Icon Size:
Gui, Add, Edit, x150 y30 w70 vVar_IconSize HWNDhVar_IconSize, %Var_IconSize%
Gui, Add, Text, x250 y35, Icon Spacing:
Gui, Add, Edit, x390 y30 w70 vVar_IconSpacing HWNDhVar_IconSpacing, %Var_IconSpacing%
Gui, Add, Text, x520 y35, Sign Hotkey:
Gui, Add, Edit, x670 y30 w70 vVar_hkW HWNDhVar_hkW, %Var_hkW%

; --- Layout Coordinates ---
c1_x := 10, c2_x := 255, c3_x := 500, c4_x := 745
col_w := 235, box_h := 98
r1_y := 90, r2_y := r1_y + box_h + 5, r3_y := r2_y + box_h + 5

; --- Vertical Offsets for Centering ---
offsetY_Titled := 32, offsetY_Sign_Content := 35
pic_r1_y      := r1_y + offsetY_Titled, text1_r1_y    := r1_y + offsetY_Titled, edit1_r1_y    := r1_y + offsetY_Titled - 5, text2_r1_y    := r1_y + offsetY_Titled + 30, edit2_r1_y    := r1_y + offsetY_Titled + 25, check_r1_y    := r1_y + 8, pic_Sign_r1_y := r1_y + offsetY_Sign_Content, text1_Sign_r1_y := r1_y + offsetY_Sign_Content, edit1_Sign_r1_y := r1_y + offsetY_Sign_Content - 5, text2_Sign_r1_y := r1_y + offsetY_Sign_Content + 25, edit2_Sign_r1_y := r1_y + offsetY_Sign_Content + 20
pic_r2_y      := r2_y + offsetY_Titled, text1_r2_y    := r2_y + offsetY_Titled, edit1_r2_y    := r2_y + offsetY_Titled - 5, text2_r2_y    := r2_y + offsetY_Titled + 30, edit2_r2_y    := r2_y + offsetY_Titled + 25, check_r2_y    := r2_y + 8, pic_Sign_r2_y := r2_y + offsetY_Sign_Content, text1_Sign_r2_y := r2_y + offsetY_Sign_Content, edit1_Sign_r2_y := r2_y + offsetY_Sign_Content - 5, text2_Sign_r2_y := r2_y + offsetY_Sign_Content + 25, edit2_Sign_r2_y := r2_y + offsetY_Sign_Content + 20, text_W4_r2_y  := r2_y + offsetY_Sign_Content, edit_W4_r2_y  := r2_y + offsetY_Sign_Content - 5, text2_W4_r2_y := r2_y + offsetY_Sign_Content + 25, edit2_W4_r2_y := r2_y + offsetY_Sign_Content + 20
pic_r3_y      := r3_y + offsetY_Titled, text1_r3_y    := r3_y + offsetY_Titled, edit1_r3_y    := r3_y + offsetY_Titled - 5, text2_r3_y    := r3_y + offsetY_Titled + 30, edit2_r3_y    := r3_y + offsetY_Titled + 25

; --- ADD CONTROLS TO GUI ---
Gui, Add, GroupBox, x%c1_x% y%r1_y% w%col_w% h%box_h%, Skill 1
Gui, Add, Picture, x20  y%pic_r1_y% w56 h56 0x40 vPicSkill1 gReplaceIcon1 HWNDhPicSkill1, % ImagePath . Var_IconFile1
Gui, Add, Text,     x90  y%text1_r1_y%, Timer:
Gui, Add, Edit,     x160 y%edit1_r1_y% w65 vVar_Timer1 HWNDhVar_Timer1, %Var_Timer1%
Gui, Add, Text,     x90  y%text2_r1_y%, Hotkey:
Gui, Add, Edit,     x160 y%edit2_r1_y% w65 vVar_hk1 HWNDhVar_hk1, %Var_hk1%
Gui, Add, GroupBox, x%c2_x% y%r1_y% w%col_w% h%box_h%, Skill 2
Gui, Add, Picture, x265 y%pic_r1_y% w56 h56 0x40 vPicSkill2 gReplaceIcon2 HWNDhPicSkill2, % ImagePath . Var_IconFile2
Gui, Add, Text,     x335 y%text1_r1_y%, Timer:
Gui, Add, Edit,     x405 y%edit1_r1_y% w65 vVar_Timer2 HWNDhVar_Timer2, %Var_Timer2%
Gui, Add, Text,     x335 y%text2_r1_y%, Hotkey:
Gui, Add, Edit,     x405 y%edit2_r1_y% w65 vVar_hk2 HWNDhVar_hk2, %Var_hk2%
Gui, Add, GroupBox, x%c3_x% y%r1_y% w%col_w% h%box_h%
Gui, Add, CheckBox, x510 y%check_r1_y% vVar_EnableW1 Checked%Var_EnableW1% HWNDhVar_EnableW1, Sign Buff 1
Gui, Add, Picture,  x510 y%pic_Sign_r1_y% w56 h56 0x40 vPicSkillW1 gReplaceIconW1 HWNDhPicSkillW1, % ImagePath . Var_IconFileW1
Gui, Add, Text,     x580 y%text1_Sign_r1_y%, Buff:
Gui, Add, Edit,     x645 y%edit1_Sign_r1_y% w65 vVar_bW1 HWNDhVar_bW1, %Var_bW1%
Gui, Add, Text,     x580 y%text2_Sign_r1_y%, Cooldown:
Gui, Add, Edit,     x645 y%edit2_Sign_r1_y% w65 vVar_cW1 HWNDhVar_cW1, %Var_cW1%
Gui, Add, GroupBox, x%c4_x% y%r1_y% w%col_w% h%box_h%
Gui, Add, CheckBox, x755 y%check_r1_y% vVar_EnableW2 Checked%Var_EnableW2% HWNDhVar_EnableW2, Sign Buff 2
Gui, Add, Picture,  x755 y%pic_Sign_r1_y% w56 h56 0x40 vPicSkillW2 gReplaceIconW2 HWNDhPicSkillW2, % ImagePath . Var_IconFileW2
Gui, Add, Text,     x825 y%text1_Sign_r1_y%, Buff:
Gui, Add, Edit,     x890 y%edit1_Sign_r1_y% w65 vVar_bW2 HWNDhVar_bW2, %Var_bW2%
Gui, Add, Text,     x825 y%text2_Sign_r1_y%, Cooldown:
Gui, Add, Edit,     x890 y%edit2_Sign_r1_y% w65 vVar_cW2 HWNDhVar_cW2, %Var_cW2%
Gui, Add, GroupBox, x%c1_x% y%r2_y% w%col_w% h%box_h%, Skill 3
Gui, Add, Picture, x20  y%pic_r2_y% w56 h56 0x40 vPicSkill3 gReplaceIcon3 HWNDhPicSkill3, % ImagePath . Var_IconFile3
Gui, Add, Text,     x90  y%text1_r2_y%, Timer:
Gui, Add, Edit,     x160 y%edit1_r2_y% w65 vVar_Timer3 HWNDhVar_Timer3, %Var_Timer3%
Gui, Add, Text,     x90  y%text2_r2_y%, Hotkey:
Gui, Add, Edit,     x160 y%edit2_r2_y% w65 vVar_hk3 HWNDhVar_hk3, %Var_hk3%
Gui, Add, GroupBox, x%c2_x% y%r2_y% w%col_w% h%box_h%, Skill 4
Gui, Add, Picture, x265 y%pic_r2_y% w56 h56 0x40 vPicSkill4 gReplaceIcon4 HWNDhPicSkill4, % ImagePath . Var_IconFile4
Gui, Add, Text,     x335 y%text1_r2_y%, Timer:
Gui, Add, Edit,     x405 y%edit1_r2_y% w65 vVar_Timer4 HWNDhVar_Timer4, %Var_Timer4%
Gui, Add, Text,     x335 y%text2_r2_y%, Hotkey:
Gui, Add, Edit,     x405 y%edit2_r2_y% w65 vVar_hk4 HWNDhVar_hk4, %Var_hk4%
Gui, Add, GroupBox, x%c3_x% y%r2_y% w%col_w% h%box_h%
Gui, Add, CheckBox, x510 y%check_r2_y% vVar_EnableW3 Checked%Var_EnableW3% HWNDhVar_EnableW3, Sign Buff 3
Gui, Add, Picture,  x510 y%pic_Sign_r2_y% w56 h56 0x40 vPicSkillW3 gReplaceIconW3 HWNDhPicSkillW3, % ImagePath . Var_IconFileW3
Gui, Add, Text,     x580 y%text1_Sign_r2_y%, Buff:
Gui, Add, Edit,     x645 y%edit1_Sign_r2_y% w65 vVar_bW3 HWNDhVar_bW3, %Var_bW3%
Gui, Add, Text,     x580 y%text2_Sign_r2_y%, Cooldown:
Gui, Add, Edit,     x645 y%edit2_Sign_r2_y% w65 vVar_cW3 HWNDhVar_cW3, %Var_cW3%

; --- Sign Buff 4 com campo de Delay ---
Gui, Add, GroupBox, x%c4_x% y%r2_y% w%col_w% h%box_h%
Gui, Add, CheckBox, x755 y%check_r2_y% vVar_EnableW4 Checked%Var_EnableW4% HWNDhVar_EnableW4, Sign Buff 4
Gui, Add, Picture,  x755 y%pic_Sign_r2_y% w56 h56 0x40 vPicSkillW4 gReplaceIconW4 HWNDhPicSkillW4, % ImagePath . Var_IconFileW4
Gui, Add, Text,     x825 y%text_W4_r2_y%, Timer:
Gui, Add, Edit,     x890 y%edit_W4_r2_y% w65 vVar_TimerW4 HWNDhVar_TimerW4, %Var_TimerW4%
Gui, Add, Text,     x825 y%text2_W4_r2_y%, Delay:
Gui, Add, Edit,     x890 y%edit2_W4_r2_y% w65 vVar_DelayW4 HWNDhVar_DelayW4, %Var_DelayW4%

Gui, Add, GroupBox, x%c1_x% y%r3_y% w%col_w% h%box_h%, Skill 5
Gui, Add, Picture, x20  y%pic_r3_y% w56 h56 0x40 vPicSkill5 gReplaceIcon5 HWNDhPicSkill5, % ImagePath . Var_IconFile5
Gui, Add, Text,     x90  y%text1_r3_y%, Timer:
Gui, Add, Edit,     x160 y%edit1_r3_y% w65 vVar_Timer5 HWNDhVar_Timer5, %Var_Timer5%
Gui, Add, Text,     x90  y%text2_r3_y%, Hotkey:
Gui, Add, Edit,     x160 y%edit2_r3_y% w65 vVar_hk5 HWNDhVar_hk5, %Var_hk5%
Gui, Add, GroupBox, x%c2_x% y%r3_y% w%col_w% h%box_h%, Right Mouse
Gui, Add, Picture, x265 y%pic_r3_y% w56 h56 0x40 vPicSkillRM gReplaceIconRM HWNDhPicSkillRM, % ImagePath . Var_IconFileRightMouse
Gui, Add, Text,     x335 y%text1_r3_y%, Timer:
Gui, Add, Edit,     x405 y%edit1_r3_y% w65 vVar_TimerRM HWNDhVar_TimerRM, %Var_TimerRM%
Gui, Add, Text,     x335 y%text2_r3_y%, Hotkey:
Gui, Add, Edit,     x405 y%edit2_r3_y% w65 vVar_hkRM HWNDhVar_hkRM, %Var_hkRM%
Gui, Add, Text, x550 y419, Load Template:
Gui, Add, DropDownList, x650 y414 w200 vSelectedTemplate gLoadTemplate HWNDhSelectedTemplate, %InitialTemplateList%
Gui, Add, Button, x870 y414 w100 h30 gButtonSave HWNDhButtonSave, Save

CoordMode, Mouse, Screen 
Gui, Show, w1000 h464, SkillTimer Settings

GoSub, PopulateToolTipMap
GoSub, PopulateControlIDs
GoSub, PopulateControlBounds
GoSub, FindMatchingTemplate

SetTimer, PollMousePosition, 100 
return

; ### LOGIC AND ACTIONS SECTION ###
LoadTemplate:
    Gui, Submit, NoHide
    LoadedTemplateFile := SelectedTemplate
    GoSub, ReadSettingsFromIni
    GoSub, UpdateGuiControls
return

ButtonSave:
    Gui, Submit, NoHide
    FileSelectFile, TargetTemplateFile, S16, % TemplatePath . LoadedTemplateFile, Save Template As..., INI Files (*.ini)
    if !TargetTemplateFile
        return
    if (SubStr(TargetTemplateFile, -3) != ".ini")
        TargetTemplateFile .= ".ini"
    WriteSettingsToIni(TargetTemplateFile)
    WriteSettingsToIni(IniFile)
    FileRead, CurrentLuaContent, %LuaFile%
    If (Var_EnableW1)
        StringReplace, CurrentLuaContent, CurrentLuaContent, --Activate('W1'), Activate('W1'), All
    Else
        StringReplace, CurrentLuaContent, CurrentLuaContent, Activate('W1'), --Activate('W1'), All
    If (Var_EnableW2)
        StringReplace, CurrentLuaContent, CurrentLuaContent, --Activate('W2'), Activate('W2'), All
    Else
        StringReplace, CurrentLuaContent, CurrentLuaContent, Activate('W2'), --Activate('W2'), All
    If (Var_EnableW3)
        StringReplace, CurrentLuaContent, CurrentLuaContent, --Activate('W3'), Activate('W3'), All
    Else
        StringReplace, CurrentLuaContent, CurrentLuaContent, Activate('W3'), --Activate('W3'), All
    If (Var_EnableW4)
        StringReplace, CurrentLuaContent, CurrentLuaContent, --ActivateDelayed('W4'`, 4), ActivateDelayed('W4'`, 4), All
    Else
        StringReplace, CurrentLuaContent, CurrentLuaContent, ActivateDelayed('W4'`, 4), --ActivateDelayed('W4'`, 4), All
    FileDelete, %LuaFile%
    FileAppend, %CurrentLuaContent%, %LuaFile%
    Run, "%RainmeterExe%" !Refresh "%SkinName%"
    SplitPath, TargetTemplateFile, , , , NewTemplateNameNoExt
    LoadedTemplateFile := NewTemplateNameNoExt . ".ini"
    GoSub, UpdateTemplateList
    GuiControl, Choose, SelectedTemplate, %LoadedTemplateFile%
    MsgBox, 64, Saved, Settings saved to the template and applied successfully!
return

GuiClose:
    ExitApp
return

; --- SUBROUTINES AND FUNCTIONS ---

FindMatchingTemplate:
    GoSub, BuildSettingsMap
    global SettingsMap, TemplatePath, LoadedTemplateFile
    MatchingTemplate := ""
    Loop, Files, % TemplatePath . "*.ini"
    {
        CurrentTemplateFile := A_LoopFileName
        CurrentTemplateFullPath := A_LoopFileFullPath
        isMatch := true
        For varName, details in SettingsMap
        {
            currentValue := %varName%
            IniRead, templateValue, %CurrentTemplateFullPath%, % details.Section, % details.Key
            if (currentValue != templateValue)
            {
                isMatch := false
                break
            }
        }
        if (isMatch)
        {
            MatchingTemplate := CurrentTemplateFile
            break
        }
    }
    if (MatchingTemplate)
    {
        GuiControl, Choose, SelectedTemplate, %MatchingTemplate%
        LoadedTemplateFile := MatchingTemplate
    }
return

BuildSettingsMap:
    global SettingsMap
    SettingsMap := { Var_IconSize: { Section: "Variables", Key: "IconSize" }
                   , Var_IconSpacing: { Section: "Variables", Key: "IconSpacing" }
                   , Var_hk1: { Section: "Hotkey1", Key: "HotKey" }
                   , Var_hk2: { Section: "Hotkey2", Key: "HotKey" }
                   , Var_hk3: { Section: "Hotkey3", Key: "HotKey" }
                   , Var_hk4: { Section: "Hotkey4", Key: "HotKey" }
                   , Var_hk5: { Section: "Hotkey5", Key: "HotKey" }
                   , Var_hkRM: { Section: "HotkeyRightMouse", Key: "HotKey" }
                   , Var_hkW: { Section: "HotkeyW", Key: "HotKey" }
                   , Var_Timer1: { Section: "Variables", Key: "TimerDuration1" }
                   , Var_Timer2: { Section: "Variables", Key: "TimerDuration2" }
                   , Var_Timer3: { Section: "Variables", Key: "TimerDuration3" }
                   , Var_Timer4: { Section: "Variables", Key: "TimerDuration4" }
                   , Var_Timer5: { Section: "Variables", Key: "TimerDuration5" }
                   , Var_TimerRM: { Section: "Variables", Key: "TimerDurationRightMouse" }
                   , Var_bW1: { Section: "Variables", Key: "BuffDurationW1" }
                   , Var_cW1: { Section: "Variables", Key: "CooldownDurationW1" }
                   , Var_bW2: { Section: "Variables", Key: "BuffDurationW2" }
                   , Var_cW2: { Section: "Variables", Key: "CooldownDurationW2" }
                   , Var_bW3: { Section: "Variables", Key: "BuffDurationW3" }
                   , Var_cW3: { Section: "Variables", Key: "CooldownDurationW3" }
                   , Var_TimerW4: { Section: "Variables", Key: "TimerDurationW4" }
                   , Var_DelayW4: { Section: "Variables", Key: "DelayDurationW4" } ; Adicionado para verificação
                   , Var_EnableW1: { Section: "Variables", Key: "EnableW1" }
                   , Var_EnableW2: { Section: "Variables", Key: "EnableW2" }
                   , Var_EnableW3: { Section: "Variables", Key: "EnableW3" }
                   , Var_EnableW4: { Section: "Variables", Key: "EnableW4" }
                   , Var_IconFile1: { Section: "Variables", Key: "IconFile1" }
                   , Var_IconFile2: { Section: "Variables", Key: "IconFile2" }
                   , Var_IconFile3: { Section: "Variables", Key: "IconFile3" }
                   , Var_IconFile4: { Section: "Variables", Key: "IconFile4" }
                   , Var_IconFile5: { Section: "Variables", Key: "IconFile5" }
                   , Var_IconFileRightMouse: { Section: "Variables", Key: "IconFileRightMouse" }
                   , Var_IconFileW1: { Section: "Variables", Key: "IconFileW1" }
                   , Var_IconFileW2: { Section: "Variables", Key: "IconFileW2" }
                   , Var_IconFileW3: { Section: "Variables", Key: "IconFileW3" }
                   , Var_IconFileW4: { Section: "Variables", Key: "IconFileW4" } }
return

PopulateToolTipMap:
    ToolTipMap["Var_IconSize"] := "Change the icon size in the buff bar."
    ToolTipMap["Var_IconSpacing"] := "Space between icons."
    ToolTipMap["Var_hkW"] := "Shortcut for your signature skill."
    ToolTipMap["PicSkill1"] := "Replace image."
    ToolTipMap["Var_Timer1"] := "How long the skill lasts."
    ToolTipMap["Var_hk1"] := "Shortcut for the skill. Remove to disable."
    ToolTipMap["PicSkill2"] := "Replace image."
    ToolTipMap["Var_Timer2"] := "How long the skill lasts."
    ToolTipMap["Var_hk2"] := "Shortcut for the skill. Remove to disable."
    ToolTipMap["PicSkill3"] := "Replace image."
    ToolTipMap["Var_Timer3"] := "How long the skill lasts."
    ToolTipMap["Var_hk3"] := "Shortcut for the skill. Remove to disable."
    ToolTipMap["PicSkill4"] := "Replace image."
    ToolTipMap["Var_Timer4"] := "How long the skill lasts."
    ToolTipMap["Var_hk4"] := "Shortcut for the skill. Remove to disable."
    ToolTipMap["PicSkill5"] := "Replace image."
    ToolTipMap["Var_Timer5"] := "How long the skill lasts."
    ToolTipMap["Var_hk5"] := "Shortcut for the skill. Remove to disable."
    ToolTipMap["PicSkillRM"] := "Replace image."
    ToolTipMap["Var_TimerRM"] := "How long the skill lasts."
    ToolTipMap["Var_hkRM"] := "Shortcut for the skill. Remove to disable."
    ToolTipMap["EnableW1"] := "Disable or enable the buff."
    ToolTipMap["PicSkillW1"] := "Replace image."
    ToolTipMap["Var_bW1"] := "Duration of the buff."
    ToolTipMap["Var_cW1"] := "Time until the buff can be activated again."
    ToolTipMap["EnableW2"] := "Disable or enable the buff."
    ToolTipMap["PicSkillW2"] := "Replace image."
    ToolTipMap["Var_bW2"] := "Duration of the buff."
    ToolTipMap["Var_cW2"] := "Time until the buff can be activated again."
    ToolTipMap["EnableW3"] := "Disable or enable the buff."
    ToolTipMap["PicSkillW3"] := "Replace image."
    ToolTipMap["Var_bW3"] := "Duration of the buff."
    ToolTipMap["Var_cW3"] := "Time until the buff can be activated again."
    ToolTipMap["EnableW4"] := "Disable or enable the buff."
    ToolTipMap["PicSkillW4"] := "Replace image."
    ToolTipMap["Var_TimerW4"] := "How long the skill lasts."
    ToolTipMap["Var_DelayW4"] := "The delay in seconds before the timer starts. Use 0 for no delay." ; Adicionado
    ToolTipMap["SelectedTemplate"] := "Load a saved configuration template."
    ToolTipMap["ButtonSave"] := "Save the current settings as a template."
return

PopulateControlIDs:
    global ControlIDs
    ControlIDs[hVar_IconSize] := "Var_IconSize", ControlIDs[hVar_IconSpacing] := "Var_IconSpacing", ControlIDs[hVar_hkW] := "Var_hkW"
    ControlIDs[hPicSkill1] := "PicSkill1", ControlIDs[hVar_Timer1] := "Var_Timer1", ControlIDs[hVar_hk1] := "Var_hk1"
    ControlIDs[hPicSkill2] := "PicSkill2", ControlIDs[hVar_Timer2] := "Var_Timer2", ControlIDs[hVar_hk2] := "Var_hk2"
    ControlIDs[hPicSkill3] := "PicSkill3", ControlIDs[hVar_Timer3] := "Var_Timer3", ControlIDs[hVar_hk3] := "Var_hk3"
    ControlIDs[hPicSkill4] := "PicSkill4", ControlIDs[hVar_Timer4] := "Var_Timer4", ControlIDs[hVar_hk4] := "Var_hk4"
    ControlIDs[hPicSkill5] := "PicSkill5", ControlIDs[hVar_Timer5] := "Var_Timer5", ControlIDs[hVar_hk5] := "Var_hk5"
    ControlIDs[hPicSkillRM] := "PicSkillRM", ControlIDs[hVar_TimerRM] := "Var_TimerRM", ControlIDs[hVar_hkRM] := "Var_hkRM"
    ControlIDs[hVar_EnableW1] := "EnableW1", ControlIDs[hPicSkillW1] := "PicSkillW1", ControlIDs[hVar_bW1] := "Var_bW1", ControlIDs[hVar_cW1] := "Var_cW1"
    ControlIDs[hVar_EnableW2] := "EnableW2", ControlIDs[hPicSkillW2] := "PicSkillW2", ControlIDs[hVar_bW2] := "Var_bW2", ControlIDs[hVar_cW2] := "Var_cW2"
    ControlIDs[hVar_EnableW3] := "EnableW3", ControlIDs[hPicSkillW3] := "PicSkillW3", ControlIDs[hVar_bW3] := "Var_bW3", ControlIDs[hVar_cW3] := "Var_cW3"
    ControlIDs[hVar_EnableW4] := "EnableW4", ControlIDs[hPicSkillW4] := "PicSkillW4", ControlIDs[hVar_TimerW4] := "Var_TimerW4", ControlIDs[hVar_DelayW4] := "Var_DelayW4" ; Adicionado
    ControlIDs[hSelectedTemplate] := "SelectedTemplate", ControlIDs[hButtonSave] := "ButtonSave"
return

PopulateControlBounds:
    global ControlBounds, ControlIDs
    For hwnd, id in ControlIDs
    {
        GuiControlGet, Pos, Pos, %hwnd%
        ControlBounds[id] := {X: PosX, Y: PosY, W: PosW, H: PosH}
    }
return

; ##################################################################
; ### LÓGICA DE TOOLTIP FINAL (MÉTODO POLLING POR BOUNDING BOX) ###
; ##################################################################

PollMousePosition:
{
    global g_ToolTipTargetID, ControlBounds, MyGuiHwnd, LastHoveredID
    MouseGetPos, MouseX, MouseY
    VarSetCapacity(Point, 8, 0), NumPut(MouseX, Point, 0, "Int"), NumPut(MouseY, Point, 4, "Int")
    DllCall("ScreenToClient", "Ptr", MyGuiHwnd, "Ptr", &Point)
    ClientX := NumGet(Point, 0, "Int"), ClientY := NumGet(Point, 4, "Int")
    CurrentHoveredID := ""
    For id, bounds in ControlBounds
    {
        if (ClientX >= bounds.X && ClientX <= bounds.X + bounds.W && ClientY >= bounds.Y && ClientY <= bounds.Y + bounds.H)
        {
            CurrentHoveredID := id
            break
        }
    }
    if (CurrentHoveredID = LastHoveredID)
        return
    LastHoveredID := CurrentHoveredID
    ToolTip 
    SetTimer, DisplayToolTipDelayed, Off
    g_ToolTipTargetID := ""
    if (CurrentHoveredID)
    {
        g_ToolTipTargetID := CurrentHoveredID
        SetTimer, DisplayToolTipDelayed, -500 
    }
    return
}

DisplayToolTipDelayed:
{
    global g_ToolTipTargetID, ToolTipMap, ControlBounds, MyGuiHwnd
    if (!g_ToolTipTargetID)
        return
    MouseGetPos, MouseX, MouseY
    VarSetCapacity(Point, 8, 0), NumPut(MouseX, Point, 0, "Int"), NumPut(MouseY, Point, 4, "Int")
    DllCall("ScreenToClient", "Ptr", MyGuiHwnd, "Ptr", &Point)
    ClientX := NumGet(Point, 0, "Int"), ClientY := NumGet(Point, 4, "Int")
    bounds := ControlBounds[g_ToolTipTargetID]
    if (ClientX >= bounds.X && ClientX <= bounds.X + bounds.W && ClientY >= bounds.Y && ClientY <= bounds.Y + bounds.H)
    {
        ToolTip, % ToolTipMap[g_ToolTipTargetID]
    }
    g_ToolTipTargetID := ""
    return
}

UpdateTemplateList:
    NewTemplateList := ""
    Loop, Files, % TemplatePath . "*.ini"
    {
        NewTemplateList .= A_LoopFileName . "|"
    }
    StringTrimRight, NewTemplateList, NewTemplateList, 1
    GuiControl,, SelectedTemplate, |%NewTemplateList%
return

ReadSettingsFromIni:
    SourceIni := LoadedTemplateFile ? TemplatePath . LoadedTemplateFile : IniFile
    IniRead, Var_IconSize, %SourceIni%, Variables, IconSize, 56
    IniRead, Var_IconSpacing, %SourceIni%, Variables, IconSpacing, 4
    IniRead, Var_hk1, %SourceIni%, Hotkey1, HotKey, 1
    IniRead, Var_hk2, %SourceIni%, Hotkey2, HotKey, 2
    IniRead, Var_hk3, %SourceIni%, Hotkey3, HotKey, 3
    IniRead, Var_hk4, %SourceIni%, Hotkey4, HotKey, 4
    IniRead, Var_hk5, %SourceIni%, Hotkey5, HotKey, 5
    IniRead, Var_hkRM, %SourceIni%, HotkeyRightMouse, HotKey, 7
    IniRead, Var_hkW, %SourceIni%, HotkeyW, HotKey, W
    IniRead, Var_Timer1, %SourceIni%, Variables, TimerDuration1, 138
    IniRead, Var_Timer2, %SourceIni%, Variables, TimerDuration2, 72
    IniRead, Var_Timer3, %SourceIni%, Variables, TimerDuration3, 72
    IniRead, Var_Timer4, %SourceIni%, Variables, TimerDuration4, 30
    IniRead, Var_Timer5, %SourceIni%, Variables, TimerDuration5, 18
    IniRead, Var_TimerRM, %SourceIni%, Variables, TimerDurationRightMouse, 34
    IniRead, Var_bW1, %SourceIni%, Variables, BuffDurationW1, 22
    IniRead, Var_cW1, %SourceIni%, Variables, CooldownDurationW1, 30
    IniRead, Var_bW2, %SourceIni%, Variables, BuffDurationW2, 10
    IniRead, Var_cW2, %SourceIni%, Variables, CooldownDurationW2, 60
    IniRead, Var_bW3, %SourceIni%, Variables, BuffDurationW3, 26
    IniRead, Var_cW3, %SourceIni%, Variables, CooldownDurationW3, 60
    IniRead, Var_TimerW4, %SourceIni%, Variables, TimerDurationW4, 13
    IniRead, Var_DelayW4, %SourceIni%, Variables, DelayDurationW4, 4 ; Adicionado
    If (LoadedTemplateFile) {
        IniRead, Var_EnableW1, %SourceIni%, Variables, EnableW1, 1
        IniRead, Var_EnableW2, %SourceIni%, Variables, EnableW2, 1
        IniRead, Var_EnableW3, %SourceIni%, Variables, EnableW3, 1
        IniRead, Var_EnableW4, %SourceIni%, Variables, EnableW4, 1
    } Else {
        FileRead, LuaContent, %LuaFile%
        Var_EnableW1 := InStr(LuaContent, "--Activate('W1')") ? 0 : 1
        Var_EnableW2 := InStr(LuaContent, "--Activate('W2')") ? 0 : 1
        Var_EnableW3 := InStr(LuaContent, "--Activate('W3')") ? 0 : 1
        Var_EnableW4 := InStr(LuaContent, "--ActivateDelayed('W4', 4)") ? 0 : 1
    }
    IniRead, Var_IconFile1, %SourceIni%, Variables, IconFile1, Skill10.png
    IniRead, Var_IconFile2, %SourceIni%, Variables, IconFile2, Skill1.png
    IniRead, Var_IconFile3, %SourceIni%, Variables, IconFile3, Skill2.png
    IniRead, Var_IconFile4, %SourceIni%, Variables, IconFile4, Skill3.png
    IniRead, Var_IconFile5, %SourceIni%, Variables, IconFile5, Skill4.png
    IniRead, Var_IconFileRightMouse, %SourceIni%, Variables, IconFileRightMouse, Skill6.png
    IniRead, Var_IconFileW1, %SourceIni%, Variables, IconFileW1, Skill5.png
    IniRead, Var_IconFileW2, %SourceIni%, Variables, IconFileW2, Skill7.png
    IniRead, Var_IconFileW3, %SourceIni%, Variables, IconFileW3, Skill8.png
    IniRead, Var_IconFileW4, %SourceIni%, Variables, IconFileW4, Skill9.png
return

UpdateGuiControls:
    GuiControl,, Var_IconSize, %Var_IconSize%
    GuiControl,, Var_IconSpacing, %Var_IconSpacing%
    GuiControl,, Var_hk1, %Var_hk1%
    GuiControl,, Var_hk2, %Var_hk2%
    GuiControl,, Var_hk3, %Var_hk3%
    GuiControl,, Var_hk4, %Var_hk4%
    GuiControl,, Var_hk5, %Var_hk5%
    GuiControl,, Var_hkRM, %Var_hkRM%
    GuiControl,, Var_hkW, %Var_hkW%
    GuiControl,, Var_Timer1, %Var_Timer1%
    GuiControl,, Var_Timer2, %Var_Timer2%
    GuiControl,, Var_Timer3, %Var_Timer3%
    GuiControl,, Var_Timer4, %Var_Timer4%
    GuiControl,, Var_Timer5, %Var_Timer5%
    GuiControl,, Var_TimerRM, %Var_TimerRM%
    GuiControl,, Var_bW1, %Var_bW1%
    GuiControl,, Var_cW1, %Var_cW1%
    GuiControl,, Var_bW2, %Var_bW2%
    GuiControl,, Var_cW2, %Var_cW2%
    GuiControl,, Var_bW3, %Var_bW3%
    GuiControl,, Var_cW3, %Var_cW3%
    GuiControl,, Var_TimerW4, %Var_TimerW4%
    GuiControl,, Var_DelayW4, %Var_DelayW4% ; Adicionado
    GuiControl,, Var_EnableW1, %Var_EnableW1%
    GuiControl,, Var_EnableW2, %Var_EnableW2%
    GuiControl,, Var_EnableW3, %Var_EnableW3%
    GuiControl,, Var_EnableW4, %Var_EnableW4%
    GuiControl,, PicSkill1, % ImagePath . Var_IconFile1
    GuiControl,, PicSkill2, % ImagePath . Var_IconFile2
    GuiControl,, PicSkill3, % ImagePath . Var_IconFile3
    GuiControl,, PicSkill4, % ImagePath . Var_IconFile4
    GuiControl,, PicSkill5, % ImagePath . Var_IconFile5
    GuiControl,, PicSkillRM, % ImagePath . Var_IconFileRightMouse
    GuiControl,, PicSkillW1, % ImagePath . Var_IconFileW1
    GuiControl,, PicSkillW2, % ImagePath . Var_IconFileW2
    GuiControl,, PicSkillW3, % ImagePath . Var_IconFileW3
    GuiControl,, PicSkillW4, % ImagePath . Var_IconFileW4
return

WriteSettingsToIni(TargetIni)
{
    global
    IniWrite, %Var_IconSize%, %TargetIni%, Variables, IconSize
    IniWrite, %Var_IconSpacing%, %TargetIni%, Variables, IconSpacing
    IniWrite, %Var_hk1%, %TargetIni%, Hotkey1, HotKey
    IniWrite, %Var_hk2%, %TargetIni%, Hotkey2, HotKey
    IniWrite, %Var_hk3%, %TargetIni%, Hotkey3, HotKey
    IniWrite, %Var_hk4%, %TargetIni%, Hotkey4, HotKey
    IniWrite, %Var_hk5%, %TargetIni%, Hotkey5, HotKey
    IniWrite, %Var_hkRM%, %TargetIni%, HotkeyRightMouse, HotKey
    IniWrite, %Var_hkW%, %TargetIni%, HotkeyW, HotKey
    IniWrite, %Var_Timer1%, %TargetIni%, Variables, TimerDuration1
    IniWrite, %Var_Timer2%, %TargetIni%, Variables, TimerDuration2
    IniWrite, %Var_Timer3%, %TargetIni%, Variables, TimerDuration3
    IniWrite, %Var_Timer4%, %TargetIni%, Variables, TimerDuration4
    IniWrite, %Var_Timer5%, %TargetIni%, Variables, TimerDuration5
    IniWrite, %Var_TimerRM%, %TargetIni%, Variables, TimerDurationRightMouse
    IniWrite, %Var_bW1%, %TargetIni%, Variables, BuffDurationW1
    IniWrite, %Var_cW1%, %TargetIni%, Variables, CooldownDurationW1
    IniWrite, %Var_bW2%, %TargetIni%, Variables, BuffDurationW2
    IniWrite, %Var_cW2%, %TargetIni%, Variables, CooldownDurationW2
    IniWrite, %Var_bW3%, %TargetIni%, Variables, BuffDurationW3
    IniWrite, %Var_cW3%, %TargetIni%, Variables, CooldownDurationW3
    IniWrite, %Var_TimerW4%, %TargetIni%, Variables, TimerDurationW4
    IniWrite, %Var_DelayW4%, %TargetIni%, Variables, DelayDurationW4 ; Adicionado
    IniWrite, %Var_EnableW1%, %TargetIni%, Variables, EnableW1
    IniWrite, %Var_EnableW2%, %TargetIni%, Variables, EnableW2
    IniWrite, %Var_EnableW3%, %TargetIni%, Variables, EnableW3
    IniWrite, %Var_EnableW4%, %TargetIni%, Variables, EnableW4
    IniWrite, %Var_IconFile1%, %TargetIni%, Variables, IconFile1
    IniWrite, %Var_IconFile2%, %TargetIni%, Variables, IconFile2
    IniWrite, %Var_IconFile3%, %TargetIni%, Variables, IconFile3
    IniWrite, %Var_IconFile4%, %TargetIni%, Variables, IconFile4
    IniWrite, %Var_IconFile5%, %TargetIni%, Variables, IconFile5
    IniWrite, %Var_IconFileRightMouse%, %TargetIni%, Variables, IconFileRightMouse
    IniWrite, %Var_IconFileW1%, %TargetIni%, Variables, IconFileW1
    IniWrite, %Var_IconFileW2%, %TargetIni%, Variables, IconFileW2
    IniWrite, %Var_IconFileW3%, %TargetIni%, Variables, IconFileW3
    IniWrite, %Var_IconFileW4%, %TargetIni%, Variables, IconFileW4
}

ReplaceIcon(ByRef VarToUpdate, PicVarName)
{
    Global ImagePath
    FileSelectFile, UserSelectedFile, 3, %ImagePath%, Select new icon file (.png), Images (*.png)
    if (UserSelectedFile)
    {
        SplitPath, UserSelectedFile, NewFileName
        DestinationFile := ImagePath . NewFileName
        if !FileExist(DestinationFile)
        {
            FileCopy, %UserSelectedFile%, %DestinationFile%, 1
            if ErrorLevel
            {
                MsgBox, 16, Error, Failed to copy image. Check folder permissions or if the destination is write-protected.
                return
            }
        }
        VarToUpdate := NewFileName
        GuiControl,, %PicVarName%, % DestinationFile "?" . A_TickCount
        MsgBox, 64, Success, Icon updated. Save your template to make the change permanent.
    }
}

ReplaceIcon1:
    ReplaceIcon(Var_IconFile1, "PicSkill1")
return
ReplaceIcon2:
    ReplaceIcon(Var_IconFile2, "PicSkill2")
return
ReplaceIcon3:
    ReplaceIcon(Var_IconFile3, "PicSkill3")
return
ReplaceIcon4:
    ReplaceIcon(Var_IconFile4, "PicSkill4")
return
ReplaceIcon5:
    ReplaceIcon(Var_IconFile5, "PicSkill5")
return
ReplaceIconW1:
    ReplaceIcon(Var_IconFileW1, "PicSkillW1")
return
ReplaceIconW2:
    ReplaceIcon(Var_IconFileW2, "PicSkillW2")
return
ReplaceIconW3:
    ReplaceIcon(Var_IconFileW3, "PicSkillW3")
return
ReplaceIconW4:
    ReplaceIcon(Var_IconFileW4, "PicSkillW4")
return
ReplaceIconRM:
    ReplaceIcon(Var_IconFileRightMouse, "PicSkillRM")
return