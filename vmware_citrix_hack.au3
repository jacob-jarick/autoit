$sleep_time = 10 * 60;
While 1
	sleep($sleep_time * 1000)
	$click = MsgBox(1, "Jacobs VMware Hack", "CTRL+ALT will be sent to the active window in 10 seconds\nClick Cancel to stop", 10)
	if($click <> 2) Then send("{CTRLDOWN}{LALT}{CTRLUP}")
WEnd
	
	
