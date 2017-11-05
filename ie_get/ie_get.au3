#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_x64=ie_get.exe
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; ie_get.au3 by jacob jarick - used for getting webpage data when wget / curl will not work.
#include <IE.au3>
#include <MsgBoxConstants.au3>

_IELoadWaitTimeout (750)

Local $debug = 0;
Local $show_ie = 0;
Local $limit = 10;
Local $count = 0;
Local $sHTML;
Local $cloudflare = 0;

Local $url = "http://torrentz2.eu/search?f=movies%20web%7Chdrip%7C720p%7C1080p%20seed%20%3E%205";
$url = $CmdLine[1];
Local $oIE;

Local $arg_count = UBound($CmdLine)

;MsgBox($MB_SYSTEMMODAL, "ie_get", "Arg count = " & @CRLF & $arg_count, 10)

if $arg_count == 3 Then
	if $CmdLine[2] == 1 Then
		$debug = 1;
		MsgBox($MB_SYSTEMMODAL, "ie_get", "Getting: " & @CRLF & $url, 1)
	EndIf
EndIf




if $debug == 1 Then
	$show_ie = 1;
EndIf

if $debug == 1 Then
	MsgBox($MB_SYSTEMMODAL, "ie_get", "Page Loaded", 1)
EndIf

While(1)
	$count+= 1;

	if $limit <= $count Then
		MsgBox($MB_SYSTEMMODAL, "ie_get", "unable to spawn ie object", 1)
		Exit
	EndIf

	$oIE = _IECreate("about:blank", 0, $show_ie, 1, 1)
	_IELoadWait($oIE)

	if(@error) Then
		if $debug == 1 Then
			MsgBox($MB_SYSTEMMODAL, "ie_get", "Failed to create ie object", 2)
		Else
			sleep(2000)
		EndIf
		ContinueLoop
	EndIf
	_IENavigate($oIE, $url)
	_IELoadWait($oIE)
	ExitLoop
WEnd

$count = 0

$sHTML = _IEDocReadHTML($oIE)


While(1)
	$count+= 1;
	if $limit <= $count Then
		if $debug == 1 Then
			MsgBox($MB_SYSTEMMODAL, "ie_get", "hit max retries, giving up", 1)
		EndIf
		ExitLoop
	EndIf

	if $sHTML == "" Then
		if $debug == 1 Then
			MsgBox($MB_SYSTEMMODAL, "blank html", "retry...", 1)
		EndIf
		Sleep(1000)
		$sHTML = _IEDocReadHTML($oIE);
		ContinueLoop
	EndIf

	$cloudflare = StringRegExp($sHTML, '(?i)cloudflare')

	if $cloudflare == 1 Then
		if $debug == 1 Then
			MsgBox($MB_SYSTEMMODAL, "Cloud Flare Block", "retry...", 1)
		EndIf
		Sleep(1000)
		$sHTML = _IEDocReadHTML($oIE);
		ContinueLoop
	EndIf

	ExitLoop
WEnd

if $debug == 1 Then
	MsgBox($MB_SYSTEMMODAL, "ie_get", "Finished", 1)
EndIf

_IEQuit($oIE)

ConsoleWrite ( $sHTML);



exit


Func _ErrFunc($oError)
    ; Do anything here.
    ConsoleWrite(@ScriptName & " (" & $oError.scriptline & ") : ==> COM Error intercepted !" & @CRLF & _
            @TAB & "err.number is: " & @TAB & @TAB & "0x" & Hex($oError.number) & @CRLF & _
            @TAB & "err.windescription:" & @TAB & $oError.windescription & @CRLF & _
            @TAB & "err.description is: " & @TAB & $oError.description & @CRLF & _
            @TAB & "err.source is: " & @TAB & @TAB & $oError.source & @CRLF & _
            @TAB & "err.helpfile is: " & @TAB & $oError.helpfile & @CRLF & _
            @TAB & "err.helpcontext is: " & @TAB & $oError.helpcontext & @CRLF & _
            @TAB & "err.lastdllerror is: " & @TAB & $oError.lastdllerror & @CRLF & _
            @TAB & "err.scriptline is: " & @TAB & $oError.scriptline & @CRLF & _
            @TAB & "err.retcode is: " & @TAB & "0x" & Hex($oError.retcode) & @CRLF & @CRLF)
EndFunc   ;==>_ErrFunc
