﻿#Region
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_UseUpx=n
;#AutoIt3Wrapper_Compression=3
#AutoIt3Wrapper_Res_Language=1049
#AutoIt3Wrapper_Icon=res\icon00.ico
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_Fileversion=0.1.1.278
#AutoIt3Wrapper_Res_Description=Окно консоли
#AutoIt3Wrapper_Res_Field=ProductName|Окно консоли
#AutoIt3Wrapper_Res_Field=Build|%longdate% %time%
;#AutoIt3Wrapper_Res_Field=OriginalFileName|exe;gui.exe
#AutoIt3Wrapper_Res_ProductVersion=0.1α
#AutoIt3Wrapper_Res_LegalCopyright=©
;#AutoIt3Wrapper_Res_Comment=Consoles GUI
#AutoIt3Wrapper_Res_Icon_Add=res\icon01.ico;gui icon
#AutoIt3Wrapper_Res_Icon_Add=res\icon02.ico;gui icon admin
#AutoIt3Wrapper_Res_Icon_Add=res\icon03.ico;tray
;#AutoIt3Wrapper_Res_File_Add=res\devcon64.exe
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/pe /sf /sv /om /rm; /SCI=1
#AutoIt3Wrapper_Run_After=del /f /q "%scriptdir%\%scriptfile%_stripped.au3"
#AutoIt3Wrapper_Run_After=Utilities\ResourceHacker.exe -delete %out%, %out%, Icon, 169,
#AutoIt3Wrapper_Run_After="%autoitdir%\Aut2Exe\Upx.exe" %out% --best --no-backup --overlay=copy --compress-exports=1 --compress-resources=1 --strip-relocs=1
#EndRegion

#NoTrayIcon
#include <includes.au3>
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
_debug_start()
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#Region one start
$hGUI = IniRead ($sysini,"RUN","RunGUIh", Null)
Select ; не запускать вторую копию программы ; @ScriptName
Case $hGUI <> "" And ProcessExists ( IniRead ($sysini,"RUN","RunPID", Null) )
$hGUI = HWnd($hGUI)
_showWin()
Exit
EndSelect
#EndRegion
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Opt("TrayAutoPause", 0)
Opt('TrayMenuMode', 3)	;	http://autoit-script.ru/autoit3_docs/functions/AutoItSetOption.htm
Opt("GUIOnEventMode", 1)
Opt("TrayOnEventMode", 1)
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Switch IniRead ($sysini,"LOG","CheckDll", "")
	Case 1 ; 1=проверять системные ресурсы
	_dllCHK()
EndSwitch
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#Region Global
Global Const $WA_ACTIVE = 1
Global Const $WA_CLICKACTIVE = 2
Global Const $WA_INACTIVE = 0

Global Const $VIP = 1

Global $hGUI, $iBtnStart, $iBtnStop, $iBtnClean, $aPIDs, $iUnSel = 1 , $btnAllStop, $btnAllStart, $hSETUP ;$iBtnPause, $iBtnUnPause,
Global $stTabs , $tmpStbs ;= $windowTabs; временное количество вкладок
$tmpStbs = $windowTabs+1
Global $strl4 , $iTab , $hImage ; элемент иконок кнопки

; размеры gui
Global $NameGUI = "CIVIR ETIYUA"
Global Const $WWidth = 670 , $WHeight = 450 ; ширина и высота окна 450
Global Const $StrTool = 35 ; сверху первая строка под вкладкой.
Global Const $THeight = $WHeight-82 ; высота консоли

Global $iBtnStart[$windowTabs+1],$iBtnStop[$windowTabs+1],$iBtnClean[$windowTabs+1],$iEdt[$windowTabs+1]
Global $iBtnUnPause[$windowTabs+1],$iBtnPause[$windowTabs+1] , $iBtnCont[$windowTabs+1]
Global $iPIDx[$windowTabs+1] , $aPIDs[$windowTabs+1] , $sOut[$windowTabs+1] , $getTab ;=GUICtrlRead($iTab)-1
Global $sn_info[$windowTabs+1],$st_typecmd[$windowTabs+1],$st_expath[$windowTabs+1],$st_exname[$windowTabs+1],$st_server[$windowTabs+1],$st_urlprofile[$windowTabs+1]
Global $st_port[$windowTabs+1],$st_user[$windowTabs+1],$st_devr[$windowTabs+1],$st_pass[$windowTabs+1],$st_exlog[$windowTabs+1],$st_params[$windowTabs+1]
Global $ckbxBigRun[$windowTabs+1], $BigRun[$windowTabs+1], $ckbxBigRunA[$windowTabs+1] ;, $BigRunA[$windowTabs+1], $BigRunSel[$windowTabs+1]
Global $outMode[$windowTabs+1],$outFile[$windowTabs+1]



;	$outFile[]= StringRegExp ( StringRegExpReplace( StringRegExpReplace($exlog[$i], "%date", @YEAR & "." & @MON &"."& @MDAY) , "%time" , @HOUR &"."& @MIN &"."& @SEC ),'[A-Z]:[^" -]+',1)
Global $vTemp
;Global $conOut[$windowTabs+1] = [0]; временная переменная вываода
;Global $aSel[2]

;Global Const $txtQual = 3 ; сглаживание
Global $st_trayexit, $st_browser

Global $lbT[$windowTabs+1]; активность
Global Const $lbTAct = 0x00FF09 ;цвет активного индикатора
Global Const $lbTdeact = 0xFBD7F4 ;цвет НЕактивного индикатора
#EndRegion Global
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
_loadSysIni()
_iniLoad() ; загрузить настройки из ini <aig-ini.au3>
_sLine()  ; загрузить строки
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
TraySetState(1) ; Показывает меню трея
TraySetIcon ( @ScriptFullPath, 203 )
;OnAutoItExitRegister("_OnExit")
_Main()
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#Region While
While 1
Switch $streadmode; = 0 ;0 _Update(), 1 _Update()
	Case 0
		_Update()
	Case Else
	  _Update2()
EndSwitch

Sleep(10)
;GUISetState($hSETUP)
WEnd
#EndRegion While
;+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
#Region Main Func
Func _Main()

Switch IniRead ($sysini,"GUI","Win7Style", 0); стиль окна. 0=стандартная, 1=изменённая(стабильность не проверена)
	Case 0
		;$hGUI = GUICreate($NameGUI & "  " & FileGetVersion(@AutoItExe) & $version & $nGUI,$WWidth,$WHeight,-1,-1)
		$hGUI = GUICreate($NameGUI,$WWidth,$WHeight,-1,-1)
	Case 1
		;$hGUI = GUICreate($NameGUI & "  " & FileGetVersion(@AutoItExe) & $version & $nGUI,$WWidth,$WHeight,-1,-1,13500416);BitXOR($WS_OVERLAPPEDWINDOW, $WS_MAXIMIZEBOX) ;0x00010000
		$hGUI = GUICreate($NameGUI,$WWidth,$WHeight,-1,-1,13500416);BitXOR($WS_OVERLAPPEDWINDOW, $WS_MAXIMIZEBOX)=13500416; $WS_EX_CONTROLPARENT=65536
		_GUICtrlMenu_DeleteMenu(_GUICtrlMenu_GetSystemMenu($hGUI), 2)
		GUIRegisterMsg(0x0020, 'WM_SETCURSOR');$WM_SETCURSOR=0x0020
	Case 2
		$hGUI = GUICreate($NameGUI,$WWidth,$WHeight+20,-1,-1,0x80800000,65536);BitXOR($WS_OVERLAPPEDWINDOW, $WS_MAXIMIZEBOX)
		GUISetBkColor(0xE0FFFF) ; устанавливает цвет фона
;								0x80000000+0x00800000 = 0x80800000
		;_GUICtrlMenu_DeleteMenu(_GUICtrlMenu_GetSystemMenu($hGUI), 2)
		;GUIRegisterMsg(0x0020, 'WM_SETCURSOR');$WM_SETCURSOR=0x0020
EndSwitch

;MsgBox(4096, "" , BitXOR($WS_OVERLAPPEDWINDOW, $WS_MAXIMIZEBOX,$WS_EX_CONTROLPARENT));13500416
;MsgBox(4096, "" , $WS_EX_CONTROLPARENT   ); 13565952;

GUISetOnEvent(-3, '_closeWin', $hGUI);$GUI_EVENT_CLOSE
GUISetOnEvent(-4, '_hideWin', $hGUI);$GUI_EVENT_MINIMIZE
TraySetOnEvent ( -8, '_showWin' );$TRAY_EVENT_PRIMARYUP

addRUN()
;GUISetFont(8.5, Null, Null, Null ,$hGUI , $txtQual);бесполезный код

$iTab = GUICtrlCreateTab(6, 5, $WWidth-10, $WHeight-10) ;создать вкладки с отступом 5 по краям окна, и 5 внутри ;$TCS_HOTTRACK
;..................................................................................................
GUICtrlCreateTabItem("  Панель  "); Вкладка для инструментов
;GUICtrlSetImage(-1, "mycomput.dll", 0, 0) ; иконка вкладки


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

;подпись версия
GUICtrlCreateLabel(FileGetVersion(@AutoItExe), $WWidth-70, $WHeight-40, 50, 20, 0x0201)
GUICtrlSetBkColor(-1, 0xFFFFFF)
;GUICtrlSetBkColor(-1, 0x23F009)
GUICtrlCreateLabel($version, $WWidth-171, $WHeight-40, 100, 20, 0x0202)
;GUICtrlSetBkColor(-1, 0x20F006)
GUICtrlSetBkColor(-1, 0xFFFFFF)

#cs
GUICtrlCreateLabel(FileGetVersion(@AutoItExe), $WWidth-170, $WHeight-40, 50, 20, 0x0201)
GUICtrlSetFont(-1, -1, -1, 4)
GUICtrlSetColor(-1, 0x0000FF)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, "Перейти: " & $urlprofile[1])

GUICtrlSetBkColor(-1, 0xB2D47D)
#ce




;VIP buttons
Switch $VIP
	Case 1

$hImage = _GUIImageList_Create(32, 32, 5, 3)
_GUIImageList_AddIcon($hImage, "shell32.dll", 137, True);112
$btnAllStart = GUICtrlCreateButton("Пуск", $WWidth-315-1, $tCordLbtT-8, 141-1, 40)
_GUICtrlButton_SetImageList($btnAllStart, $hImage)
GUICtrlSetOnEvent(-1, "btnAllStart")

$hImage = _GUIImageList_Create(32, 32, 5, 3);, 6)
_GUIImageList_AddIcon($hImage, "shell32.dll", 215, True)
$btnAllStop = GUICtrlCreateButton("Остановить всё", $WWidth-176+8, $tCordLbtT-8, 141, 40);   150 ;$WWidth-176 ;;494-145
_GUICtrlButton_SetImageList($btnAllStop, $hImage)
GUICtrlSetOnEvent(-1, "btnAllStop")
GUICtrlSetState(-1, $GUI_DISABLE)

EndSwitch
;End VIP buttons

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
;_GUIImageList_AddIcon($hImage, "mycomput.dll", 0, True);GUICtrlSetImage(-1, "shell32.dll", -155, 0) ; иконка вкладки
$btnST = GUICtrlCreateButton("Настройки", 494 , $WHeight-100, 150, 40);494 $WWidth-176
_GUICtrlButton_SetImageList($btnST, $hImage)
GUICtrlSetOnEvent(-1, "btnST")

$hImage = _GUIImageList_Create(32, 32, 5, 3);, 6)
_GUIImageList_AddIcon($hImage, "calc.exe", 0, True)
$btnCA = GUICtrlCreateButton("Калькулятор", 339, $WHeight-148, 150, 40);494-145
_GUICtrlButton_SetImageList($btnCA, $hImage)
GUICtrlSetOnEvent(-1, "btnCA")


;$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
$hImage = _GUIImageList_Create(16 , 16,5, "")
_GUIImageList_AddIcon($hImage, "msconfig.exe", 0, False)
$btnMC = GUICtrlCreateButton("msconfig", 25, $WHeight-51, 80, 24) ;157 40
_GUICtrlButton_SetImageList($btnMC, $hImage)
GUICtrlSetOnEvent(-1, "btnMC")

$hImage = _GUIImageList_Create(16 , 16,5, "");,5 )
_GUIImageList_AddIcon($hImage, "miguiresource.dll", 1, False)
$btnTC = GUICtrlCreateButton("taskschd", 25+87, $WHeight-51, 80, 24) ;157 40
_GUICtrlButton_SetImageList($btnTC, $hImage)
GUICtrlSetOnEvent(-1, "btnTC")

$hImage = _GUIImageList_Create(16 , 16,5, "")
_GUIImageList_AddIcon($hImage, "perfmon.exe", 0, False)
$btnPMr = GUICtrlCreateButton("perfmon/r", 25+87+87, $WHeight-51, 80, 24)
_GUICtrlButton_SetImageList($btnPMr, $hImage)
GUICtrlSetOnEvent(-1, "btnPMr")


;..................................................................................................
For $t = 0 To $windowTabs
GUICtrlCreateTabItem($info[$t]) ; Вкладки программ

$hImage = _GUIImageList_Create(24, 24, 5, 3);, 6)
;_GUIImageList_AddIcon($hImage, "gameux.dll", 2, True)
_GUIImageList_AddIcon($hImage, "shell32.dll", 137, True)
$iBtnStart[$t] = GUICtrlCreateButton("Старт", 14, $THeight+35 , 95, 32, $BS_DEFPUSHBUTTON)
GUICtrlSetOnEvent(-1, "StartPressed")
_GUICtrlButton_SetImageList(-1, $hImage)

$hImage = _GUIImageList_Create(24, 24, 5, 3);, 6)
_GUIImageList_AddIcon($hImage, "SyncCenter.dll", 5, True)
$iBtnStop[$t] = GUICtrlCreateButton("Стоп", 115, $THeight+35, 95, 32, 0x01) ; $BS_DEFPUSHBUTTON
GUICtrlSetOnEvent(-1, "StopPressed")
GUICtrlSetState(-1, $GUI_DISABLE)
_GUICtrlButton_SetImageList(-1, $hImage)

$hImage = _GUIImageList_Create(24, 24, 5, 3);, 6)
_GUIImageList_AddIcon($hImage, "imageres.dll", 93, True)
$iBtnClean = GUICtrlCreateButton("Очистить", 216, $THeight+35, 95, 32)
GUICtrlSetOnEvent(-1, "CleanPressed")
_GUICtrlButton_SetImageList(-1, $hImage)


_GUICtrlHyperLink_Create("Профиль", 320, $THeight+49, 50, 15, 0x0000FF, 0x0000FF, -1, $urlprofile[$t], 'Перейти: ' & $urlprofile[$t], $hGUI);colors 0x0000FF 0x551A8B

$ckbxBigRun[$t] = GUICtrlCreateCheckbox("Пуск БОЛЬШОЙ кнопкой", 400, $THeight+30+12-8, 150, 16); ,0x0020)
;GUICtrlSetBkColor(-1, 0x23F009)

Switch $BigRun[$t]
   Case 1
	  GUICtrlSetState ( -1, 1 ) ;$GUI_CHECKED 1
   Case Else
	  GUICtrlSetState ( -1, 4 ) ; $GUI_UNCHECKED 4
EndSwitch

;GUICtrlSetTip(-1, 'Если установлен это флаг' & @CRLF & "процесс на вкладке" & @CRLF & "будет запущен" )
;GUICtrlSetTip(-1, 'Если установлен это флаг' & @CRLF & "процесс на вкладке" & @CRLF & "будет запущен" )

#cs
$ckbxBigRunA[$t] = GUICtrlCreateCheckbox("адаптивно", 400, $THeight+30+12+18-8, 150, 16); ,0x0020)
Switch $BigRunA[$t]
   Case 1
	  GUICtrlSetState ( -1, 1 )
   Case Else
	  GUICtrlSetState ( -1, 4 )
EndSwitch
#ce

GUICtrlCreateIcon("mblctr.exe", 133, $WWidth-44, $WHeight-47)
;GUICtrlSetImage ( -1, "winhlp32.exe", 0 ,0);154 215


;$iBtnCont[$t] = GUICtrlCreateButton("Продолжить" , 272, $THeight+35, 80, 25)
;;GUICtrlSetState($iBtnCont[$t], $GUI_DISABLE)
;GUICtrlSetOnEvent(-1, "ButtonCont");ButtonCont

;MsgBox(4096, "lll" , $windowTabs)
;
Local $arttmp = " "& $t & " "
If $t > 9 Then $arttmp = $t
;$iEdt[$t] = GUICtrlCreateEdit("╔═════╗"&"==>[" & $t & "]" & @CRLF & _Encoding_OEM2ANSI($sLine[$t]) & $itmHello[$t] , 14, $StrTool, $WWidth-30, $THeight-8, 2099264);BitOR($ES_READONLY, $ES_AUTOVSCROLL, $WS_VSCROLL))
$iEdt[$t] = GUICtrlCreateEdit _
 (@CRLF & "   ╔═══╗"& @CRLF &"   ║  " & $arttmp &"  ║"& @CRLF &"   ╚═══╝"& @CRLF &"┌─┬┬┐"& @CRLF &"└─┴┴┘"& @CRLF& _
 $itmHello[$t] & @CRLF & @CRLF & _Encoding_OEM2ANSI($sLine[$t])  , 15, $StrTool, $WWidth-31, $THeight-8, 2099264);BitOR($ES_READONLY, $ES_AUTOVSCROLL, $WS_VSCROLL))

GUICtrlSendMsg(-1, $EM_LIMITTEXT, -1, 0)
;GUIRegisterMsg($WM_ACTIVATE, "WM_ACTIVATE")
;MsgBox(4096, "lll" , BitOR($ES_READONLY, $ES_AUTOVSCROLL, $WS_VSCROLL))2099264


Next
GUICtrlCreateTabItem("")

GUISetState(@SW_SHOW, $hGUI)
EndFunc ;==>_Main
#EndRegion Main Func
;--------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------
#Region Setup Window
Func btnST() ; окно настроек
Local $guiCoord = WinGetPos ($hGUI)

Select
	Case Not IsHWnd($hSETUP);если окна нет, создать

$hSETUP = GUICreate("Настройки", $guiCoord[2]-16, $guiCoord[3]-39, $guiCoord[0]+7, $guiCoord[1]+30, -2139095040, -1, $hGUI);BitOR ($WS_BORDER, $WS_POPUP)


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
Local Const $snTabs2 = $guiCoord[3]-80	; вкладок. ;438

$hImage = _GUIImageList_Create(32, 32, 5, 3)
_GUIImageList_AddIcon($hImage, "shell32.dll", 71, True)
GUICtrlCreateButton("Запилить батник", 11, $snTabs2-7, 100, 36, 0x2000 )
_GUICtrlButton_SetImageList(-1, $hImage)
GUICtrlSetOnEvent(-1, "createBAT")
;;............................................
Local Const $snTabs1 = $guiCoord[2]-82 ; позиция_ ;276

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
Local Const $snTUD = 92 ; вертикаль таблицы
local Const $snMLen = 200 ; длина поля путь
Local Const $snXLen = 100
Local Const $snSWLen = 165
Local Const $snPLen = $snSWLen-65
Local Const $snULen = 280 ;пользователь длина
Local Const $snRLen = 70 ; префикс
Local Const $snPSLen = 150
Local Const $snVStep = 1 ; шаг между строками
;Local Const $snLLen = $guiCoord[2]-96

GUICtrlCreateTab(12, $snTUD, $guiCoord[2]-38, 250-15)

For $i=0 To $windowTabs;начало вкладок
GUICtrlCreateTabItem($i)

$sn_info[$i] = GUICtrlCreateInput($info[$i], 66, $snTUD+30, $snMLen-2,20);название процесса
If $exlpid[$i] Then GUICtrlCreateLabel("Last PID " & $exlpid[$i], $snMLen+72+3, $snTUD+30, 100,20)

GUICtrlCreateLabel("Mode:", 24, $snTUD+30, 28, 20, 0x0200)
$st_typecmd[$i] = GUICtrlCreateCombo($typecmd[$i], 24, $snTUD+60-$snVStep, 32, 100)
GUICtrlSetData(-1, "0|1|2",$typecmd[$i])
$st_expath[$i] = GUICtrlCreateInput($expath[$i], 62+3, $snTUD+60-$snVStep,  $snMLen, 20)
$st_exname[$i] = GUICtrlCreateInput($exname[$i], $snMLen+72+3, $snTUD+60-$snVStep,  $snXLen, 20)
;
GUICtrlCreateLabel("Server:", 20+3, $snTUD+90-$snVStep*2, 35, 20, 0x0200)
$st_server[$i] = GUICtrlCreateInput($server[$i], 57+3, $snTUD+90-$snVStep*2, $snSWLen,20)
$st_port[$i] = GUICtrlCreateInput($port[$i], $snSWLen+30+39+3, $snTUD+90-$snVStep*2, $snPLen,20) ;$snSWLen+40+$snPLen

GUICtrlCreateLabel("User:", 20+3, $snTUD+120-$snVStep*3, 28, 20, 0x0200)
$st_user[$i] = GUICtrlCreateInput($user[$i], 53, $snTUD+120-$snVStep*3, $snULen,20)
GUICtrlCreateLabel("&&", $snULen+51+3, $snTUD+120-$snVStep*3, 10, 20, 0x0200)
$st_devr[$i] = GUICtrlCreateInput($devr[$i], $snULen+30+2+26+3, $snTUD+120-$snVStep*3, $snRLen,20)
GUICtrlCreateLabel("Pass:", $snULen+$snRLen+60+3, $snTUD+120-$snVStep*3, 30, 20, 0x0200)
;GUICtrlSetBkColor(-1,0x00FF09)
$st_pass[$i] = GUICtrlCreateInput($pass[$i], $snULen+$snRLen+91+3, $snTUD+120-$snVStep*3, $snPSLen,20)

GUICtrlCreateLabel("Log:", 20+3, $snTUD+150-$snVStep*4, 28, 20, 0x0200)
;GUICtrlSetBkColor(-1,0x00FF09)
$st_exlog[$i] = GUICtrlCreateInput($exlog[$i], 53, $snTUD+150-$snVStep*4, $guiCoord[2]-96+3,20)
$st_params[$i] = GUICtrlCreateInput($params[$i], 20+4, $snTUD+180-$snVStep*5, $guiCoord[2]-63,20)

GUICtrlCreateLabel("Url:", 20+3, $snTUD+210-$snVStep*6, 28, 20, 0x0200)
$st_urlprofile[$i] = GUICtrlCreateInput($urlprofile[$i], 56, $snTUD+210-$snVStep*6, $guiCoord[2]-96+1,20)

Next
GUICtrlCreateTabItem(""); конец вкладок

Local Const $snPUD = $snTUD+250-10 ; высота блока
Local Const $snWBL = $guiCoord[2]-350 ; ширина строки браузера
Local Const $snWBtn = 60; ширина кнопки




;$hImage = _GUIImageList_Create(16, 16, 5, 3)
;_GUIImageList_AddIcon($hImage, $webbrowser, 0, True)
$st_browser = GUICtrlCreateInput($webbrowser, $snWBtn+16, $snPUD, $snWBL,20)
GUICtrlCreateButton("Браузер", 11, $snPUD, $snWBtn, 20);, 0x2000 )
;_GUICtrlButton_SetImageList(-1, $hImage,1);
GUICtrlSetOnEvent(-1, "_setWebBrowser")

;GUICtrlSetBkColor(-1,0x00FF09)
;                    Browser
;"Размеры:" & @LF & @TAB & _
;"ширина =  " & $guiCoord[2] & @LF & @TAB & _
;"высота  =  " & $guiCoord[3])
EndSelect
;$guiCoord = WinGetPos ($hGUI)
WinSetState ( $hGUI, Null, @SW_DISABLE )
GUISetState(@SW_SHOW);http://forum.oszone.net/post-1455732.html

;$guiCoord = WinGetPos ($hGUI)
WinMove ( $hSETUP, "", $guiCoord[0]+7, $guiCoord[1]+30);перемещает окно настроек за главным, при повторном показе

;GUISwitch($hGUI)
;WinSetState ( $hSETUP, Null, @SW_SHOW )
;WinActivate($hSETUP)



EndFunc
#EndRegion Setup Window
;--------------------------------------------------------------------------------------------------
#Region Setup Func
Func SetsClose(); закрыть окно настроек
GUISetState(@SW_HIDE, $hSETUP);GUIDelete($hSETUP);@GUI_WinHandle ;$hSETUP
WinSetState ( $hGUI, Null, @SW_ENABLE )
WinActivate ( $hGUI, Null )
WinSetState ( $hGUI, Null, @SW_SHOW )
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
$urlprofile[$i] = GUICtrlRead($st_urlprofile[$i])
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

Select
   Case $tmpStbs <> $windowTabs+1
MsgBox(4096, "Настройки : вкладки" , "Настройки изменены" & @CRLF & "Текущие вкладки: " & $windowTabs+1 & @CRLF & "После перезапуска: " & $tmpStbs & " вкладок")
EndSelect

   SetsClose()
EndFunc
#EndRegion Setup Func
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
;Local $vTemp

Select
	Case $outMode[$i] = "" Or $outMode[$i] = "dll"
$vTemp = $sOut[$i] & DllCall('user32.dll', 'bool', 'OemToChar', 'str', StdoutRead($iPIDx[$i]), 'str', StdoutRead($iPIDx[$i]))[2]
	Case $outMode[$i] = "stdout" Or $outMode[$i] = "so"
$vTemp = _Encoding_OEM2ANSI( StdoutRead ( $iPIDx[$i],True) & StderrRead( $iPIDx[$i],True) )
	Case Else
;читаем из файла чтоб обойти буферизацию стандартного вывода ;https://github.com/nanopool/ewbf-miner/issues/59

Local  $tmp[2],$tmp;,$str[1],$str
;$tmp = StringRegExp($exlog[$i],'[A-Z]:[^" -]+',1)


;$file = ' -lo --logfile="G:\путь\log.txt"'

;MsgBox(0, "Результат", "-"& $exlog[$i] & "-")

;If $exlog[$i]<>"" Then	$tmp=StringRegExp($exlog[$i],'[A-Z]:[^" -]+',1)

Select
	Case $exlog[$i]<>""


	;$tmp=StringRegExp($exlog[$i],'[A-Z]:[^" -]+',1)

	;$tmp= StringRegExp ( StringRegExpReplace( StringRegExpReplace($exlog[$i], "%date", @YEAR & "." & @MON &"."& @MDAY) , "%time" , @HOUR &"."& @MIN &"."& @SEC ),'[A-Z]:[^" -]+',1)

	;$tmp= StringRegExp ( StringRegExpReplace( StringRegExpReplace($exlog[$i], "%date", @YEAR & "." & @MON &"."& @MDAY) , "%time" , @HOUR &"."& @MIN &"."& @SEC ),'[A-Z]:[^" -]+',1)[0]

		;$tmp= StringRegExp ( StringRegExpReplace( StringRegExpReplace($exlog[$i], "%date", @YEAR & "." & @MON &"."& @MDAY) , "%time" , @HOUR &"."& @MIN &"."& @SEC ),'[A-Z]:[^" -]+',1)[0]

$tmp= StringRegExp ( StringRegExpReplace( StringRegExpReplace($exlog[$i], "%date", @YEAR & "." & @MON &"."& @MDAY) , "%time" , @HOUR &"."& @MIN &"."& @SEC ),'[A-Z]:[^" -]+',1)[0]
EndSelect


;$outFile[$i] = FileOpen ( $tmp, 8+1)

$vTemp = FileRead ( $tmp)


;FileClose($outFile[$i])


Select
Case $i=5
;MsgBox(0, "Результат", $tmp)
;MsgBox(262144, $tmp, $outFile[$i])


EndSelect



EndSelect


;MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, 'Selection:' & @CRLF & '$outMode' & @CRLF & @CRLF & 'Return:' & @CRLF & "-" & $outMode[$i] &"-") ;### Debug MSGBOX

Local $strl4 =  StringLen ( $vTemp )
Local $aSel = GUICtrlRecvMsg($iEdt[$i],0xB0 ); 0xB0 $EM_GETSEL$selectTime

Select
   Case $vTemp <> $sOut[$i]
		 ;$sOut[$i] = $vTemp & " >" & $strl4 & @CRLF ;+ отладочная метка
		 $sOut[$i] = $vTemp;	 & @CRLF

Select ; очищать окно с сохранением в файл
Case $strl4 > $strLimit ; если строка слишком длинная
	;clearEdt($i)
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
Func addRUN()
IniWrite($sysini, "RUN", "RunPID", WinGetProcess ( $hGUI )); отметить что программа запущена
IniWrite($sysini, "RUN", "RunGUIh", Dec(StringMid($hGUI,3,16)))
;EndFunc
;Func _GUIisAdmin()
Select
	Case IsAdmin()
		GUISetIcon(@ScriptFullPath, 202)
		;WinSetTitle ( $hGUI, "", $NameGUI & "  " & $version & " - Администратор" )
		WinSetTitle ( $hGUI, "", " !!! " & $NameGUI & " !!!")
	Case Else
		GUISetIcon(@ScriptFullPath, 201)
		;WinSetTitle ( $hGUI, "", $NameGUI & "  " & $version & " - без прав администратора" )
		WinSetTitle ( $hGUI, "", "  " & $NameGUI); & " - без прав администратора" )
EndSelect
EndFunc
;--------------------------------------------------------------------------------------------------









;--------------------------------------------------------------------------------------------------
Func StartPressed();нажата кнопка старт
Local $getTab = GUICtrlRead($iTab)-1; определяем номер процесса по вкладке
;stdbuf https://github.com/nanopool/ewbf-miner/issues/59
;$iPIDx[$getTab] = Run(@ComSpec , Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED); создаём процесс

;Select
;	Case $outMode[$getTab] = "f"
;		tmpdir()
;$tmp = DllCall('user32.dll', 'bool', 'OemToChar', 'str', StdoutRead($iPIDx[$getTab]), 'str', StdoutRead($iPIDx[$getTab]))[2]
;FileWrite ( $utils & "\~\" & $getTab,$tmp)
;$tmp= '"'& @ComSpec & '" /c ' & StringStripWS ( $sLine[$getTab], 2+1 ) & " >" & $utils & "\~\" & $getTab & @CRLF
;$iPIDx[$getTab] = Run($tmp, Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
;MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, 'Selection:' & @CRLF & '$sLine' & @CRLF & @CRLF & 'Return:' & @CRLF & $tmp) ;### Debug MSGBOX
;StdinWrite($iPIDx[$getTab], $sLine[$getTab] & " >" & $utils & "\~\" & $getTab); отправляем на него команду
;	Case Else

;Local $tmp[1],$tmp

;$tmp = StringRegExp ( StringRegExpReplace( StringRegExpReplace($exlog[$i], "%date", @YEAR & "." & @MON &"."& @MDAY) , "%time" , @HOUR &"."& @MIN &"."& @SEC ),'[A-Z]:[^" -]+',1)

#cs
Select
	Case $exlog[$iTab]<>""
$tmp= StringRegExp ( StringRegExpReplace( StringRegExpReplace($exlog[$i], "%date", @YEAR & "." & @MON &"."& @MDAY) , "%time" , @HOUR &"."& @MIN &"."& @SEC ),'[A-Z]:[^" -]+',1)[0]
$outFile[$iTab] = FileOpen ( $tmp, 1)

EndSelect
#ce


;$outFile[$iTab] = FileOpen ( $tmp[0], 1)
;

$iPIDx[$getTab] = Run(@ComSpec , Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED); создаём процесс
StdinWrite($iPIDx[$getTab], $sLine[$getTab]); отправляем на него команду

;EndSelect
; если нажата кнопка и режим лога, открыть файл; закрыть файл при остановке
; записать в файл содержимое вывода и очистить вывод.
;StdinWrite($iPIDx[$getTab], " | unbuffer" &  $sLine[$getTab]); отправляем на него команду
;$iPIDx[$getTab] = Run(@ComSpec & " " & $sLine[$getTab], Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
;$iPIDx[$getTab] = Run("C:\Windows\System32\ping.exe  -t ya.ru ", Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
;$iPIDx[$getTab] = Run("G:\home\Documents\Projects\autoit\aigui\src\TlS\cygwin\bin\bash.exe stdbuf -oL -eL  G:/home/Documents/Projects/autoit/aigui/src/TlS/cygwin/miner.sh", Null, @SW_SHOW, $STDIN_CHILD + $STDERR_MERGED)
;$iPIDx[$getTab] = Run("G:\home\Documents\Projects\autoit\aigui\src\TlS\cygwin\bin\bash.exe -c G:/home/Documents/Projects/autoit/aigui/src/TlS/cygwin/bin/stdbuf.exe -oL -eL  G:/home/Documents/Projects/autoit/aigui/src/TlS/cygwin/miner.sh", Null, @SW_SHOW, $STDIN_CHILD + $STDERR_MERGED)
;$iPIDx[$getTab] = Run("G:/home/Documents/Projects/autoit/aigui/src/TlS/cygwin/bin/stdbuf.exe -o0 -e0  G:/home/Documents/Projects/autoit/aigui/src/0.3.4b/miner.exe  --server zec.suprnova.cc --port 2142 --user satok.gpu_ewbf --pass gpu0p", Null, @SW_SHOW, $STDIN_CHILD + $STDERR_MERGED)


;;Run (@SystemDir & "\mmc.exe " & @SystemDir & "\devmgmt.msc" , @SystemDir ,@SW_SHOW)

;MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, 'Selection:' & @CRLF & '$sLine' & @CRLF & @CRLF & 'Return:' & @CRLF & $sLine[$getTab]) ;### Debug MSGBOX



If ProcessExists($iPIDx[$getTab]) Then GUICtrlSetBkColor($lbT[$getTab], $lbTAct);если процесс запущен, отмечаем на главной панели
	$exlpid[$getTab] = $iPIDx[$getTab];записываем пид в файл
	_iniSave()

	GUICtrlSetState($iBtnStart[$getTab], $GUI_DISABLE);меняем состояние кнопок
	GUICtrlSetState($iBtnStop[$getTab], $GUI_ENABLE)
	GUICtrlSetState($btnAllStop, $GUI_ENABLE)
	_disAllRun(); изменяем состояние главной кнопки


EndFunc ;==>StartPressed




;--------------------------------------------------------------------------------------------------
#Region StopPressed
Func StopPressed()
   ;GUICtrlSetBkColor($lbT[$getTab], 0xEBA794)

Local $getTab = GUICtrlRead($iTab)-1
	GUICtrlSetState($btnAllStart, $GUI_ENABLE)

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
#EndRegion StopPressed
;--------------------------------------------------------------------------------------------------
Func btnAllStop()
   For $i=0 To $windowTabs

Select
   Case ControlCommand($hGUI, '', $iBtnStop[$i], 'IsEnabled')

GUICtrlSetState($btnAllStart, $GUI_ENABLE)
GUICtrlSetState($iBtnStart[$i], $GUI_ENABLE)
GUICtrlSetState($iBtnStop[$i], $GUI_DISABLE)

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
Func _disAllRun()
Local $tmp=-1
For $i=0 To $windowTabs
Select ; если стоит птичка   и   кнопка нажата   или   птички нет
	Case GUICtrlRead($ckbxBigRun[$i]) = 1 And GUICtrlGetState ($iBtnStart[$i] ) = 144 Or GUICtrlRead($ckbxBigRun[$i]) = 4
	$tmp=$tmp+1
		EndSelect
			Next
Select
	Case $tmp = $windowTabs
		GUICtrlSetState($btnAllStart, $GUI_DISABLE)
EndSelect
;MsgBox(262144, $windowTabs, $tmp) ;### Debug MSGBOX
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
Func _showWin()
WinSetState ( $hGUI, Null, @SW_SHOW )
WinActivate ( $hGUI, Null )
EndFunc
;--------------------------------------------------------------------------------------------------
#Region Exit
Func _ProExit()
	; нажата кнопка выход на окне
Switch MsgBox(4+32+8192, 'Выход из программы', 'Выйти из программы' & @CRLF & 'завершив все процессы ?',10)
	Case 6 ; если нажата да
		_OnExit()
		_exitIniSave();_iniSave()
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
#EndRegion Exit
Func btnHL()
EndFunc
;--------------------------------------------------------------------------------------------------
#Region ShellExecute
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
Func btnPMr()
ShellExecute(@SystemDir & '\perfmon.exe', "/res", '', '', @SW_SHOW)
EndFunc
#EndRegion ShellExecute
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


Func btnAllStart()

For $i=0 To $windowTabs

Select
	Case GUICtrlRead($ckbxBigRun[$i]) = 1 And GUICtrlGetState ($iBtnStart[$i] ) = 80 ; $GUI_DISABLE

	$iPIDx[$i] = Run(@ComSpec , Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
	If ProcessExists ( $iPIDx[$i] ) Then GUICtrlSetBkColor($lbT[$i], $lbTAct)

	$exlpid[$i] = $iPIDx[$i]
	_iniSave()
	GUICtrlSetState($iBtnStart[$i], $GUI_DISABLE)
	GUICtrlSetState($iBtnStop[$i], $GUI_ENABLE)
	GUICtrlSetState($btnAllStop, $GUI_ENABLE)
	_disAllRun()

#cs
Switch GUICtrlRead($ckbxBigRunA[$i])
Case 4

Switch $BigRunSel[$i]
	Case 1
		GUICtrlSetState ( $ckbxBigRun[$i], 1 )
		$BigRun[$i] = 1

EndSwitch

EndSwitch
#ce


	StdinWrite($iPIDx[$i], $sLine[$i])

EndSelect


Next
;func_refrash()



;MsgBox(262144, $m, $n)

;MsgBox(262144, "", 'Selection:' & @CRLF & '$iBtnStart' & @CRLF & @CRLF & 'Return:' & @CRLF & GUICtrlGetState ($iBtnStart[0] )) ;### Debug MSGBOX
		;MsgBox(262144, "", 'Selection:' & @CRLF & '$iBtnStart' & @CRLF & @CRLF & 'Return:' & @CRLF & GUICtrlGetState ($iBtnStart[$i] )) ;### Debug MSGBOX



; если кнопка не нажата и стоит флаг
; нажать

EndFunc


Func func_refrash()
	#cs
	Select
	Case GUICtrlRead($ckbxBigRun[$i]) = 1 And GUICtrlGetState ($iBtnStart[$i] ) = 144




	EndSelect
For $i=0 To $windowTabs



Next


#ce


#cs

Local $n = 0 ,$m=0
For $i=0 To $windowTabs

Select
	Case GUICtrlRead($ckbxBigRun[$i]) =1
$n = $n+1
EndSelect

Select
	Case GUICtrlGetState ($iBtnStart[$i] ) = 144
$m=$m+1
EndSelect
Next

Select
	Case $m=$n
GUICtrlSetState($btnAllStart, $GUI_DISABLE)
EndSelect

#ce
EndFunc


;GUICtrlSetTip(-1, '#Region LABEL')