$GUI = GUICreate("Console")
$Btn = GUICtrlCreateButton("Enter", 350, 5, 45, 20, 0x01) ; $BS_DEFPUSHBUTTON
$Edt = GUICtrlCreateEdit("", 5, 30, 390, 365, 0x200840) ; $ES_READONLY + $ES_AUTOVSCROLL + $WS_VSCROLL
GUICtrlSendMsg(-1, 0xC5, -1, 0) ; $EM_LIMITTEXT
GUISetState(@SW_SHOW)

$PID = Run(@ComSpec, "", @SW_HIDE, 9)
Sleep(100)
$Out = StdoutRead($PID)
GUICtrlSetData($Edt, DllCall('user32.dll', 'bool', 'OemToChar', 'str', $Out, 'str', $Out)[2])
 $Line = @ComSpec & " /c ping -t ya.ru"

Do
  Switch GUIGetMsg()
    Case -3
      Exit
    Case $Btn
      StdinWrite($PID, DllCall('user32.dll', 'bool', 'CharToOem', 'str', $Line, 'str', $Line)[2] & @CRLF)
      Sleep(100)
   EndSwitch
   $Out = StdoutRead($PID)
      GUICtrlSetData($Edt, DllCall('user32.dll', 'bool', 'OemToChar', 'str', $Out, 'str', $Out)[2], 1)
Until 0