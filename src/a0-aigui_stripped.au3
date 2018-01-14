#NoTrayIcon
Global Const $0 = -3
Global Const $1 = -4
Global Const $2 = 64
Global Const $3 = 128
Global Const $4 = 0x00040000
Global Const $5 = 0x00200000
Global Const $6 = 0x00800000
Global Const $7 = 0x80000000
Global Const $8 = 64
Global Const $9 = 2048
Global Const $a = 0xC5
Global Const $b = 0xB5
Global Const $c = 0xB1
Global Const $d = "struct;long Left;long Top;long Right;long Bottom;endstruct"
Global Const $e = "uint cbSize;uint fMask;uint fStyle;dword clrFore;dword clrBack;ptr lpText;uint cch;" & "int iImage;hwnd hwndChild;uint cxMinChild;uint cyMinChild;uint cx;handle hbmBack;uint wID;uint cyChild;uint cyMaxChild;" & "uint cyIntegral;uint cxIdeal;lparam lParam;uint cxHeader" &((@OSVersion = "WIN_XP") ? "" : ";" & $d & ";uint uChevronState")
Func _11($f, $g, $h = 0, $i = 0, $j = 0, $k = "wparam", $l = "lparam", $m = "lresult")
Local $n = DllCall("user32.dll", $m, "SendMessageW", "hwnd", $f, "uint", $g, $k, $h, $l, $i)
If @error Then Return SetError(@error, @extended, "")
If $j >= 0 And $j <= 4 Then Return $n[$j]
Return $n
EndFunc
Global Const $o = 1
Global Const $p = 8
Global Const $q = 1
Global Const $r = 2
Global Const $s = Ptr(-1)
Global Const $t = Ptr(-1)
Global Const $u = 0x0100
Global Const $v = 0x2000
Global Const $w = 0x8000
Global Const $x = BitShift($u, 8)
Global Const $y = BitShift($v, 8)
Global Const $0z = BitShift($w, 8)
Func _1v($10)
Local $n = DllCall("user32.dll", "bool", "DestroyIcon", "handle", $10)
If @error Then Return SetError(@error, @extended, False)
Return $n[0]
EndFunc
Func _24($f, $11 = True)
Local $n = DllCall("user32.dll", "bool", "EnableWindow", "hwnd", $f, "bool", $11)
If @error Then Return SetError(@error, @extended, False)
Return $n[0]
EndFunc
Func _2d($12, $13, $14, $15, $16)
Local $n = DllCall("shell32.dll", "uint", "ExtractIconExW", "wstr", $12, "int", $13, "struct*", $14, "struct*", $15, "uint", $16)
If @error Then Return SetError(@error, @extended, 0)
Return $n[0]
EndFunc
Func _2s($f)
If Not IsHWnd($f) Then $f = GUICtrlGetHandle($f)
Local $n = DllCall("user32.dll", "int", "GetClassNameW", "hwnd", $f, "wstr", "", "int", 4096)
If @error Or Not $n[0] Then Return SetError(@error, @extended, '')
Return SetExtended($n[0], $n[2])
EndFunc
Func _4d($f, $17)
Local $18 = Opt("GUIDataSeparatorChar")
Local $19 = StringSplit($17, $18)
If Not IsHWnd($f) Then $f = GUICtrlGetHandle($f)
Local $1a = _2s($f)
For $1b = 1 To UBound($19) - 1
If StringUpper(StringMid($1a, 1, StringLen($19[$1b]))) = StringUpper($19[$1b]) Then Return True
Next
Return False
EndFunc
Global Const $1c = 0x0001
Global Const $1d = 0x0020
Global Const $1e = 0x0040
Global Const $1f = 0x1600
Global Const $1g =($1f + 0x0002)
Func _97(ByRef $1h, $1i = 100)
Select
Case UBound($1h, $r)
If $1i < 0 Then
ReDim $1h[$1h[0][0] + 1][UBound($1h, $r)]
Else
$1h[0][0] += 1
If $1h[0][0] > UBound($1h) - 1 Then
ReDim $1h[$1h[0][0] + $1i][UBound($1h, $r)]
EndIf
EndIf
Case UBound($1h, $q)
If $1i < 0 Then
ReDim $1h[$1h[0] + 1]
Else
$1h[0] += 1
If $1h[0] > UBound($1h) - 1 Then
ReDim $1h[$1h[0] + $1i]
EndIf
EndIf
Case Else
Return 0
EndSelect
Return 1
EndFunc
Global Const $1j = 'dword Size;dword Usage;dword ProcessID;ulong_ptr DefaultHeapID;dword ModuleID;dword Threads;dword ParentProcessID;long PriClassBase;dword Flags;wchar ExeFile[260]'
Func _98($1k = 0)
If Not $1k Then $1k = @AutoItPID
Local $1l = DllCall('kernel32.dll', 'handle', 'CreateToolhelp32Snapshot', 'dword', 0x00000002, 'dword', 0)
If @error Or($1l[0] = Ptr(-1)) Then Return SetError(@error + 10, @extended, 0)
Local $1m = DllStructCreate($1j)
Local $n[101][2] = [[0]]
$1l = $1l[0]
DllStructSetData($1m, 'Size', DllStructGetSize($1m))
Local $1n = DllCall('kernel32.dll', 'bool', 'Process32FirstW', 'handle', $1l, 'struct*', $1m)
Local $1o = @error
While(Not @error) And($1n[0])
If DllStructGetData($1m, 'ParentProcessID') = $1k Then
_97($n)
$n[$n[0][0]][0] = DllStructGetData($1m, 'ProcessID')
$n[$n[0][0]][1] = DllStructGetData($1m, 'ExeFile')
EndIf
$1n = DllCall('kernel32.dll', 'bool', 'Process32NextW', 'handle', $1l, 'struct*', $1m)
$1o = @error
WEnd
DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $1l)
If Not $n[0][0] Then Return SetError($1o + 20, 0, 0)
_97($n, -1)
Return $n
EndFunc
Func _99($f, $11 = True)
If Not IsHWnd($f) Then $f = GUICtrlGetHandle($f)
If _4d($f, "Button") Then Return _24($f, $11) = $11
EndFunc
Func _9a($f, $1p, $1q = 0, $1r = 1, $1s = 1, $1t = 1, $1u = 1)
If Not IsHWnd($f) Then $f = GUICtrlGetHandle($f)
If $1q < 0 Or $1q > 4 Then $1q = 0
Local $1v = DllStructCreate("ptr ImageList;" & $d & ";uint Align")
DllStructSetData($1v, "ImageList", $1p)
DllStructSetData($1v, "Left", $1r)
DllStructSetData($1v, "Top", $1s)
DllStructSetData($1v, "Right", $1t)
DllStructSetData($1v, "Bottom", $1u)
DllStructSetData($1v, "Align", $1q)
Local $1w = _99($f, False)
Local $1x = _11($f, $1g, 0, $1v, 0, "wparam", "struct*") <> 0
_99($f)
If Not $1w Then _99($f, False)
Return $1x
EndFunc
Func _9b($1y = 16, $1z = 16, $20 = 4, $21 = 0, $22 = 4, $23 = 4)
Local Const $24[7] = [0x00000000, 0x00000004, 0x00000008, 0x00000010, 0x00000018, 0x00000020, 0x000000FE]
Local $25 = 0
If BitAND($21, 1) <> 0 Then $25 = BitOR($25, 0x00000001)
If BitAND($21, 2) <> 0 Then $25 = BitOR($25, 0x00002000)
If BitAND($21, 4) <> 0 Then $25 = BitOR($25, 0x00008000)
$25 = BitOR($25, $24[$20])
Local $n = DllCall("comctl32.dll", "handle", "ImageList_Create", "int", $1y, "int", $1z, "uint", $25, "int", $22, "int", $23)
If @error Then Return SetError(@error, @extended, 0)
Return $n[0]
EndFunc
Func _9c($f, $26, $13 = 0, $27 = False)
Local $1x, $28 = DllStructCreate("handle Handle")
If $27 Then
$1x = _2d($26, $13, $28, 0, 1)
Else
$1x = _2d($26, $13, 0, $28, 1)
EndIf
If $1x <= 0 Then Return SetError(-1, $1x, -1)
Local $10 = DllStructGetData($28, "Handle")
$1x = _9d($f, -1, $10)
_1v($10)
If $1x = -1 Then Return SetError(-2, $1x, -1)
Return $1x
EndFunc
Func _9d($f, $13, $10)
Local $n = DllCall("comctl32.dll", "int", "ImageList_ReplaceIcon", "handle", $f, "int", $13, "handle", $10)
If @error Then Return SetError(@error, @extended, -1)
Return $n[0]
EndFunc
Global Const $29 = -8
Global $2a
Global $2b[$2a+1],$2c[$2a+1],$2d[$2a+1],$2e[$2a+1],$2f[$2a+1]
Global $2g[$2a+1],$2h[$2a+1],$2i[$2a+1],$2j[$2a+1],$2k[$2a+1]
Global $2l[$2a+1],$2m[$2a+1],$2n[$2a+1],$2o[$2a+1]
Global $2p[$2a+1]
Func _9e()
$2b[0] = "ping ya.ru"
$2c[0] = " -t ya.ru"
$2i[0] = "ping.exe"
$2j[0] = Null
$2l[0] = @SystemDir & $2h[0] & "\" & $2i[0] & $2c[0] & $2d[0] & $2e[0] & $2f[0] & $2j[0] & $2k[0]
$2p[0] = 0
$2b[1] = "CPU NH ZEC"
$2c[1] = " -l zec.suprnova.cc:2142"
$2e[1] = " -u satok.cpu0"
$2f[1] = " -p cpu0p"
$2h[1] = "nheqminer_suprnovav0.4a"
$2i[1] = "nheqminer.exe"
$2j[1] = Null
$2o[1] = "https://zec.suprnova.cc/index.php?page=dashboard"
$2l[1] = @WorkingDir & $2h[1] & "\" & $2i[1] & $2c[1] & $2e[1] & $2f[1] & $2j[1] & $2k[1]
$2p[1] = 1
ReDim $2b[$2a+2]
ReDim $2c[$2a+2]
ReDim $2d[$2a+2]
ReDim $2h[$2a+2]
ReDim $2i[$2a+2]
ReDim $2j[$2a+2]
ReDim $2p[$2a+2]
ReDim $2l[$2a+2]
ReDim $2e[$2a+2]
ReDim $2f[$2a+2]
ReDim $2o[$2a+2]
$2b[2] = "GPU0 dstm sn ZEC"
$2c[2] = "--server zec.suprnova.cc"
$2d[2] = "--port 2142"
$2e[2] = "--user satok.gpu0"
$2f[2] = "--pass gpu0p"
$2h[2] = "zm_0.5.7_win"
$2i[2] = "zm.exe"
$2j[2] = '--logfile="' & @WorkingDir & '\tmp\log.txt"'
$2o[2] = "https://zec.suprnova.cc/index.php?page=dashboard"
$2l[2] = @WorkingDir & $2h[2] & "\" & $2i[2] & $2c[2] & $2d[2] & $2e[2] & $2f[2] & $2j[2]
$2p[2] = 2
$2b[4] = "GPU0 dstm fl ZEC"
$2c[4] = "--server eu1-zcash.flypool.org"
$2d[4] = "--port 3333"
$2e[4] = "--user t1dBppEDzq477cPp9xRfULUPWkxaVvuW2Ro"
$2g[4] = ".ZM_gpu0"
$2h[4] = "zm_0.5.7_win"
$2i[4] = "zm.exe"
$2j[4] = '--logfile="' & @WorkingDir & '\tmp\log.txt"'
$2o[4] = "https://zcash.flypool.org/miners/t1dBppEDzq477cPp9xRfULUPWkxaVvuW2Ro"
$2l[4] = @WorkingDir & $2h[4] & "\" & $2i[4] & $2c[4] & $2d[4] & $2e[4] & $2f[4] & $2j[4]
$2p[4] = 2
$2b[3] = "CPU NH ZEC fl"
$2c[3] = " -l eu1-zcash.flypool.org:3333"
$2e[3] = " -u t1dBppEDzq477cPp9xRfULUPWkxaVvuW2Ro"
$2g[3] = ".cpu0"
$2h[3] = "nheqminer_0.3a_flypool"
$2i[3] = "nheqminer.exe"
$2j[3] = Null
$2o[3] = "https://zcash.flypool.org/miners/t1dBppEDzq477cPp9xRfULUPWkxaVvuW2Ro"
$2l[3] = @WorkingDir & $2h[3] & "\" & $2i[3] & $2c[3] & $2e[3] & $2f[3] & $2j[3] & $2k[3]
$2p[3] = 1
EndFunc
Func _9g($2q)
Local $2r = DllStructCreate('char[' & StringLen($2q) + 1 & ']')
Local $1n = DllCall('User32.dll', 'int', 'CharToOem', 'str', $2q, 'ptr', DllStructGetPtr($2r))
If Not IsArray($1n) Then Return SetError(1, 0, '')
If $1n[0] = 0 Then Return SetError(2, $1n[0], '')
Return DllStructGetData($2r, 1)
EndFunc
Func _9w($2q)
Local $2r = DllStructCreate('char[' & StringLen($2q) + 1 & ']')
Local $1n = DllCall('User32.dll', 'int', 'OemToChar', 'str', $2q, 'ptr', DllStructGetPtr($2r))
If Not IsArray($1n) Then Return SetError(1, 0, '')
If $1n[0] = 0 Then Return SetError(2, $1n[0], '')
Return DllStructGetData($2r, 1)
EndFunc
Global $2s = @WorkingDir & "\myconf.ini"
Global $2t = @WorkingDir & "\system.ini"
Global $2a=4
Global $2u=0
Global $2v=600000
Global $2w = 0
Global $2x = 5000
Select
Case Not FileExists($2t)
_a9()
EndSelect
_aa()
Select
Case FileExists($2s)
_a6()
EndSelect
Func _a6()
$2a = IniRead($2s,"system","tabs", 1)
If $2a > 15 Then $2a = 15
EndFunc
Global $2y[$2a+1],$2p[$2a+1]
Global $2b[$2a+1],$2c[$2a+1],$2d[$2a+1],$2e[$2a+1],$2f[$2a+1]
Global $2g[$2a+1],$2h[$2a+1],$2i[$2a+1],$2j[$2a+1],$2k[$2a+1]
Global $2l[$2a+1],$2m[$2a+1],$2n[$2a+1],$2o[$2a+1]
Func _a7()
For $2z=0 To $2a
$2b[$2z] = $2z
$2g[$2z] = Null
$2c[$2z] = Null
$2d[$2z] = Null
$2e[$2z] = Null
$2f[$2z] = Null
$2h[$2z] = Null
$2i[$2z] = Null
$2j[$2z] = Null
$2k[$2z] = Null
$2p[$2z] = 0
$2l[$2z] = @WorkingDir & $2h[$2z] & "\" & $2i[$2z] & $2c[$2z] & $2d[$2z] & $2e[$2z] & $2g[$2z] & $2f[$2z] & $2j[$2z] & $2k[$2z]
$2m[$2z] = Null
$2n[$2z] = 0
$2o[$2z] = "http:/www#"
Next
EndFunc
Func _a8()
Select
Case Not FileExists($2s)
_a7()
_9e()
EndSelect
For $2z=0 To $2a
Local $30 = "miner"
IniWrite($2s, $30 & $2z, "info", '"' & $2b[$2z] & '"')
IniWrite($2s, $30 & $2z, "dev", $2g[$2z])
IniWrite($2s, $30 & $2z, "server",'"' & $2c[$2z] & '"')
IniWrite($2s, $30 & $2z, "port",'"' & $2d[$2z] & '"')
IniWrite($2s, $30 & $2z, "user",'"' & $2e[$2z] & '"')
IniWrite($2s, $30 & $2z, "pass", '"' & $2f[$2z] & '"')
IniWrite($2s, $30 & $2z, "expath",'"' & $2h[$2z] & '"')
IniWrite($2s, $30 & $2z, "exname",'"' & $2i[$2z] & '"')
IniWrite($2s, $30 & $2z, "exlog",'"' & $2j[$2z] & '"')
IniWrite($2s, $30 & $2z, "params",'"' & $2k[$2z] & '"')
IniWrite($2s, $30 & $2z, "typecmd", $2p[$2z])
_ac()
$2l[$2z] = StringStripWS($2y[$2z], 2 )
IniWrite($2s, $30 & $2z, "debug",'"' & $2l[$2z] & '"')
IniWrite($2s, $30 & $2z, "exlpid", $2m[$2z])
IniWrite($2s, $30 & $2z, "useregflg", $2n[$2z])
IniWrite($2s, $30 & $2z, "urlprofile",'"' & $2o[$2z] & '"')
Next
IniWrite($2s, "system", "tabs", $2a)
EndFunc
Func _a9()
IniWrite($2t, "GUI", "Tray1_Exit",$2u)
IniWrite($2t, "GUI", "ListingLimit",$2v)
EndFunc
Func _aa()
Select
Case Not FileExists($2t)
IniWrite($2t, "LOG", "CheckDll", 1)
Case Else
Select
Case IniRead($2t,"LOG","CheckDll", Null) = ""
IniWrite($2t, "LOG", "CheckDll", 1)
EndSelect
EndSelect
$2u = IniRead($2t,"GUI","Tray1_Exit", $2u)
$2v = IniRead($2t,"GUI","ListingLimit", $2v)
EndFunc
Func _ab()
Select
Case FileExists($2s)
_a6()
For $2z = 0 To $2a
Local $30 = "miner"
$2b[$2z] = IniRead($2s,$30 & $2z,"info", $2z)
If $2b[$2z] = "" Then $2b[$2z] = $2z
$2g[$2z] = IniRead($2s,$30 & $2z,"dev", Null)
$2c[$2z] = IniRead($2s,$30 & $2z,"server", Null)
$2d[$2z] = IniRead($2s,$30 & $2z,"port", Null)
$2e[$2z] = IniRead($2s,$30 & $2z,"user", Null)
$2f[$2z] = IniRead($2s,$30 & $2z,"pass", Null)
$2h[$2z] = IniRead($2s,$30 & $2z,"expath", Null)
$2i[$2z] = IniRead($2s,$30 & $2z,"exname", Null)
$2j[$2z] = IniRead($2s,$30 & $2z,"exlog", Null)
$2k[$2z] = IniRead($2s,$30 & $2z,"params", Null)
$2p[$2z] = IniRead($2s,$30 & $2z,"typecmd", 0)
$2l[$2z] = IniRead($2s,$30 & $2z,"debug", Null)
$2m[$2z] = IniRead($2s,$30 & $2z,"exlpid", Null)
$2n[$2z] = IniRead($2s,$30 & $2z,"useregflg", Null)
$2o[$2z] = IniRead($2s,$30 & $2z,"urlprofile", Null)
Next
Case Else
_a8()
EndSelect
EndFunc
Func _ac()
For $2z = 0 To $2a
Select
Case $2p[$2z] = 4
$2y[$2z] = _9g(@WorkingDir & '\' & $2h[$2z] & '\' & $2i[$2z]) & $2c[$2z] & $2d[$2z] & $2e[$2z] & $2g[$2z] & $2f[$2z] & $2j[$2z] & $2k[$2z] & @CRLF
Case $2p[$2z] = 5
$2y[$2z] = _9g(@WorkingDir & '\' & $2h[$2z] & '\' & $2i[$2z] & $2c[$2z] & $2d[$2z] & $2e[$2z] & $2g[$2z] & $2f[$2z] & $2j[$2z] & $2k[$2z]) & @CRLF
Case $2p[$2z] = 3
$2y[$2z] = _9g('"' & @WorkingDir & '\' & $2h[$2z] & '\' & $2i[$2z] & '" ' & $2c[$2z] & $2d[$2z] & $2e[$2z] & $2g[$2z] & $2f[$2z] & $2j[$2z] & $2k[$2z]) & @CRLF
Case $2p[$2z] = 6
$2y[$2z] = @WorkingDir & '\' & $2h[$2z] & '\' & $2i[$2z] & ' ' & $2c[$2z] & ' ' & $2d[$2z] & ' ' & $2e[$2z] & $2g[$2z] & ' ' & $2f[$2z] & ' ' & $2j[$2z] & ' ' & $2k[$2z] & @CRLF
Case $2p[$2z] = 0
$2y[$2z] = $2i[$2z] & " " & $2c[$2z] & " " & $2d[$2z] & " " & $2e[$2z] & $2g[$2z] & " " & $2f[$2z] & " " & $2j[$2z] & " " & $2k[$2z] & @CRLF
Case $2p[$2z] = 1
$2y[$2z] = '"' & _9g(@WorkingDir & '\' & $2h[$2z] & '\' & $2i[$2z]) & '" ' & $2c[$2z] & $2d[$2z] & $2e[$2z] & $2g[$2z] & $2f[$2z] & _9g($2j[$2z]) & $2k[$2z] & @CRLF
Case $2p[$2z] = 2
$2y[$2z] = '"' & _9g(@WorkingDir & '\' & $2h[$2z] & '\' & $2i[$2z]) & '" ' & $2c[$2z] & " " & $2d[$2z] & " " & $2e[$2z] & $2g[$2z] & " " & $2f[$2z] & " " & _9g($2j[$2z]) & " " & $2k[$2z] & @CRLF
EndSelect
Next
EndFunc
Global $31[$2a+11]
$31[0] = @CRLF & "    /\_/\" & @CRLF & " =(  �w� )=" & @CRLF & "    )      (  //" & @CRLF & "   (__ __)//"
$31[1] = @CRLF & "                ______    ____" & @CRLF & "               :  ;;;;\__/:  ;\" & @CRLF & "                \;__/.... :  _/;" & @CRLF & "               ___:__ ..__\_/__;" & @CRLF & "               |  ## `--'   ##|;" & @CRLF & "               |_____/~;\_____|;" & @CRLF & "                 /~~~_ _ ~~   /" & @CRLF & "                 // (_:_)   \\" & @CRLF & "           _     // ,'~ `,_\\~\_" & @CRLF & "          //     ~~`,---,'~~~   \" & @CRLF & " ___     //         ~~~~      ;; \_  __" & @CRLF & "/_\/____::_        ,(:;:  __    ;; \/;;\  __" & @CRLF & "\_/) _  :: (       ; ;;:    \    / ;:;;::-,-'" & @CRLF & "   |[-]_::-|       : :;;:   /  * | ;:;;:;'" & @CRLF & "   | :__:: |       :.`,:::  : +  : /___:'" & @CRLF & "   |[_ ] [\|       ;. ;--`:_:.  *| /   /" & @CRLF & "   |__| |_]|    ,-' . :uu-'/     \|UUU/" & @CRLF & "   |_______|   ;_|_|_/    :_;_;_;_:" & @CRLF & "    [=====]"
$31[2] = @CRLF & "       --------------------------------------/ ^^^^^^^^^ \" & @CRLF & "     /                                      |       | *  * |       |" & @CRLF & "   / |    )                           |    | |\__/  @  \__/" & @CRLF & "\/   \ / /----------\______/ \ //        '----'" & @CRLF & "       | |=|=                           | |=|="
Global Const $32 = "  0.180114.0235 dev"
Func _ad()
Local $33
$33 = FileOpen(@WorkingDir & "\dllchk.log", 2)
Switch FileExists(@SystemDir & "\cmd.exe")
Case 1
FileWrite($33, "[0] " & @SystemDir & "\cmd.exe        - OK" & @CRLF)
Case 0
FileWrite($33, "[0] " & @SystemDir & "\cmd.exe        - Not Found" & @CRLF)
EndSwitch
Switch FileExists(@SystemDir & "\user32.dll")
Case 1
FileWrite($33, "[0] " & @SystemDir & "\user32.dll     - OK" & @CRLF)
Case 0
FileWrite($33, "[0] " & @SystemDir & "\user32.dll     - Not Found" & @CRLF)
EndSwitch
Switch FileExists(@SystemDir & "\imageres.dll")
Case 1
FileWrite($33, "[1] " & @SystemDir & "\imageres.dll   - OK" & @CRLF)
Case 0
FileWrite($33, "[1] " & @SystemDir & "\imageres.dll   - Not Found" & @CRLF)
EndSwitch
Switch FileExists(@SystemDir & "\mblctr.exe")
Case 1
FileWrite($33, "[1] " & @SystemDir & "\mblctr.exe     - OK" & @CRLF)
Case 0
FileWrite($33, "[1] " & @SystemDir & "\mblctr.exe     - Not Found" & @CRLF)
EndSwitch
Switch FileExists(@SystemDir & "\shell32.dll")
Case 1
FileWrite($33, "[1] " & @SystemDir & "\shell32.dll    - OK" & @CRLF)
Case 0
FileWrite($33, "[1] " & @SystemDir & "\shell32.dll    - Not Found" & @CRLF)
EndSwitch
Switch FileExists(@SystemDir & "\SyncCenter.dll")
Case 1
FileWrite($33, "[1] " & @SystemDir & "\SyncCenter.dll - OK" & @CRLF)
Case 0
FileWrite($33, "[1] " & @SystemDir & "\SyncCenter.dll - Not Found" & @CRLF)
EndSwitch
Switch FileExists(@SystemDir & "\calc.exe")
Case 1
FileWrite($33, "[2] " & @SystemDir & "\calc.exe       - OK" & @CRLF)
Case 0
FileWrite($33, "[2] " & @SystemDir & "\calc.exe       - Not Found" & @CRLF)
EndSwitch
Switch FileExists(@SystemDir & "\devmgr.dll")
Case 1
FileWrite($33, "[2] " & @SystemDir & "\devmgr.dll     - OK" & @CRLF)
Case 0
FileWrite($33, "[2] " & @SystemDir & "\devmgr.dll     - Not Found" & @CRLF)
EndSwitch
Switch FileExists(@SystemDir & "\devmgmt.msc")
Case 1
FileWrite($33, "[2] " & @SystemDir & "\devmgmt.msc    - OK" & @CRLF)
Case 0
FileWrite($33, "[2] " & @SystemDir & "\devmgmt.msc    - Not Found" & @CRLF)
EndSwitch
Switch FileExists(@SystemDir & "\mmc.exe")
Case 1
FileWrite($33, "[2] " & @SystemDir & "\mmc.exe        - OK" & @CRLF)
Case 0
FileWrite($33, "[2] " & @SystemDir & "\mmc.exe        - Not Found" & @CRLF)
EndSwitch
Switch FileExists(@SystemDir & "\msconfig.exe")
Case 1
FileWrite($33, "[2] " & @SystemDir & "\msconfig.exe   - OK" & @CRLF)
Case 0
FileWrite($33, "[2] " & @SystemDir & "\msconfig.exe   - Not Found" & @CRLF)
EndSwitch
Switch FileExists(@SystemDir & "\taskmgr.exe")
Case 1
FileWrite($33, "[2] " & @SystemDir & "\taskmgr.exe    - OK" & @CRLF)
Case 0
FileWrite($33, "[2] " & @SystemDir & "\taskmgr.exe    - Not Found" & @CRLF)
EndSwitch
FileClose($33)
EndFunc
Func _ae()
Local $34 = @WorkingDir & "\log\debugLog.txt"
Local $35 = @CRLF & @CRLF & "---Start--" & @YEAR & @MON & @MDAY & "." & @MIN & @SEC & "------------------------------------------------"
$36 = FileOpen($34, 1)
FileWrite($36, $35)
FileClose($36)
EndFunc
Func _af()
Local $34 = @WorkingDir & "\log\debugLog.txt"
Local $37 = @CRLF & "---Stop---" & @YEAR & @MON & @MDAY & "." & @MIN & @SEC & "------------------------------------------------"
$36 = FileOpen($34, 1)
FileWrite($36, $37)
FileClose($36)
EndFunc
Opt("TrayAutoPause", 0)
Opt('TrayMenuMode', 3)
Opt("GUIOnEventMode", 1)
_ae()
Select
Case IniRead($2t,"RUN","RunPID", Null) <> "" And ProcessExists(IniRead($2t,"RUN","RunPID", Null) )
WinSetState(IniRead($2t,"RUN","RunGUI", Null), Null, @SW_SHOW )
WinActivate(IniRead($2t,"RUN","RunGUI", Null), Null )
Exit
EndSelect
Switch IniRead($2t,"LOG","CheckDll", "")
Case 1
_ad()
EndSwitch
Global Const $38 = 1
Global $39, $3a, $3b, $3c, $3d, $3e, $3f, $3g, $3h = 1 , $3i
Global $3j , $3k
$3k = $2a+1
Global $3l , $3m , $1p
Global Const $3n = "AiGUI"
Global Const $3o = 670 , $3p = 450
Global Const $3q = 35
Global Const $3r = $3p-82
_ab()
_ac()
Global $3b[$2a+1],$3c[$2a+1],$3d[$2a+1],$3s[$2a+1]
Global $3f[$2a+1],$3e[$2a+1] , $3t[$2a+1]
Global $3u[$2a+1] , $3g[$2a+1] , $3v[$2a+1] , $3w
Global $3x[$2a+1],$3y[$2a+1],$3z[$2a+1],$40[$2a+1],$41[$2a+1],$42[$2a+1]
Global $43[$2a+1],$44[$2a+1],$45[$2a+1],$46[$2a+1],$47[$2a+1],$48[$2a+1]
Global Const $49 = 3
Global $4a
Global $4b[$2a+1]
Global Const $4c = 0x00FF09
Global Const $4d = 0xFBD7F4
TraySetState(1)
_ak()
While 1
Switch TrayGetMsg()
Case $29
WinSetState($39, Null, @SW_SHOW )
WinActivate($39, Null )
EndSwitch
Switch $2w
Case 0
_ap()
Case Else
_aq()
EndSwitch
Sleep(10)
WEnd
Func _ak()
Select
Case IsAdmin()
$4e = " - Администратор"
Case Else
$4e = " - без прав администратора"
EndSelect
$39 = GUICreate($3n & " " & $32 & $4e,$3o,$3p,-1,-1)
IniWrite($2t, "RUN", "RunPID", WinGetProcess($39 ))
IniWrite($2t, "RUN", "RunGUI", '"' & $3n & " " & $32 & $4e & '"')
GUISetOnEvent($0, '_aw', $39)
GUISetOnEvent($1, '_ax', $39)
GUISetFont(8.5, Null, Null, Null ,$39 , $49)
$3m = GUICtrlCreateTab(5, 5, $3o-10, $3p-10)
GUICtrlCreateTabItem("  Панель  ")
GUICtrlCreateGroup("", 15 , $3q-5 , $3o-32 , $3p-46)
GUICtrlCreateLabel($3n & " - зелёная фигня", 20, $3q+5, $3o-42-70, 60)
GUICtrlSetFont(-1, 10.5, 400, 0 , "Arial" , 5)
GUICtrlSetBkColor(-1, 0x00FF00)
$4f = GUICtrlCreateButton("", $3o-50, $3q+9, 24, 24, $1e)
GUICtrlSetImage(-1, "winhlp32.exe", 0 ,0)
GUICtrlSetOnEvent(-1, "_b0")
Local Const $4g = 33
Local Const $4h = $3q+80
Local Const $4i = 20
Local Const $4j = 18
Local Const $4k = 150
GUICtrlCreateGroup("", $4g-8 , $4h-14 , $4k*2+21 , $4i*9+1)
For $2z=0 To $2a
Select
Case $2z < 8
$4b[$2z] = GUICtrlCreateLabel(" " & $2b[$2z] & " ", $4g, $4h+($2z*$4i), $4k, $4j, 0x0200)
case Else
$4b[$2z] = GUICtrlCreateLabel(" " & $2b[$2z] & " ", $4g+$4k+5, $4h+($2z*$4i)-($4i*8), $4k, $4j, 0x0200)
EndSelect
Next
$1p = _9b(32, 32, 5, 3)
_9c($1p, "taskmgr.exe", 0, True)
$4l = GUICtrlCreateButton("Диспетчер задач", 187, $3p-100, 147, 40)
GUICtrlSetOnEvent(-1, "_b1")
_9a($4l, $1p)
$1p = _9b(32, 32, 5, 3)
_9c($1p, "devmgr.dll", 4, True)
$4m = GUICtrlCreateButton("Диспетчер устройств", 25, $3p-100, 157, 40)
GUICtrlSetOnEvent(-1, "_b2")
_9a($4m, $1p)
$1p = _9b(32, 32, 5, 3)
_9c($1p, "cmd.exe", 0, True)
$4n = GUICtrlCreateButton("Командная строка", 339, $3p-100, 150, 40)
_9a($4n, $1p)
GUICtrlSetOnEvent(-1, "_b3")
$1p = _9b(32, 32, 5, 3)
_9c($1p, "shell32.dll", 21, True)
$4o = GUICtrlCreateButton("Настройки", 494 , $3p-100, 150, 40)
_9a($4o, $1p)
GUICtrlSetOnEvent(-1, "_al")
$1p = _9b(32, 32, 5, 3)
_9c($1p, "calc.exe", 0, True)
$4p = GUICtrlCreateButton("Калькулятор", 494-145, $3p-200, 150, 40)
_9a($4p, $1p)
GUICtrlSetOnEvent(-1, "_b4")
$1p = _9b(16 , 16,5, 3)
$4q = GUICtrlCreateButton("msconfig", 25, $3p-51, 80, 24)
Select
Case IsAdmin()
_9c($1p, "msconfig.exe", 0, True)
Case Else
_9c($1p, "shell32.dll", 109, True)
GUICtrlSetState(-1, $3)
EndSelect
_9a($4q, $1p)
GUICtrlSetOnEvent(-1, "_b5")
Switch $38
Case 1
$1p = _9b(32, 32, 5, 3)
_9c($1p, "shell32.dll", 215, True)
$3i = GUICtrlCreateButton("Остановить всё", $3o-176, $4h-8, 150, 40)
_9a($3i, $1p)
GUICtrlSetOnEvent(-1, "_au")
GUICtrlSetState(-1, $3)
EndSwitch
For $4r = 0 To $2a
GUICtrlCreateTabItem($2b[$4r])
$1p = _9b(24, 24, 5, 3)
_9c($1p, "shell32.dll", 137, True)
$3b[$4r] = GUICtrlCreateButton("Старт", 14, $3r+35 , 95, 32, $1c)
GUICtrlSetOnEvent(-1, "_as")
_9a(-1, $1p)
$1p = _9b(24, 24, 5, 3)
_9c($1p, "SyncCenter.dll", 5, True)
$3c[$4r] = GUICtrlCreateButton("Стоп", 100+5+5+5, $3r+35, 95, 32, 0x01)
GUICtrlSetOnEvent(-1, "_at")
GUICtrlSetState(-1, $3)
_9a(-1, $1p)
$1p = _9b(24, 24, 5, 3)
_9c($1p, "imageres.dll", 93, True)
$3d = GUICtrlCreateButton("Очистить", 186+10+10+10, $3r+35, 95, 32)
GUICtrlSetOnEvent(-1, "_av")
_9a(-1, $1p)
GUICtrlCreateIcon("mblctr.exe", 133, $3o-44, $3p-47)
$3s[$4r] = GUICtrlCreateEdit("==>[" & $4r & "]" & @CRLF & _9w($2y[$4r]) & $31[$4r] , 14, $3q, $3o-30, $3r-8, BitOR($9, $8, $5))
GUICtrlSendMsg(-1, $a, -1, 0)
Next
GUISetState(@SW_SHOW, $39)
EndFunc
Func _al()
WinSetState($39, Null, @SW_DISABLE )
Local $4s = WinGetPos($39)
$3a = GUICreate("Настройки", $4s[2]-20, $4s[3]-41, $4s[0]+8, $4s[1]+30, BitOR($6, $7), -1, $39)
GUICtrlCreateGroup("Настройки", 9, 9 , $4s[2]-38 , 70)
$1p = _9b(24, 24, 5, 3)
_9c($1p, "imageres.dll", 161, True)
GUICtrlCreateButton("Закрыть", 23, 32, 100, 32)
GUICtrlSetOnEvent(-1, "_am")
_9a(-1, $1p)
$1p = _9b(24, 24, 5, 3)
_9c($1p, "shell32.dll", 165, True)
GUICtrlCreateButton("Сохранить", 135, 32, 100, 32)
GUICtrlSetOnEvent(-1, "_an")
_9a(-1, $1p)
Local Const $4t = $4s[2]-85
Local Const $4u = $4s[3]-80
GUICtrlCreateGroup(Null, $4t-123, $4u-16 , 178 , 45)
GUICtrlCreateLabel("Количество вкладок", $4t-109, $4u+3)
$3j = GUICtrlCreateInput($3k, $4t, $4u, 40, 20)
GUICtrlCreateUpdown(-1,BitOR(0x40 , 0x01, 0x20) )
GUICtrlSetLimit(-1, 10, 1)
$4a = GUICtrlCreateCheckbox("Сворачивать в трей", $4s[2]-160, $4s[3]-$3p-5, 120, 20, $1d)
Switch $2u
Case 1
GUICtrlSetState($4a, 1 )
Case Else
GUICtrlSetState($4a, 4 )
EndSwitch
Local Const $4v = 110
local Const $4w = 200
Local Const $4x = 100
Local Const $4y = 165
Local Const $4z = $4y-65
Local Const $50 = 280
Local Const $51 = 70
Local Const $52 = 150
GUICtrlCreateTab(9, $4v, $4s[2]-38, 250)
For $2z=0 To $2a
GUICtrlCreateTabItem($2z)
GUICtrlCreateLabel("Mode:", 20, $4v+30, 28, 20, 0x0200)
$3x[$2z] = GUICtrlCreateInput($2b[$2z], 63, $4v+30, $4w-2,20)
If $2m[$2z] Then GUICtrlCreateLabel("Last PID " & $2m[$2z], $4w+72, $4v+30, 100,20)
$3y[$2z] = GUICtrlCreateCombo($2p[$2z], 20, $4v+60, 32, 100)
GUICtrlSetData(-1, "0|1|2",$2p[$2z])
$3z[$2z] = GUICtrlCreateInput($2h[$2z], 62, $4v+60, $4w, 20)
$40[$2z] = GUICtrlCreateInput($2i[$2z], $4w+72, $4v+60, $4x, 20)
GUICtrlCreateLabel("Server:", 20, $4v+90, 35, 20, 0x0200)
$41[$2z] = GUICtrlCreateInput($2c[$2z], 57, $4v+90, $4y,20)
$43[$2z] = GUICtrlCreateInput($2d[$2z], $4y+30+39, $4v+90, $4z,20)
GUICtrlCreateLabel("User:", 20, $4v+120, 28, 20, 0x0200)
$44[$2z] = GUICtrlCreateInput($2e[$2z], 50, $4v+120, $50,20)
GUICtrlCreateLabel("&&", $50+51, $4v+120, 10, 20, 0x0200)
$45[$2z] = GUICtrlCreateInput($2g[$2z], $50+30+2+26, $4v+120, $51,20)
GUICtrlCreateLabel("Pass:", $50+$51+60, $4v+120, 30, 20, 0x0200)
$46[$2z] = GUICtrlCreateInput($2f[$2z], $50+$51+91, $4v+120, $52,20)
GUICtrlCreateLabel("Log:", 20, $4v+150, 28, 20, 0x0200)
$47[$2z] = GUICtrlCreateInput($2j[$2z], 53, $4v+150, $4s[2]-96,20)
$48[$2z] = GUICtrlCreateInput($2k[$2z], 20, $4v+180, $4s[2]-63,20)
GUICtrlCreateLabel("Url:", 20, $4v+210, 28, 20, 0x0200)
$42[$2z] = GUICtrlCreateInput($2o[$2z], 53, $4v+210, $4s[2]-96,20)
Next
GUISetState(@SW_SHOW)
EndFunc
Func _am()
GUIDelete(@GUI_WinHandle)
WinSetState($39, Null, @SW_ENABLE )
WinSetState($39, Null, @SW_SHOW )
WinActivate($39, Null )
EndFunc
Func _an()
For $2z=0 To $2a
$2b[$2z] = GUICtrlRead($3x[$2z])
$2p[$2z] = GUICtrlRead($3y[$2z])
$2h[$2z] = GUICtrlRead($3z[$2z])
$2i[$2z] = GUICtrlRead($40[$2z])
$2c[$2z] = GUICtrlRead($41[$2z])
$2d[$2z] = GUICtrlRead($43[$2z])
$2e[$2z] = GUICtrlRead($44[$2z])
$2g[$2z] = GUICtrlRead($45[$2z])
$2f[$2z] = GUICtrlRead($46[$2z])
$2j[$2z] = GUICtrlRead($47[$2z])
$2k[$2z] = GUICtrlRead($48[$2z])
Next
_a8()
$3k = GUICtrlRead($3j)
IniWrite($2s, "system", "tabs", $3k-1)
Switch GUICtrlRead($4a)
Case 1
$2u = 1
Case Else
$2u = 0
EndSwitch
_a9()
Select
Case $3k <> $2a+1
MsgBox(4096, "Настройки : вкладки" , "Настройки изменены" & @CRLF & "Текущие вкладки: " & $2a+1 & @CRLF & "После перезапуска: " & $3k & " вкладок")
EndSelect
_am()
EndFunc
Func _ap()
For $2z = 0 to $2a
Local $53 = $3v[$2z] & DllCall('user32.dll', 'bool', 'OemToChar', 'str', StdoutRead($3u[$2z]), 'str', StdoutRead($3u[$2z]))[2]
Local $3l = StringLen($53 )
Local $54 = GUICtrlRecvMsg($3s[$2z],0xB0 )
Select
Case $53 <> $3v[$2z]
$3v[$2z] = $53
Select
Case $3l > $2v
Local $34 = @WorkingDir & "\tmp\zLog" & "_" & $2z & "_" & @YEAR & @MON & @MDAY & "." & @MIN & @SEC & ".txt"
$36 = FileOpen($34, 1)
FileWrite($36, $3v[$2z] & @CRLF & ">" & $3l & "<")
FileClose($36)
$3v[$2z] = "Превышено " & $3l & " знаков." & @CRLF & "Прошлый вывод сохранён в " & $34 & @CRLF
$3l = 0
EndSelect
$53 = 1
Case Else
$53 = 0
EndSelect
If @error Or(Not @error And $54[0] = $54[1]) Then
Select
Case $53
GUICtrlSetData($3s[$2z], $3v[$2z])
GUICtrlSendMsg($3s[$2z], $b, 7, 0)
EndSelect
Else
Select
Case $3h
$3h = 0
EndSelect
EndIf
Next
EndFunc
Func _aq()
Local $3w = GUICtrlRead($3m)-1
For $2z = 0 to $2a
Local $53 = $3v[$2z] & DllCall('user32.dll', 'bool', 'OemToChar', 'str', StdoutRead($3u[$2z]), 'str', StdoutRead($3u[$2z]))[2]
Select
Case $3w > -1
Local $54 = GUICtrlRecvMsg($3s[$3w], 0xB0 )
EndSelect
Select
Case $53 <> $3v[$2z]
$3v[$2z] = $53
$53 = 1
Case Else
$53 = 0
EndSelect
If @error Or(Not @error And $54[0] = $54[1]) Then
Select
Case $53
GUICtrlSetData($3s[$3w], $3v[$3w])
GUICtrlSendMsg($3s[$3w], $b, 7, 0)
EndSelect
Else
Select
Case $3h
$3h = 0
AdlibRegister("_ar", $2x)
EndSelect
EndIf
Next
EndFunc
Func _ar()
Local $3w = GUICtrlRead($3m)-1
GUICtrlSendMsg($3s[$3w], $c, -1, 0)
GUICtrlSendMsg($3s[$3w], $b, 7, 0)
AdlibUnRegister("_ar")
$3h = 1
EndFunc
Func _as()
Local $3w = GUICtrlRead($3m)-1
$3u[$3w] = Run(@ComSpec, Null, @SW_HIDE, $o + $p)
If ProcessExists($3u[$3w] ) Then GUICtrlSetBkColor($4b[$3w], $4c)
$2m[$3w] = $3u[$3w]
_a8()
GUICtrlSetState($3b[$3w], $3)
GUICtrlSetState($3c[$3w], $2)
GUICtrlSetState($3i, $2)
StdinWrite($3u[$3w], $2y[$3w])
EndFunc
Func _at()
Local $3w = GUICtrlRead($3m)-1
GUICtrlSetState($3c[$3w], $3)
GUICtrlSetState($3b[$3w], $2)
Local $55 = $3u[$3w]
Local $3g = _98($55)
If Not @error Then
For $56 = 1 To $3g[0][0]
ProcessClose($3g[$56][0])
Next
ProcessClose($55)
If Not ProcessExists($3u[$3w] ) Then GUICtrlSetBkColor($4b[$3w], $4d)
EndIf
EndFunc
Func _au()
For $2z=0 To $2a
Select
Case ControlCommand($39, '', $3c[$2z], 'IsEnabled')
GUICtrlSetState($3b[$2z], $2)
GUICtrlSetState($3c[$2z], $3)
Local $55 = $3u[$2z]
Local $3g = _98($55)
If Not @error Then
For $56 = 1 To $3g[0][0]
ProcessClose($3g[$56][0])
Next
ProcessClose($55)
EndIf
EndSelect
If Not ProcessExists($3u[$2z] ) Then GUICtrlSetBkColor($4b[$2z], $4d)
Next
GUICtrlSetState($3i, $3)
EndFunc
Func _av()
Local $3w = GUICtrlRead($3m)-1
GUICtrlSetData($3s[$3w], Null)
$3v[$3w] = Null
EndFunc
Func _aw()
Switch $2u
Case 1
_ax()
Case Else
_ay()
EndSwitch
EndFunc
Func _ax()
WinSetState($39, Null, @SW_HIDE )
EndFunc
Func _ay()
_az()
IniDelete($2t, "RUN" )
_af()
Exit
EndFunc
Func _az()
For $2z = 0 To $2a
Local $55 = $3u[$2z]
Local $3g = _98($55)
If Not @error Then
For $56 = 1 To $3g[0][0]
ProcessClose($3g[$56][0])
Next
EndIf
Next
EndFunc
Func _b0()
EndFunc
Func _b1()
ShellExecute(@SystemDir & '\taskmgr.exe', '', '', '', @SW_SHOW)
EndFunc
Func _b2()
ShellExecute(@SystemDir & '\mmc.exe', @SystemDir & "\devmgmt.msc", '', '', @SW_SHOW)
EndFunc
Func _b3()
ShellExecute(@SystemDir & '\cmd.exe', '', '', '', @SW_SHOW)
EndFunc
Func _b4()
ShellExecute(@SystemDir & '\calc.exe', '', '', '', @SW_SHOW)
EndFunc
Func _b5()
ShellExecute(@SystemDir & '\msconfig.exe', '', '', '', @SW_SHOW)
EndFunc
