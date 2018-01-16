#Region
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Fileversion=0.1.0.91
#AutoIt3Wrapper_Res_Description=Окно консоли
#AutoIt3Wrapper_Res_Field=ProductName|Окно консоли
#AutoIt3Wrapper_Res_Field=Build|%longdate% %time%
;#AutoIt3Wrapper_Res_Field=OriginalFileName|exe;gui.exe
#AutoIt3Wrapper_Res_ProductVersion=0.1¤;a;α¤
#AutoIt3Wrapper_Res_LegalCopyright=©
#AutoIt3Wrapper_Res_Comment=Consoles GUI
#AutoIt3Wrapper_Res_Language=1049
#AutoIt3Wrapper_Icon=res\icon14.ico
;#AutoIt3Wrapper_Res_Icon_Add=bin\PING1.EXE
;#AutoIt3Wrapper_Res_Icon_Add=res\icon3.ico ;3 13
#AutoIt3Wrapper_Run_Au3Stripper=y
;#Au3Stripper_Parameters
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_Run_After=del /f /q "%scriptdir%\%scriptfile%_Obfuscated.au3"
#EndRegion

#NoTrayIcon
#include <includes.au3>

Opt("TrayAutoPause", 0)
Opt('TrayMenuMode', 3)	;	http://autoit-script.ru/autoit3_docs/functions/AutoItSetOption.htm
; Opt("GUICoordMode", 2)
 ;Opt("GUIResizeMode", 1)
Opt("GUIOnEventMode", 1)
;Opt ("TrayIconDebug" , 1)

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
_debug_start()
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Select ; не запускать вторую копию программы ; @ScriptName
Case IniRead ($sysini,"RUN","RunPID", Null) <> "" And ProcessExists ( IniRead ($sysini,"RUN","RunPID", Null) )
			WinSetState ( IniRead ($sysini,"RUN","RunGUI", Null), Null, @SW_SHOW )
			WinActivate ( IniRead ($sysini,"RUN","RunGUI", Null), Null )
			Exit
EndSelect
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Switch IniRead ($sysini,"LOG","CheckDll", "")
	Case 1 ; 1=проверять системные ресурсы
	_dllCHK()
EndSwitch
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Global Const $WA_ACTIVE = 1
Global Const $WA_CLICKACTIVE = 2
Global Const $WA_INACTIVE = 0

Global Const $VIP = 1

Global $hGUI, $iBtnStart, $iBtnStop, $iBtnClean, $iBtnPause, $iBtnUnPause, $aPIDs, $iUnSel = 1 , $btnAllStop;$hSETUP
Global $stTabs , $tmpStbs ;= $windowTabs; временное количество вкладок
$tmpStbs = $windowTabs+1
Global $strl4 , $iTab , $hImage ; элемент иконок кнопки

; размеры gui
Global Const $NameGUI = "AiGUI"
Global Const $WWidth = 670 , $WHeight = 450 ; ширина и высота окна 450
Global Const $StrTool = 35 ; сверху первая строка под вкладкой.
Global Const $THeight = $WHeight-82 ; высота консоли


_iniLoad() ; загрузить настройки из ini <aig-ini.au3>
_sLine()  ; загрузить строки
Global $iBtnStart[$windowTabs+1],$iBtnStop[$windowTabs+1],$iBtnClean[$windowTabs+1],$iEdt[$windowTabs+1]
Global $iBtnUnPause[$windowTabs+1],$iBtnPause[$windowTabs+1] , $iBtnCont[$windowTabs+1]
Global $iPIDx[$windowTabs+1] , $aPIDs[$windowTabs+1] , $sOut[$windowTabs+1] , $getTab ;=GUICtrlRead($iTab)-1
Global $sn_info[$windowTabs+1],$st_typecmd[$windowTabs+1],$st_expath[$windowTabs+1],$st_exname[$windowTabs+1],$st_server[$windowTabs+1],$st_urlprofile[$windowTabs+1]
Global $st_port[$windowTabs+1],$st_user[$windowTabs+1],$st_devr[$windowTabs+1],$st_pass[$windowTabs+1],$st_exlog[$windowTabs+1],$st_params[$windowTabs+1]
Global $conOut[$windowTabs+1] = [0]; временная переменная вываода
;Global $aSel[2]

Global Const $txtQual = 3 ; сглаживание
Global $st_trayexit

Global $lbT[$windowTabs+1]; активность
Global Const $lbTAct = 0x00FF09 ;цвет активного индикатора
Global Const $lbTdeact = 0xFBD7F4 ;цвет НЕактивного индикатора
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
TraySetState(1) ; Показывает меню трея
;OnAutoItExitRegister("_OnExit")

_Main()

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
While 1
   Switch TrayGetMsg()
	  Case -8;$TRAY_EVENT_PRIMARYUP
		 WinSetState ( $hGUI, Null, @SW_SHOW )
		 WinActivate ( $hGUI, Null )
	  EndSwitch

Switch $streadmode; = 0 ;0 _Update(), 1 _Update()
	Case 0
		_Update()
	Case Else
	  _Update2()
EndSwitch

Sleep(10)
;GUISetState($hSETUP)
WEnd
;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
Func _Main()

Select ; определение прав запуска
   Case IsAdmin()
	  $nGUI = " - Администратор"
   Case Else
	  $nGUI = " - без прав администратора"
EndSelect

Switch IniRead ($sysini,"GUI","Win7Style", 0); стиль окна. 0=стандартная, 1=изменённая(стабильность не проверена)
	Case 0
		;$hGUI = GUICreate($NameGUI & "  " & FileGetVersion(@AutoItExe) & $version & $nGUI,$WWidth,$WHeight,-1,-1)
		$hGUI = GUICreate($NameGUI & "  " & $version & $nGUI,$WWidth,$WHeight,-1,-1)
	Case 1
		;$hGUI = GUICreate($NameGUI & "  " & FileGetVersion(@AutoItExe) & $version & $nGUI,$WWidth,$WHeight,-1,-1,13500416);BitXOR($WS_OVERLAPPEDWINDOW, $WS_MAXIMIZEBOX) ;0x00010000
		$hGUI = GUICreate($NameGUI & "  " & $version & $nGUI,$WWidth,$WHeight,-1,-1,13500416);BitXOR($WS_OVERLAPPEDWINDOW, $WS_MAXIMIZEBOX)=13500416; $WS_EX_CONTROLPARENT=65536
		_GUICtrlMenu_DeleteMenu(_GUICtrlMenu_GetSystemMenu($hGUI), 2)
		GUIRegisterMsg(0x0020, 'WM_SETCURSOR');$WM_SETCURSOR=0x0020
	Case 2
$hGUI = GUICreate($NameGUI & "  " & $version & $nGUI,$WWidth,$WHeight+20,-1,-1,0x80800000,65536);BitXOR($WS_OVERLAPPEDWINDOW, $WS_MAXIMIZEBOX)
GUISetBkColor(0xE0FFFF) ; устанавливает цвет фона
;								0x80000000+0x00800000 = 0x80800000
		;_GUICtrlMenu_DeleteMenu(_GUICtrlMenu_GetSystemMenu($hGUI), 2)
		;GUIRegisterMsg(0x0020, 'WM_SETCURSOR');$WM_SETCURSOR=0x0020
EndSwitch

;MsgBox(4096, "" , BitXOR($WS_OVERLAPPEDWINDOW, $WS_MAXIMIZEBOX,$WS_EX_CONTROLPARENT));13500416
;MsgBox(4096, "" , $WS_EX_CONTROLPARENT   ); 13565952;

IniWrite($sysini, "RUN", "RunPID", WinGetProcess ( $hGUI )); отметить что программа запущена
IniWrite($sysini, "RUN", "RunGUI", '"' & $NameGUI & " " & $version & $nGUI & '"')

;GUISetIcon(@SystemDir & "\cmd.exe", 0)
GUISetOnEvent(-3, '_closeWin', $hGUI);$GUI_EVENT_CLOSE
GUISetOnEvent(-4, '_hideWin', $hGUI);$GUI_EVENT_MINIMIZE

GUISetFont(8.5, Null, Null, Null ,$hGUI , $txtQual);бесполезный код

$iTab = GUICtrlCreateTab(6, 5, $WWidth-10, $WHeight-10) ;создать вкладки с отступом 5 по краям окна, и 5 внутри ;$TCS_HOTTRACK
;..................................................................................................
GUICtrlCreateTabItem("  Панель  "); Вкладка для инструментов

GUICtrlCreateGroup("", 15 , $StrTool-5 , $WWidth-32 , $WHeight-46)
GUICtrlCreateLabel($NameGUI & " - зелёная фигня", 20, $StrTool+5, $WWidth-42-70, 60)
GUICtrlSetFont(-1, 10.5, 400, 0 , "Arial" , 5)
GUICtrlSetBkColor(-1, 0x00FF00)


;_GUIImageList_AddIcon($hImage, @ScriptName, 201, True)
$btnHL = GUICtrlCreateButton("", $WWidth-50, $StrTool+9, 24, 24, $BS_ICON)
;GUICtrlSetImage ( -1, "shell32.dll", 154+109 ,0);154 215
GUICtrlSetImage ( -1, "winhlp32.exe", 0 ,0);154 215
;GUICtrlSetImage ( -1, @ScriptName, 201 ,0);154 215
GUICtrlSetOnEvent(-1, "btnHL")

Local Const $tCordLbtL = 33 ; левый край
Local Const $tCordLbtT = $StrTool+80 ;верхний край
Local Const $tCordSV = 20 ;вертикальный шаг
Local Const $tCordSzV = 18 ; высота надписи
Local Const $tCordSzH = 150 ; длина надписи
GUICtrlCreateGroup("", $tCordLbtL-8 , $tCordLbtT-14 , $tCordSzH*2+21 , $tCordSV*9+1)
For $i=0 To $windowTabs ; рисуем индикаторы
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
$btnTM = GUICtrlCreateButton("Диспетчер задач", 187, $WHeight-100, 147, 40)
GUICtrlSetOnEvent(-1, "btnTM")
_GUICtrlButton_SetImageList($btnTM, $hImage)

$hImage = _GUIImageList_Create(32, 32, 5, 3)
_GUIImageList_AddIcon($hImage, "devmgr.dll", 4, True)
$btnDM = GUICtrlCreateButton("Диспетчер устройств", 25, $WHeight-100, 157, 40)
GUICtrlSetOnEvent(-1, "btnDM")
_GUICtrlButton_SetImageList($btnDM, $hImage)






$hImage = _GUIImageList_Create(32, 32, 5, 3);, 6)
_GUIImageList_AddIcon($hImage, "cmd.exe", 0, True)
$btnCM = GUICtrlCreateButton("Командная строка", 339, $WHeight-100, 150, 40) ; 339 $WWidth-331
_GUICtrlButton_SetImageList($btnCM, $hImage)
GUICtrlSetOnEvent(-1, "btnCM")

$hImage = _GUIImageList_Create(32, 32, 5, 3);, 6)
_GUIImageList_AddIcon($hImage, "shell32.dll", 21, True)
;$hImage = _GUIImageList_Create(30, 30, 5, 3);, 6)
;_GUIImageList_AddIcon($hImage, "mycomput.dll", 0, True)
$btnST = GUICtrlCreateButton("Настройки", 494 , $WHeight-100, 150, 40);494 $WWidth-176
_GUICtrlButton_SetImageList($btnST, $hImage)
GUICtrlSetOnEvent(-1, "btnST")

$hImage = _GUIImageList_Create(32, 32, 5, 3);, 6)
_GUIImageList_AddIcon($hImage, "calc.exe", 0, True)
$btnCA = GUICtrlCreateButton("Калькулятор", 339, $WHeight-148, 150, 40);494-145
_GUICtrlButton_SetImageList($btnCA, $hImage)
GUICtrlSetOnEvent(-1, "btnCA")


;$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
$hImage = _GUIImageList_Create(17 , 17,5, 3);,5 )
_GUIImageList_AddIcon($hImage, "msconfig.exe", 0, True)
$btnMC = GUICtrlCreateButton("msconfig", 25, $WHeight-51, 80, 24) ;157 40
_GUICtrlButton_SetImageList($btnMC, $hImage)
GUICtrlSetOnEvent(-1, "btnMC")



$hImage = _GUIImageList_Create(17 , 17,5, "");,5 )
_GUIImageList_AddIcon($hImage, "miguiresource.dll", 1, True)
$btnTC = GUICtrlCreateButton("taskschd", 25+87, $WHeight-51, 80, 24) ;157 40
_GUICtrlButton_SetImageList($btnTC, $hImage)
GUICtrlSetOnEvent(-1, "btnTC")





;VIP buttons
Switch $VIP
   Case 1
$hImage = _GUIImageList_Create(32, 32, 5, 3);, 6)
_GUIImageList_AddIcon($hImage, "shell32.dll", 215, True)
$btnAllStop = GUICtrlCreateButton("Остановить всё", $WWidth-176, $tCordLbtT-8, 150, 40) ;$WWidth-176 ;;494-145
_GUICtrlButton_SetImageList($btnAllStop, $hImage)
GUICtrlSetOnEvent(-1, "btnAllStop")
GUICtrlSetState(-1, $GUI_DISABLE)

EndSwitch
;End VIP buttons

;..................................................................................................
For $t = 0 To $windowTabs
GUICtrlCreateTabItem($info[$t]) ; Вкладки программ

;gameux.dll
$hImage = _GUIImageList_Create(24, 24, 5, 3);, 6)
;_GUIImageList_AddIcon($hImage, "gameux.dll", 2, True)
_GUIImageList_AddIcon($hImage, "shell32.dll", 137, True)
$iBtnStart[$t] = GUICtrlCreateButton("Старт", 14, $THeight+35 , 95, 32, $BS_DEFPUSHBUTTON)
GUICtrlSetOnEvent(-1, "StartPressed")
_GUICtrlButton_SetImageList(-1, $hImage)

$hImage = _GUIImageList_Create(24, 24, 5, 3);, 6)
_GUIImageList_AddIcon($hImage, "SyncCenter.dll", 5, True)
$iBtnStop[$t] = GUICtrlCreateButton("Стоп", 100+5+5+5, $THeight+35, 95, 32, 0x01) ; $BS_DEFPUSHBUTTON
GUICtrlSetOnEvent(-1, "StopPressed")
GUICtrlSetState(-1, $GUI_DISABLE)
_GUICtrlButton_SetImageList(-1, $hImage)



$hImage = _GUIImageList_Create(24, 24, 5, 3);, 6)
_GUIImageList_AddIcon($hImage, "imageres.dll", 93, True)
$iBtnClean = GUICtrlCreateButton("Очистить", 186+10+10+10, $THeight+35, 95, 32)
GUICtrlSetOnEvent(-1, "CleanPressed")
_GUICtrlButton_SetImageList(-1, $hImage)

GUICtrlCreateIcon("mblctr.exe", 133, $WWidth-44, $WHeight-47)
;GUICtrlSetImage ( -1, "winhlp32.exe", 0 ,0);154 215


;$iBtnCont[$t] = GUICtrlCreateButton("Продолжить" , 272, $THeight+35, 80, 25)
;;GUICtrlSetState($iBtnCont[$t], $GUI_DISABLE)
;GUICtrlSetOnEvent(-1, "ButtonCont");ButtonCont

;MsgBox(4096, "lll" , $windowTabs)
;
$iEdt[$t] = GUICtrlCreateEdit("==>[" & $t & "]" & @CRLF & _Encoding_OEM2ANSI($sLine[$t]) & $itmHello[$t] , 14, $StrTool, $WWidth-30, $THeight-8, 2099264);BitOR($ES_READONLY, $ES_AUTOVSCROLL, $WS_VSCROLL))
GUICtrlSendMsg(-1, $EM_LIMITTEXT, -1, 0)
;GUIRegisterMsg($WM_ACTIVATE, "WM_ACTIVATE")
;MsgBox(4096, "lll" , BitOR($ES_READONLY, $ES_AUTOVSCROLL, $WS_VSCROLL))2099264


Next

GUISetState(@SW_SHOW, $hGUI)
EndFunc ;==>_Main
;--------------------------------------------------------------------------------------------------
Func btnST() ; окно настроек
;$setEXIT = 0
;$guiSZ = WinGetClientSize ($hGUI );670 450
;$guiCoord = WinGetPos ($hGUI);676 478

WinSetState ( $hGUI, Null, @SW_DISABLE )
Local $guiCoord = WinGetPos ($hGUI)

;local Const $snMain1 = $guiCoord[2]-38 ; шир.
;local Const $snMain2 = $guiCoord[3]-60 ; выс.

;Local $stTabs
;												20+4ж+2		41+2			+2			+8
;$hSETUP = GUICreate("Настройки", $guiCoord[2]-16, $guiCoord[3]-39, $guiCoord[0]+7, $guiCoord[1]+30, -2139095040, -1, $hGUI);BitOR ($WS_BORDER, $WS_POPUP)
GUICreate("Настройки", $guiCoord[2]-16, $guiCoord[3]-39, $guiCoord[0]+7, $guiCoord[1]+30, -2139095040, -1, $hGUI);BitOR ($WS_BORDER, $WS_POPUP)

;MsgBox(4096, "lll" ,  BitOR ($WS_BORDER, $WS_POPUP))
;$hSETUP = GUICreate("Настройки", $guiCoord[2]-20, $guiCoord[3]-41, $guiCoord[0]+8, $guiCoord[1]+30, $WS_BORDER, -1, $hGUI)
;GUICtrlCreateGroup("Настройки", 9, 9 , $guiCoord[2]-38 , $guiCoord[3]-60)
GUICtrlCreateGroup("Настройки", 11, 9 , $guiCoord[2]-38 , 70)

  ;"X=" & $guiCoord[0] & @LF & @TAB & _
 ;"Y=" & $guiCoord[1] & @LF & @LF & _
;"Размеры:" & @LF & @TAB & _
;"ширина =  " & $guiCoord[2] & @LF & @TAB & _
;"высота  =  " & $guiCoord[3])



;$btnCM = GUICtrlCreateButton("Командная строка", 339, $WHeight-97, 150, 40) ; 339 $WWidth-331

$hImage = _GUIImageList_Create(24, 24, 5, 3);, 6)
;_GUIImageList_AddIcon($hImage, "shell32.dll", 146, True)
_GUIImageList_AddIcon($hImage, "imageres.dll", 161, True) ;161 ;218 not win10
GUICtrlCreateButton("Закрыть", 25, 32, 100, 32)
GUICtrlSetOnEvent(-1, "SetsClose")
_GUICtrlButton_SetImageList(-1, $hImage)


$hImage = _GUIImageList_Create(24, 24, 5, 3);, 6)
;_GUIImageList_AddIcon($hImage, "DeviceCenter.dll", 3, True)
_GUIImageList_AddIcon($hImage, "shell32.dll", 165, True)
;_GUIImageList_AddIcon($hImage, "imageres.dll", 111, True)
GUICtrlCreateButton("Сохранить", 137, 32, 100, 32)
GUICtrlSetOnEvent(-1, "SetsSave")
_GUICtrlButton_SetImageList(-1, $hImage)





;;..................................................................................................
Local Const $snTabs1 = $guiCoord[2]-82 ; позиция_ ;276
Local Const $snTabs2 = $guiCoord[3]-80	; вкладок. ;438
GUICtrlCreateGroup(Null, $snTabs1-123, $snTabs2-16 , 178 , 45)
GUICtrlCreateLabel("Количество вкладок", $snTabs1-109, $snTabs2+3)
$stTabs = GUICtrlCreateInput($tmpStbs, $snTabs1, $snTabs2, 40, 20)
GUICtrlCreateUpdown(-1,BitOR (0x40 , 0x01, 0x20) )
GUICtrlSetLimit(-1, 10, 1)
;;..................................................................................................
; ширина-отступ. высота-максимальная высота-отступ
;(высота-отступ снизу не верно $guiCoord[3]-455). не верно  $guiCoord[3]-$WHeight-13
$st_trayexit = GUICtrlCreateCheckbox("Сворачивать в трей", $guiCoord[2]-160, 25, 120, 20,0x0020); $BS_RIGHTBUTTON)
Switch $trayexit
   Case 1
	  GUICtrlSetState ( $st_trayexit, 1 ) ;$GUI_CHECKED 1
   Case Else
	  GUICtrlSetState ( $st_trayexit, 4 ) ; $GUI_UNCHECKED 4
EndSwitch
;..................................................................................................
Local Const $snTUD = 110 ; вертикаль таблицы
local Const $snMLen = 200 ; длина поля путь
Local Const $snXLen = 100
Local Const $snSWLen = 165
Local Const $snPLen = $snSWLen-65
Local Const $snULen = 280 ;пользователь длина
Local Const $snRLen = 70 ; префикс
Local Const $snPSLen = 150
;Local Const $snLLen = $guiCoord[2]-96

GUICtrlCreateTab(12, $snTUD, $guiCoord[2]-38, 250)

For $i=0 To $windowTabs
GUICtrlCreateTabItem($i)

;GUICtrlCreateLabel("Mode", 40, $snTUD+30, 32)
;GUICtrlSetBkColor(-1,0x00FF09)
;$snInfo[$i] = GUICtrlCreateInput($info[$i], 63, $snTUD+30, $snMLen-2,20)
;GUICtrlCreateInput($info[$i], 63, $snTUD+30, $snMLen-2,20)
;MsgBox(0, "WinGetPos активного окна", $i)

$sn_info[$i] = GUICtrlCreateInput($info[$i], 66, $snTUD+30, $snMLen-2,20)

If $exlpid[$i] Then GUICtrlCreateLabel("Last PID " & $exlpid[$i], $snMLen+72+3, $snTUD+30, 100,20)

GUICtrlCreateLabel("Mode:", 24, $snTUD+30, 28, 20, 0x0200)
$st_typecmd[$i] = GUICtrlCreateCombo($typecmd[$i], 24, $snTUD+60, 32, 100)
GUICtrlSetData(-1, "0|1|2",$typecmd[$i])

$st_expath[$i] = GUICtrlCreateInput($expath[$i], 62+3, $snTUD+60,  $snMLen, 20)
$st_exname[$i] = GUICtrlCreateInput($exname[$i], $snMLen+72+3, $snTUD+60,  $snXLen, 20)

GUICtrlCreateLabel("Server:", 20+3, $snTUD+90, 35, 20, 0x0200)
$st_server[$i] = GUICtrlCreateInput($server[$i], 57+3, $snTUD+90, $snSWLen,20)
$st_port[$i] = GUICtrlCreateInput($port[$i], $snSWLen+30+39+3, $snTUD+90, $snPLen,20) ;$snSWLen+40+$snPLen

GUICtrlCreateLabel("User:", 20+3, $snTUD+120, 28, 20, 0x0200)
$st_user[$i] = GUICtrlCreateInput($user[$i], 50+3, $snTUD+120, $snULen,20)
GUICtrlCreateLabel("&&", $snULen+51+3, $snTUD+120, 10, 20, 0x0200)
;GUICtrlSetBkColor(-1,0x00FF09)
$st_devr[$i] = GUICtrlCreateInput($devr[$i], $snULen+30+2+26+3, $snTUD+120, $snRLen,20)
GUICtrlCreateLabel("Pass:", $snULen+$snRLen+60+3, $snTUD+120, 30, 20, 0x0200)
;GUICtrlSetBkColor(-1,0x00FF09)
$st_pass[$i] = GUICtrlCreateInput($pass[$i], $snULen+$snRLen+91+3, $snTUD+120, $snPSLen,20)

GUICtrlCreateLabel("Log:", 20+3, $snTUD+150, 28, 20, 0x0200)
;GUICtrlSetBkColor(-1,0x00FF09)
$st_exlog[$i] = GUICtrlCreateInput($exlog[$i], 53+3, $snTUD+150, $guiCoord[2]-96,20)

$st_params[$i] = GUICtrlCreateInput($params[$i], 20+4, $snTUD+180, $guiCoord[2]-63,20)

GUICtrlCreateLabel("Url:", 20+3, $snTUD+210, 28, 20, 0x0200)
$st_urlprofile[$i] = GUICtrlCreateInput($urlprofile[$i], 53+3, $snTUD+210, $guiCoord[2]-96,20)

Next

;$stTabs = GUICtrlCreateInput($tmpStbs, $snTabs1, $snTabs2, 40, 20)




;MsgBox(0, "WinGetPos активного окна", $exname[5])
  ;"X=" & $guiCoord[0] & @LF & @TAB & _
 ;"Y=" & $guiCoord[1] & @LF & @LF & _
;"Размеры:" & @LF & @TAB & _
;"ширина =  " & $guiCoord[2] & @LF & @TAB & _
;"высота  =  " & $guiCoord[3])
GUISetState(@SW_SHOW)
;GUISwitch($hGUI)
EndFunc
;--------------------------------------------------------------------------------------------------
Func SetsClose(); закрыть окно настроек
GUIDelete(@GUI_WinHandle);@GUI_WinHandle ;$hSETUP
WinSetState ( $hGUI, Null, @SW_ENABLE )
WinSetState ( $hGUI, Null, @SW_SHOW )
WinActivate ( $hGUI, Null )
EndFunc
;--------------------------------------------------------------------------------------------------
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

Switch GUICtrlRead($st_trayexit)
   Case 1
	  $trayexit = 1
   Case Else
	  $trayexit = 0
EndSwitch

_saveSysIni()

   ;MsgBox(4096, "Настройки : вкладки" ,GUICtrlRead($st_trayexit))


Select
   Case $tmpStbs <> $windowTabs+1
MsgBox(4096, "Настройки : вкладки" , "Настройки изменены" & @CRLF & "Текущие вкладки: " & $windowTabs+1 & @CRLF & "После перезапуска: " & $tmpStbs & " вкладок")
EndSelect

   SetsClose()
EndFunc
;--------------------------------------------------------------------------------------------------
Func WM_ACTIVATE($hWnd, $iMsg, $wParam, $lParam)
    Switch _WinAPI_LoWord($wParam)
        Case $WA_ACTIVE, $WA_CLICKACTIVE
            AdlibRegister("_Update")
     ;   Case $WA_INACTIVE
    ;        AdlibUnRegister("_Update")
    EndSwitch
EndFunc   ;==>WM_ACTIVATE
;--------------------------------------------------------------------------------------------------
Func _Update()
For $i = 0 to $windowTabs

; Local $vTemp = $sOut & _WinAPI_OemToChar(StdoutRead($iPID)), $aSel = GUICtrlRecvMsg($iEdt, $EM_GETSEL)


;Local $stdTmp = DllCall('user32.dll', 'bool', 'OemToChar', 'str', StdoutRead($iPIDx[$i]), 'str', StdoutRead($iPIDx[$i]))[2]
;Local $vTemp = $sOut[$i] & _Encoding_UTF8ToANSI_API( $stdTmp )
Local $vTemp = $sOut[$i] & DllCall('user32.dll', 'bool', 'OemToChar', 'str', StdoutRead($iPIDx[$i]), 'str', StdoutRead($iPIDx[$i]))[2]
Local $strl4 =  StringLen ( $vTemp )
Local $aSel = GUICtrlRecvMsg($iEdt[$i],0xB0 ); 0xB0 $EM_GETSEL$selectTime

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
   _debug_send_file()
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
		; AdlibRegister("_UnSel", 5000);$selectTime
EndSelect
    EndIf

   ;  MsgBox(4096, $i ,  $exlpid[$i])
;Select

 ;  Case $exlpid[$i] > Null
   ; GUICtrlSetData($iBtnCont,'1 минута' &  $exlpid[$i] )
	;  GUICtrlSetState($iBtnCont[$i], $GUI_ENABLE)

;	EndSelect

Next
EndFunc   ;==>_Update
;--------------------------------------------------------------------------------------------------

Func _Update2()

Local $getTab = GUICtrlRead($iTab)-1

For $i = 0 to $windowTabs

;прочитать поток во временную переменную $vTemp
Local $vTemp = $sOut[$i] & DllCall('user32.dll', 'bool', 'OemToChar', 'str', StdoutRead($iPIDx[$i]), 'str', StdoutRead($iPIDx[$i]))[2]
;Local $strl4 =  StringLen ( $vTemp )


Select
   Case $getTab > -1
	  Local $aSel = GUICtrlRecvMsg($iEdt[$getTab], 0xB0 ); 0xB0 $EM_GETSEL
EndSelect

;MsgBox(4096,"_iniDefLoad",$aSelt[0]&" "&$aSelt[0])


;Local $aSel = $conOut[$i]


Select ; усли вывод $sOut[$i] не равен $vTemp, сделать таким и использовать $vTemp как флаг 1
   Case $vTemp <> $sOut[$i]
		 ;$sOut[$i] = $vTemp & " >" & $strl4 & @CRLF ;+ отладочная метка
		 $sOut[$i] = $vTemp;	 & @CRLF

;Select ; очищать окно с сохранением в файл
;Case $strl4 > $strLimit ; если строка слишком длинная
  ; Local $nFile = @WorkingDir & "\tmp\zLog" & "_" & $i & "_" & @YEAR & @MON & @MDAY & "." & @MIN & @SEC & ".txt"
   ;$hFile = FileOpen($nFile, 1)
   ;FileWrite($hFile, $sOut[$i] & @CRLF & ">" & $strl4 & "<")
   ;FileClose($hFile)
 ;  _debug_send_file()
 ;  $sOut[$i] = "Превышено " & $strl4 & " знаков." & @CRLF & "Прошлый вывод сохранён в " & $nFile & @CRLF
  ; $strl4 = 0
;EndSelect

		 $vTemp = 1
   Case Else
		 $vTemp = 0
EndSelect

    If @error Or (Not @error And $aSel[0] = $aSel[1]) Then
Select
    Case $vTemp ;=1

		;Select
		; Case $getTab = $i
		GUICtrlSetData($iEdt[$getTab], $sOut[$getTab])
		 GUICtrlSendMsg($iEdt[$getTab], $EM_SCROLL, 7, 0);$SB_BOTTOM=7
		; EndSelect



	  EndSelect

	 Else
Select
    Case $iUnSel
		 $iUnSel = 0
		 AdlibRegister("_UnSel", $selectTime)
EndSelect
    EndIf

   ;  MsgBox(4096, $i ,  $exlpid[$i])
;Select

 ;  Case $exlpid[$i] > Null
   ; GUICtrlSetData($iBtnCont,'1 минута' &  $exlpid[$i] )
	;  GUICtrlSetState($iBtnCont[$i], $GUI_ENABLE)

;	EndSelect

Next
EndFunc   ;==>_Update2
;--------------------------------------------------------------------------------------------------
Func _UnSel()

  Local $getTab = GUICtrlRead($iTab)-1
 ; If $getTab < 0 Then $getTab = 0

    GUICtrlSendMsg($iEdt[$getTab], $EM_SETSEL, -1, 0)
    GUICtrlSendMsg($iEdt[$getTab], $EM_SCROLL, 7, 0);$SB_BOTTOM=7
    AdlibUnRegister("_UnSel")
    $iUnSel = 1
EndFunc   ;==>_UnSel
;--------------------------------------------------------------------------------------------------
Func StartPressed()
Local $getTab = GUICtrlRead($iTab)-1
   $iPIDx[$getTab] = Run(@ComSpec , Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
   If ProcessExists ( $iPIDx[$getTab] ) Then GUICtrlSetBkColor($lbT[$getTab], $lbTAct)
   ;OnAutoItExitRegister("_OnExit")
   $exlpid[$getTab] = $iPIDx[$getTab]
   _iniSave()
	  GUICtrlSetState($iBtnStart[$getTab], $GUI_DISABLE)
	  GUICtrlSetState($iBtnStop[$getTab], $GUI_ENABLE)
	  GUICtrlSetState($btnAllStop, $GUI_ENABLE)
	  StdinWrite($iPIDx[$getTab], $sLine[$getTab])
EndFunc

;--------------------------------------------------------------------------------------------------
Func StopPressed()
   ;GUICtrlSetBkColor($lbT[$getTab], 0xEBA794)

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
;--------------------------------------------------------------------------------------------------
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
;--------------------------------------------------------------------------------------------------
Func CleanPressed()
Local $getTab = GUICtrlRead($iTab)-1
;GUICtrlSetData($iEdt[GUICtrlRead($iTab)-1], Null)
GUICtrlSetData($iEdt[$getTab], Null)
$sOut[$getTab] = Null
EndFunc
;--------------------------------------------------------------------------------------------------
;Func ButtonCont()
;Local $getTab = GUICtrlRead($iTab)-1
;   $iPIDx[$getTab] = $exlpid[$getTab]
;
;	  GUICtrlSetState($iBtnStart[$getTab], $GUI_DISABLE)
;	  GUICtrlSetState($iBtnStop[$getTab], $GUI_ENABLE)
;	  StdinWrite($iPIDx[$getTab], $sLine[$getTab])
;EndFunc
;--------------------------------------------------------------------------------------------------
Func _closeWin(); кнопка закрытия окна
   Switch $trayexit
	  Case 1
		 _hideWin()
	  Case Else
		 _ProExit()
   EndSwitch
EndFunc
;--------------------------------------------------------------------------------------------------
Func _hideWin(); скрыть главное окно
 ;  AdlibUnRegister("_UnSel")
WinSetState ( $hGUI, Null, @SW_HIDE )
EndFunc
;--------------------------------------------------------------------------------------------------
Func _ProExit()
	; нажата кнопка выход на окне
Switch MsgBox(4+32+8192, 'Выход из программы', 'Выйти из программы' & @CRLF & 'завершив все процессы ?',10)
	Case 6
		_OnExit()
		IniDelete ( $sysini, "RUN" );IniWrite($sysini, "RUN", "RunPID", "");IniWrite($sysini, "RUN", "RunGUI", "")
		_debug_stop()
		Exit
EndSwitch

 EndFunc
;--------------------------------------------------------------------------------------------------
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
;--------------------------------------------------------------------------------------------------
Func btnHL()
EndFunc
;--------------------------------------------------------------------------------------------------
Func btnTM()
ShellExecute(@SystemDir & '\taskmgr.exe', '', '', '', @SW_SHOW)
;Run (@SystemDir & "\taskmgr.exe", @SystemDir ,@SW_SHOW)
;Run(@ComSpec & ' /c ' & @SystemDir & "\taskmgr.exe", @SystemDir, @SW_HIDE)
EndFunc
;--------------------------------------------------------------------------------------------------
Func btnDM()
ShellExecute(@SystemDir & '\mmc.exe', @SystemDir & "\devmgmt.msc", '', '', @SW_SHOW)
;Run (@SystemDir & "\mmc.exe " & @SystemDir & "\devmgmt.msc" , @SystemDir ,@SW_SHOW)
;;Run(@ComSpec & ' /c ' & @SystemDir & "\mmc.exe " & @SystemDir & "\devmgmt.msc", @SystemDir, @SW_HIDE)
EndFunc
;--------------------------------------------------------------------------------------------------
Func btnCM()
ShellExecute(@SystemDir & '\cmd.exe', '', '', '', @SW_SHOW)
;Run (@SystemDir & "\cmd.exe", @WorkingDir ,@SW_SHOW)
EndFunc
;--------------------------------------------------------------------------------------------------
Func btnCA()
ShellExecute(@SystemDir & '\calc.exe', '', '', '', @SW_SHOW)
;Run (@SystemDir & "\calc.exe", @WorkingDir ,@SW_SHOW)
EndFunc
;--------------------------------------------------------------------------------------------------
Func btnMC()
ShellExecute(@SystemDir & '\msconfig.exe', '', '', '', @SW_SHOW)
;Run (@SystemDir & "\msconfig.exe", @WorkingDir ,@SW_SHOW)
EndFunc
;--------------------------------------------------------------------------------------------------
Func btnTC()
ShellExecute(@SystemDir & '\mmc.exe', @SystemDir & "\taskschd.msc /s", '', '', @SW_SHOW)
EndFunc
;--------------------------------------------------------------------------------------------------
Func WM_SETCURSOR($hWnd, $Msg, $wParam, $lParam)
    If $wParam = $hGUI Then
        Switch BitAND($lParam, 0xFFFF) ; _WinAPI_LoWord
            Case 10 To 18
                GUISetCursor(2)
        EndSwitch
   EndIf
   Return 'GUI_RUNDEFMSG';$GUI_RUNDEFMSG
EndFunc ; ==> WM_SETCURSOR
;--------------------------------------------------------------------------------------------------
