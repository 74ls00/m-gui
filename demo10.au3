#include <GuiConstantsEx.au3>
#include <ScrollBarConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <WinAPIProc.au3>
#include <WinAPI.au3>
;#include <WinAPIMisc.au3> ;_WinAPI_OemToChar
;#include <GuiButton.au3>
;#include <GuiImageList.au3>

;ini имитация загрузки из настроек
Global $windowTabs=1
Global $info[$windowTabs+1]
Global $sLine[$windowTabs+1]
Global $strLimit=600000
For $i=0 To $windowTabs
$info[$i] = $i
Next
$sLine[0] = "ping -t 127.0.0.1" & @CRLF
$sLine[1] = "ping -t 8.8.8.8" & @CRLF
;end ini

Global Const $WA_ACTIVE = 1
Global Const $WA_CLICKACTIVE = 2
Global Const $WA_INACTIVE = 0
Global $hGUI, $hSETUP,$aMsg, $iBtnStart, $iBtnStop, $iBtnClean, $iBtnPause, $iBtnUnPause, $iEdt, $iPID, $aPIDs, $sOut, $iUnSel = 1

Global $strl4

; размеры gui
Global $NameGUI = "GUI"
Global $WWidth = 670 , $WHeight = 450 ; ширина и высота окна
Global $StrTool = 35 ; сверху первая строка под вкладкой.
Global $THeight = $WHeight-75 ; высота консоли

Global $iBtnStart[$windowTabs+1],$iBtnStop[$windowTabs+1],$iBtnClean[$windowTabs+1],$iBtnUnPause[$windowTabs+1],$iEdt[$windowTabs+1],$iBtnPause[$windowTabs+1]

$iPID = Run(@ComSpec, Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
OnAutoItExitRegister("_OnExit")

$hGUI = GUICreate($NameGUI ,$WWidth,$WHeight)

$iTab = GUICtrlCreateTab(5, 5, $WWidth-10, $WHeight-10) ;создать вкладки с отступом 5 по краям окна, и 5 внутри
GUICtrlCreateTabItem("  Панель  "); Вкладка для инструментов
$btnTM = GUICtrlCreateButton("Диспетчер задач", 187, $WHeight-95, 147, 40)

For $t = 0 To $windowTabs
GUICtrlCreateTabItem($info[$t]) ; Вкладки программ

$iBtnStart = GUICtrlCreateButton("Старт", 14, $THeight+40 , 80, 25, $BS_DEFPUSHBUTTON)
$iBtnStop = GUICtrlCreateButton("Стоп", 100, $THeight+40, 80, 25, 0x01) ; $BS_DEFPUSHBUTTON
GUICtrlSetState(-1, $GUI_DISABLE)
$iBtnClean[0] = GUICtrlCreateButton("Очистить", 186, $THeight+40, 80, 25)

$iEdt = GUICtrlCreateEdit("text " & $t, 14, $StrTool, $WWidth-30, $THeight, BitOR($ES_READONLY, $ES_AUTOVSCROLL, $WS_VSCROLL))
GUICtrlSendMsg(-1, $EM_LIMITTEXT, -1, 0)
GUIRegisterMsg($WM_ACTIVATE, "WM_ACTIVATE")
Next

GUISetState(@SW_SHOW)

While 1

Switch GUIGetMsg()
   Case $GUI_EVENT_CLOSE
	  Exit
   Case $btnTM
		 Run (@SystemDir & "\taskmgr.exe", @SystemDir ,@SW_SHOW)
   Case $iBtnStart
            GUICtrlSetState($iBtnStart, $GUI_DISABLE)
            GUICtrlSetState($iBtnStop, $GUI_ENABLE)
            StdinWrite($iPID, $sLine[0])
   Case $iBtnClean[0]
            GUICtrlSetData($iEdt, Null)
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
      ;  Case $WA_INACTIVE
      ;      AdlibUnRegister("_Update")
    EndSwitch
EndFunc   ;==>WM_ACTIVATE

Func _Update()
; $Line = GUICtrlRead($iEdt)
; Local $vTemp = $sOut & _WinAPI_OemToChar(StdoutRead($iPID)), $aSel = GUICtrlRecvMsg($iEdt, $EM_GETSEL)
Local $vTemp = $sOut & DllCall('user32.dll', 'bool', 'OemToChar', 'str', StdoutRead($iPID), 'str', StdoutRead($iPID))[2]

Local $strl4 =  StringLen ( $vTemp )
Local $aSel = GUICtrlRecvMsg($iEdt, $EM_GETSEL)

Select
   Case $vTemp <> $sOut
		 $sOut = $vTemp & " >" & $strl4 & @CRLF ;+ отладочная метка

Select ; очищать окно с сохранением в файл
Case $strl4 > $strLimit ; если строка слишком длинная
   Local $nFile = @WorkingDir & "\tmp\zLog" & @YEAR & @MON & @MDAY & "." & @MIN & @SEC & ".txt"
   $hFile = FileOpen($nFile, 1)
   FileWrite($hFile, $sOut & @CRLF & ">" & $strl4 & "<")
   FileClose($hFile)
   _debug_send_file()
   $sOut = "Превышено " & $strl4 & " знаков." & @CRLF & "Прошлый вывод сохранён в " & $nFile & @CRLF
   $strl4 = 0
EndSelect

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

