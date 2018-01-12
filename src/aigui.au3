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
#include <TabConstants.au3>

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


Global Const $VIP = 1

Global Const $WA_ACTIVE = 1
Global Const $WA_CLICKACTIVE = 2
Global Const $WA_INACTIVE = 0
Global $hGUI, $hSETUP, $iBtnStart, $iBtnStop, $iBtnClean, $iBtnPause, $iBtnUnPause, $aPIDs, $iUnSel = 1 , $btnAllStop

Global $stTabs , $tmpStbs ;= $windowTabs; временное количество вкладок
$tmpStbs = $windowTabs+1

; $win = IniRead ($sysini,"RUN","RunPID", Null)
;MsgBox(4096,$myini,"-" & $win & "-")
;exit
Select
   Case IniRead ($sysini,"RUN","RunPID", Null) <> "" ; добавить. если пид есть, искать по нему процесс и тогда ... >
	  Select
		 Case ProcessExists ( IniRead ($sysini,"RUN","RunPID", Null) )
			WinSetState ( IniRead ($sysini,"RUN","RunGUI", Null), Null, @SW_SHOW )
			WinActivate ( IniRead ($sysini,"RUN","RunGUI", Null), Null )
			Exit
	  EndSelect
EndSelect
;WinSetState ( IniRead ($sysini,"RUN","RunPID", Null), Null, @SW_SHOW )



  ; MsgBox(4096,"_iniDefLoad","-" & IniRead ($sysini,"RUN","RunPID", Null) & "-")


 ;WinSetState ( $hGUI, Null, @SW_SHOW )
	;	 WinActivate ( $hGUI, Null )

  ; exit
;Case Else
  ; Exit
; MsgBox(4096,"_iniDefLoad",6)




;IniWrite($sysini, "RUN", "RunPID", WinGetProcess ( $hGUI ))


Global $strl4 , $iTab , $hImage ; элемент иконок кнопки

; размеры gui
Global Const $NameGUI = "AiGUI"
Global Const $WWidth = 670 , $WHeight = 450 ; ширина и высота окна 450
Global Const $StrTool = 35 ; сверху первая строка под вкладкой.
Global Const $THeight = $WHeight-75 ; высота консоли


_iniLoad() ; загрузить настройки из ini aig-ini.au3
_sLine()  ; загрузить строки


Global $iBtnStart[$windowTabs+1],$iBtnStop[$windowTabs+1],$iBtnClean[$windowTabs+1],$iEdt[$windowTabs+1]
Global $iBtnUnPause[$windowTabs+1],$iBtnPause[$windowTabs+1] , $iBtnCont[$windowTabs+1]
Global $iPIDx[$windowTabs+1] , $aPIDs[$windowTabs+1] , $sOut[$windowTabs+1] , $getTab ;=GUICtrlRead($iTab)-1

;Global $strEdt[$windowTabs+1]
Global Const $txtQual = 3 ; сглаживание

Global $sn_info[$windowTabs+1],$st_typecmd[$windowTabs+1],$st_expath[$windowTabs+1],$st_exname[$windowTabs+1],$st_server[$windowTabs+1],$st_urlprofile[$windowTabs+1]
Global $st_port[$windowTabs+1],$st_user[$windowTabs+1],$st_devr[$windowTabs+1],$st_pass[$windowTabs+1],$st_exlog[$windowTabs+1],$st_params[$windowTabs+1]
; запускать консоли до запуска команды
;For $i = 0 To $windowTabs
;$iPIDx[$i] = Run(@ComSpec, Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
;OnAutoItExitRegister("_OnExit")
;Next
Global $lbT[$windowTabs+1]; активность
Global Const $lbTAct = 0x00FF09
Global Const $lbTdeact = 0xFBD7F4

TraySetState(1) ; Показывает меню трея
;OnAutoItExitRegister("_OnExit")




;Switch IniRead ($myini,"GUI","RunPID", Null)
 ;  Case Not ""

;Exit
;Case Else

 ;
;EndSwitch



;_iniLoad() ; загрузить настройки из ini aig-ini.au3
;_sLine()  ; загрузить строки

_Main()

;Func _trayIcon()

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
;IniWrite($sysini, "GUI", "run_version", '"' & $NameGUI & " " & $version & $nGUI & '"')
;IniWrite($sysini, "GUI", "RunPID", WinGetProcess ( $hGUI ))
IniWrite($sysini, "RUN", "RunPID", WinGetProcess ( $hGUI ))
IniWrite($sysini, "RUN", "RunGUI", '"' & $NameGUI & " " & $version & $nGUI & '"')

;IniWrite($sysini, "GUI", "run_version", '"' & $NameGUI & " " & $version & $nGUI & '"')

;GUISetIcon(@SystemDir & "\cmd.exe", 0)
GUISetOnEvent($GUI_EVENT_CLOSE, '_ProExit', $hGUI)
GUISetOnEvent($GUI_EVENT_MINIMIZE, '_hideWin', $hGUI)

GUISetFont(8.5, Null, Null, Null ,$hGUI , $txtQual)

$iTab = GUICtrlCreateTab(5, 5, $WWidth-10, $WHeight-10) ;создать вкладки с отступом 5 по краям окна, и 5 внутри ;$TCS_HOTTRACK
GUICtrlCreateTabItem("  Панель  "); Вкладка для инструментов

GUICtrlCreateGroup("", 15 , $StrTool-5 , $WWidth-32 , $THeight+30)
GUICtrlCreateLabel($NameGUI & " - зелёная фигня", 20, $StrTool+5, $WWidth-42, 60)
GUICtrlSetFont(-1, 10.5, 400, 0 , "Arial" , 5)
GUICtrlSetBkColor(-1, 0x00FF00)

Local Const $tCordLbtL = 33 ; левый край
Local Const $tCordLbtT = $StrTool+80 ;верхний край
Local Const $tCordSV = 20 ;вертикальный шаг
Local Const $tCordSzV = 18 ; высота надписи
Local Const $tCordSzH = 150 ; длина надписи
GUICtrlCreateGroup("", $tCordLbtL-8 , $tCordLbtT-14 , $tCordSzH*2+21 , $tCordSV*9+1)
For $i=0 To $windowTabs
   Select
Case $i < 8
$lbT[$i] = GUICtrlCreateLabel(" " & $info[$i] & " ", $tCordLbtL,  $tCordLbtT+($i*$tCordSV), $tCordSzH, $tCordSzV, 0x0200)
case Else
$lbT[$i] = GUICtrlCreateLabel(" " & $info[$i] & " ", $tCordLbtL+$tCordSzH+5,  $tCordLbtT+($i*$tCordSV)-($tCordSV*8), $tCordSzH, $tCordSzV, 0x0200);x=a+(n*b)-(b*8)
   EndSelect
Next
;GUICtrlSetBkColor(-1, 0x23F009)



$hImage = _GUIImageList_Create(32, 32, 5, 3);, 6)
_GUIImageList_AddIcon($hImage, "taskmgr.exe", 0, True)
$btnTM = GUICtrlCreateButton("Диспетчер задач", 187, $WHeight-66, 147, 40)

Select
   Case IsAdmin()
GUICtrlSetOnEvent(-1, "btnTM")
Case Else
;_GUIImageList_AddIcon($hImage, "shell32.dll", 109, True)
GUICtrlSetOnEvent(-1, "btnTMu")
EndSelect
_GUICtrlButton_SetImageList($btnTM, $hImage)

$hImage = _GUIImageList_Create(32, 32, 5, 3)
_GUIImageList_AddIcon($hImage, "devmgr.dll", 4, True)
$btnDM = GUICtrlCreateButton("Диспетчер устройств", 25, $WHeight-66, 157, 40)
Select
   Case IsAdmin()
GUICtrlSetOnEvent(-1, "btnDM")
Case Else
;_GUIImageList_AddIcon($hImage, "shell32.dll", 109, True)
GUICtrlSetOnEvent(-1, "btnDMu")
EndSelect
_GUICtrlButton_SetImageList($btnDM, $hImage)



;$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
$hImage = _GUIImageList_Create(16 , 16,5, 3);,5 )
$btnMC = GUICtrlCreateButton("msconfig", 25, $WHeight-113, 80, 22) ;157 40
Select
   Case IsAdmin()
_GUIImageList_AddIcon($hImage, "msconfig.exe", 0, True)
Case Else
_GUIImageList_AddIcon($hImage, "shell32.dll", 109, True)
GUICtrlSetState(-1, $GUI_DISABLE)
   EndSelect
_GUICtrlButton_SetImageList($btnMC, $hImage)
GUICtrlSetOnEvent(-1, "btnMC")







$hImage = _GUIImageList_Create(32, 32, 5, 3);, 6)
_GUIImageList_AddIcon($hImage, "cmd.exe", 0, True)
$btnCM = GUICtrlCreateButton("Командная строка", 339, $WHeight-66, 150, 40)
_GUICtrlButton_SetImageList($btnCM, $hImage)
GUICtrlSetOnEvent(-1, "btnCM")

$hImage = _GUIImageList_Create(32, 32, 5, 3);, 6)
_GUIImageList_AddIcon($hImage, "shell32.dll", 21, True)
$btnST = GUICtrlCreateButton("Настройки", 494, $WHeight-66, 150, 40)
_GUICtrlButton_SetImageList($btnST, $hImage)
GUICtrlSetOnEvent(-1, "btnST")

$hImage = _GUIImageList_Create(32, 32, 5, 3);, 6)
_GUIImageList_AddIcon($hImage, "calc.exe", 0, True)
$btnCA = GUICtrlCreateButton("Калькулятор", 494, $WHeight-113, 150, 40)
_GUICtrlButton_SetImageList($btnCA, $hImage)
GUICtrlSetOnEvent(-1, "btnCA")


;VIP buttons
Switch $VIP
   Case 1
$hImage = _GUIImageList_Create(32, 32, 5, 3);, 6)
_GUIImageList_AddIcon($hImage, "shell32.dll", 215, True)
$btnAllStop = GUICtrlCreateButton("Остановить всё", 494, $WHeight-160, 150, 40)
_GUICtrlButton_SetImageList($btnAllStop, $hImage)
GUICtrlSetOnEvent(-1, "btnAllStop")
GUICtrlSetState(-1, $GUI_DISABLE)

EndSwitch
;End VIP buttons




;$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
;_GUIImageList_AddIcon($hImage, "cmd.exe", 0, True)
;$btnCM = GUICtrlCreateButton("  К     о" & @CRLF & "м" & @CRLF & "а" & @CRLF & "н" & @CRLF & _
;"д" & @CRLF & "н" & @CRLF & "а" & @CRLF & "я" & @CRLF & " " & @CRLF & "с" & @CRLF & "т" & @CRLF & _
; "р" & @CRLF & "о" & @CRLF & "к" & @CRLF & "а", 20, $WHeight-320, 40, 280, BitOR ( $BS_VCENTER,$BS_MULTILINE , $BS_FLAT ) );150
;_GUICtrlButton_SetImageList($btnCM, $hImage)
;GUICtrlSetFont(-1, 8.5, Null, Null, Null , $txtQual)
;GUICtrlSetFont(-1, 9.5, 400, "", "arial" , 3)


;GUICtrlSetOnEvent(-1, "btnCM")




For $t = 0 To $windowTabs
GUICtrlCreateTabItem($info[$t]) ; Вкладки программ

$iBtnStart[$t] = GUICtrlCreateButton("Старт", 14, $THeight+35 , 80, 25, $BS_DEFPUSHBUTTON)
GUICtrlSetOnEvent(-1, "StartPressed")

$iBtnStop[$t] = GUICtrlCreateButton("Стоп", 100, $THeight+35, 80, 25, 0x01) ; $BS_DEFPUSHBUTTON
GUICtrlSetOnEvent(-1, "StopPressed")
GUICtrlSetState(-1, $GUI_DISABLE)

$iBtnClean = GUICtrlCreateButton("Очистить", 186, $THeight+35, 80, 25)
GUICtrlSetOnEvent(-1, "CleanPressed")

;$iBtnCont[$t] = GUICtrlCreateButton("Продолжить" , 272, $THeight+35, 80, 25)
;;GUICtrlSetState($iBtnCont[$t], $GUI_DISABLE)
;GUICtrlSetOnEvent(-1, "ButtonCont");ButtonCont

;MsgBox(4096, "lll" , $windowTabs)

$iEdt[$t] = GUICtrlCreateEdit("==>[" & $t & "]" & @CRLF & _Encoding_OEM2ANSI($sLine[$t]) & $itmHello[$t] , 14, $StrTool, $WWidth-30, $THeight-8, BitOR($ES_READONLY, $ES_AUTOVSCROLL, $WS_VSCROLL))
GUICtrlSendMsg(-1, $EM_LIMITTEXT, -1, 0)
;GUIRegisterMsg($WM_ACTIVATE, "WM_ACTIVATE")

Next

GUISetState(@SW_SHOW, $hGUI)
EndFunc ;==>_Main



Func btnST() ; окно настроек
;$setEXIT = 0
;$guiSZ = WinGetClientSize ($hGUI );670 450
;$guiCoord = WinGetPos ($hGUI);676 478


WinSetState ( $hGUI, Null, @SW_DISABLE )
Local $guiCoord = WinGetPos ($hGUI)

;local Const $snMain1 = $guiCoord[2]-38 ; шир.
;local Const $snMain2 = $guiCoord[3]-60 ; выс.
Local Const $snTabs1 = $guiCoord[2]-276 ; позиция_
Local Const $snTabs2 = $guiCoord[3]-438	; вкладок.
;Local $stTabs



$hSETUP = GUICreate("Настройки", $guiCoord[2]-20, $guiCoord[3]-41, $guiCoord[0]+8, $guiCoord[1]+30, BitOR ($WS_BORDER, $WS_POPUP), -1, $hGUI)
;$hSETUP = GUICreate("Настройки", $guiCoord[2]-20, $guiCoord[3]-41, $guiCoord[0]+8, $guiCoord[1]+30, $WS_BORDER, -1, $hGUI)
;GUICtrlCreateGroup("Настройки", 9, 9 , $guiCoord[2]-38 , $guiCoord[3]-60)
GUICtrlCreateGroup("Настройки", 9, 9 , $guiCoord[2]-38 , $guiCoord[3]-400)

GUICtrlCreateButton("Сохранить и выйти", 23, 32, 120, 30)
GUICtrlSetOnEvent(-1, "SetsSave")

GUICtrlCreateButton("Отменить", 155, 32, 90, 30)
GUICtrlSetOnEvent(-1, "SetsClose")



GUICtrlCreateGroup(Null, $snTabs1-123, $snTabs2-16 , 178 , 45)
GUICtrlCreateLabel("Количество вкладок", $snTabs1-109, $snTabs2+3)
$stTabs = GUICtrlCreateInput($tmpStbs, $snTabs1, $snTabs2, 40, 20)
GUICtrlCreateUpdown(-1,BitOR (0x40 , 0x01, 0x20) )
GUICtrlSetLimit(-1, 10, 1)
;GUICtrlSetBkColor(-1,0x00FF09)

;$windowTab = GUICtrlRead(-1)

Local Const $snTUD = 110 ; вертикаль таблицы

local Const $snMLen = 200 ; длина поля путь
Local Const $snXLen = 100
Local Const $snSWLen = 165
Local Const $snPLen = $snSWLen-65
Local Const $snULen = 280 ;пользователь длина
Local Const $snRLen = 70 ; префикс
Local Const $snPSLen = 150
;Local Const $snLLen = $guiCoord[2]-96

GUICtrlCreateTab(9, $snTUD, $guiCoord[2]-38, 250)

For $i=0 To $windowTabs
GUICtrlCreateTabItem($i)

GUICtrlCreateLabel("Mode:", 20, $snTUD+30, 28, 20, 0x0200)
;GUICtrlCreateLabel("Mode", 40, $snTUD+30, 32)
;GUICtrlSetBkColor(-1,0x00FF09)
;$snInfo[$i] = GUICtrlCreateInput($info[$i], 63, $snTUD+30, $snMLen-2,20)
;GUICtrlCreateInput($info[$i], 63, $snTUD+30, $snMLen-2,20)
;MsgBox(0, "WinGetPos активного окна", $i)


;GUICtrlSetBkColor(-1,0x00FF09)
$sn_info[$i] = GUICtrlCreateInput($info[$i], 63, $snTUD+30, $snMLen-2,20)

;GUICtrlSetBkColor(-1,0x00FF09)
If $exlpid[$i] Then GUICtrlCreateLabel("Last PID " & $exlpid[$i], $snMLen+72, $snTUD+30, 100,20)
;GUICtrlSetBkColor(-1,0x00FF09)

$st_typecmd[$i] = GUICtrlCreateCombo($typecmd[$i], 20, $snTUD+60, 32, 100)
GUICtrlSetData(-1, "0|1|2",$typecmd[$i])


$st_expath[$i] = GUICtrlCreateInput($expath[$i], 62, $snTUD+60,  $snMLen, 20)
$st_exname[$i] = GUICtrlCreateInput($exname[$i], $snMLen+72, $snTUD+60,  $snXLen, 20)

GUICtrlCreateLabel("Server:", 20, $snTUD+90, 35, 20, 0x0200)
;GUICtrlSetBkColor(-1,0x00FF09)
$st_server[$i] = GUICtrlCreateInput($server[$i], 57, $snTUD+90, $snSWLen,20)
$st_port[$i] = GUICtrlCreateInput($port[$i], $snSWLen+30+39, $snTUD+90, $snPLen,20) ;$snSWLen+40+$snPLen

GUICtrlCreateLabel("User:", 20, $snTUD+120, 28, 20, 0x0200)
$st_user[$i] = GUICtrlCreateInput($user[$i], 50, $snTUD+120, $snULen,20)
GUICtrlCreateLabel("&&", $snULen+51, $snTUD+120, 10, 20, 0x0200)
;GUICtrlSetBkColor(-1,0x00FF09)
$st_devr[$i] = GUICtrlCreateInput($devr[$i], $snULen+30+2+26, $snTUD+120, $snRLen,20)
GUICtrlCreateLabel("Pass:", $snULen+$snRLen+60, $snTUD+120, 30, 20, 0x0200)
;GUICtrlSetBkColor(-1,0x00FF09)
$st_pass[$i] = GUICtrlCreateInput($pass[$i], $snULen+$snRLen+91, $snTUD+120, $snPSLen,20)

GUICtrlCreateLabel("Log:", 20, $snTUD+150, 28, 20, 0x0200)
;GUICtrlSetBkColor(-1,0x00FF09)
$st_exlog[$i] = GUICtrlCreateInput($exlog[$i], 53, $snTUD+150, $guiCoord[2]-96,20)

$st_params[$i] = GUICtrlCreateInput($params[$i], 20, $snTUD+180, $guiCoord[2]-63,20)

GUICtrlCreateLabel("Url:", 20, $snTUD+210, 28, 20, 0x0200)
;GUICtrlSetBkColor(-1,0x00FF09)
$st_urlprofile[$i] = GUICtrlCreateInput($urlprofile[$i], 53, $snTUD+210, $guiCoord[2]-96,20)

Next

;MsgBox(0, "WinGetPos активного окна", $exname[5])


;MsgBox(0, "WinGetPos активного окна", _
 ;  "Координаты:" & @LF & @TAB & _
  ;"X=" & $guiCoord[0] & @LF & @TAB & _
 ;"Y=" & $guiCoord[1] & @LF & @LF & _
;"Размеры:" & @LF & @TAB & _
;"ширина =  " & $guiCoord[2] & @LF & @TAB & _
;"высота  =  " & $guiCoord[3])


;676 478




GUISetState(@SW_SHOW)
;GUISwitch($hGUI)




EndFunc

Func SetsClose(); закрыть окно настроек
GUIDelete(@GUI_WinHandle);@GUI_WinHandle ;$hSETUP
WinSetState ( $hGUI, Null, @SW_ENABLE )
WinSetState ( $hGUI, Null, @SW_SHOW )
WinActivate ( $hGUI, Null )
EndFunc

Func SetsSave()





For $i=0 To $windowTabs
$info[$i] = GUICtrlRead($sn_info[$i])
$typecmd[$i] = GUICtrlRead($st_typecmd[$i])
$expath[$i] = GUICtrlRead($st_expath[$i])
$exname[$i] = GUICtrlRead($st_exname[$i])
$server[$i] = GUICtrlRead($st_server[$i])
$port[$i] = GUICtrlRead($st_port[$i])
$user[$i] = GUICtrlRead($st_user[$i])
$devr[$i] = GUICtrlRead($st_devr[$i])
$pass[$i] = GUICtrlRead($st_pass[$i])
$exlog[$i] = GUICtrlRead($st_exlog[$i])
$params[$i] = GUICtrlRead($st_params[$i])
Next
   _iniSave()

   $tmpStbs = GUICtrlRead($stTabs)
   IniWrite($myini, "system", "tabs", $tmpStbs-1)
Select
   Case $tmpStbs <> $windowTabs+1
MsgBox(4096, "Настройки : вкладки" , "Настройки изменены" & @CRLF & "Текущие вкладки: " & $windowTabs+1 & @CRLF & "После перезапуска: " & $tmpStbs & " вкладок")
EndSelect

   SetsClose()
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
		 ;$sOut[$i] = $vTemp & " >" & $strl4 & @CRLF ;+ отладочная метка
		 $sOut[$i] = $vTemp;	 & @CRLF

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







Func StartPressed()
Local $getTab = GUICtrlRead($iTab)-1
   $iPIDx[$getTab] = Run(@ComSpec, Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
   If ProcessExists ( $iPIDx[$getTab] ) Then GUICtrlSetBkColor($lbT[$getTab], $lbTAct)
   ;OnAutoItExitRegister("_OnExit")
   $exlpid[$getTab] = $iPIDx[$getTab]
   _iniSave()
	  GUICtrlSetState($iBtnStart[$getTab], $GUI_DISABLE)
	  GUICtrlSetState($iBtnStop[$getTab], $GUI_ENABLE)
	  GUICtrlSetState($btnAllStop, $GUI_ENABLE)
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
   GUICtrlSetBkColor($lbT[$getTab], 0xEBA794)

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
			   If Not ProcessExists ( $iPIDx[$getTab] ) Then GUICtrlSetBkColor($lbT[$getTab], $lbTdeact)
		   EndIf
EndFunc

Func btnAllStop()
   For $i=0 To $windowTabs

Select
   Case ControlCommand($hGUI, '', $iBtnStop[$i], 'IsEnabled')

;If ControlCommand($hGUI, '', $iBtnStop[$i], 'IsEnabled') Then
GUICtrlSetState($iBtnStart[$i], $GUI_ENABLE)
GUICtrlSetState($iBtnStop[$i], $GUI_DISABLE)


 ;EndIf
	   Local $iPIDs = $iPIDx[$i]
	   Local $aPIDs = _WinAPI_EnumChildProcess($iPIDs)

 If Not @error Then ; завершить дочерний процес
			   For $n = 1 To $aPIDs[0][0]
                    ProcessClose($aPIDs[$n][0])
               Next
			   ProcessClose($iPIDs); завершить cmd по PID
			EndIf
EndSelect
If Not ProcessExists ( $iPIDx[$i] ) Then GUICtrlSetBkColor($lbT[$i], $lbTdeact)
   Next

GUICtrlSetState($btnAllStop, $GUI_DISABLE)


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

Func btnTM()
Run (@SystemDir & "\taskmgr.exe", @SystemDir ,@SW_SHOW)
;Run(@ComSpec & ' /c ' & @SystemDir & "\taskmgr.exe", @SystemDir, @SW_HIDE)
EndFunc

Func btnTMu()
;Run (@SystemDir & "\taskmgr.exe", @SystemDir ,@SW_SHOW)
Run(@ComSpec & ' /c ' & @SystemDir & "\taskmgr.exe", @SystemDir, @SW_HIDE)
EndFunc

Func btnDM()
Run (@SystemDir & "\mmc.exe " & @SystemDir & "\devmgmt.msc" , @SystemDir ,@SW_SHOW)
;Run(@ComSpec & ' /c ' & @SystemDir & "\mmc.exe " & @SystemDir & "\devmgmt.msc", @SystemDir, @SW_HIDE)
EndFunc

Func btnDMu()
;Run (@SystemDir & "\mmc.exe " & @SystemDir & "\devmgmt.msc" , @SystemDir ,@SW_SHOW)
Run(@ComSpec & ' /c ' & @SystemDir & "\mmc.exe " & @SystemDir & "\devmgmt.msc", @SystemDir, @SW_HIDE)
EndFunc

Func btnCM()
Run (@SystemDir & "\cmd.exe", @WorkingDir ,@SW_SHOW)
EndFunc

Func btnCA()
Run (@SystemDir & "\calc.exe", @WorkingDir ,@SW_SHOW)
EndFunc

Func btnMC()
Run (@SystemDir & "\msconfig.exe", @WorkingDir ,@SW_SHOW)
EndFunc



Func _ProExit()
    _OnExit()
	_debug_stop()
	;IniWrite($sysini, "RUN", "RunPID", "")
	;IniWrite($sysini, "RUN", "RunGUI", "")
	IniDelete ( $sysini, "RUN" )
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