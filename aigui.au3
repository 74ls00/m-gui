#include <GuiConstantsEx.au3>
#include <ScrollBarConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
;#include <WinAPIMisc.au3> ;_WinAPI_OemToChar
#include <WinAPIProc.au3>
#include <WinAPI.au3>
#include <GuiButton.au3>
#include <GuiImageList.au3>

#include <aig-ini.au3>
#include <version.au3>
#include <debug-log.au3>

_debug_start()
;IniWrite($myini, "system", "run", 1)


AutoItSetOption("TrayAutoPause", 0)

Global Const $WA_ACTIVE = 1
Global Const $WA_CLICKACTIVE = 2
Global Const $WA_INACTIVE = 0
Global $hGUI, $hSETUP,$aMsg, $iBtnStart, $iBtnStop, $iBtnClean, $iBtnPause, $iBtnUnPause, $iEdt, $iPID, $aPIDs, $sOut, $iUnSel = 1

Dim $iBtnClean[$windowTabs+1] , $setEXIT

Global $iTab , $readTab ;, $sLine
;, $readTab = GUICtrlRead($iTab)

;Dim $iMsg
_iniLoad() ; ��������� ��������� �� ini aig-ini.au3
_sLine()  ; ��������� ������


;$sLine = "ping -t 8.8.8.8" & @CRLF
;Global $sLine = @WorkingDir & "\nheqminer_suprnovav0.4a\nheqminer.exe -l zec.suprnova.cc:2142 -u satok.cpu0 -p cpu0p" & @CRLF
;$sLine = @ComSpec & " /c dir c:\windows\system32" & @CRLF
;$sLine = @WorkingDir & "\inp.bat" & @CRLF
;Global $sLine = @WorkingDir & "\debug\dcon2.exe" & @CRLF
$sLine = $sLine[2]

Global $strl4


Dim $hImage ; ������� ������ ������
; ������� gui
Dim $NameGUI = "AiGUI"
Dim $WWidth = 670 , $WHeight = 450 ; ������ � ������ ����
Dim $StrTool = 35 ; ������ ������ ������ ��� ��������.
Dim $THeight = $WHeight-75 ; ������ �������
;���������������� ���������

;Dim $info[$windowTabs+1],$mpath[$windowTabs+1],$name[$windowTabs+1],$server[$windowTabs+1],$port[$windowTabs+1],$user[$windowTabs+1],$rig[$windowTabs+1],$pass[$windowTabs+1]

Dim $iBtnStart[$windowTabs+1],$iBtnStop[$windowTabs+1],$iBtnClean[$windowTabs+1],$iBtnUnPause[$windowTabs+1],$iEdt[$windowTabs+1],$iBtnPause[$windowTabs+1]
Dim $iPIDx[$windowTabs+1],$sLineX[$windowTabs+1]
;Dim $sOut[$windowTabs+1]
;For $i = 0 To $windowTabs


 ; $sLineX[$i] = $sLine
 ;  $iPIDx[$i] = Run(@ComSpec, Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
 ; OnAutoItExitRegister("_OnExit")

;Next

;IniWrite($myini, "system", "run", "exit")

;IniWrite($myini, "system", "run", "running")

 ;  Local $running = IniRead ($myini,"system","run", Null)
 ;  MsgBox(4096,"$running",$running)


$iPID = Run(@ComSpec, Null, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
OnAutoItExitRegister("_OnExit")




Select ; ����������� ���� �������
   Case IsAdmin()
	  $nGUI = " - �������������"
   Case Else
	  $nGUI = " - ��� ���� ��������������"
   EndSelect
$hGUI = GUICreate($NameGUI & " " & $version & $nGUI,$WWidth,$WHeight)

 ;GUISetOnEvent($GUI_EVENT_CLOSE, '_CloseWin')



$iTab = GUICtrlCreateTab(5, 5, $WWidth-10, $WHeight-10) ;������� ������� � �������� 5 �� ����� ����, � 5 ������
GUICtrlCreateTabItem("  ������  "); ������ ������� ��� ������������

GUICtrlCreateGroup("", 15 , $StrTool-5 , $WWidth-30 , $THeight+5)
GUICtrlCreateLabel($NameGUI & " - ���������", 20, $StrTool+5, $WWidth-40, 60)
GUICtrlSetFont(-1, 10.5, 400, 0 , "Arial" , 5)
GUICtrlSetBkColor(-1, 0x00FF00)

GUICtrlCreateLabel("kk", 20, $StrTool+80)
GUICtrlSetBkColor(-1, 0x00FF09)
GUICtrlCreateLabel("���������2", 160, $StrTool+80)
GUICtrlSetBkColor(-1, 0x00FF09)

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "devmgr.dll", 4, True)
$btnDM = GUICtrlCreateButton("��������� ���������", 25, $WHeight-95, 157, 40)
_GUICtrlButton_SetImageList($btnDM, $hImage)

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "taskmgr.exe", 0, True)
$btnTM = GUICtrlCreateButton("��������� �����", 187, $WHeight-95, 147, 40)
_GUICtrlButton_SetImageList($btnTM, $hImage)

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "cmd.exe", 0, True)
$btnCM = GUICtrlCreateButton("��������� ������", 339, $WHeight-95, 150, 40)
_GUICtrlButton_SetImageList($btnCM, $hImage)

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "shell32.dll", 21, True)
$btnST = GUICtrlCreateButton("���������", 494, $WHeight-95, 150, 40)
_GUICtrlButton_SetImageList($btnST, $hImage)

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "calc.exe", 0, True)
$btnCA = GUICtrlCreateButton("�����������", 494, $WHeight-140, 150, 40)
_GUICtrlButton_SetImageList($btnCA, $hImage)

For $t = 0 To $windowTabs
;������� 0
GUICtrlCreateTabItem($info[$t]) ; ������� ������ ���������

$iBtnStart = GUICtrlCreateButton("�����", 14, $THeight+40 , 80, 25, $BS_DEFPUSHBUTTON)
$iBtnStop = GUICtrlCreateButton("����", 100, $THeight+40, 80, 25, 0x01) ; $BS_DEFPUSHBUTTON
GUICtrlSetState(-1, $GUI_DISABLE)
$iBtnClean[0] = GUICtrlCreateButton("��������", 186, $THeight+40, 80, 25)

;$iBtnClean[$t] = GUICtrlCreateButton("��������", 186, $THeight+40, 80, 25)


;$iBtnPause = GUICtrlCreateButton("�����", 270, $THeight+40, 80, 25)
;$iBtnUnPause = GUICtrlCreateButton("����������", 355, $THeight+40, 80, 25)
;GUICtrlSetState(-1, $GUI_DISABLE)
$iEdt = GUICtrlCreateEdit("kk", 14, $StrTool, $WWidth-30, $THeight, BitOR($ES_READONLY, $ES_AUTOVSCROLL, $WS_VSCROLL))
GUICtrlSendMsg(-1, $EM_LIMITTEXT, -1, 0)
GUIRegisterMsg($WM_ACTIVATE, "WM_ACTIVATE")
Next

GUISetState(@SW_SHOW)
GUISwitch($hSETUP)

;$hChildWin = GUICreate("Child GUI", $iGUIWidth, $iGUIHeight, $aParentWin_Pos[0] + 100, $aParentWin_Pos[1] + 100, -1, -1, $hParentWin)

;	GUISetState(@SW_SHOW)

;GUISetOnEvent($GUI_EVENT_CLOSE, '_CloseWin' )


While 1

;GUISetOnEvent($GUI_EVENT_CLOSE, '_CloseWin' )


;Sleep(10)



  ; $readTab = GUICtrlRead($iTab)
   	;   MsgBox(4096,"����� ���",$readTab)
   		; For $i = 0 To $windowTabs
		;$aMsg = GUIGetMsg(1)
	;	Select

;$aMsg = GUIGetMsg(1)
;Select

  ; Case GUIGetMsg() = $btnDM
;Run (@SystemDir & "\cmd.exe", @WorkingDir ,@SW_SHOW)

		; Case GUIGetMsg() = $btnST
		;	_settingsWin()





;Case $aMsg[0] = $GUI_EVENT_CLOSE


;Select
;Case $aMsg[1] = $hSETUP

   					;MsgBox(64, "Test", "Child GUI will now close.")
					;Switch to the child window
		;			GUISwitch($hSETUP)
					;Destroy the child GUI including the controls
		;			GUIDelete()
		;			GUISwitch($hGUI)
					;Check if user clicked on the close button of the parent window

;Case $aMsg[1] = $hGUI
					 ;MsgBox(64, "Test", "Parent GUI will now close.")
					;Switch to the parent window
	;				GUISwitch($hGUI)
					;Destroy the parent GUI including the controls
	;				GUIDelete()
					;Exit the script
	;				Exit




;EndSelect





;EndSelect

    Switch GUIGetMsg()
	Case $GUI_EVENT_CLOSE

	 ;  If GUIGetMsg(1)[1] = $hSETUP Then
	;	  GUISwitch($hSETUP)
	;	  GUIDelete($hSETUP)
	;	  GUISwitch($hGUI)
	;	  GUIGetMsg(0)


	;	 ElseIf GUIGetMsg(1)[1] = $hGUI Then
	;	  GUISwitch($hGUI)
	;	  GUIDelete($hGUI)
	;	  GUIGetMsg(0)
	;ExitLoop
	Exit
		;  EndIf


	   _debug_stop()
            ;Exit
		Case $btnDM
			Run (@SystemDir & "\mmc.exe " & @SystemDir & "\devmgmt.msc" , @SystemDir ,@SW_SHOW)
		 Case $btnTM
			Run (@SystemDir & "\taskmgr.exe", @SystemDir ,@SW_SHOW)
		 Case $btnCM
			Run (@SystemDir & "\cmd.exe", @WorkingDir ,@SW_SHOW)
		 Case $btnCA
			Run (@SystemDir & "\calc.exe", @WorkingDir ,@SW_SHOW)
		 Case  $btnST
			_settingsWin()

;Case $setEXIT
;GUISwitch($hSETUP)
  ;  GUIDelete(@GUI_WinHandle)
  ;GUIDelete($hSETUP)
;GUISwitch($hGUI)
 ;MsgBox(4096,"11","a")


			Case $iBtnStart
			   _debug_pid()
            GUICtrlSetState($iBtnStart, $GUI_DISABLE)
            GUICtrlSetState($iBtnStop, $GUI_ENABLE)
            StdinWrite($iPID, $sLine)

       ; Case $iBtnClean

	  Case $iBtnClean[0]
            GUICtrlSetData($iEdt, Null)
            $sOut = Null

        Case $iBtnStop
            GUICtrlSetState($iBtnStop, $GUI_DISABLE)
            GUICtrlSetState($iBtnStart, $GUI_ENABLE)
            $aPIDs = _WinAPI_EnumChildProcess($iPID)
            If Not @error Then
                For $n = 1 To $aPIDs[0][0]
                    ProcessClose($aPIDs[$n][0])
                Next
            EndIf
			_debug_pid_stop()


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
  ;
 ; Local $vTemp = DllCall('user32.dll', 'bool', 'OemToChar', 'str', StdoutRead($iPID), 'str', StdoutRead($iPID))[2]
   ;  $Line = GUICtrlRead($iEdt)
 Local $strl4 =  StringLen ( $vTemp )
  Local $aSel = GUICtrlRecvMsg($iEdt, $EM_GETSEL)


;MsgBox(4096, '���������', $strl4)

Select
   Case $vTemp <> $sOut
		 $sOut = $vTemp & " >" & $strl4 & @CRLF

;$hFile = FileOpen("test.txt", 1)
;FileWrite($hFile, $strl4 & " " & @CRLF & $vTemp & @CRLF)
;FileClose($hFile)

Select ; ������� ���� � ����������� � ����
Case $strl4 > 600000
   Local $nFile = @WorkingDir & "\tmp\zLog" & @YEAR & @MON & @MDAY & "." & @MIN & @SEC & ".txt"
   $hFile = FileOpen($nFile, 1)
   FileWrite($hFile, $sOut & @CRLF & ">" & $strl4 & "<")
   FileClose($hFile)
   _debug_send_file()
   $sOut = "��������� " & $strl4 & " ������." & @CRLF & "������� ����� ������� � " & $nFile & @CRLF
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

	;Local $strl4 = StringLen ( $sOut )
;MsgBox(4096, '���������', $strl4)

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
	_debug_pid_exit()
EndFunc   ;==>_OnExit


Func _CloseWin()
    GUIDelete(@GUI_WinHandle)
EndFunc



Func _settingsWin() ; ���� ��������
$setEXIT = 0
$hSETUP = GUICreate("Child GUI", 200, 200, 300, 300, BitOR ($WS_BORDER, $WS_POPUP), -1, $hGUI)

$setEXIT = GUICtrlCreateButton("s exit", 20, 20, 147, 40)

GUISetState(@SW_SHOW)
GUISwitch($hGUI)


EndFunc