
Global $sysini = @WorkingDir & "\system.ini"


;$num = "AiGUI    0.180117.1915 dev3 - Администратор"
;$num = 0049055A
;$num = "[Class:AutoIt v3 GUI]"

;$num = WinGetHandle ( "AiGUI    0.180117.1915 dev3 - Администратор" )

;$num = WinGetHandle ( "Безымянный — Блокнот" )

;$num1 =  "0x" & Hex(IniRead ($sysini,"RUN","RunGUIh", Null),8)



;$num = HWnd ( $num1)
$num = HWnd (     IniRead ($sysini,"RUN","RunGUIh", Null)   )




WinActivate( $num )
MsgBox(262144, "",  $num)

;WinSetState ( $num  , "", @SW_SHOW )

;$hWnd = WinGetHandle("[ACTIVE]")
;MsgBox(4096, "", $hWnd)