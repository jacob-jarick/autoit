#include <GUIConstantsEx.au3>
#Include <GuiEdit.au3>
#include <file.au3>

#RequireAdmin

#include <Timers.au3>

Opt('MustDeclareVars', 1)

Global $version = "1.1"
Global $file = "c:\tmp\auto_kill.txt"
Global $Form1 = GUICreate("Auto Killer v" & $version, 250, 400, 200, 150)
Global $editctrl = GUICtrlCreateEdit("", 10, 10, 230, 360)
Global $filemenu = GUICtrlCreateMenu("File")
Global $fileitem = GUICtrlCreateMenuItem("Settings", $filemenu)
Global $helpitem = GUICtrlCreateMenuItem("Help", $filemenu)
Global $exititem = GUICtrlCreateMenuItem("Exit", $filemenu)
Global $count = 0;

local $msg, $line;

_Timer_SetTimer ($Form1, 1000, quit(), -1)

_GUICtrlEdit_AppendText($editctrl, @HOUR &  ":" & @MIN & ":" & @SEC &  " - Started Auto Killer" & @CRLF & @CRLF)
GUISetState(@SW_SHOW)

while 1
	Sleep(100)
WEnd

Exit

Func quit()
	WinKill($Form1)
EndFunc


func gui_check()
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			Exit
		Case $msg = $fileitem
			run("notepad.exe " & $file);

		Case $msg = $helpitem
			MsgBox(-1, "Help", "Add the full name of any process you want auto killed to the settings file.")

		Case $msg = $exititem
			Exit
	EndSelect
EndFunc

func kill()
   $count = 0;
   local $i, $line, $variable, $fh

   $fh = FileOpen($file, 0)
   For $i = 1 to _FileCountLines($file)
		$line = FileReadLine($file, $i)
		If ProcessExists($line) Then
			ProcessClose($line)
			$variable = @HOUR &  ":" & @MIN & ":" & @SEC & " - killed: " & $line & @CRLF
			_GUICtrlEdit_AppendText($editctrl,$variable)
		EndIf
	Next
	FileClose($fh)
EndFunc