#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

; --- CONFIGURATION ---
IniFile := "SkillTimers.ini"
LuaFile := "BuffLogic.lua"
SkinName := "SkillTimer"
RainmeterExe := "C:\Program Files\Rainmeter\Rainmeter.exe"
ImagePath := A_ScriptDir . "\@Resources\Images\"

; --- READ INITIAL VALUES ---
IniRead, Var_IconSize, %IniFile%, Variables, IconSize
IniRead, Var_IconSpacing, %IniFile%, Variables, IconSpacing
IniRead, Var_hk1, %IniFile%, Hotkey1, HotKey
IniRead, Var_hk2, %IniFile%, Hotkey2, HotKey
IniRead, Var_hk3, %IniFile%, Hotkey3, HotKey
IniRead, Var_hk4, %IniFile%, Hotkey4, HotKey
IniRead, Var_hk5, %IniFile%, Hotkey5, HotKey
IniRead, Var_hkRM, %IniFile%, HotkeyRightMouse, HotKey
IniRead, Var_hkW, %IniFile%, HotkeyW, HotKey
IniRead, Var_Timer1, %IniFile%, Variables, TimerDuration1
IniRead, Var_Timer2, %IniFile%, Variables, TimerDuration2
IniRead, Var_Timer3, %IniFile%, Variables, TimerDuration3
IniRead, Var_Timer4, %IniFile%, Variables, TimerDuration4
IniRead, Var_Timer5, %IniFile%, Variables, TimerDuration5
IniRead, Var_TimerRM, %IniFile%, Variables, TimerDurationRightMouse
IniRead, Var_bW1, %IniFile%, Variables, BuffDurationW1
IniRead, Var_cW1, %IniFile%, Variables, CooldownDurationW1
IniRead, Var_bW2, %IniFile%, Variables, BuffDurationW2
IniRead, Var_cW2, %IniFile%, Variables, CooldownDurationW2
IniRead, Var_bW3, %IniFile%, Variables, BuffDurationW3
IniRead, Var_cW3, %IniFile%, Variables, CooldownDurationW3
IniRead, Var_TimerW4, %IniFile%, Variables, TimerDurationW4
FileRead, LuaContent, %LuaFile%
Var_EnableW1 := InStr(LuaContent, "--Activate('W1')") ? 0 : 1
Var_EnableW2 := InStr(LuaContent, "--Activate('W2')") ? 0 : 1
Var_EnableW3 := InStr(LuaContent, "--Activate('W3')") ? 0 : 1
Var_EnableW4 := InStr(LuaContent, "--ActivateDelayed('W4', 4)") ? 0 : 1

; --- FINAL GUI CREATION ---
Gui, Font, s9, Segoe UI

; --- Global Settings Section ---
Gui, Add, GroupBox, x10 y10 w980 h70, Global Settings
Gui, Add, Text, x30 y35, Icon Size:
Gui, Add, Edit, x150 y30 w70 vVar_IconSize, %Var_IconSize%
Gui, Add, Text, x250 y35, Icon Spacing:
Gui, Add, Edit, x390 y30 w70 vVar_IconSpacing, %Var_IconSpacing%
Gui, Add, Text, x520 y35, Sign Hotkey:
Gui, Add, Edit, x670 y30 w70 vVar_hkW, %Var_hkW%

; --- Layout Coordinates ---
c1_x := 10
c2_x := 255
c3_x := 500
c4_x := 745
col_w := 235
box_h := 98
r1_y := 90
r2_y := r1_y + box_h + 5
r3_y := r2_y + box_h + 5

; --- Vertical Offsets for Centering ---
offsetY_Titled := 32
offsetY_Sign_Content := 35

; --- CALCULATE Y-COORDINATES ---

; -- Row 1 --
pic_r1_y      := r1_y + offsetY_Titled
text1_r1_y    := r1_y + offsetY_Titled
edit1_r1_y    := r1_y + offsetY_Titled - 5
text2_r1_y    := r1_y + offsetY_Titled + 30
edit2_r1_y    := r1_y + offsetY_Titled + 25
check_r1_y    := r1_y + 8
pic_Sign_r1_y := r1_y + offsetY_Sign_Content
text1_Sign_r1_y := r1_y + offsetY_Sign_Content
edit1_Sign_r1_y := r1_y + offsetY_Sign_Content - 5
text2_Sign_r1_y := r1_y + offsetY_Sign_Content + 25
edit2_Sign_r1_y := r1_y + offsetY_Sign_Content + 20

; -- Row 2 --
pic_r2_y      := r2_y + offsetY_Titled
text1_r2_y    := r2_y + offsetY_Titled
edit1_r2_y    := r2_y + offsetY_Titled - 5
text2_r2_y    := r2_y + offsetY_Titled + 30
edit2_r2_y    := r2_y + offsetY_Titled + 25
check_r2_y    := r2_y + 8
pic_Sign_r2_y := r2_y + offsetY_Sign_Content
text1_Sign_r2_y := r2_y + offsetY_Sign_Content
edit1_Sign_r2_y := r2_y + offsetY_Sign_Content - 5
text2_Sign_r2_y := r2_y + offsetY_Sign_Content + 25
edit2_Sign_r2_y := r2_y + offsetY_Sign_Content + 20
text_W4_r2_y  := r2_y + offsetY_Sign_Content + 17
edit_W4_r2_y  := r2_y + offsetY_Sign_Content + 12

; -- Row 3 --
pic_r3_y      := r3_y + offsetY_Titled
text1_r3_y    := r3_y + offsetY_Titled
edit1_r3_y    := r3_y + offsetY_Titled - 5
text2_r3_y    := r3_y + offsetY_Titled + 30
edit2_r3_y    := r3_y + offsetY_Titled + 25


; --- ADD CONTROLS TO GUI ---

; --- Row 1 ---
Gui, Add, GroupBox, x%c1_x% y%r1_y% w%col_w% h%box_h%, Skill 1
Gui, Add, Picture, x20  y%pic_r1_y% w56 h56 vPicSkill1 gReplaceIcon1, % ImagePath . "Skill10.png"
Gui, Add, Text,    x90  y%text1_r1_y%, Timer:
Gui, Add, Edit,    x160 y%edit1_r1_y% w65 vVar_Timer1, %Var_Timer1%
Gui, Add, Text,    x90  y%text2_r1_y%, Hotkey:
Gui, Add, Edit,    x160 y%edit2_r1_y% w65 vVar_hk1, %Var_hk1%

Gui, Add, GroupBox, x%c2_x% y%r1_y% w%col_w% h%box_h%, Skill 2
Gui, Add, Picture, x265 y%pic_r1_y% w56 h56 vPicSkill2 gReplaceIcon2, % ImagePath . "Skill1.png"
Gui, Add, Text,    x335 y%text1_r1_y%, Timer:
Gui, Add, Edit,    x405 y%edit1_r1_y% w65 vVar_Timer2, %Var_Timer2%
Gui, Add, Text,    x335 y%text2_r1_y%, Hotkey:
Gui, Add, Edit,    x405 y%edit2_r1_y% w65 vVar_hk2, %Var_hk2%

Gui, Add, GroupBox, x%c3_x% y%r1_y% w%col_w% h%box_h%
Gui, Add, CheckBox, x510 y%check_r1_y% vVar_EnableW1 Checked%Var_EnableW1%, Sign Buff 1
Gui, Add, Picture,  x510 y%pic_Sign_r1_y% w56 h56 vPicSkillW1 gReplaceIconW1, % ImagePath . "Skill5.png"
Gui, Add, Text,     x580 y%text1_Sign_r1_y%, Buff:
Gui, Add, Edit,     x645 y%edit1_Sign_r1_y% w65 vVar_bW1, %Var_bW1%
Gui, Add, Text,     x580 y%text2_Sign_r1_y%, Cooldown:
Gui, Add, Edit,     x645 y%edit2_Sign_r1_y% w65 vVar_cW1, %Var_cW1%

Gui, Add, GroupBox, x%c4_x% y%r1_y% w%col_w% h%box_h%
Gui, Add, CheckBox, x755 y%check_r1_y% vVar_EnableW2 Checked%Var_EnableW2%, Sign Buff 2
Gui, Add, Picture,  x755 y%pic_Sign_r1_y% w56 h56 vPicSkillW2 gReplaceIconW2, % ImagePath . "Skill7.png"
Gui, Add, Text,     x825 y%text1_Sign_r1_y%, Buff:
Gui, Add, Edit,     x890 y%edit1_Sign_r1_y% w65 vVar_bW2, %Var_bW2%
Gui, Add, Text,     x825 y%text2_Sign_r1_y%, Cooldown:
Gui, Add, Edit,     x890 y%edit2_Sign_r1_y% w65 vVar_cW2, %Var_cW2%

; --- Row 2 ---
Gui, Add, GroupBox, x%c1_x% y%r2_y% w%col_w% h%box_h%, Skill 3
Gui, Add, Picture, x20  y%pic_r2_y% w56 h56 vPicSkill3 gReplaceIcon3, % ImagePath . "Skill2.png"
Gui, Add, Text,    x90  y%text1_r2_y%, Timer:
Gui, Add, Edit,    x160 y%edit1_r2_y% w65 vVar_Timer3, %Var_Timer3%
Gui, Add, Text,    x90  y%text2_r2_y%, Hotkey:
Gui, Add, Edit,    x160 y%edit2_r2_y% w65 vVar_hk3, %Var_hk3%

Gui, Add, GroupBox, x%c2_x% y%r2_y% w%col_w% h%box_h%, Skill 4
Gui, Add, Picture, x265 y%pic_r2_y% w56 h56 vPicSkill4 gReplaceIcon4, % ImagePath . "Skill3.png"
Gui, Add, Text,    x335 y%text1_r2_y%, Timer:
Gui, Add, Edit,    x405 y%edit1_r2_y% w65 vVar_Timer4, %Var_Timer4%
Gui, Add, Text,    x335 y%text2_r2_y%, Hotkey:
Gui, Add, Edit,    x405 y%edit2_r2_y% w65 vVar_hk4, %Var_hk4%

Gui, Add, GroupBox, x%c3_x% y%r2_y% w%col_w% h%box_h%
Gui, Add, CheckBox, x510 y%check_r2_y% vVar_EnableW3 Checked%Var_EnableW3%, Sign Buff 3
Gui, Add, Picture,  x510 y%pic_Sign_r2_y% w56 h56 vPicSkillW3 gReplaceIconW3, % ImagePath . "Skill8.png"
Gui, Add, Text,     x580 y%text1_Sign_r2_y%, Buff:
Gui, Add, Edit,     x645 y%edit1_Sign_r2_y% w65 vVar_bW3, %Var_bW3%
Gui, Add, Text,     x580 y%text2_Sign_r2_y%, Cooldown:
Gui, Add, Edit,     x645 y%edit2_Sign_r2_y% w65 vVar_cW3, %Var_cW3%

Gui, Add, GroupBox, x%c4_x% y%r2_y% w%col_w% h%box_h%
Gui, Add, CheckBox, x755 y%check_r2_y% vVar_EnableW4 Checked%Var_EnableW4%, Sign Buff 4
Gui, Add, Picture,  x755 y%pic_Sign_r2_y% w56 h56 vPicSkillW4 gReplaceIconW4, % ImagePath . "Skill9.png"
Gui, Add, Text,     x825 y%text_W4_r2_y%, Timer:
Gui, Add, Edit,     x890 y%edit_W4_r2_y% w65 vVar_TimerW4, %Var_TimerW4%

; --- Row 3 ---
Gui, Add, GroupBox, x%c1_x% y%r3_y% w%col_w% h%box_h%, Skill 5
Gui, Add, Picture, x20  y%pic_r3_y% w56 h56 vPicSkill5 gReplaceIcon5, % ImagePath . "Skill4.png"
Gui, Add, Text,    x90  y%text1_r3_y%, Timer:
Gui, Add, Edit,    x160 y%edit1_r3_y% w65 vVar_Timer5, %Var_Timer5%
Gui, Add, Text,    x90  y%text2_r3_y%, Hotkey:
Gui, Add, Edit,    x160 y%edit2_r3_y% w65 vVar_hk5, %Var_hk5%

Gui, Add, GroupBox, x%c2_x% y%r3_y% w%col_w% h%box_h%, Right Mouse
Gui, Add, Picture, x265 y%pic_r3_y% w56 h56 vPicSkillRM gReplaceIconRM, % ImagePath . "Skill6.png"
Gui, Add, Text,    x335 y%text1_r3_y%, Timer:
Gui, Add, Edit,    x405 y%edit1_r3_y% w65 vVar_TimerRM, %Var_TimerRM%
Gui, Add, Text,    x335 y%text2_r3_y%, Hotkey:
Gui, Add, Edit,    x405 y%edit2_r3_y% w65 vVar_hkRM, %Var_hkRM%

; --- Save Button & Final Show ---
Gui, Add, Button, x870 y414 w100 h30 gButtonSave, Save & Close
Gui, Show, w1000 h464, SkillTimer Settings
return

; ### LOGIC AND ACTIONS SECTION ###
ButtonSave:
    Gui, Submit, NoHide

    ; --- Save values to .ini file ---
    IniWrite, %Var_IconSize%, %IniFile%, Variables, IconSize
    IniWrite, %Var_IconSpacing%, %IniFile%, Variables, IconSpacing
    IniWrite, %Var_hk1%, %IniFile%, Hotkey1, HotKey
    IniWrite, %Var_hk2%, %IniFile%, Hotkey2, HotKey
    IniWrite, %Var_hk3%, %IniFile%, Hotkey3, HotKey
    IniWrite, %Var_hk4%, %IniFile%, Hotkey4, HotKey
    IniWrite, %Var_hk5%, %IniFile%, Hotkey5, HotKey
    IniWrite, %Var_hkRM%, %IniFile%, HotkeyRightMouse, HotKey
    IniWrite, %Var_hkW%, %IniFile%, HotkeyW, HotKey
    IniWrite, %Var_Timer1%, %IniFile%, Variables, TimerDuration1
    IniWrite, %Var_Timer2%, %IniFile%, Variables, TimerDuration2
    IniWrite, %Var_Timer3%, %IniFile%, Variables, TimerDuration3
    IniWrite, %Var_Timer4%, %IniFile%, Variables, TimerDuration4
    IniWrite, %Var_Timer5%, %IniFile%, Variables, TimerDuration5
    IniWrite, %Var_TimerRM%, %IniFile%, Variables, TimerDurationRightMouse
    IniWrite, %Var_bW1%, %IniFile%, Variables, BuffDurationW1
    IniWrite, %Var_cW1%, %IniFile%, Variables, CooldownDurationW1
    IniWrite, %Var_bW2%, %IniFile%, Variables, BuffDurationW2
    IniWrite, %Var_cW2%, %IniFile%, Variables, CooldownDurationW2
    IniWrite, %Var_bW3%, %IniFile%, Variables, BuffDurationW3
    IniWrite, %Var_cW3%, %IniFile%, Variables, CooldownDurationW3
    IniWrite, %Var_TimerW4%, %IniFile%, Variables, TimerDurationW4

    ; --- Update .lua file based on checkboxes ---
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

    ; FIX: A vírgula dentro do texto de busca/substituição agora está escapada com `
    If (Var_EnableW4)
        StringReplace, CurrentLuaContent, CurrentLuaContent, --ActivateDelayed('W4'`, 4), ActivateDelayed('W4'`, 4), All
    Else
        StringReplace, CurrentLuaContent, CurrentLuaContent, ActivateDelayed('W4'`, 4), --ActivateDelayed('W4'`, 4), All

    FileDelete, %LuaFile%
    FileAppend, %CurrentLuaContent%, %LuaFile%

    ; --- Refresh Rainmeter Skin ---
    MsgBox, 4160, Saved, Settings saved successfully! The Rainmeter skin will now be refreshed.
    Run, %RainmeterExe% !Refresh "%SkinName%"

    ExitApp
return

GuiClose:
    ExitApp
return

; --- Functions to handle icon replacement ---
ReplaceIcon1:
    ReplaceIcon("Skill10.png", "PicSkill1")
return
ReplaceIcon2:
    ReplaceIcon("Skill1.png", "PicSkill2")
return
ReplaceIcon3:
    ReplaceIcon("Skill2.png", "PicSkill3")
return
ReplaceIcon4:
    ReplaceIcon("Skill3.png", "PicSkill4")
return
ReplaceIcon5:
    ReplaceIcon("Skill4.png", "PicSkill5")
return
ReplaceIconW1:
    ReplaceIcon("Skill5.png", "PicSkillW1")
return
ReplaceIconW2:
    ReplaceIcon("Skill7.png", "PicSkillW2")
return
ReplaceIconW3:
    ReplaceIcon("Skill8.png", "PicSkillW3")
return
ReplaceIconW4:
    ReplaceIcon("Skill9.png", "PicSkillW4")
return
ReplaceIconRM:
    ReplaceIcon("Skill6.png", "PicSkillRM")
return

; --- Generic function to replace an icon file ---
ReplaceIcon(FileName, PicVarName)
{
    Global ImagePath
    FileSelectFile, UserSelectedFile, 3,, Select the new icon file (.png), Images (*.png)
    if (UserSelectedFile)
    {
        DestinationFile := ImagePath . FileName
        FileCopy, %UserSelectedFile%, %DestinationFile%, 1
        if ErrorLevel
            MsgBox, 16, Error, Failed to copy the image. Check folder permissions.
        else
        {
            ; Append a timestamp to the path to break the GUI's image cache and force a reload
            GuiControl,, %PicVarName%, % DestinationFile . "?" . A_TickCount
            MsgBox, 64, Success, Icon for %FileName% was updated successfully!
        }
    }
}