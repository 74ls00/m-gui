#include <GuiConstantsEx.au3>
#include <ScrollBarConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <WinAPIMisc.au3>
#include <WinAPIProc.au3>
#include <WinAPI.au3>
#include <GuiButton.au3>
#include <GuiImageList.au3>

AutoItSetOption("TrayAutoPause", 0)

Global Const $WA_ACTIVE = 1
Global Const $WA_CLICKACTIVE = 2
Global Const $WA_INACTIVE = 0
Global $hGUI, $iBtnStart, $iBtnStop, $iBtnClean, $iBtnPause, $iBtnUnPause, $iEdt, $iPID, $aPIDs, $sOut, $iUnSel = 1
$sLine = "ping -t 8.8.8.8" & @CRLF

Dim $hImage ; элемент иконок кнопки
; размеры gui
Dim $NameGUI = "AiGUI"
Dim $WWidth = 670 , $WHeight = 450 ; ширина и высота окна
Dim $StrTool = 35 ; сверху первая строка под вкладкой.
Dim $THeight = $WHeight-75 ; высота консоли
;пользовательские настройки
Dim $windowTabs=1

Dim $info[$windowTabs+1],$mpath[$windowTabs+1],$name[$windowTabs+1],$server[$windowTabs+1],$port[$windowTabs+1],$user[$windowTabs+1]
Dim $iBtnStart[$windowTabs+1],$iBtnStop[$windowTabs+1],$iBtnClean[$windowTabs+1],$iBtnUnPause[$windowTabs+1],$iEdt[$windowTabs+1],$iBtnPause[$windowTabs+1]
For $i = 0 To $windowTabs
   $info[$i] = "tabs " & $i
   $mpath[$i] = $i
   $name[$i] = $i
   $server[$i] = $i
   $port[$i] = $i
   $user[$i] = $i
Next

$iPID = Run(@ComSpec, Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
OnAutoItExitRegister("_OnExit")

$hGUI = GUICreate("",$WWidth,$WHeight)

GUICtrlCreateTab(5, 5, $WWidth-10, $WHeight-10) ;создать вкладки с отступом 5 по краям окна, и 5 внутри

GUICtrlCreateTabItem(" Панель "); Первая вкладка для инструментов


For $t = 0 To $windowTabs
GUICtrlCreateTabItem($info[$t]) ; Вкладка первой программы
$iBtnStart = GUICtrlCreateButton("Старт", 14, $THeight+40 , 80, 25, $BS_DEFPUSHBUTTON)
$iBtnStop = GUICtrlCreateButton("Стоп", 100, $THeight+40, 80, 25, 0x01) ; $BS_DEFPUSHBUTTON
GUICtrlSetState(-1, $GUI_DISABLE)
$iBtnClean = GUICtrlCreateButton("Очистить", 180, $THeight+40, 80, 25)

$iEdt = GUICtrlCreateEdit(Null, 14, $StrTool, $WWidth-30, $THeight, BitOR($ES_READONLY, $ES_AUTOVSCROLL, $WS_VSCROLL))
GUICtrlSendMsg(-1, $EM_LIMITTEXT, -1, 0)
GUIRegisterMsg($WM_ACTIVATE, "WM_ACTIVATE")
Next

GUISetState()

While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            Exit

			Case $iBtnStart
            GUICtrlSetState($iBtnStart, $GUI_DISABLE)
            GUICtrlSetState($iBtnStop, $GUI_ENABLE)
            StdinWrite($iPID, $sLine)

        Case $iBtnClean
            GUICtrlSetData($iEdt, Null)
            $sOut = Null
        Case $iBtnStop
            GUICtrlSetState($iBtnStop, $GUI_DISABLE)
            GUICtrlSetState($iBtnStart, $GUI_ENABLE)
            $aPIDs = _WinAPI_EnumChildProcess($iPID)
            If Not @error Then
                For $n = 1 To $aPIDs[0][0]
                    ProcessClose($aPIDs[$n][0])
                Next
            EndIf
    EndSwitch

WEnd




Func WM_ACTIVATE($hWnd, $iMsg, $wParam, $lParam)
    Switch _WinAPI_LoWord($wParam)
        Case $WA_ACTIVE, $WA_CLICKACTIVE
            AdlibRegister("_Update")
    ;    Case $WA_INACTIVE
    ;        AdlibUnRegister("_Update")
    EndSwitch
EndFunc   ;==>WM_ACTIVATE

Func _Update()
    Local $vTemp = $sOut & _WinAPI_OemToChar(StdoutRead($iPID)), $aSel = GUICtrlRecvMsg($iEdt, $EM_GETSEL)
Select
    Case $vTemp <> $sOut
		 $sOut = $vTemp
		 $vTemp = 1
    Case Else
		 $vTemp = 0
EndSelect
    If @error Or (Not @error And $aSel[0] = $aSel[1]) Then
Select
    Case $vTemp
		 GUICtrlSetData($iEdt, $sOut)
		 GUICtrlSendMsg($iEdt, $EM_SCROLL, $SB_BOTTOM, 0)
EndSelect
	  Else
Select
    Case $iUnSel
		 $iUnSel = 0
		 AdlibRegister("_UnSel", 5000)
EndSelect
    EndIf
EndFunc   ;==>_Update



Func _UnSel()
    GUICtrlSendMsg($iEdt, $EM_SETSEL, -1, 0)
    GUICtrlSendMsg($iEdt, $EM_SCROLL, $SB_BOTTOM, 0)
    AdlibUnRegister("_UnSel")
    $iUnSel = 1
EndFunc   ;==>_UnSel


Func _OnExit()
    Local $aPIDs = _WinAPI_EnumChildProcess($iPID)
   Select
	  Case Not @error
		 For $n = 1 To $aPIDs[0][0]
            ProcessClose($aPIDs[$n][0])
		 Next
   EndSelect
    ProcessClose($iPID)
EndFunc   ;==>_OnExit

