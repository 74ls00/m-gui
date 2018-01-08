#include <GuiConstantsEx.au3> ;EditConstants.au3
;#include <ScrollBarConstants.au3>;#include <ScrollBarsConstants.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3> ; EditConstants.au3 http://autoit-script.ru/index.php?topic=1076.0
#include <EditConstants.au3> ;GuiConstantsEx.au3
#include <ButtonConstants.au3>
;#include <WinAPIProc.au3>
#include <WinAPI.au3>
;#include <WinAPIMisc.au3> ;_WinAPI_OemToChar

#include <Constants.au3>
#NoTrayIcon


#include <aig-func.au3>
;#include <GuiButton.au3> ;>aig-func.au3
;#include <GuiImageList.au3>;>aig-func.au3

Opt("TrayAutoPause", 0)
Opt('TrayMenuMode', 3)	;	http://autoit-script.ru/autoit3_docs/functions/AutoItSetOption.htm
; Opt("GUICoordMode", 2)
 ;Opt("GUIResizeMode", 1)
Opt("GUIOnEventMode", 1)
;Opt ("TrayIconDebug" , 1)

;ini �������� �������� �� ��������
Global $windowTabs=2
Global $info[$windowTabs+1]
Global $sLine[$windowTabs+1]
Global $strLimit=600000
For $i=0 To $windowTabs
$info[$i] = $i
Next
$sLine[0] = "ping -t 127.0.0.1" & @CRLF
$sLine[1] = "ping -t 8.8.8.8" & @CRLF
;$sLine[2] = "ping -t 8.8.4.4" & @CRLF
$sLine[2] = "���" & @CRLF
ReDim $sLine[$windowTabs+1]
Global $version = 0.1
;end ini

Global Const $WA_ACTIVE = 1
Global Const $WA_CLICKACTIVE = 2
Global Const $WA_INACTIVE = 0
Global $hGUI, $hSETUP,$aMsg, $iBtnStart, $iBtnStop, $iBtnClean, $iBtnPause, $iBtnUnPause, $aPIDs, $iUnSel = 1

Global $strl4 , $iTab , $hImage ; ������� ������ ������

; ������� gui
Global Const $NameGUI = "AiGUI"
Global Const $WWidth = 670 , $WHeight = 450 ; ������ � ������ ����
Global Const $StrTool = 35 ; ������ ������ ������ ��� ��������.
Global Const $THeight = $WHeight-75 ; ������ �������

Global $iBtnStart[$windowTabs+1],$iBtnStop[$windowTabs+1],$iBtnClean[$windowTabs+1],$iEdt[$windowTabs+1]
Global $iBtnUnPause[$windowTabs+1],$iBtnPause[$windowTabs+1]
Global $iPIDx[$windowTabs+1] , $aPIDs[$windowTabs+1] , $sOut[$windowTabs+1] , $getTab ;=GUICtrlRead($iTab)-1

; ��������� ������� �� ������� �������
;For $i = 0 To $windowTabs
;$iPIDx[$i] = Run(@ComSpec, Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
;OnAutoItExitRegister("_OnExit")
;Next

;OnAutoItExitRegister("_OnExit")

;Global $iExit

_Main()

;Func _trayIcon()
TraySetState(1) ; ���������� ���� ����
;TrayCreateItem("")
;$iExit = TrayCreateItem("�����")
;EndFunc

While 1
   Switch TrayGetMsg()
	  Case $TRAY_EVENT_PRIMARYUP
		 WinSetState ( $hGUI, Null, @SW_SHOW )
		 WinActivate ( $hGUI, Null )
   EndSwitch
Sleep(10)
WEnd



Func _Main()

Select ; ����������� ���� �������
   Case IsAdmin()
	  $nGUI = " - �������������"
   Case Else
	  $nGUI = " - ��� ���� ��������������"
   EndSelect
$hGUI = GUICreate($NameGUI & " " & $version & $nGUI,$WWidth,$WHeight)
GUISetOnEvent($GUI_EVENT_CLOSE, '_ProExit', $hGUI)
GUISetOnEvent($GUI_EVENT_MINIMIZE, '_hideWin', $hGUI)

$iTab = GUICtrlCreateTab(5, 5, $WWidth-10, $WHeight-10) ;������� ������� � �������� 5 �� ����� ����, � 5 ������
GUICtrlCreateTabItem("  ������  "); ������� ��� ������������

GUICtrlCreateGroup("", 15 , $StrTool-5 , $WWidth-30 , $THeight+5)
GUICtrlCreateLabel($NameGUI & " - ���������", 20, $StrTool+5, $WWidth-40, 60)
GUICtrlSetFont(-1, 10.5, 400, 0 , "Arial" , 5)
GUICtrlSetBkColor(-1, 0x00FF00)

GUICtrlCreateLabel("kk", 20, $StrTool+80)
GUICtrlSetBkColor(-1, 0x00FF09)
GUICtrlCreateLabel("���������2", 160, $StrTool+80)
GUICtrlSetBkColor(-1, 0x00FF09)

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "taskmgr.exe", 0, True)
$btnTM = GUICtrlCreateButton("��������� �����", 187, $WHeight-95, 147, 40)
_GUICtrlButton_SetImageList($btnTM, $hImage)
GUICtrlSetOnEvent(-1, "btnTM")

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "devmgr.dll", 4, True)
$btnDM = GUICtrlCreateButton("��������� ���������", 25, $WHeight-95, 157, 40)
_GUICtrlButton_SetImageList($btnDM, $hImage)
GUICtrlSetOnEvent(-1, "btnDM")

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "cmd.exe", 0, True)
$btnCM = GUICtrlCreateButton("��������� ������", 339, $WHeight-95, 150, 40)
_GUICtrlButton_SetImageList($btnCM, $hImage)
GUICtrlSetOnEvent(-1, "btnCM")

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "shell32.dll", 21, True)
$btnST = GUICtrlCreateButton("���������", 494, $WHeight-95, 150, 40)
_GUICtrlButton_SetImageList($btnST, $hImage)
GUICtrlSetOnEvent(-1, "btnST")

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "calc.exe", 0, True)
$btnCA = GUICtrlCreateButton("�����������", 494, $WHeight-140, 150, 40)
_GUICtrlButton_SetImageList($btnCA, $hImage)
GUICtrlSetOnEvent(-1, "btnCA")

For $t = 0 To $windowTabs
GUICtrlCreateTabItem($info[$t]) ; ������� ��������

$iBtnStart[$t] = GUICtrlCreateButton("�����", 14, $THeight+40 , 80, 25, $BS_DEFPUSHBUTTON)
GUICtrlSetOnEvent(-1, "StartPressed")

$iBtnStop[$t] = GUICtrlCreateButton("����", 100, $THeight+40, 80, 25, 0x01) ; $BS_DEFPUSHBUTTON
GUICtrlSetOnEvent(-1, "StopPressed")
GUICtrlSetState(-1, $GUI_DISABLE)

$iBtnClean = GUICtrlCreateButton("��������", 186, $THeight+40, 80, 25)
GUICtrlSetOnEvent(-1, "CleanPressed")

$iEdt[$t] = GUICtrlCreateEdit("������� " & $t & @CRLF & "��������� �������: " & $sLine[$t] , 14, $StrTool, $WWidth-30, $THeight, BitOR($ES_READONLY, $ES_AUTOVSCROLL, $WS_VSCROLL))
GUICtrlSendMsg(-1, $EM_LIMITTEXT, -1, 0)
GUIRegisterMsg($WM_ACTIVATE, "WM_ACTIVATE")

Next

GUISetState(@SW_SHOW, $hGUI)
EndFunc

Func _hideWin(); ������ ������� ����
WinSetState ( $hGUI, Null, @SW_HIDE )
EndFunc




Func btnST() ; ���� ��������
$setEXIT = 0
$hSETUP = GUICreate("Child GUI", 200, 200, 300, 300, BitOR ($WS_BORDER, $WS_POPUP), -1, $hGUI)

$setEXIT = GUICtrlCreateButton("s exit", 20, 20, 147, 40)
GUICtrlSetOnEvent(-1, "CloseST")
GUISetState(@SW_SHOW)
;GUISwitch($hGUI)

EndFunc

Func CloseST(); ������� ���� ��������
GUIDelete(@GUI_WinHandle)
EndFunc



Func StartPressed()
Local $getTab = GUICtrlRead($iTab)-1
   $iPIDx[$getTab] = Run(@ComSpec, Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
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
           If Not @error Then ; ��������� �������� ������
			   For $n = 1 To $aPIDs[0][0]
                    ProcessClose($aPIDs[$n][0])
               Next
			   ProcessClose($iPIDs); ��������� cmd �� PID
		   EndIf
EndFunc

Func CleanPressed()
Local $getTab = GUICtrlRead($iTab)-1
;GUICtrlSetData($iEdt[GUICtrlRead($iTab)-1], Null)
GUICtrlSetData($iEdt[$getTab], Null)
$sOut[$getTab] = Null
EndFunc

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
		 $sOut[$i] = $vTemp & " >" & $strl4 & @CRLF ;+ ���������� �����

Select ; ������� ���� � ����������� � ����
Case $strl4 > $strLimit ; ���� ������ ������� �������
   Local $nFile = @WorkingDir & "\tmp\zLog" & "_" & $i & "_" & @YEAR & @MON & @MDAY & "." & @MIN & @SEC & ".txt"
   $hFile = FileOpen($nFile, 1)
   FileWrite($hFile, $sOut[$i] & @CRLF & ">" & $strl4 & "<")
   FileClose($hFile)
 ;  _debug_send_file()
   $sOut[$i] = "��������� " & $strl4 & " ������." & @CRLF & "������� ����� �������� � " & $nFile & @CRLF
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

Func _ProExit()
    _OnExit()
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
