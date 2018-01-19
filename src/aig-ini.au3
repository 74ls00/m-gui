#include <dev-ini1.au3>
#Region Init
Global $sysini = @WorkingDir & "\system.ini"
Global Const $myini = @WorkingDir & "\myconf.ini"
Global Const $process = "miner"
Global $windowTabs=4
Global $trayexit=0 ;1=tray. 0=exit
Global $strLimit=600000
Global $webbrowser = "G:\home\Documents\Projects\0-MyFirefox\FirefoxPortable_x64\FirefoxPortable.exe"

Global $streadmode = 0 ;0 _Update(), 1 _Update()
Global $selectTime = 5000 ;ms

Select
Case Not FileExists($sysini)
_saveSysIni()
EndSelect
_loadSysIni()

Select
Case FileExists($myini)
_readTab()
EndSelect

Func _readTab()
   $windowTabs = IniRead ($myini,"system","tabs", 1)
   If $windowTabs > 15 Then $windowTabs = 15
EndFunc

Global $sLine[$windowTabs+1],$typecmd[$windowTabs+1]
Global $info[$windowTabs+1],$server[$windowTabs+1],$port[$windowTabs+1],$user[$windowTabs+1],$pass[$windowTabs+1]
Global $devr[$windowTabs+1],$expath[$windowTabs+1],$exname[$windowTabs+1],$exlog[$windowTabs+1],$params[$windowTabs+1]
Global $debug[$windowTabs+1],$exlpid[$windowTabs+1],$useregflg[$windowTabs+1],$urlprofile[$windowTabs+1]
Global $ckbxBigRun[$windowTabs+1], $BigRun[$windowTabs+1], $ckbxBigRunA[$windowTabs+1], $BigRunA[$windowTabs+1]
Global $NameGUI
#EndRegion
;--------------------------------------------------------------------------------------------------
#Region _iniDefLoad
Func _iniDefLoad()
For $i=0 To $windowTabs
$info[$i] = $i		; строка .название вкладки
$devr[$i] = Null	; имя. устройство
$server[$i] = Null	; параметр. сервер
$port[$i] = Null	; параметр. порт
$user[$i] = Null	; параметр. пользователь
$pass[$i] = Null	; параметр. пароль
$expath[$i] = Null	; путь к программе
$exname[$i] = Null	; программа.exe
$exlog[$i] = Null	; параметр. путь к логу
$params[$i] = Null	; дополнительные параметры
$typecmd[$i] = 0 ; тип команды. 1 через @WorkingDir . 0 без пути
$debug[$i] = @WorkingDir & $expath[$i] & "\" & $exname[$i] & $server[$i] & $port[$i] & $user[$i] & $devr[$i] & $pass[$i] & $exlog[$i] & $params[$i] ; вывод. полученная команда
$exlpid[$i] = Null	; pid запущеного процесса
$useregflg[$i] = 0	; 1 = пользователь зарегестрирован на пуле , 0 = предупредить
$urlprofile[$i] = "http:/www#"
$BigRun[$i] = ""
$BigRunA[$i] = ""
;IniWrite($myini, $process & $i, "separator","----------------------------------------------------------------------")
Next
 ;MsgBox(4096,"_iniDefLoad",$info[0])
EndFunc
#EndRegion
;--------------------------------------------------------------------------------------------------
Func _iniSave()

Select
   Case Not FileExists($myini)
   _iniDefLoad()   ; загрузить  дефолтные настройки
   _load_dev_ini() ; загрузить личные настройки разработчика

EndSelect

   For $i=0 To $windowTabs
;Local Const $process = "miner"
IniWrite($myini, $process & $i, "info", '"' & $info[$i] & '"')
IniWrite($myini, $process & $i, "dev", $devr[$i])
;IniWrite($myini, $process & $i, "dev",  '"' & $devr[$i] & '"')
IniWrite($myini, $process & $i, "server",'"' & $server[$i] & '"')
IniWrite($myini, $process & $i, "port",'"' & $port[$i] & '"')
IniWrite($myini, $process & $i, "user",'"' & $user[$i] & '"')
IniWrite($myini, $process & $i, "pass", '"' & $pass[$i] & '"')
IniWrite($myini, $process & $i, "expath",'"' & $expath[$i] & '"')
IniWrite($myini, $process & $i, "exname",'"' & $exname[$i] & '"')
IniWrite($myini, $process & $i, "exlog",'"' & $exlog[$i] & '"')
IniWrite($myini, $process & $i, "params",'"' & $params[$i] & '"')
IniWrite($myini, $process & $i, "typecmd", $typecmd[$i])

_sLine()
$debug[$i] = StringStripWS ( $sLine[$i], 2 )
IniWrite($myini, $process & $i, "debug",'"' & $debug[$i] & '"')

IniWrite($myini, $process & $i, "exlpid", $exlpid[$i])
IniWrite($myini, $process & $i, "useregflg", $useregflg[$i])
IniWrite($myini, $process & $i, "urlprofile",'"' & $urlprofile[$i] & '"')


   Next
;MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, 'Selection:' & @CRLF & '$BigRun' & @CRLF & @CRLF & 'Return:' & @CRLF & $BigRun[0])

IniWrite($myini, "system", "tabs", $windowTabs)
EndFunc

Func _exitIniSave()
	For $i=0 To $windowTabs
Local $process = "miner"

Switch GUICtrlRead($ckbxBigRun[$i])
	Case 1
		$BigRun[$i] = 1
	Case Else
		$BigRun[$i] = 0
			EndSwitch
				IniWrite($myini, $process & $i, "bigrun",$BigRun[$i])

Switch GUICtrlRead($ckbxBigRunA[$i])
	Case 1
		$BigRunA[$i] = 1
	Case Else
		$BigRunA[$i] = 0
			EndSwitch
				IniWrite($myini, $process & $i, "bigruna",$BigRunA[$i])

IniDelete ( $myini, $process & $i, "__________________________________________" )
IniWrite($myini, $process & $i, "__________________________________________","__________________________________________")
Next

;MsgBox(262144, "",$BigRun[0])

EndFunc

;--------------------------------------------------------------------------------------------------
Func _saveSysIni()
IniWrite($sysini, "GUI", "Tray1_Exit",$trayexit)
IniWrite($sysini, "GUI", "ListingLimit",$strLimit)

EndFunc
;--------------------------------------------------------------------------------------------------
Func _loadSysIni()
	Select
		Case Not FileExists($sysini); если нет файла настроек
			;IniWrite($sysini, "LOG", "CheckDll", 1);записать дефолтные
			;IniWrite($sysini, "GUI", "Win7Style", 0)

		Case Else ;если существует
			Select ;но пустая строка
				Case IniRead ($sysini,"LOG","CheckDll", Null) = ""
				IniWrite($sysini, "LOG", "CheckDll", 1) ; то записать дефолтные
					EndSelect
			Select
				Case IniRead ($sysini,"GUI","Win7Style", Null) = ""
				IniWrite($sysini, "GUI", "Win7Style", 0)
					EndSelect

			Select ;$webbrowser = IniRead ($sysini,"GUI","WebBrowser", $webbrowser)
				Case IniRead ($sysini,"GUI","WebBrowser", Null) = ""
				IniWrite($sysini, "GUI", "WebBrowser", '"' & $webbrowser & '"')
					EndSelect
	EndSelect

$trayexit = IniRead ($sysini,"GUI","Tray1_Exit", $trayexit)
$strLimit = IniRead ($sysini,"GUI","ListingLimit", $strLimit)

EndFunc
;--------------------------------------------------------------------------------------------------
Func _iniLoad()
Select
   Case FileExists($myini)
_readTab()

   For $i = 0 To $windowTabs
;Local $process = "miner"
$info[$i] = IniRead ($myini,$process & $i,"info", $i)
If $info[$i] = "" Then $info[$i] = $i ; защита  от слёта гуя при пустом названии вкладки
$devr[$i] = IniRead ($myini,$process & $i,"dev", Null)
$server[$i] = IniRead ($myini,$process & $i,"server", Null)
$port[$i] = IniRead ($myini,$process & $i,"port", Null)
$user[$i] = IniRead ($myini,$process & $i,"user", Null)
$pass[$i] = IniRead ($myini,$process & $i,"pass", Null)
$expath[$i] = IniRead ($myini,$process & $i,"expath", Null)
$exname[$i] = IniRead ($myini,$process & $i,"exname", Null)
$exlog[$i] = IniRead ($myini,$process & $i,"exlog", Null)
$params[$i] = IniRead ($myini,$process & $i,"params", Null)
$typecmd[$i] = IniRead ($myini,$process & $i,"typecmd", 0)
$debug[$i] = IniRead ($myini,$process & $i,"debug", Null)
$exlpid[$i] = IniRead ($myini,$process & $i,"exlpid", Null)
$useregflg[$i] = IniRead ($myini,$process & $i,"useregflg", Null)
$urlprofile[$i] = IniRead ($myini,$process & $i,"urlprofile", Null)
$BigRun[$i] = IniRead ($myini,$process & $i,"bigrun", 0)
$BigRunA[$i] = IniRead ($myini,$process & $i,"bigruna", 0)
Next
Case Else
   _iniSave()
EndSelect


EndFunc
;--------------------------------------------------------------------------------------------------
#Region _sLine
Func _sLine()
   For $i = 0 To $windowTabs
;                 >------------------------------------------------------------------------------------------------------------------------------------------------<
;                                       >------------------------------------------------------------------------------------------------------------------------<
;                                                            >---------------------------------------------------------------------<
;                                                                                >-------<
Local $exlogTmp = _Encoding_ANSIToOEM ( StringRegExpReplace( StringRegExpReplace($exlog[$i], "%date", @YEAR & "." & @MON &"."& @MDAY) , "%time" , @HOUR &"."& @MIN &"."& @SEC ) )

Select ; тип пути. 0=без пути. 1=кирилица с пробелами в пути. 2=как 1, с пробелом между параметрами
      Case $typecmd[$i] = 4
$sLine[$i] = _Encoding_ANSIToOEM(@WorkingDir & '\' & $expath[$i] & '\' & $exname[$i]) & $server[$i] & $port[$i] & $user[$i] & $devr[$i] & $pass[$i] & $exlog[$i] & $params[$i] & @CRLF

   Case $typecmd[$i] = 5
$sLine[$i] = _Encoding_ANSIToOEM(@WorkingDir & '\' & $expath[$i] & '\' & $exname[$i] & $server[$i] & $port[$i] & $user[$i] & $devr[$i] & $pass[$i] & $exlog[$i] & $params[$i]) & @CRLF

	Case $typecmd[$i] = 3
$sLine[$i] = _Encoding_ANSIToOEM('"' & @WorkingDir & '\' & $expath[$i] & '\' & $exname[$i] & '" ' & $server[$i] & $port[$i] & $user[$i] & $devr[$i] & $pass[$i] & $exlog[$i] & $params[$i]) & @CRLF

	Case $typecmd[$i] = 6
$sLine[$i] =  @WorkingDir & '\' & $expath[$i] & '\' & $exname[$i] & ' ' & $server[$i] & ' ' & $port[$i] & ' ' & $user[$i] & $devr[$i] & ' ' & $pass[$i] & ' ' & $exlog[$i] & ' ' & $params[$i] & @CRLF

	Case $typecmd[$i] = 0 ; без папки. программа.exe сервер порт пользовательУстройство Пароль лог параметры(перевод строки)
$sLine[$i] = $exname[$i] & " " & $server[$i] & " " & $port[$i] & " " & $user[$i] & $devr[$i] & " " & $pass[$i] & " " & $exlogTmp & " " & $params[$i] & @CRLF

	Case $typecmd[$i] = 1 ; в папке программы. "(путь1251>866)" параметр1параметр2параметр3(...)(перевод строки)
$sLine[$i] = '"' & _Encoding_ANSIToOEM(@WorkingDir & '\' & $expath[$i] & '\' & $exname[$i]) & '" ' & $server[$i] & $port[$i] & $user[$i] & $devr[$i] & $pass[$i] & $exlogTmp & $params[$i] & @CRLF


; в папке программы. "(путь1251>866)" сервер порт пользовательУстройство пароль лог параметры(перевод строки)
	Case $typecmd[$i] = 2
$sLine[$i] = '"' & _Encoding_ANSIToOEM(@WorkingDir & '\' & $expath[$i] & '\' & $exname[$i]) & '" ' & $server[$i] & " " & $port[$i] & " " & $user[$i] & $devr[$i] & " " & $pass[$i] & " " & $exlogTmp & " " & $params[$i] & @CRLF


EndSelect
   Next
EndFunc
#EndRegion _sLine
;--------------------------------------------------------------------------------------------------
Func createBAT()
	Select
		Case Not FileExists (  @WorkingDir & "\запилки")
			DirCreate ( @WorkingDir & "\запилки" )
				EndSelect
For $i=0 To $windowTabs
	FileDelete ( @WorkingDir & "\запилки\" & $process & $i & "_" & $info[$i] & ".bat" )
	FileWrite ( @WorkingDir & "\запилки\" & $process & $i & "_" & $info[$i] & ".bat", "@echo off" & @CRLF & _
"title " & $info[$i] & " - Created in " & $NameGUI & @CRLF & @CRLF & $sLine[$i] )
Next
EndFunc