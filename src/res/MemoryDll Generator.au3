;http://autoit-script.ru/index.php?topic=2345.15
$VarName = StringStripWS(InputBox("MemoryDllGen", "Select a name of variable:", "DllBinary"), 3)
If $VarName = "" Then Exit

$DllName = FileOpenDialog("Open dll file", @ScriptDir, "All files (*.*)")
If $DllName = "" Then Exit

$Handle = FileOpen($DllName, 16)
$DllBinary = FileRead($Handle)
FileClose($Handle)

$LineLen = 2050
$DllString = String($DllBinary)

$Script = "Dim $" & $VarName & " = '" & StringLeft($DllString, $LineLen) & "'" & @CRLF
$DllString = StringTrimLeft($DllString, $LineLen)

While StringLen($DllString) > $LineLen
    $Script &= "    $" & $VarName & " &= '" & StringLeft($DllString, $LineLen) & "'" & @CRLF
    $DllString = StringTrimLeft($DllString, $LineLen)
WEnd

If StringLen($DllString) <> 0 Then $Script &= "    $" & $VarName & " &= '" & $DllString & "'" & @CRLF
ClipPut($Script)


MsgBox(64, 'MemoryDll Generator', 'The result is in the clipboard, you can paste it to your script.')
Exit