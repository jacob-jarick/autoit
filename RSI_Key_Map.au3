;RSI Saver

HotKeySet("{F1}", "Copy")
HotKeySet("{F2}", "Cut")
HotKeySet("{F3}", "Paste")
HotKeySet("{F4}", "Undo")

While 1
	sleep(1)
WEnd

Func Copy()
	send("^c")
EndFunc

Func Cut()
	send("^x")
EndFunc

Func Paste()
	send("^v")
EndFunc

Func Undo()
	send("^z")
EndFunc
