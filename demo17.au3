#include <GuiConstantsEx.au3> ;EditConstants.au3
;#include <ScrollBarConstants.au3>;#include <ScrollBarsConstants.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3> ; EditConstants.au3 http://autoit-script.ru/index.php?topic=1076.0
#include <EditConstants.au3> ;GuiConstantsEx.au3
#include <ButtonConstants.au3>
;#include <WinAPIProc.au3>
#include <WinAPI.au3>
;#include <WinAPIMisc.au3> ;_WinAPI_OemToChar





#include <aig-func.au3>
;#include <GuiButton.au3> ;>aig-func.au3
;#include <GuiImageList.au3>;>aig-func.au3

Opt('TrayMenuMode', 1)	;	http://autoit-script.ru/autoit3_docs/functions/AutoItSetOption.htm
; Opt("GUICoordMode", 2)
 ;Opt("GUIResizeMode", 1)
Opt("GUIOnEventMode", 1)
Opt ("TrayIconDebug" , 1)

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
Global $hGUI, $hSETUP,$aMsg, $iBtnStart, $iBtnStop, $iBtnClean, $iBtnPause, $iBtnUnPause, $aPIDs, $iUnSel = 1

Global $strl4 , $iTab , $hImage ; элемент иконок кнопки


; размеры gui
Global $NameGUI = "GUI"
Global $WWidth = 670 , $WHeight = 450 ; ширина и высота окна
Global $StrTool = 35 ; сверху первая строка под вкладкой.
Global $THeight = $WHeight-75 ; высота консоли

Global $iBtnStart[$windowTabs+1],$iBtnStop[$windowTabs+1],$iBtnClean[$windowTabs+1],$iEdt[$windowTabs+1]
Global $iBtnUnPause[$windowTabs+1],$iBtnPause[$windowTabs+1]
Global $iPIDx[$windowTabs+1] , $aPIDs[$windowTabs+1] , $sOut[$windowTabs+1] , $getTab ;=GUICtrlRead($iTab)-1

; запускать консоли до запуска команды
;For $i = 0 To $windowTabs
;$iPIDx[$i] = Run(@ComSpec, Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
;OnAutoItExitRegister("_OnExit")
;Next

;OnAutoItExitRegister("_OnExit")

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

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "taskmgr.exe", 0, True)
$btnTM = GUICtrlCreateButton("Диспетчер задач", 187, $WHeight-95, 147, 40)
_GUICtrlButton_SetImageList($btnTM, $hImage)
GUICtrlSetOnEvent(-1, "btnTM")

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "devmgr.dll", 4, True)
$btnDM = GUICtrlCreateButton("Диспетчер устройств", 25, $WHeight-95, 157, 40)
_GUICtrlButton_SetImageList($btnDM, $hImage)
GUICtrlSetOnEvent(-1, "btnDM")


For $t = 0 To $windowTabs
GUICtrlCreateTabItem($info[$t]) ; Вкладки программ

$iBtnStart[$t] = GUICtrlCreateButton("Старт", 14, $THeight+40 , 80, 25, $BS_DEFPUSHBUTTON)
GUICtrlSetOnEvent(-1, "StartPressed")

$iBtnStop[$t] = GUICtrlCreateButton("Стоп", 100, $THeight+40, 80, 25, 0x01) ; $BS_DEFPUSHBUTTON
GUICtrlSetOnEvent(-1, "StopPressed")
GUICtrlSetState(-1, $GUI_DISABLE)

$iBtnClean = GUICtrlCreateButton("Очистить", 186, $THeight+40, 80, 25)
GUICtrlSetOnEvent(-1, "CleanPressed")

$iEdt[$t] = GUICtrlCreateEdit("Консоль " & $t & @CRLF & "Ожидаемая команда: " & $sLine[$t] , 14, $StrTool, $WWidth-30, $THeight, BitOR($ES_READONLY, $ES_AUTOVSCROLL, $WS_VSCROLL))
GUICtrlSendMsg(-1, $EM_LIMITTEXT, -1, 0)
GUIRegisterMsg($WM_ACTIVATE, "WM_ACTIVATE")

Next

GUISetState(@SW_SHOW, $hGUI)
EndFunc

Func btnTM()
 ;  MsgBox(4096, "Нажата кнопка OK",GUICtrlRead($iTab)-1 )
 ;OnAutoItExitUnRegister ( "_OnExit" )
Run (@SystemDir & "\taskmgr.exe", @SystemDir ,@SW_SHOW)


EndFunc

Func btnDM()
Run (@SystemDir & "\mmc.exe " & @SystemDir & "\devmgmt.msc" , @SystemDir ,@SW_SHOW)
EndFunc

Func StartPressed()
Local $getTab = GUICtrlRead($iTab)-1

   $iPIDx[$getTab] = Run(@ComSpec, Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)

   ; MsgBox(4096, "Нажата кнопка OK",$getTab )
 ; If GUICtrlRead($iTab) <> -1 Then
 ;OnAutoItExitRegister("_OnExit")

	  GUICtrlSetState($iBtnStart[$getTab], $GUI_DISABLE)
	  GUICtrlSetState($iBtnStop[$getTab], $GUI_ENABLE)
	  StdinWrite($iPIDx[$getTab], $sLine[$getTab])
EndFunc

Func StopPressed()
Local $getTab = GUICtrlRead($iTab)-1
   GUICtrlSetState($iBtnStop[$getTab], $GUI_DISABLE)
   GUICtrlSetState($iBtnStart[$getTab], $GUI_ENABLE)
	  Local $iPIDs = $iPIDx[$getTab]
	  Local $aPIDs = _WinAPI_EnumChildProcess($iPIDs)
           If Not @error Then ; завершить дочерний процес
			   For $n = 1 To $aPIDs[0][0]
                    ProcessClose($aPIDs[$n][0])
               Next
			   ProcessClose($iPIDs); завершить cmd по PID

		   EndIf
EndFunc

Func CleanPressed()
Local $getTab = GUICtrlRead($iTab)-1
;GUICtrlSetData($iEdt[GUICtrlRead($iTab)-1], Null)
GUICtrlSetData($iEdt[$getTab], Null)
$sOut[$getTab] = Null
EndFunc

 ;MsgBox(4096, "Нажата кнопка OK",$iPIDs )
;MsgBox(4096, "Нажата кнопка OK",$aPIDs[$n][0 )

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


Func WM_ACTIVATE($hWnd, $iMsg, $wParam, $lParam)
    Switch _WinAPI_LoWord($wParam)
        Case $WA_ACTIVE, $WA_CLICKACTIVE
            AdlibRegister("_Update")
        Case $WA_INACTIVE
            AdlibUnRegister("_Update")
    EndSwitch
EndFunc   ;==>WM_ACTIVATE

Func _Update() ;---------------------------------------------------------------------------------------------
For $i = 0 to $windowTabs

; Local $vTemp = $sOut & _WinAPI_OemToChar(StdoutRead($iPID)), $aSel = GUICtrlRecvMsg($iEdt, $EM_GETSEL)
Local $vTemp = $sOut[$i] & DllCall('user32.dll', 'bool', 'OemToChar', 'str', StdoutRead($iPIDx[$i]), 'str', StdoutRead($iPIDx[$i]))[2]
Local $strl4 =  StringLen ( $vTemp )
Local $aSel = GUICtrlRecvMsg($iEdt[$i], $EM_GETSEL)

Select
   Case $vTemp <> $sOut[$i]
		 $sOut[$i] = $vTemp & " >" & $strl4 & @CRLF ;+ отладочная метка

Select ; очищать окно с сохранением в файл
Case $strl4 > $strLimit ; если строка слишком длинная
   Local $nFile = @WorkingDir & "\tmp\zLog" & "_" & $i & "_" & @YEAR & @MON & @MDAY & "." & @MIN & @SEC & ".txt"
   $hFile = FileOpen($nFile, 1)
   FileWrite($hFile, $sOut[$i] & @CRLF & ">" & $strl4 & "<")
   FileClose($hFile)
 ;  _debug_send_file()
   $sOut[$i] = "Превышено " & $strl4 & " знаков." & @CRLF & "Прошлый вывод сохранён в " & $nFile & @CRLF
   $strl4 = 0
EndSelect

		 $vTemp = 1
   Case Else
		 $vTemp = 0
EndSelect

    If @error Or (Not @error And $aSel[0] = $aSel[1]) Then
Select
    Case $vTemp
		 GUICtrlSetData($iEdt[$i], $sOut[$i])
		 GUICtrlSendMsg($iEdt[$i], $EM_SCROLL, 7, 0);$SB_BOTTOM=7
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




Func _UnSel()

  Local $getTab = GUICtrlRead($iTab)-1
 ; If $getTab < 0 Then $getTab = 0

    GUICtrlSendMsg($iEdt[$getTab], $EM_SETSEL, -1, 0)
    GUICtrlSendMsg($iEdt[$getTab], $EM_SCROLL, 7, 0);$SB_BOTTOM=7
    AdlibUnRegister("_UnSel")
    $iUnSel = 1
EndFunc   ;==>_UnSel


Func _OnExit()

For $i = 0 To $windowTabs
   Local $iPIDs = $iPIDx[$i]
   Local $aPIDs = _WinAPI_EnumChildProcess($iPIDs)
	  If Not @error Then
		 For $n = 1 To $aPIDs[0][0]
			ProcessClose($aPIDs[$n][0])
		 Next
	  EndIf
Next
EndFunc   ;==>_OnExit


