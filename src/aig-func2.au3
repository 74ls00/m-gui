;in3.3.14.2

;Constants.au3

;TrayConstants.au3
;Global Const $TRAY_EVENT_PRIMARYUP = -8
;end TrayConstants.au3
;end Constants.au3

;ButtonConstants.au3
Global Const $BCM_FIRST = 0x1600
Global Const $BCM_SETIMAGELIST = ($BCM_FIRST + 0x0002)
Global Const $BS_ICON = 0x0040
Global Const $BS_DEFPUSHBUTTON = 0x0001
Global Const $BS_RIGHTBUTTON = 0x0020

;end ButtonConstants.au3


;MenuConstants.au3
;Global Const $MF_BYPOSITION = 0x00000400
;end MenuConstants.au3


; GuiMenu.au3

Func _GUICtrlMenu_DeleteMenu($hMenu, $iItem, $bByPos = True)
	Local $iByPos = 0

	If $bByPos Then $iByPos = 0x00000400;$MF_BYPOSITION
	Local $aResult = DllCall("user32.dll", "bool", "DeleteMenu", "handle", $hMenu, "uint", $iItem, "uint", $iByPos)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] = 0 Then Return SetError(10, 0, False)

	_GUICtrlMenu_DrawMenuBar(_GUICtrlMenu_FindParent($hMenu))
	Return True
EndFunc   ;==>_GUICtrlMenu_DeleteMenu

Func _GUICtrlMenu_GetSystemMenu($hWnd, $bRevert = False)
	Local $aResult = DllCall("user32.dll", "hwnd", "GetSystemMenu", "hwnd", $hWnd, "int", $bRevert)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_GetSystemMenu

Func _GUICtrlMenu_FindParent($hMenu)
	Local $hList = _WinAPI_EnumWindowsTop()
	For $iI = 1 To $hList[0][0]
		If _GUICtrlMenu_GetMenu($hList[$iI][0]) = $hMenu Then Return $hList[$iI][0]
	Next
EndFunc   ;==>_GUICtrlMenu_FindParent

Func _GUICtrlMenu_DrawMenuBar($hWnd)
	Local $aResult = DllCall("user32.dll", "bool", "DrawMenuBar", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_DrawMenuBar

Func _GUICtrlMenu_GetMenu($hWnd)
	Local $aResult = DllCall("user32.dll", "handle", "GetMenu", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_GUICtrlMenu_GetMenu



;end GuiMenu.au3
