#include-once

;GuiImageList.au3;
;#include "ColorConstants.au3";
;#include "ImageListConstants.au3" ;!
;#include "StructureConstants.au3";

;GuiButton.au3
;#include "ButtonConstants.au3";
;#include "UDFGlobalID.au3";
;#include "SendMessage.au3";

;end include


;ImageListConstants.au3
;#CONSTANTS# ===================================================================================================================
;Global Const $ILC_COLOR = 0x00000000
;Global Const $ILC_COLOR4 = 0x00000004
;Global Const $ILC_COLOR8 = 0x00000008
;Global Const $ILC_COLOR16 = 0x00000010
;Global Const $ILC_COLOR24 = 0x00000018
;Global Const $ILC_COLOR32 = 0x00000020
;Global Const $ILC_COLORDDB = 0x000000FE
;Global Const $ILC_MASK = 0x00000001
;Global Const $ILC_MIRROR = 0x00002000


;end ImageListConstants.au3



;GuiButton.au3
; #CONSTANTS# ===================================================================================================================
;Global Const $tagBUTTON_IMAGELIST = "ptr ImageList;" & $tagRECT & ";uint Align"
;Global Const $__BUTTONCONSTANT_ClassName = "Button"

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_Enable($hWnd, $bEnable = True)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	If _WinAPI_IsClassName($hWnd, "Button") Then Return _WinAPI_EnableWindow($hWnd, $bEnable) = $bEnable;$__BUTTONCONSTANT_ClassName
EndFunc   ;==>_GUICtrlButton_Enable


; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlButton_SetImageList($hWnd, $hImage, $nAlign = 0, $iLeft = 1, $iTop = 1, $iRight = 1, $iBottom = 1)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	If $nAlign < 0 Or $nAlign > 4 Then $nAlign = 0

	Local $tBUTTON_IMAGELIST = DllStructCreate("ptr ImageList;" & $tagRECT & ";uint Align");$tagBUTTON_IMAGELIST

	DllStructSetData($tBUTTON_IMAGELIST, "ImageList", $hImage)
	DllStructSetData($tBUTTON_IMAGELIST, "Left", $iLeft)
	DllStructSetData($tBUTTON_IMAGELIST, "Top", $iTop)
	DllStructSetData($tBUTTON_IMAGELIST, "Right", $iRight)
	DllStructSetData($tBUTTON_IMAGELIST, "Bottom", $iBottom)
	DllStructSetData($tBUTTON_IMAGELIST, "Align", $nAlign)

	Local $bEnabled = _GUICtrlButton_Enable($hWnd, False)
	Local $iRet = _SendMessage($hWnd, $BCM_SETIMAGELIST, 0, $tBUTTON_IMAGELIST, 0, "wparam", "struct*") <> 0
	_GUICtrlButton_Enable($hWnd)
	If Not $bEnabled Then _GUICtrlButton_Enable($hWnd, False)
	Return $iRet
EndFunc   ;==>_GUICtrlButton_SetImageList


;end GuiButton.au3




;GuiImageList.au3

;#FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_Create($iCX = 16, $iCY = 16, $iColor = 4, $iOptions = 0, $iInitial = 4, $iGrow = 4)
	Local Const $aColor[7] = [0x00000000, 0x00000004, 0x00000008, 0x00000010, 0x00000018, 0x00000020, 0x000000FE]
	;Local Const $aColor[7] = [$ILC_COLOR, $ILC_COLOR4, $ILC_COLOR8, $ILC_COLOR16, $ILC_COLOR24, $ILC_COLOR32, $ILC_COLORDDB]
	Local $iFlags = 0

	If BitAND($iOptions, 1) <> 0 Then $iFlags = BitOR($iFlags, 0x00000001);$ILC_MASK
	If BitAND($iOptions, 2) <> 0 Then $iFlags = BitOR($iFlags, 0x00002000);$ILC_MIRROR
	If BitAND($iOptions, 4) <> 0 Then $iFlags = BitOR($iFlags, 0x00008000);$ILC_PERITEMMIRROR
	$iFlags = BitOR($iFlags, $aColor[$iColor])
	Local $aResult = DllCall("comctl32.dll", "handle", "ImageList_Create", "int", $iCX, "int", $iCY, "uint", $iFlags, "int", $iInitial, "int", $iGrow)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_GUIImageList_Create

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _GUIImageList_AddIcon($hWnd, $sFile, $iIndex = 0, $bLarge = False)
	Local $iRet, $tIcon = DllStructCreate("handle Handle")
	If $bLarge Then
		$iRet = _WinAPI_ExtractIconEx($sFile, $iIndex, $tIcon, 0, 1)
	Else
		$iRet = _WinAPI_ExtractIconEx($sFile, $iIndex, 0, $tIcon, 1)
	EndIf
	If $iRet <= 0 Then Return SetError(-1, $iRet, -1)

	Local $hIcon = DllStructGetData($tIcon, "Handle")
	$iRet = _GUIImageList_ReplaceIcon($hWnd, -1, $hIcon)
	_WinAPI_DestroyIcon($hIcon)
	If $iRet = -1 Then Return SetError(-2, $iRet, -1)
	Return $iRet
EndFunc   ;==>_GUIImageList_AddIcon

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (GaryFrost) changed return type from hwnd to int
; ===============================================================================================================================
Func _GUIImageList_ReplaceIcon($hWnd, $iIndex, $hIcon)
	Local $aResult = DllCall("comctl32.dll", "int", "ImageList_ReplaceIcon", "handle", $hWnd, "int", $iIndex, "handle", $hIcon)
	If @error Then Return SetError(@error, @extended, -1)
	Return $aResult[0]
EndFunc   ;==>_GUIImageList_ReplaceIcon

;end GuiImageList.au3




