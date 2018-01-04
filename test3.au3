#include <GuiConstantsEx.au3>
#include <ScrollBarConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <WinAPIMisc.au3>
#include <WinAPIProc.au3>
#include <WinAPI.au3>
Global Const $WA_ACTIVE = 1
Global Const $WA_CLICKACTIVE = 2
Global Const $WA_INACTIVE = 0
Global $hGUI, $iBtnStart, $iBtnStop, $iBtnClean, $iBtnPause, $iBtnUnPause, $iEdt, $iPID, $aPIDs, $sOut, $iUnSel = 1, $sLine = "ping -t 8.8.8.8" & @CRLF

$iPID = Run(@ComSpec, Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
OnAutoItExitRegister("_OnExit")
$hGUI = GUICreate("������", 430)
$iBtnStart = GUICtrlCreateButton("�����", 5, 5, 80, 25, $BS_DEFPUSHBUTTON)
$iBtnStop = GUICtrlCreateButton("����", 90, 5, 80, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$iBtnClean = GUICtrlCreateButton("��������", 175, 5, 80, 25)
$iBtnPause = GUICtrlCreateButton("�����", 260, 5, 80, 25)
$iBtnUnPause = GUICtrlCreateButton("����������", 345, 5, 80, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$iEdt = GUICtrlCreateEdit(Null, 5, 35, 420, 360, BitOR($ES_READONLY, $ES_AUTOVSCROLL, $WS_VSCROLL))
GUICtrlSendMsg(-1, $EM_LIMITTEXT, -1, 0)
GUIRegisterMsg($WM_ACTIVATE, "WM_ACTIVATE")
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
                For $i = 1 To $aPIDs[0][0]
                    ProcessClose($aPIDs[$i][0])
                Next
            EndIf
        Case $iBtnPause
            GUICtrlSetState($iBtnPause, $GUI_DISABLE)
            GUICtrlSetState($iBtnUnPause, $GUI_ENABLE)
            AdlibUnRegister("_Update")
            GUIRegisterMsg($WM_ACTIVATE, Null)
        Case $iBtnUnPause
            GUICtrlSetState($iBtnUnPause, $GUI_DISABLE)
            GUICtrlSetState($iBtnPause, $GUI_ENABLE)
            AdlibRegister("_Update")
            GUIRegisterMsg($WM_ACTIVATE, "WM_ACTIVATE")
    EndSwitch
WEnd

Func WM_ACTIVATE($hWnd, $iMsg, $wParam, $lParam)
    Switch _WinAPI_LoWord($wParam)
        Case $WA_ACTIVE, $WA_CLICKACTIVE
            AdlibRegister("_Update")
        Case $WA_INACTIVE
            AdlibUnRegister("_Update")
    EndSwitch
EndFunc   ;==>WM_ACTIVATE

Func _Update()
    Local $vTemp = $sOut & _WinAPI_OemToChar(StdoutRead($iPID)), $aSel = GUICtrlRecvMsg($iEdt, $EM_GETSEL)
    If $vTemp <> $sOut Then
        $sOut = $vTemp
        $vTemp = 1
    Else
        $vTemp = 0
    EndIf
    If @error Or (Not @error And $aSel[0] = $aSel[1]) Then
        If $vTemp Then
            GUICtrlSetData($iEdt, $sOut)
            GUICtrlSendMsg($iEdt, $EM_SCROLL, $SB_BOTTOM, 0)
        EndIf
    Else
        If $iUnSel Then
            $iUnSel = 0
            AdlibRegister("_UnSel", 5000)
        EndIf
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
    If Not @error Then
        For $i = 1 To $aPIDs[0][0]
            ProcessClose($aPIDs[$i][0])
        Next
    EndIf
    ProcessClose($iPID)
EndFunc   ;==>_OnExit

