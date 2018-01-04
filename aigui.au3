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
$sLine = @WorkingDir & "\nheqminer_suprnovav0.4a\nheqminer.exe -l zec.suprnova.cc:2142 -u satok.cpu0 -p cpu0p" & @CRLF

Dim $hImage

; размеры gui
Dim $NameGUI = "AiGUI" & $version
Dim $WWidth = 670 , $WHeight = 450 ; ширина и высота окна
Dim $StrTool = 35 ; сверху первая строка под вкладкой.
Dim $THeight = $WHeight-75 ; высота консоли
;пользовательские настройки
Dim $tabs=2
Dim $mpath0 , $name0 , $server0 , $port0 , $user0 , $rig0 , $pass0 , $info0
Dim $mpath1 , $name1 , $server1 , $port1 , $user1 , $rig1 , $pass1 , $info1
_iniLoad() ; загрузить настройки из ini aig-ini.au3

$input1=@WorkingDir & "\" & $mpath0 & $name0 & " " & $server0 & " " & $user0 & " " & $pass0
$input0=@WorkingDir & "\" & $mpath1 & $name1 & " " & $server1 & " " & $port1 & " " & $user1 & " " & $pass1




Select ; определение прав запуска
   Case IsAdmin()
	  $GUI = GUICreate($NameGUI & " - Администратор",$WWidth,$WHeight , "" , "" ,-1)
   Case Else
	  $GUI = GUICreate($NameGUI & " - без прав администратора",$WWidth,$WHeight , "" , "" ,-1)
EndSelect


;$GUI = GUICreate("AiGUI",$WWidth,$WHeight , "" , "" ,-1)

;GUICtrlCreateGroup("", 5, 0 , 34 , 300)
;GUICtrlCreateLabel("GPU 05", 10, 10 , 40 , 20 ,1)

;GUICtrlCreateLabel("GPU" & @CRLF & "0", 10, 10 , 32 , 20 ,1)
;GUICtrlSetFont(-1, 8, 400, 0 , "Arial" , 5)
GUICtrlSetBkColor(-1, 0x00FF00)


GUICtrlCreateTab(5, 5, $WWidth-10, $WHeight-10) ;создать вкладки с отступом 5 по краям окна, и 5 внутри

GUICtrlCreateTabItem("Панель"); Первая вкладка для инструментов
GUICtrlCreateGroup("", 15 , $StrTool-5 , $WWidth-30 , $THeight+5)
GUICtrlCreateLabel($NameGUI & " - интерфейс контроля консольных приложений длительного действия", 20, $StrTool+5, $WWidth-40, 60)
GUICtrlSetFont(-1, 10.5, 400, 0 , "Arial" , 5)
GUICtrlSetBkColor(-1, 0x00FF00)



$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "taskmgr.exe", 0, True)
$btnTM = GUICtrlCreateButton("Диспетчер задач", 25, $WHeight-95, 150, 40)
_GUICtrlButton_SetImageList($btnTM, $hImage)

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "devmgr.dll", 4, True)
$btnDM = GUICtrlCreateButton("Диспетчер устройств", 25+155, $WHeight-95, 160, 40)
_GUICtrlButton_SetImageList($btnDM, $hImage)







$Inp4 = GUICtrlCreateInput($input0, 15, $THeight+40, 340, 20)

;Вкладка 0
GUICtrlCreateTabItem($info0) ; Вкладка первой программы
;окно консоли 1
$Edt = GUICtrlCreateEdit("", 14, $StrTool, $WWidth-30, $THeight, 0x200840) ; $ES_READONLY + $ES_AUTOVSCROLL + $WS_VSCROLL
;GUICtrlSetFont(-1, 10, 400, 0 , "Lucida Console" , 5) ; Шрифт в окне
GUICtrlSendMsg(-1, 0xC5, -1, 0) ; $EM_LIMITTEXT

$Inp = GUICtrlCreateInput($input0, 15, $THeight+40, 340, 20)

;$Btn = GUICtrlCreateButton("Enter", 360+0, $THeight+40, 45, 20, 0x01) ; $BS_DEFPUSHBUTTON
$Btn = GUICtrlCreateButton("Старт", 360, $THeight+40 , 80, 25)
$BtnStop = GUICtrlCreateButton("Stop", 450, $THeight+40, 80, 25, 0x01) ; $BS_DEFPUSHBUTTON
$BtnRead0 = GUICtrlCreateButton("Read", 540, $THeight+40, 80, 25, 0x01) ; $BS_DEFPUSHBUTTON


;Вкладка 2
GUICtrlCreateTabItem($info1)

$Inp1 = GUICtrlCreateInput($input1, 15, $StrTool+10, 340, 20)
$Btn1 = GUICtrlCreateButton("Enter", 360, $StrTool+10, 45, 20, 0x01) ; $BS_DEFPUSHBUTTON
$BtnStop1 = GUICtrlCreateButton("Stop", 410, $StrTool+10, 45, 20, 0x01) ; $BS_DEFPUSHBUTTON
$Edt1 = GUICtrlCreateEdit("", 15, $StrTool+35, $WWidth-33, $WHeight-75, 0x200840) ; $ES_READONLY + $ES_AUTOVSCROLL + $WS_VSCROLL
GUICtrlSetFont(-1, 10, 400, 0 , "Lucida Console" , 5) ; Шрифт в окне
GUICtrlSendMsg(-1, 0xC5, -1, 0) ; $EM_LIMITTEXT

;GUICtrlCreateMenu("Menu&One")
GUISetState(@SW_SHOW)


$PID = Run(@ComSpec, "", @SW_HIDE, 0x9)
$PID1 = Run(@ComSpec, "", @SW_HIDE, 0x9)
Sleep(10)
$Out = StdoutRead($PID)
$Out1 = StdoutRead($PID1)
GUICtrlSetData($Edt, DllCall('user32.dll', 'bool', 'OemToChar', 'str', $Out, 'str', $Out)[2])
GUICtrlSetData($Edt1, DllCall('user32.dll', 'bool', 'OemToChar', 'str', $Out1, 'str', $Out1)[2])

$Line = $input0


Do
  Switch GUIGetMsg()
    Case -3
      Exit
   Case $Btn


      ;$Line = GUICtrlRead($Inp)
	  ;$Line = $input0
      ;If $Line = "cls" Then GUICtrlSetData($Edt, "")

Select
Case Not ProcessExists($name0) ;если не запущен

 StdinWrite($PID, DllCall('user32.dll', 'bool', 'CharToOem', 'str', $Line, 'str', $Line)[2] & @CRLF)
  Sleep(10)
  conRead()
;Case Else	;если клиент запущен
EndSelect

      ;GUICtrlSetData($Inp, "")
      ;Sleep(10)
      ;$Out = StdoutRead($PID)
      ;GUICtrlSetData($Edt, DllCall('user32.dll', 'bool', 'OemToChar', 'str', $Out, 'str', $Out)[2], 1)

   Case $BtnRead0
conRead()

   Case $Btn1
	  $Line1 = $input1
      ;$Line1 = GUICtrlRead($Inp1)
      If $Line1 = "cls" Then GUICtrlSetData($Edt1, "")
      GUICtrlSetData($Inp1, "")
      StdinWrite($PID1, DllCall('user32.dll', 'bool', 'CharToOem', 'str', $Line1, 'str', $Line1)[2] & @CRLF)
      Sleep(10)
      $Out1 = StdoutRead($PID1)
      GUICtrlSetData($Edt1, DllCall('user32.dll', 'bool', 'OemToChar', 'str', $Out1, 'str', $Out1)[2], 1)


   Case $BtnStop
	  $PIDs = ProcessList($name0) ;Возвращает двумерный массив, содержащий список выполняемых процессов (имя и PID).
		 For $i = 1 To $PIDs[0][0] ;$PIDs[0][0] - это количество процессов
			If ProcessExists($PIDs[$i][1]) Then ProcessClose($PIDs[$i][1]) ;Если процесс существует, то закрываем его
			Next
   Case $BtnStop1
	  $PIDs = ProcessList($name1) ;Возвращает двумерный массив, содержащий список выполняемых процессов (имя и PID).
		 For $i = 1 To $PIDs[0][0] ;$PIDs[0][0] - это количество процессов
			If ProcessExists($PIDs[$i][1]) Then ProcessClose($PIDs[$i][1]) ;Если процесс существует, то закрываем его
		 Next
	  EndSwitch


Until 0

Func conRead()
   $Out = StdoutRead($PID)
   GUICtrlSetData($Edt, DllCall('user32.dll', 'bool', 'OemToChar', 'str', $Out, 'str', $Out)[2], 1)
EndFunc