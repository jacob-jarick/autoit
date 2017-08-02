#include <GUIConstants.au3>

GUICreate("Lod3n's Bandwidth Monitor",220,100,0,0,-1,$WS_EX_TOOLWINDOW)

$label1 = GUICtrlCreateLabel ( "Waiting for data...", 10, 5,200,20)
$progressbar1 = GUICtrlCreateProgress (10,20,200,20,$PBS_SMOOTH)

$label2 = GUICtrlCreateLabel ( "Waiting for data...", 10, 50,200,20)
$progressbar2 = GUICtrlCreateProgress (10,65,200,20,$PBS_SMOOTH)

GUISetState ()

$wbemFlagReturnImmediately = 0x10
$wbemFlagForwardOnly = 0x20
$colItems = ""
$strComputer = "localhost"
$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")

$inmax = 0
$outmax = 0

$lastin = 0
$lastout = 0

while 1
    ;$colItems = $objWMIService.ExecQuery("SELECT BytesReceivedPersec,BytesSentPersec FROM Win32_PerfFormattedData_Tcpip_NetworkInterface", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
    $colItems = $objWMIService.ExecQuery("SELECT BytesReceivedPersec,BytesSentPersec FROM Win32_PerfRawData_Tcpip_NetworkInterface", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
    
    If IsObj($colItems) then
        For $objItem In $colItems
            $newin = $objItem.BytesReceivedPersec
            $newout = $objItem.BytesSentPersec
            
            ;new realtime counter code...
            if $lastin = 0 and $lastout = 0 Then
                $lastin = $newin
                $lastout = $newout
            endif
            $in = $newin - $lastin
            $out = $newout - $lastout
            $lastin = $newin
            $lastout = $newout

            if $in <> 0 and $out <> 0 Then
                if $in > $inmax then $inmax = $in
                if $out > $outmax then $outmax = $out
                
                $inP = int(($in / $inmax) * 100)
                $outP = int(($out / $outmax) * 100)
                ;$in = $in/1024
                ;$out = $out/1024         
                $intext = "Bytes In/Sec: " & int($in) & " [" &$inP & "% of record]" & @CRLF
                $outtext = "Bytes Out/Sec: " & int($out) & " [" &$outP & "% of record]" &@CRLF

                GUICtrlSetData ($progressbar1,$inP)
                GUICtrlSetData ($label1,$intext)
                GUICtrlSetData ($progressbar2,$outP)
                GUICtrlSetData ($label2,$outtext)
                
            EndIf
            ExitLoop ; I only care about the first network adapter, yo
        Next
    EndIf
   sleep(1000) ; bytes PER SECOND
   If GUIGetMsg() = $GUI_EVENT_CLOSE Then ExitLoop
WEnd