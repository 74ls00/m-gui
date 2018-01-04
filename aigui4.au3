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

#include <aig-ini.au3>
#include <version.au3>

Global Const $WA_ACTIVE = 1
Global Const $WA_CLICKACTIVE = 2
Global Const $WA_INACTIVE = 0
Global $hGUI, $iBtnStart, $iBtnStop, $iBtnClean, $iBtnPause, $iBtnUnPause, $iEdt, $iPID, $aPIDs, $sOut, $iUnSel = 1
$sLine = "ping -t 8.8.8.8" & @CRLF
;$sLine = @WorkingDir & "\nheqminer_suprnovav0.4a\nheqminer.exe -l zec.suprnova.cc:2142 -u satok.cpu0 -p cpu0p" & @CRLF

Dim $hImage
; размеры gui
Dim $NameGUI = "AiGUI"
Dim $WWidth = 670 , $WHeight = 450 ; ширина и высота окна
Dim $StrTool = 35 ; сверху первая строка под вкладкой.
Dim $THeight = $WHeight-75 ; высота консоли
;пользовательские настройки
Dim $tabs=2
Dim $nTabs[$tabs]
Dim $mpath0 , $name0 , $server0 , $port0 , $user0 , $rig0 , $pass0 , $info0
Dim $mpath1 , $name1 , $server1 , $port1 , $user1 , $rig1 , $pass1 , $info1

_iniLoad() ; загрузить настройки из ini aig-ini.au3

$iPID = Run(@ComSpec, Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
OnAutoItExitRegister("_OnExit")

Select ; определение прав запуска
   Case IsAdmin()
	  $nGUI = " - Администратор"
   Case Else
	  $nGUI = " - без прав администратора"
   EndSelect
$hGUI = GUICreate($NameGUI & " " & $version & $nGUI,$WWidth,$WHeight)

GUICtrlCreateTab(5, 5, $WWidth-10, $WHeight-10) ;создать вкладки с отступом 5 по краям окна, и 5 внутри

GUICtrlCreateTabItem(" Панель "); Первая вкладка для инструментов
GUICtrlCreateGroup("", 15 , $StrTool-5 , $WWidth-30 , $THeight+5)
GUICtrlCreateLabel($NameGUI & " - интерфейс контроля консольных программ", 20, $StrTool+5, $WWidth-40, 60)
GUICtrlSetFont(-1, 10.5, 400, 0 , "Arial" , 5)
GUICtrlSetBkColor(-1, 0x00FF00)

GUICtrlCreateLabel($info0, 20, $StrTool+80)
GUICtrlSetBkColor(-1, 0x00FF09)
GUICtrlCreateLabel("guyguygjiljiojijijjiijyuguy", 160, $StrTool+80)
GUICtrlSetBkColor(-1, 0x00FF09)

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "devmgr.dll", 4, True)
$btnDM = GUICtrlCreateButton("Диспетчер устройств", 25, $WHeight-95, 157, 40)
_GUICtrlButton_SetImageList($btnDM, $hImage)

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "taskmgr.exe", 0, True)
$btnTM = GUICtrlCreateButton("Диспетчер задач", 187, $WHeight-95, 147, 40)
_GUICtrlButton_SetImageList($btnTM, $hImage)

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "cmd.exe", 0, True)
$btnCM = GUICtrlCreateButton("Командная строка", 339, $WHeight-95, 150, 40)
_GUICtrlButton_SetImageList($btnCM, $hImage)

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "shell32.dll", 21, True)
$btnST = GUICtrlCreateButton("Настройки", 494, $WHeight-95, 150, 40)
_GUICtrlButton_SetImageList($btnST, $hImage)

;Вкладка 0
GUICtrlCreateTabItem($info0) ; Вкладка первой программы

$iBtnStart = GUICtrlCreateButton("Старт", 14, $THeight+40 , 80, 25, $BS_DEFPUSHBUTTON)
$iBtnStop = GUICtrlCreateButton("Стоп", 100, $THeight+40, 80, 25, 0x01) ; $BS_DEFPUSHBUTTON
GUICtrlSetState(-1, $GUI_DISABLE)
$iBtnClean = GUICtrlCreateButton("Очистить", 180, $THeight+40, 80, 25)
$iBtnPause = GUICtrlCreateButton("Пауза", 270, $THeight+40, 80, 25)
$iBtnUnPause = GUICtrlCreateButton("Продолжить", 355, $THeight+40, 80, 25)
GUICtrlSetState(-1, $GUI_DISABLE)

$iEdt = GUICtrlCreateEdit(Null, 14, $StrTool, $WWidth-30, $THeight, BitOR($ES_READONLY, $ES_AUTOVSCROLL, $WS_VSCROLL))
GUICtrlSendMsg(-1, $EM_LIMITTEXT, -1, 0)
GUIRegisterMsg($WM_ACTIVATE, "WM_ACTIVATE")

GUICtrlCreateTabItem("вкладка2")
GUICtrlCreateTabItem("вкладка3")
GUICtrlCreateTabItem("вкладка4")
GUICtrlCreateTabItem("вкладка5  ")
GUICtrlCreateTabItem("вкладка6  ")
GUICtrlCreateTabItem("вкладка7")
GUICtrlCreateTabItem("вкладка8")



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
	    Case $btnDM

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
		 For $i = 1 To $aPIDs[0][0]
            ProcessClose($aPIDs[$i][0])
		 Next
   EndSelect
    ProcessClose($iPID)
EndFunc   ;==>_OnExit

