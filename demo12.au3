#include <GuiConstantsEx.au3> ;EditConstants.au3
#include <ScrollBarConstants.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3> ; EditConstants.au3 http://autoit-script.ru/index.php?topic=1076.0
#include <EditConstants.au3> ;GuiConstantsEx.au3
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
;$sLine[2] = "ping -t 8.8.4.4" & @CRLF
ReDim $sLine[$windowTabs+1]
;end ini

Global Const $WA_ACTIVE = 1
Global Const $WA_CLICKACTIVE = 2
Global Const $WA_INACTIVE = 0
Global $hGUI, $hSETUP,$aMsg, $iBtnStart, $iBtnStop, $iBtnClean, $iBtnPause, $iBtnUnPause, $iEdt, $iPID, $aPIDs, $sOut, $iUnSel = 1


Global $strl4 , $btnTM , $iTab

; размеры gui
Global $NameGUI = "GUI"
Global $WWidth = 670 , $WHeight = 450 ; ширина и высота окна
Global $StrTool = 35 ; сверху первая строка под вкладкой.
Global $THeight = $WHeight-75 ; высота консоли

Global $iBtnStart[$windowTabs+1],$iBtnStop[$windowTabs+1],$iBtnClean[$windowTabs+1],$iEdt[$windowTabs+1]
Global $iBtnUnPause[$windowTabs+1],$iBtnPause[$windowTabs+1]
Global $getTab ;=GUICtrlRead($iTab)-1
Global $iPIDx[$windowTabs+1] , $aPIDs[$windowTabs+1] , $aTab
Global $sOut[$windowTabs+1]

For $i = 0 To $windowTabs
;$iPID = Run(@ComSpec, Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
$iPIDx[$i] = Run(@ComSpec, Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
OnAutoItExitRegister("_OnExit")

Next
$iPID = $iPIDx[$windowTabs-1] ; $iPIDx[0] 1-1


; Opt("GUICoordMode", 2)
 ;Opt("GUIResizeMode", 1)
Opt("GUIOnEventMode", 1)

_Main()
While 1
   Sleep(10)
WEnd

Func _ProExit()
    _OnExit()
    Exit
 EndFunc




Func _Main()

$hGUI = GUICreate($NameGUI ,$WWidth,$WHeight)
GUISetOnEvent($GUI_EVENT_CLOSE, '_ProExit', $hGUI)

$iTab = GUICtrlCreateTab(5, 5, $WWidth-10, $WHeight-10) ;создать вкладки с отступом 5 по краям окна, и 5 внутри
GUICtrlCreateTabItem("  Панель  "); Вкладка для инструментов
$btnTM = GUICtrlCreateButton("Диспетчер задач", 187, $WHeight-95, 147, 40)
GUICtrlSetOnEvent(-1, "btnTM")

For $t = 0 To $windowTabs
GUICtrlCreateTabItem($info[$t]) ; Вкладки программ

$iBtnStart[$t] = GUICtrlCreateButton("Старт", 14, $THeight+40 , 80, 25, $BS_DEFPUSHBUTTON)
GUICtrlSetOnEvent(-1, "StartPressed")

$iBtnStop[$t] = GUICtrlCreateButton("Стоп", 100, $THeight+40, 80, 25, 0x01) ; $BS_DEFPUSHBUTTON
GUICtrlSetOnEvent(-1, "StopPressed")
GUICtrlSetState(-1, $GUI_DISABLE)

$iBtnClean = GUICtrlCreateButton("Очистить", 186, $THeight+40, 80, 25)
GUICtrlSetOnEvent(-1, "CleanPressed")

$iEdt[$t] = GUICtrlCreateEdit("Консоль " & $t, 14, $StrTool, $WWidth-30, $THeight, BitOR($ES_READONLY, $ES_AUTOVSCROLL, $WS_VSCROLL))
GUICtrlSendMsg(-1, $EM_LIMITTEXT, -1, 0)
GUIRegisterMsg($WM_ACTIVATE, "WM_ACTIVATE")

Next

GUISetState(@SW_SHOW, $hGUI)
EndFunc

Func btnTM()
Run (@SystemDir & "\taskmgr.exe", @SystemDir ,@SW_SHOW)
EndFunc

Func CleanPressed()
GUICtrlSetData($iEdt[GUICtrlRead($iTab)-1], Null)
EndFunc

Func StartPressed()
Local $getTab = GUICtrlRead($iTab)-1
   GUICtrlSetState($iBtnStart[$getTab], $GUI_DISABLE)
   GUICtrlSetState($iBtnStop[$getTab], $GUI_ENABLE)
$aTab = $getTab/10
   StdinWrite($iPIDx[$getTab], $sLine[$getTab])
EndFunc

Func StopPressed()
Local $getTab = GUICtrlRead($iTab)-1
;$aTab = $getTab
   GUICtrlSetState($iBtnStop[$getTab], $GUI_DISABLE)
   GUICtrlSetState($iBtnStart[$getTab], $GUI_ENABLE)

   ;MsgBox(4096, "Нажата кнопка OK",$sLine[$getTab] )

   ;Local $itmp = GUICtrlRead($iTab)
   ;MsgBox(4096, "Нажата кнопка OK", "ID=" & @GUI_CtrlId & @CRLF & " WinHandle=" & @GUI_WinHandle & @CRLF & " CtrlHandle=" & @GUI_CtrlHandle & @CRLF & $itmp)
  ;GUICtrlSetData($iEdt[$itmp-1], Null)
												   ; вкладок=1 2штуки
 ;MsgBox(4096, "[$getTab]",$iPID & " " & $getTab ) ;pid индентификатор cmd  , посл. вкладка = 1 . pid=6800 w=1
												   ;=pidx[0] wintab=1-1
 ;MsgBox(4096, "$iPID[$getTab]","pid[0]=" & $iPIDx[0] & " $sLine[0]=" & $sLine[0] & @CRLF & _
 ;"pid[" & $getTab & "]=" & $iPIDx[$getTab] & " $sLine[gt]=" & $sLine[$getTab])
 ;            pid1=3840

Local $iPIDs = $iPIDx[$getTab]
;Local $iPIDs = $iPID
; MsgBox(4096, "$iPIDs",$iPIDs )
            $aPIDs = _WinAPI_EnumChildProcess($iPIDs)
           If Not @error Then
                For $n = 1 To $aPIDs[0][0]
                    ProcessClose($aPIDs[$n][0])
               Next
		   EndIf
EndFunc



Func WM_ACTIVATE($hWnd, $iMsg, $wParam, $lParam)
    Switch _WinAPI_LoWord($wParam)
        Case $WA_ACTIVE, $WA_CLICKACTIVE
            AdlibRegister("_Update2")
      ;  Case $WA_INACTIVE
      ;      AdlibUnRegister("_Update")
    EndSwitch
EndFunc   ;==>WM_ACTIVATE

Func _Update2() ;---------------------------------------------------------------------------------------------

   For $i = 0 to $windowTabs

; Local $vTemp = $sOut & _WinAPI_OemToChar(StdoutRead($iPID)), $aSel = GUICtrlRecvMsg($iEdt, $EM_GETSEL)
Local $vTemp = $sOut[$i] & DllCall('user32.dll', 'bool', 'OemToChar', 'str', StdoutRead($iPIDx[$i]), 'str', StdoutRead($iPIDx[$i]))[2]

Local $strl4 =  StringLen ( $vTemp )

;$getTab = GUICtrlRead($iTab)
;MsgBox(4096, "$iEdt[$aTab]" ,$iEdt[$aTab] )


Local $aSel = GUICtrlRecvMsg($iEdt[$i], $EM_GETSEL)

Select
   Case $vTemp <> $sOut[$i]
		 $sOut[$i] = $vTemp & " >" & $strl4 & @CRLF ;+ отладочная метка

;_clearEdt()

		 $vTemp = 1
   Case Else
		 $vTemp = 0
EndSelect


    If @error Or (Not @error And $aSel[0] = $aSel[1]) Then
Select
    Case $vTemp
		 GUICtrlSetData($iEdt[$i], $sOut[$i])
		 GUICtrlSendMsg($iEdt[$i], $EM_SCROLL, $SB_BOTTOM, 0)
	  EndSelect

	 Else
Select
    Case $iUnSel
		 $iUnSel = 0
		; AdlibRegister("_UnSel", 5000)
EndSelect
    EndIf


Next


EndFunc   ;==>_Update




Func _Update()
; $Line = GUICtrlRead($iEdt)
; Local $vTemp = $sOut & _WinAPI_OemToChar(StdoutRead($iPID)), $aSel = GUICtrlRecvMsg($iEdt, $EM_GETSEL)
Local $vTemp = $sOut & DllCall('user32.dll', 'bool', 'OemToChar', 'str', StdoutRead($iPIDx[$getTab]), 'str', StdoutRead($iPIDx[$getTab]))[2]

Local $strl4 =  StringLen ( $vTemp )

;$getTab = GUICtrlRead($iTab)
MsgBox(4096, "$iEdt[$aTab]" ,$iEdt[$aTab] )


Local $aSel = GUICtrlRecvMsg($iEdt[$aTab], $EM_GETSEL)

Select
   Case $vTemp <> $sOut
		 $sOut = $vTemp & " >" & $strl4 & @CRLF ;+ отладочная метка

;_clearEdt()

		 $vTemp = 1
   Case Else
		 $vTemp = 0
EndSelect


    If @error Or (Not @error And $aSel[0] = $aSel[1]) Then
Select
    Case $vTemp
		 GUICtrlSetData($iEdt[$aTab], $sOut)
		 GUICtrlSendMsg($iEdt[$aTab], $EM_SCROLL, $SB_BOTTOM, 0)
	  EndSelect

	 Else
Select
    Case $iUnSel
		 $iUnSel = 0
		; AdlibRegister("_UnSel", 5000)
EndSelect
    EndIf

EndFunc   ;==>_Update

Func _UnSel()
    GUICtrlSendMsg($iEdt[$windowTabs], $EM_SETSEL, -1, 0)
    GUICtrlSendMsg($iEdt[$windowTabs], $EM_SCROLL, $SB_BOTTOM, 0)
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

Func _clearEdt()
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
EndFunc

Func OKPressed()
    MsgBox(4096, "Нажата кнопка OK", "ID=" & @GUI_CtrlId & " WinHandle=" & @GUI_WinHandle & " CtrlHandle=" & @GUI_CtrlHandle)
EndFunc