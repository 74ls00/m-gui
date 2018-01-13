Func _dllCHK()
Local $chklog
	$chklog = FileOpen(@WorkingDir & "\dllchk.log", 2)

Switch FileExists(@SystemDir & "\cmd.exe")
	Case 1
		FileWrite($chklog, "[0] " & @SystemDir & "\cmd.exe        - OK" & @CRLF)
	Case 0
		FileWrite($chklog, "[0] " & @SystemDir & "\cmd.exe        - Not Found" & @CRLF)
EndSwitch

Switch FileExists(@SystemDir & "\user32.dll")
	Case 1
		FileWrite($chklog, "[0] " & @SystemDir & "\user32.dll     - OK" & @CRLF)
	Case 0
		FileWrite($chklog, "[0] " & @SystemDir & "\user32.dll     - Not Found" & @CRLF)
EndSwitch

Switch FileExists(@SystemDir & "\imageres.dll")
	Case 1
		FileWrite($chklog, "[1] " & @SystemDir & "\imageres.dll   - OK" & @CRLF)
	Case 0
		FileWrite($chklog, "[1] " & @SystemDir & "\imageres.dll   - Not Found" & @CRLF)
EndSwitch

Switch FileExists(@SystemDir & "\mblctr.exe")
	Case 1
		FileWrite($chklog, "[1] " & @SystemDir & "\mblctr.exe     - OK" & @CRLF)
	Case 0
		FileWrite($chklog, "[1] " & @SystemDir & "\mblctr.exe     - Not Found" & @CRLF)
EndSwitch

Switch FileExists(@SystemDir & "\shell32.dll")
	Case 1
		FileWrite($chklog, "[1] " & @SystemDir & "\shell32.dll    - OK" & @CRLF)
	Case 0
		FileWrite($chklog, "[1] " & @SystemDir & "\shell32.dll    - Not Found" & @CRLF)
EndSwitch

Switch FileExists(@SystemDir & "\SyncCenter.dll")
	Case 1
		FileWrite($chklog, "[1] " & @SystemDir & "\SyncCenter.dll - OK" & @CRLF)
	Case 0
		FileWrite($chklog, "[1] " & @SystemDir & "\SyncCenter.dll - Not Found" & @CRLF)
EndSwitch

Switch FileExists(@SystemDir & "\calc.exe")
	Case 1
		FileWrite($chklog, "[2] " & @SystemDir & "\calc.exe       - OK" & @CRLF)
	Case 0
		FileWrite($chklog, "[2] " & @SystemDir & "\calc.exe       - Not Found" & @CRLF)
EndSwitch

Switch FileExists(@SystemDir & "\devmgr.dll")
	Case 1
		FileWrite($chklog, "[2] " & @SystemDir & "\devmgr.dll     - OK" & @CRLF)
	Case 0
		FileWrite($chklog, "[2] " & @SystemDir & "\devmgr.dll     - Not Found" & @CRLF)
EndSwitch

Switch FileExists(@SystemDir & "\devmgmt.msc")
	Case 1
		FileWrite($chklog, "[2] " & @SystemDir & "\devmgmt.msc    - OK" & @CRLF)
	Case 0
		FileWrite($chklog, "[2] " & @SystemDir & "\devmgmt.msc    - Not Found" & @CRLF)
EndSwitch

Switch FileExists(@SystemDir & "\mmc.exe")
	Case 1
		FileWrite($chklog, "[2] " & @SystemDir & "\mmc.exe        - OK" & @CRLF)
	Case 0
		FileWrite($chklog, "[2] " & @SystemDir & "\mmc.exe        - Not Found" & @CRLF)
EndSwitch

Switch FileExists(@SystemDir & "\msconfig.exe")
	Case 1
		FileWrite($chklog, "[2] " & @SystemDir & "\msconfig.exe   - OK" & @CRLF)
	Case 0
		FileWrite($chklog, "[2] " & @SystemDir & "\msconfig.exe   - Not Found" & @CRLF)
EndSwitch

Switch FileExists(@SystemDir & "\taskmgr.exe")
	Case 1
		FileWrite($chklog, "[2] " & @SystemDir & "\taskmgr.exe    - OK" & @CRLF)
	Case 0
		FileWrite($chklog, "[2] " & @SystemDir & "\taskmgr.exe    - Not Found" & @CRLF)
EndSwitch

	FileClose($chklog)
;MsgBox(4096, "", "-------")
EndFunc