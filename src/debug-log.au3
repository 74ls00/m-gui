Global $iPID
global const $debuglogfile = @WorkingDir & "\log\" & StringStripWS ($version,1) & "debugLog.txt"

Func _debug_start()

Local $nFile = $debuglogfile
Local $dlstart = @CRLF & @CRLF & "---Start--" & @YEAR & @MON & @MDAY & "." & @MIN & @SEC & "------------------------------------------------"
   $hFile = FileOpen($nFile, 1)
   FileWrite($hFile, $dlstart)
   FileClose($hFile)
EndFunc

Func _debug_stop()
   Local $nFile = $debuglogfile
   Local $dlstop = @CRLF & "---Stop---" & @YEAR & @MON & @MDAY & "." & @MIN & @SEC  & "------------------------------------------------"
   $hFile = FileOpen($nFile, 1)
   FileWrite($hFile, $dlstop)
   FileClose($hFile)
EndFunc

Func _debug_pid()
   ;Local $nFile = @WorkingDir & "\log\debugLogPID.txt"
   Local $nFile = $debuglogfile
   ;Local $dlstop = @CRLF & " PID " & $iPID & " " & @YEAR & @MON & @MDAY & "." & @MIN & @SEC & " " & $sLine
   Local $neline = StringStripWS ( $sLine, 2 )
   Local $dlstop = @CRLF & " PID " & $iPID & "                " & $neline
   $hFile = FileOpen($nFile, 1)
   FileWrite($hFile, $dlstop)
   FileClose($hFile)

   Local $debug_ini= @WorkingDir & "\debug.ini"
   IniWrite($debug_ini, "system", "pid", $iPID)
EndFunc

Func _debug_pid_stop()
   Local $nFile = $debuglogfile
   Local $dlstop =@CRLF & " Stop" & $iPID
   $hFile = FileOpen($nFile, 1)
   FileWrite($hFile, $dlstop)
   FileClose($hFile)
EndFunc

Func _debug_pid_exit()
   Local $nFile = $debuglogfile
   Local $dlstop =@CRLF & " Exit " & $iPID
   $hFile = FileOpen($nFile, 1)
   FileWrite($hFile, $dlstop)
   FileClose($hFile)
EndFunc


Func _debug_send_file()
   Local $nFile = $debuglogfile
   Local $dlstop =@CRLF & " zLog" & @YEAR & @MON & @MDAY & "." & @MIN & @SEC & ".txt "
   $hFile = FileOpen($nFile, 1)
   FileWrite($hFile, $dlstop)
   FileClose($hFile)
EndFunc

