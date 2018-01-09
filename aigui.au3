#NoTrayIcon
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

#include <Constants.au3>

#include <aig-ini.au3>
#include <asciiArt.au3>
#include <version.au3>
#include <debug-log.au3>

_debug_start()

Opt("TrayAutoPause", 0)
Opt('TrayMenuMode', 3)	;	http://autoit-script.ru/autoit3_docs/functions/AutoItSetOption.htm
; Opt("GUICoordMode", 2)
 ;Opt("GUIResizeMode", 1)
Opt("GUIOnEventMode", 1)
;Opt ("TrayIconDebug" , 1)

;Func dissable()
;ini имитация загрузки из настроек
;Global $windowTabs=2
;Global $info[$windowTabs+1]
;Global $sLine[$windowTabs+1]
;Global $strLimit=600000
;For $i=0 To $windowTabs
;$info[$i] = $i
;Next
;$sLine[0] = "ping -t 127.0.0.1" & @CRLF
;$sLine[1] = "ping -t 8.8.8.8" & @CRLF
;$sLine[2] = "ping -t 8.8.4.4" & @CRLF
;$sLine[2] = "нет" & @CRLF
;ReDim $sLine[$windowTabs+1]
;Global $version = 0.1
;end ini
;EndFunc
;_redimset()

Global Const $WA_ACTIVE = 1
Global Const $WA_CLICKACTIVE = 2
Global Const $WA_INACTIVE = 0
Global $hGUI, $hSETUP, $iBtnStart, $iBtnStop, $iBtnClean, $iBtnPause, $iBtnUnPause, $aPIDs, $iUnSel = 1 , $iBtnCont

Global $strl4 , $iTab , $hImage ; элемент иконок кнопки

; размеры gui
Global Const $NameGUI = "AiGUI"
Global Const $WWidth = 670 , $WHeight = 450 ; ширина и высота окна 450
Global Const $StrTool = 35 ; сверху первая строка под вкладкой.
Global Const $THeight = $WHeight-75 ; высота консоли

Global $iBtnStart[$windowTabs+1],$iBtnStop[$windowTabs+1],$iBtnClean[$windowTabs+1],$iEdt[$windowTabs+1]
Global $iBtnUnPause[$windowTabs+1],$iBtnPause[$windowTabs+1] , $iBtnCont[$windowTabs+1]
Global $iPIDx[$windowTabs+1] , $aPIDs[$windowTabs+1] , $sOut[$windowTabs+1] , $getTab ;=GUICtrlRead($iTab)-1

; запускать консоли до запуска команды
;For $i = 0 To $windowTabs
;$iPIDx[$i] = Run(@ComSpec, Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
;OnAutoItExitRegister("_OnExit")
;Next

;OnAutoItExitRegister("_OnExit")

_iniLoad() ; загрузить настройки из ini aig-ini.au3
_sLine()  ; загрузить строки

_Main()

;Func _trayIcon()
TraySetState(1) ; Показывает меню трея
;TrayCreateItem("")
;$iExit = TrayCreateItem("Выход")
;EndFunc

While 1
   Switch TrayGetMsg()
	  Case $TRAY_EVENT_PRIMARYUP
		 WinSetState ( $hGUI, Null, @SW_SHOW )
		 WinActivate ( $hGUI, Null )
	  EndSwitch
_Update()
Sleep(10)

;GUISetState($hSETUP)
WEnd

Func _Main()

Select ; определение прав запуска
   Case IsAdmin()
	  $nGUI = " - Администратор"
   Case Else
	  $nGUI = " - без прав администратора"
   EndSelect
$hGUI = GUICreate($NameGUI & " " & $version & $nGUI,$WWidth,$WHeight)
GUISetOnEvent($GUI_EVENT_CLOSE, '_ProExit', $hGUI)
GUISetOnEvent($GUI_EVENT_MINIMIZE, '_hideWin', $hGUI)

$iTab = GUICtrlCreateTab(5, 5, $WWidth-10, $WHeight-10) ;создать вкладки с отступом 5 по краям окна, и 5 внутри
GUICtrlCreateTabItem("  Панель  "); Вкладка для инструментов

GUICtrlCreateGroup("", 15 , $StrTool-5 , $WWidth-32 , $THeight+30)
GUICtrlCreateLabel($NameGUI & " - интерфейс", 20, $StrTool+5, $WWidth-42, 60)
GUICtrlSetFont(-1, 10.5, 400, 0 , "Arial" , 5)
GUICtrlSetBkColor(-1, 0x00FF00)

GUICtrlCreateLabel("kk", 20, $StrTool+80)
GUICtrlSetBkColor(-1, 0x00FF09)
GUICtrlCreateLabel("индикатор2", 160, $StrTool+80)
GUICtrlSetBkColor(-1, 0x00FF09)

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
Select
   Case IsAdmin()
_GUIImageList_AddIcon($hImage, "taskmgr.exe", 0, True)
Case Else
_GUIImageList_AddIcon($hImage, "shell32.dll", 109, True)
EndSelect
$btnTM = GUICtrlCreateButton("Диспетчер задач", 187, $WHeight-66, 147, 40)
_GUICtrlButton_SetImageList($btnTM, $hImage)
GUICtrlSetOnEvent(-1, "btnTM")


$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
Select
   Case IsAdmin()
_GUIImageList_AddIcon($hImage, "devmgr.dll", 4, True)
Case Else
_GUIImageList_AddIcon($hImage, "shell32.dll", 109, True)
EndSelect
$btnDM = GUICtrlCreateButton("Диспетчер устройств", 25, $WHeight-66, 157, 40)
_GUICtrlButton_SetImageList($btnDM, $hImage)
GUICtrlSetOnEvent(-1, "btnDM")

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "cmd.exe", 0, True)
$btnCM = GUICtrlCreateButton("Командная строка", 339, $WHeight-66, 150, 40)
_GUICtrlButton_SetImageList($btnCM, $hImage)
GUICtrlSetOnEvent(-1, "btnCM")

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "shell32.dll", 21, True)
$btnST = GUICtrlCreateButton("Настройки", 494, $WHeight-66, 150, 40)
_GUICtrlButton_SetImageList($btnST, $hImage)
GUICtrlSetOnEvent(-1, "btnST")

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "calc.exe", 0, True)
$btnCA = GUICtrlCreateButton("Калькулятор", 494, $WHeight-113, 150, 40)
_GUICtrlButton_SetImageList($btnCA, $hImage)
GUICtrlSetOnEvent(-1, "btnCA")

For $t = 0 To $windowTabs
GUICtrlCreateTabItem($info[$t]) ; Вкладки программ

$iBtnStart[$t] = GUICtrlCreateButton("Старт", 14, $THeight+35 , 80, 25, $BS_DEFPUSHBUTTON)
GUICtrlSetOnEvent(-1, "StartPressed")

$iBtnStop[$t] = GUICtrlCreateButton("Стоп", 100, $THeight+35, 80, 25, 0x01) ; $BS_DEFPUSHBUTTON
GUICtrlSetOnEvent(-1, "StopPressed")
GUICtrlSetState(-1, $GUI_DISABLE)

$iBtnClean = GUICtrlCreateButton("Очистить", 186, $THeight+35, 80, 25)
GUICtrlSetOnEvent(-1, "CleanPressed")

$iBtnCont[$t] = GUICtrlCreateButton("Продолжить" , 272, $THeight+35, 80, 25)
;GUICtrlSetState($iBtnCont[$t], $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "ButtonCont");ButtonCont



;MsgBox(4096, "lll" , $windowTabs)
;_redimset()
$iEdt[$t] = GUICtrlCreateEdit("==>[" & $t & "]" & @CRLF & $sLine[$t] & $itmHello[$t] , 14, $StrTool, $WWidth-30, $THeight-8, BitOR($ES_READONLY, $ES_AUTOVSCROLL, $WS_VSCROLL))
;$iEdt[$t] = GUICtrlCreateEdit("==>[" & $t & "]" & @CRLF & $sLine[$t] , 14, $StrTool, $WWidth-30, $THeight, BitOR($ES_READONLY, $ES_AUTOVSCROLL, $WS_VSCROLL))
;$iEdt[$t] = GUICtrlCreateEdit("[" & $t & "]==>" & @CRLF & $sLine[$t] , 14, $StrTool, $WWidth-30, $THeight, BitOR($ES_READONLY, $ES_AUTOVSCROLL, $WS_VSCROLL))
;$iEdt[$t] = GUICtrlCreateEdit("Консоль " & $t & " . " & "Ожидаемая команда: ==>" & @CRLF & $sLine[$t] , 14, $StrTool, $WWidth-30, $THeight, BitOR($ES_READONLY, $ES_AUTOVSCROLL, $WS_VSCROLL))
GUICtrlSendMsg(-1, $EM_LIMITTEXT, -1, 0)
;GUIRegisterMsg($WM_ACTIVATE, "WM_ACTIVATE")

Next

GUISetState(@SW_SHOW, $hGUI)
EndFunc



Func btnST() ; окно настроек
;$setEXIT = 0
;$guiSZ = WinGetClientSize ($hGUI );670 450
;$guiCoord = WinGetPos ($hGUI);676 478

;MsgBox(0, "WinGetPos активного окна", _
 ;   "Координаты:" & @LF & @TAB & _
  ;  "X=" & $guiSZ[0] & @LF & @TAB & _
   ; "Y=" & $guiSZ[1] & @LF & @LF & _
    ;"Размеры:" & @LF & @TAB & _
    ;"ширина =  " & $guiCoord[2] & @LF & @TAB & _
    ;"высота  =  " & $guiCoord[3])

WinSetState ( $hGUI, Null, @SW_DISABLE )
$guiCoord = WinGetPos ($hGUI)


$hSETUP = GUICreate("Настройки", $guiCoord[2]-20, $guiCoord[3]-41, $guiCoord[0]+8, $guiCoord[1]+30, BitOR ($WS_BORDER, $WS_POPUP), -1, $hGUI)
;$hSETUP = GUICreate("Настройки", $guiCoord[2]-20, $guiCoord[3]-41, $guiCoord[0]+8, $guiCoord[1]+30, $WS_BORDER, -1, $hGUI)

GUICtrlCreateGroup("Настройки", 9, 9 , $guiCoord[2]-38 , $guiCoord[3]-60)

$setEXIT = GUICtrlCreateButton("Сохранить и выйти", 23, 32, 120, 30)
GUICtrlSetOnEvent(-1, "CloseST")

$setEXIT = GUICtrlCreateButton("Отменить", 155, 32, 90, 30)
GUICtrlSetOnEvent(-1, "CloseST")


GUISetState(@SW_SHOW)
;GUISwitch($hGUI)

EndFunc

Func CloseST(); закрыть окно настроек
GUIDelete(@GUI_WinHandle)
WinSetState ( $hGUI, Null, @SW_ENABLE )
WinSetState ( $hGUI, Null, @SW_SHOW )
WinActivate ( $hGUI, Null )
EndFunc


Func WM_ACTIVATE($hWnd, $iMsg, $wParam, $lParam)
    Switch _WinAPI_LoWord($wParam)
        Case $WA_ACTIVE, $WA_CLICKACTIVE
            AdlibRegister("_Update")
     ;   Case $WA_INACTIVE
    ;        AdlibUnRegister("_Update")
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

   ;  MsgBox(4096, $i ,  $exlpid[$i])
;Select

 ;  Case $exlpid[$i] > Null
    GUICtrlSetData($iBtnCont,'1 минута' &  $exlpid[$i] )
	  GUICtrlSetState($iBtnCont[$i], $GUI_ENABLE)

;	EndSelect

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

Func _ProExit()
    _OnExit()
	_debug_stop()
    Exit
 EndFunc

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

Func btnTM()
Run (@SystemDir & "\taskmgr.exe", @SystemDir ,@SW_SHOW)
EndFunc

Func btnDM()
Run (@SystemDir & "\mmc.exe " & @SystemDir & "\devmgmt.msc" , @SystemDir ,@SW_SHOW)
EndFunc

Func btnCM()
Run (@SystemDir & "\cmd.exe", @WorkingDir ,@SW_SHOW)
EndFunc

Func btnCA()
Run (@SystemDir & "\calc.exe", @WorkingDir ,@SW_SHOW)
EndFunc

Func StartPressed()
Local $getTab = GUICtrlRead($iTab)-1
   $iPIDx[$getTab] = Run(@ComSpec, Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
   ;OnAutoItExitRegister("_OnExit")
   $exlpid[$getTab] = $iPIDx[$getTab]
   _iniSave()
	  GUICtrlSetState($iBtnStart[$getTab], $GUI_DISABLE)
	  GUICtrlSetState($iBtnStop[$getTab], $GUI_ENABLE)
	  StdinWrite($iPIDx[$getTab], $sLine[$getTab])
EndFunc

Func ButtonCont()
Local $getTab = GUICtrlRead($iTab)-1
   $iPIDx[$getTab] = $exlpid[$getTab]

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

Func _hideWin(); скрыть главное окно
WinSetState ( $hGUI, Null, @SW_HIDE )
EndFunc