
#include <dev-ini.au3>

$myini = @WorkingDir & "\myconf.ini"
$sysini = @WorkingDir & "\system.ini"
$windowTabs=1
Global $initabs

;Dim $firstrun ;видимо для записи инструкции в настройки
Dim $info[$windowTabs+1],$server[$windowTabs+1],$port[$windowTabs+1],$user[$windowTabs+1],$pass[$windowTabs+1]
Dim $devr[$windowTabs+1],$expath[$windowTabs+1],$exname[$windowTabs+1],$exlog[$windowTabs+1],$params[$windowTabs+1]
Dim $debug[$windowTabs+1],$exlpid[$windowTabs+1],$useregflg[$windowTabs+1],$urlprofile[$windowTabs+1]



;--------------------------------------------------------------------------------------------------
Func _iniSave()

Select
   Case Not FileExists($myini)
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
$debug[$i] = @WorkingDir & $expath[$i] & "\" & $exname[$i] & $server[$i] & $port[$i] & $user[$i] & $devr[$i] & $pass[$i] & $exlog[$i] & $params[$i] ; вывод. полученная команда
$exlpid[$i] = Null	; pid запущеного процесса
$useregflg[$i] = 0	; 1 = пользователь зарегестрирован на пуле , 0 = предупредить
$urlprofile[$i] = "http:/www#"
Next
 ;  $firstrun = 1
   _load_dev_ini() ; загрузить личные настройки
   $initabs = $windowTabs ; метка размерности
EndSelect

For $i=0 To $windowTabs
Local $process = "miner"
IniWrite($myini, $process & $i, "info", $info[$i])
IniWrite($myini, $process & $i, "dev", $devr[$i])
IniWrite($myini, $process & $i, "server", $server[$i])
IniWrite($myini, $process & $i, "port", $port[$i])
IniWrite($myini, $process & $i, "user", $user[$i])
IniWrite($myini, $process & $i, "pass", $pass[$i])
IniWrite($myini, $process & $i, "expath", $expath[$i])
IniWrite($myini, $process & $i, "exname", $exname[$i])
IniWrite($myini, $process & $i, "exlog", $exlog[$i])
IniWrite($myini, $process & $i, "params", $params[$i])
IniWrite($myini, $process & $i, "debug", $debug[$i])
IniWrite($myini, $process & $i, "exlpid", $exlpid[$i])
IniWrite($myini, $process & $i, "useregflg", $useregflg[$i])
IniWrite($myini, $process & $i, "urlprofile", $urlprofile[$i])
Next
IniWrite($myini, "system", "initabs", $windowTabs)

IniWrite($sysini, "system", "myconf", $myini)
IniWrite($sysini, "system", "tabs", $initabs)


EndFunc
;--------------------------------------------------------------------------------------------------
Func _iniLoad()
   ;MsgBox(4096, $ini)

Select
Case FileExists($sysini)
$myini = IniRead ($sysini,"system","myconf", Null)
$windowTabs = IniRead ($sysini,"system","tabs", Null)

If $windowTabs > $initabs Then
ReDim $info[$windowTabs+1]
ReDim $devr[$windowTabs+1]
ReDim $server[$windowTabs+1]
ReDim $port[$windowTabs+1]
ReDim $user[$windowTabs+1]
ReDim $pass[$windowTabs+1]
ReDim $expath[$windowTabs+1]
ReDim $exname[$windowTabs+1]
ReDim $exlog[$windowTabs+1]
ReDim $params[$windowTabs+1]
ReDim $debug[$windowTabs+1]
ReDim $exlpid[$windowTabs+1]
ReDim $useregflg[$windowTabs+1]
ReDim $urlprofile[$windowTabs+1]
EndIf

   Case Else
   _iniSave()
EndSelect


If FileExists($myini) Then

For $i = 0 To $windowTabs
Local $process = "miner"
$info[$i] = IniRead ($myini,$process & $i,"info", Null)
$devr[$i] = IniRead ($myini,$process & $i,"dev", Null)
$server[$i] = IniRead ($myini,$process & $i,"server", Null)
$port[$i] = IniRead ($myini,$process & $i,"port", Null)
$user[$i] = IniRead ($myini,$process & $i,"user", Null)
$pass[$i] = IniRead ($myini,$process & $i,"pass", Null)
$expath[$i] = IniRead ($myini,$process & $i,"expath", Null)
$exname[$i] = IniRead ($myini,$process & $i,"exname", Null)
$exlog[$i] = IniRead ($myini,$process & $i,"exlog", Null)
$params[$i] = IniRead ($myini,$process & $i,"params", Null)
$debug[$i] = IniRead ($myini,$process & $i,"debug", Null)
$exlpid[$i] = IniRead ($myini,$process & $i,"exlpid", Null)
$useregflg[$i] = IniRead ($myini,$process & $i,"useregflg", Null)
$urlprofile[$i] = IniRead ($myini,$process & $i,"urlprofile", Null)
Next

Else
_iniSave()
EndIf
;_dataLoad()
;If $firstrun Then _firstrun()
EndFunc
;--------------------------------------------------------------------------------------------------
;Func _dataLoad()
;Dim $tlay[8] = [$m1,$s1,$m2,$s2,$k,$m3,$m4,$e]	;слои
;EndFunc
;--------------------------------------------------------------------------------------------------
;Func _firstrun()
 ;  $hFile = FileOpen($myini, 1)
 ;  FileWriteLine($hFile, "$mpath" & @CRLF)
 ;  FileWriteLine($hFile, ";mode=0 Click mode" & @CRLF)
 ;  FileClose($hFile)
 ;  IniWrite($myini, "system", "firstrun", 0)
;   $firstrun = 0
;EndFunc











;$debug  ; вывод. полученная команда
; ! параметр означает что перед ним будет пробел

; parp="programs\" = "C:\эта папка\programs\"
; parx=prog.exe    = "prog.exe"
; pars="-p pass"   = " -p pass"
; parn="-p pass"   = "-p pass"








