;AiGUI GUI v0.1a
;
;    G:\home\Documents\Projects\autoit\aigui-miner\nheqminer_suprnovav0.4a\cpu.bat
;
;

#include <GuiButton.au3>
#include <GuiImageList.au3>


#include <GuiConstantsEx.au3>
#include <ScrollBarConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <WinAPIMisc.au3>
#include <WinAPIProc.au3>
#include <WinAPI.au3>

#include <version.au3>
#include <aig-ini.au3>
#include <aig-bin.au3>

AutoItSetOption("TrayAutoPause", 0)
;системные переменные
Global Const $WA_ACTIVE = 1
Global Const $WA_CLICKACTIVE = 2
Global Const $WA_INACTIVE = 0
Global $hGUI, $iBtnStart, $iBtnStop, $iBtnClean, $iBtnPause, $iBtnUnPause, $iEdt, $iPID, $aPIDs, $sOut, $iUnSel = 1
;$sLine = @WorkingDir & "\nheqminer_suprnovav0.4a\nheqminer.exe -l zec.suprnova.cc:2142 -u satok.cpu0 -p cpu0p" & @CRLF
$sLine = "ping -t 8.8.8.8" & @CRLF

$iPID = Run(@ComSpec, Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
OnAutoItExitRegister("_OnExit")

Dim $hImage

; размеры gui
Dim $NameGUI = "AiGUI" & $version
Dim $WWidth = 670 , $WHeight = 450 ; ширина и высота окна
Dim $StrTool = 35 ; сверху первая строка под вкладкой.
Dim $THeight = $WHeight-75 ; высота консоли
;пользовательские настройки
Dim $tabs=2
Dim $nTabs[$tabs]
Dim $mpath0 , $name0 , $server0 , $port0 , $user0 , $rig0 , $pass0 , $info0
Dim $mpath1 , $name1 , $server1 , $port1 , $user1 , $rig1 , $pass1 , $info1
_iniLoad() ; загрузить настройки из ini aig-ini.au3

$input1=@WorkingDir & "\" & $mpath0 & $name0 & " " & $server0 & " " & $user0 & " " & $pass0
;$input0=@WorkingDir & "\" & $mpath1 & $name1 & " " & $server1 & " " & $port1 & " " & $user1 & " " & $pass1
$input0=@WorkingDir & " ping -t ya.ru"









Select ; определение прав запуска
   Case IsAdmin()
	  $hGUI = GUICreate($NameGUI & " - Администратор",$WWidth,$WHeight , "" , "" ,-1)
   Case Else
	  $hGUI = GUICreate($NameGUI & " - без прав администратора",$WWidth,$WHeight , "" , "" ,-1)
EndSelect


;$GUI = GUICreate("AiGUI",$WWidth,$WHeight , "" , "" ,-1)

;GUICtrlCreateGroup("", 5, 0 , 34 , 300)
;GUICtrlCreateLabel("GPU 05", 10, 10 , 40 , 20 ,1)

;GUICtrlCreateLabel("GPU" & @CRLF & "0", 10, 10 , 32 , 20 ,1)
;GUICtrlSetFont(-1, 8, 400, 0 , "Arial" , 5)
;GUICtrlSetBkColor(-1, 0x00FF00)


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
$btnDM = GUICtrlCreateButton("Командная строка", 339, $WHeight-95, 150, 40)
_GUICtrlButton_SetImageList($btnDM, $hImage)

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "shell32.dll", 21, True)
$btnDM = GUICtrlCreateButton("Настройки", 494, $WHeight-95, 150, 40)
_GUICtrlButton_SetImageList($btnDM, $hImage)

;$Inp4 = GUICtrlCreateInput($input0, 15, $THeight+40, 340, 20)


;GUICtrlCreateTab(0, 0, $WWidth+200, $WHeight+200) ;создать вкладки с отступом 5 по краям окна, и 5 внутри

;Вкладка 0
GUICtrlCreateTabItem($info0) ; Вкладка первой программы
;окно консоли 1
$iEdt = GUICtrlCreateEdit(Null, 14, $StrTool, $WWidth-30, $THeight, BitOR($ES_READONLY, $ES_AUTOVSCROLL, $WS_VSCROLL))
GUICtrlSendMsg(-1, $EM_LIMITTEXT, -1, 0)
GUIRegisterMsg($WM_ACTIVATE, "WM_ACTIVATE")

;GUICtrlSetFont(-1, 10, 400, 0 , "Lucida Console" , 5) ; Шрифт в окне
;GUICtrlSendMsg(-1, 0xC5, -1, 0) ; $EM_LIMITTEXT

$Inp = GUICtrlCreateInput($input0, 15, $THeight+40, 340, 20)

;$Btn = GUICtrlCreateButton("Enter", 360+0, $THeight+40, 45, 20, 0x01) ; $BS_DEFPUSHBUTTON
$iBtnStart = GUICtrlCreateButton("Старт", 360, $THeight+40 , 80, 25, $BS_DEFPUSHBUTTON)
$iBtnStop = GUICtrlCreateButton("Stop", 450, $THeight+40, 80, 25, 0x01) ; $BS_DEFPUSHBUTTON
GUICtrlSetState(-1, $GUI_DISABLE)

;$BtnRead0 = GUICtrlCreateButton("Read", 540, $THeight+40, 80, 25, 0x01) ; $BS_DEFPUSHBUTTON


GUICtrlCreateTabItem("вкладка2")
GUICtrlCreateTabItem("вкладка3")
GUICtrlCreateTabItem("вкладка4")
GUICtrlCreateTabItem("вкладка5  ")
GUICtrlCreateTabItem("вкладка6  ")
GUICtrlCreateTabItem("вкладка7")
GUICtrlCreateTabItem("вкладка8")
;GUICtrlCreateTabItem("вкладка9")
;GUICtrlCreateTabItem("вкладка10")
;GUICtrlCreateTabItem("вкладка11")


;Вкладка 2
;GUICtrlCreateTabItem($info1)

;$Inp1 = GUICtrlCreateInput($input1, 15, $StrTool+10, 340, 20)
;$Btn1 = GUICtrlCreateButton("Enter", 360, $StrTool+10, 45, 20, 0x01) ; $BS_DEFPUSHBUTTON
;$BtnStop1 = GUICtrlCreateButton("Stop", 410, $StrTool+10, 45, 20, 0x01) ; $BS_DEFPUSHBUTTON
;$Edt1 = GUICtrlCreateEdit("", 15, $StrTool+35, $WWidth-33, $WHeight-75, 0x200840) ; $ES_READONLY + $ES_AUTOVSCROLL + $WS_VSCROLL
;GUICtrlSetFont(-1, 10, 400, 0 , "Lucida Console" , 5) ; Шрифт в окне
;GUICtrlSendMsg(-1, 0xC5, -1, 0) ; $EM_LIMITTEXT

;GUICtrlCreateMenu("Menu&One")
;GUISetState(@SW_SHOW)
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
   ;     Case $WA_INACTIVE
  ;          AdlibUnRegister("_Update")
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

