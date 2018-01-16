#Region Header

#CS
	Name:				GUIHyperLink UDF
	Author:				Copyright © 2011-2013 CreatoR's Lab (G.Sandler), www.creator-lab.ucoz.ru, www.autoit-script.ru. All rights reserved.
	AutoIt version:		3.3.6.1 - 3.3.10.2
	UDF version:		1.2

	History:
						v1.2
						* Attempt to fix the issue when sometimes script crashed with error: "Array variable has incorrect number of subscripts or subscript dimension range exceeded".

						v1.1
						+ Added _GUICtrlHyperLink_SetData function. Sets HyperLink control data.
						* Changed example.
						* Fixed "THIS" issue, now use @THIS@ instead.
						* Fixed issue with receiving clicks even if the HyperLink label is under other window (the main window not active).
						* Fixed issue with receiving clicks when the mouse "down click" was made not on the label control.

						v1.0
						* First public vesrion.
#CE

;Includes
#include-once
;#include <GUIConstantsEx.au3>

#EndRegion Header

#Region Global Variables

Global $aGCHL_Ctrls[1][1]
Global $iGCHL_MouseHeldDown = 0

Global $sysini , $webbrowser


#EndRegion Global Variables

#Region Example

#CS

#include <GUIConstantsEx.au3>
#include "GUIHyperLink.au3"

$hGUI = GUICreate("GUIHyperLink UDF Demo!", 300, 200)

$nAutoItScript_Com_HyperLink = _GUICtrlHyperLink_Create("AutoIt Official Website", 100, 50, 110, 15, 0x0000FF, 0x551A8B, _
	-1, 'http://google.com', 'Visit: www.google.com', $hGUI) ;Intentionally set as google.com, will change later

$nAutoItScript_Ru_HyperLink = _GUICtrlHyperLink_Create("AutoIt Russian Community", 90, 80, 130, 15, 0x0000FF, 0x551A8B, _
	-1, 'http://autoit-script.ru', 'Visit: www.autoit-script.ru', $hGUI)

$nCreatoRLab_HyperLink = _GUICtrlHyperLink_Create("CreatoR's Lab", 120, 110, 70, 15, 0x0000FF, 0x551A8B, _
	1, '_CreatoRLab_ShowInfo(@THIS@, ' & $hGUI & ')', 'Show website information...', $hGUI)

_GUICtrlHyperLink_SetData($nAutoItScript_Com_HyperLink, 2, 'www.autoitscript.com')
GUICtrlSetTip($nAutoItScript_Com_HyperLink, 'Visit: www.autoitscript.com')

GUISetState(@SW_SHOW, $hGUI)

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd

Func _CreatoRLab_ShowInfo($nCtrlID, $h_GUI)
	MsgBox(64, 'Info', 'HyperLink Clicked:' & @CRLF & GUICtrlRead($nCtrlID), 0, $h_GUI)
EndFunc

#CE

#EndRegion Example

#Region Public Functions

; #FUNCTION# ====================================================================================================
; Name...........:	_GUICtrlHyperLink_Create
; Description....:	Creates HyperLink control (from label).
;
; Syntax.........:	_GUICtrlHyperLink_Create($sText, $iLeft, $iTop [, $iWidth=-1 [, $iHeight=-1 [, $iColor=0x0000FF [, $iVisitedColor=0x551A8B [, $sActionURL='' [, $iAction=-1 [, $sToolTip='' [, $hWnd=0 ]]]]]]]])
;
; Parameters.....:	$sText         - HyperLink text.
;					$iLeft         - The left side of the control. If -1 is used then left will be computed according to GUICoordMode.
;					$iTop          - The top of the control. If -1 is used then top will be computed according to GUICoordMode.
;					$iWidth        - [Optional] The width of the control (default text autofit in width).
;					$iHeight       - [Optional] The height of the control (default text autofit in height).
;					$iColor        - [Optional] Label color. Default is 0x0000FF (blue).
;					$iVisitedColor - [Optional] Label color after the HyperLink been visited (clicked). Default is 0x551A8B.
;					$iAction       - [Optional] Defines the action to perform with $sActionURL (next parameter). Default is -1 - ShellExecute the url.
;					$sActionURL    - [Optional] URL to ShellExecte, or the function execute string. Default is "", label text used as url.
;                                       If you set function string to execute (i.e: 'MyFunc("THIS")'), then Execute command is performed instead of ShellExecute.
;                                       "THIS" in function parameter will be replaced with control id of the HyperLink.
;					$sToolTip      - [Optional] ToolTip text of the control.
;					$hWnd          - [Optional] The window handle to use as the parent for this control.
;
; Return values..:	Success        - Returns the identifier (controlID) of the new control.
;					Failure        - Returns 0.
;
; Author.........:	G.Sandler (CreatoR).
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:	Yes.
; ===============================================================================================================
Func _GUICtrlHyperLink_Create($sText, $iLeft, $iTop, $iWidth = -1, $iHeight= - 1, $iColor = 0x0000FF, $iVisitedColor = 0x551A8B, $iAction = -1, $sActionURL = "", $sToolTip = "", $hWnd = 0)
	Local $nID = GUICtrlCreateLabel($sText, $iLeft, $iTop, $iWidth, $iHeight)

	If $nID Then
		GUICtrlSetFont($nID, -1, -1, 4)
		GUICtrlSetColor($nID, $iColor)
		GUICtrlSetCursor($nID, 0)
		GUICtrlSetTip($nID, $sToolTip)
	EndIf

	Local $iPreCount = $aGCHL_Ctrls[0][0]

	$aGCHL_Ctrls[0][0] += 1
	ReDim $aGCHL_Ctrls[$aGCHL_Ctrls[0][0]+1][5]

	$aGCHL_Ctrls[$aGCHL_Ctrls[0][0]][0] = $hWnd
	$aGCHL_Ctrls[$aGCHL_Ctrls[0][0]][1] = $nID
	$aGCHL_Ctrls[$aGCHL_Ctrls[0][0]][2] = $iAction
	$aGCHL_Ctrls[$aGCHL_Ctrls[0][0]][3] = $sActionURL
	$aGCHL_Ctrls[$aGCHL_Ctrls[0][0]][4] = $iVisitedColor

	If $iPreCount = 0 Then
		AdlibRegister("__GUICtrlHyperLink_Handler", 10)
	EndIf

	Return $nID
EndFunc

; #FUNCTION# ====================================================================================================
; Name...........:	_GUICtrlHyperLink_Delete
; Description....:	Deletes HyperLink control.
; Syntax.........:	_GUICtrlHyperLink_Delete($nCtrlID)
; Parameters.....:	$nCtrlID - Control ID as returned by _GUICtrlHyperLink_Create.
;
; Return values..:	Success - Returns 1 if control has been deleted.
;					Failure - Returns 0.
;
; Author.........:	G.Sandler (CreatoR).
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _GUICtrlHyperLink_Delete($nCtrlID)
	Local $aTmp[1][1], $iRet = 0

	For $i = 1 To $aGCHL_Ctrls[0][0]
		If $aGCHL_Ctrls[$i][1] = $nCtrlID Then
			$iRet = GUICtrlDelete($nCtrlID)
		Else
			$aTmp[0][0] =+ 1
			ReDim $aTmp[$aTmp[0][0]+1][5]

			$aTmp[$aTmp[0][0]][0] = $aGCHL_Ctrls[$i][0]
			$aTmp[$aTmp[0][0]][1] = $aGCHL_Ctrls[$i][1]
			$aTmp[$aTmp[0][0]][2] = $aGCHL_Ctrls[$i][2]
			$aTmp[$aTmp[0][0]][3] = $aGCHL_Ctrls[$i][3]
			$aTmp[$aTmp[0][0]][4] = $aGCHL_Ctrls[$i][4]
		EndIf
	Next

	$aGCHL_Ctrls = $aTmp

	If $aGCHL_Ctrls[0][0] = 0 Then
		AdlibUnRegister("__GUICtrlHyperLink_Handler")
	EndIf

	Return $iRet
EndFunc

; #FUNCTION# ====================================================================================================
; Name...........:	_GUICtrlHyperLink_SetData
; Description....:	Sets HyperLink control data.
; Syntax.........:	_GUICtrlHyperLink_SetData($nCtrlID, $iData, $vNewData)
; Parameters.....:	$nCtrlID  - Control ID as returned by _GUICtrlHyperLink_Create.
;                   $iData    - Data element index. The following indexes are supported:
;                                          1 - $iAction
;                                              (Defines the action to perform with $sActionURL, see this parameter in description for _GUICtrlHyperLink_Create)
;                                          2 - $sActionURL
;                                              (URL to ShellExecte, or the function execute string)
;                                          3 - $iVisitedColor
;                                              (Label color after the HyperLink been visited/clicked)
;					$vNewData - New data to set.
;
; Return values..:	Success - Returns 1 if the data has been set.
;					Failure - Set @error to 1 if the $iData is wrong value (< 1 and > 3), and returns 0 in any case of failure.
;
; Author.........:	G.Sandler (CreatoR).
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
;						2018.01.16	* Убрал возможность запуска Execute($sActionURL) при пустой ссылке
;
; ===============================================================================================================
Func _GUICtrlHyperLink_SetData($nCtrlID, $iData, $vNewData)
	If $iData < 1 Or $iData > 3 Then
		Return SetError(1, 0, 0)
	EndIf

	$iData += 1

	For $i = 1 To $aGCHL_Ctrls[0][0]
		If $aGCHL_Ctrls[$i][1] = $nCtrlID Then
			$aGCHL_Ctrls[$i][$iData] = $vNewData
			Return 1
		EndIf
	Next

	Return 0
EndFunc

#EndRegion Public Functions

#Region Internal Functions

;Main "clicks handler"
Func __GUICtrlHyperLink_Handler()
	Local $hWnd, $iCtrlID, $sActionURL, $iAction = -1, $iVisitedColor = 0x551A8B
	Local $aCurInfo, $iFlag

	For $i = 1 To $aGCHL_Ctrls[0][0]
;~ 		If UBound($aGCHL_Ctrls, 0) < 2 Or $i > UBound($aGCHL_Ctrls) Then
;~ 			ExitLoop
;~ 		EndIf

		$hWnd = $aGCHL_Ctrls[$i][0]
		$iCtrlID = $aGCHL_Ctrls[$i][1]
		$iAction = $aGCHL_Ctrls[$i][2]
		$sActionURL = $aGCHL_Ctrls[$i][3]
		$iVisitedColor = $aGCHL_Ctrls[$i][4]

		If BitAND(GUICtrlGetState($iCtrlID), 128) Then;$GUI_DISABLE
			ContinueLoop
		EndIf

		$aCurInfo = GUIGetCursorInfo($hWnd)

		If Not IsArray($aCurInfo) Then
			ContinueLoop
		EndIf

		If $iGCHL_MouseHeldDown And $aCurInfo[2] = 0 And WinActive($hWnd) Then
			$iGCHL_MouseHeldDown = 0
			ExitLoop
		EndIf

		If $aCurInfo[4] = 0 And $aCurInfo[2] = 1 And WinActive($hWnd) Then
			$iGCHL_MouseHeldDown = 1
			ExitLoop
		EndIf

		If Not $iGCHL_MouseHeldDown And $aCurInfo[4] = $iCtrlID And $aCurInfo[2] = 1 And WinActive($hWnd) Then
			$iFlag = 0

			While IsArray($aCurInfo) And $aCurInfo[2] = 1
				$aCurInfo = GUIGetCursorInfo($hWnd)

				If $iFlag = 0 And $aCurInfo[4] <> $iCtrlID Then
					GUISetCursor(7, 1, $hWnd)
					$iFlag = 1
				ElseIf $iFlag = 1 And $aCurInfo[4] = $iCtrlID Then
					GUISetCursor(2, 0, $hWnd)
					$iFlag = 0
				EndIf

				Sleep(10)
			WEnd

			GUISetCursor(2, 0, $hWnd)
#cs
			If IsArray($aCurInfo) And $aCurInfo[2] = 0 And $aCurInfo[4] = $iCtrlID Then
				$sActionURL = StringReplace($sActionURL, '@THIS@', $iCtrlID)

				If $sActionURL = '' Then
					$sActionURL = GUICtrlRead($iCtrlID)
				EndIf

				If $iAction = 1 Then
					Execute($sActionURL)
				ElseIf $iAction = -1 Then
					ShellExecute($sActionURL)
				EndIf

				If @error = 0 And $iVisitedColor Then
					GUICtrlSetColor($iCtrlID, $iVisitedColor)
				EndIf

				Return
			EndIf
#ce
Select
	Case IsArray($aCurInfo) And $aCurInfo[2] = 0 And $aCurInfo[4] = $iCtrlID
		$sActionURL = StringReplace($sActionURL, '@THIS@', $iCtrlID)

		;это выкидываем
		;Select
		;	Case $sActionURL = ''
		;		$sActionURL = GUICtrlRead($iCtrlID)
		;EndSelect
Select
	Case $sActionURL <> ''
		Switch $iAction
			Case 1
				Execute($sActionURL)
			Case -1
				;Global $webbrowser
				$webbrowser = IniRead ($sysini,"GUI","WebBrowser", $webbrowser)
				;MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, 'Selection:' & @CRLF & '$webbrowser' & @CRLF & @CRLF & 'Return:' & @CRLF & $webbrowser) ;### Debug MSGBOX
				Switch $webbrowser
					Case "0"
						ShellExecute($sActionURL)
					Case Else
						ShellExecute('"' & $webbrowser & '"', $sActionURL,'','', @SW_SHOW)
				EndSwitch
				;



		EndSwitch
	Case Else
		;$sActionURL = GUICtrlRead($iCtrlID) ;это экономим
			Switch $iAction
				Case 1
					;Execute($sActionURL)
					Execute(GUICtrlRead($iCtrlID))
				;Case -1 ;а это вырубаем
					;ShellExecute($sActionURL)
					;ShellExecute(GUICtrlRead($iCtrlID))
			EndSwitch
EndSelect
		Select
			Case @error = 0 And $iVisitedColor
				GUICtrlSetColor($iCtrlID, $iVisitedColor)
		EndSelect
	Return
EndSelect
;.
			ExitLoop
		EndIf
	Next
EndFunc

#EndRegion Internal Functions
