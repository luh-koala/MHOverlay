#Persistent
#SingleInstance Force
SetTimer, CheckGame, 200
return

CheckGame:
WinGet, activeProcess, ProcessName, A
if (activeProcess = "MarvelHeroesOmega.exe")
    gameIsActive := true
else
    gameIsActive := false
return

~RButton::
if (gameIsActive)
{
    Send 7
}
return