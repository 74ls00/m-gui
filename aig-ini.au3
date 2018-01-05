


$ini = @WorkingDir & "\aigui.ini"

Dim $firstrun


;@WorkingDir & "nheqminer_suprnovav0.4a\nheqminer.exe -l zec.suprnova.cc:2142 -u satok.cpu0 -p cpu0p"

;$info   ; заголовок  окна
;$dev    ; значение. имя устройства
;$server ; параметр сервера
;$port   ; параметр порта
;$user   ; параметр пользователя
;$pass	 ; параметр пароль

;$expath ; путь к исполняемому файлу
;$exname ; программа
;$log    ; параметр указание лог файла
;$params ; дополнительные параметры

;$debug  ; вывод. полученная команда
; ! параметр означает что перед ним будет пробел

; parp="programs\" = "C:\эта папка\programs\"
; parx=prog.exe    = "prog.exe"
; pars="-p pass"   = " -p pass"
; parn="-p pass"   = "-p pass"


Func _iniSave()

If Not FileExists($ini) Then
   $mpath0 = "nheqminer_suprnovav0.4a\"
   $name0 = "nheqminer.exe"
   $server0 = "-l zec.suprnova.cc:2142"
   $port0 = ""
   $user0 = "-u satok.cpu0"
   $rig0 = ""
   $pass0 = "-p cpu0p"
   $info0 = "CPU NH ZEC"

   $mpath1 = "zm_0.5.7_win\"
   $name1 = "zm.exe"
   $server1 = "--server zec.suprnova.cc"
   $port1 = "--port 2142"
   $user1 = "--user satok.gpu0"
   $rig1 = ""
   $pass1 = "--pass gpu0p"
   $info1 = "GPU0 dstm ZEC"




   ;FileWrite ($ini,"")
   $firstrun = 1
EndIf

IniWrite($ini, "miner0", "mpath0", $mpath0)
IniWrite($ini, "miner0", "name0", $name0)
IniWrite($ini, "miner0", "server0", $server0)
IniWrite($ini, "miner0", "port0", $port0)
IniWrite($ini, "miner0", "user0", $user0)
IniWrite($ini, "miner0", "rig0", $rig0)
IniWrite($ini, "miner0", "pass0", $pass0)
IniWrite($ini, "miner0", "info0", $info0)

IniWrite($ini, "miner1", "mpath1", $mpath1)
IniWrite($ini, "miner1", "name1", $name1)
IniWrite($ini, "miner1", "server1", $server1)
IniWrite($ini, "miner1", "port1", $port1)
IniWrite($ini, "miner1", "user1", $user1)
IniWrite($ini, "miner1", "rig1", $rig1)
IniWrite($ini, "miner1", "pass1", $pass1)
IniWrite($ini, "miner1", "info1", $info1)

EndFunc
;--------------------------------------------------------------------------------------------------
Func _iniLoad()
   ;MsgBox(4096, $ini)
If FileExists($ini) Then
$mpath0 = IniRead ($ini,"miner0","mpath0","")
$name0 = IniRead ($ini,"miner0","name0","")
$server0 = IniRead ($ini,"miner0","server0","")
$port0 = IniRead ($ini,"miner0","port0","")
$user0 = IniRead ($ini,"miner0","user0","")
$rig0 = IniRead ($ini,"miner0","rig0","")
$pass0 = IniRead ($ini,"miner0","pass0","")
$info0 = IniRead ($ini,"miner0","info0","")

$mpath1 = IniRead ($ini,"miner1","mpath1","")
$name1 = IniRead ($ini,"miner1","name1","")
$server1 = IniRead ($ini,"miner1","server1","")
$port1 = IniRead ($ini,"miner1","port1","")
$user1 = IniRead ($ini,"miner1","user1","")
$rig1 = IniRead ($ini,"miner1","rig1","")
$pass1 = IniRead ($ini,"miner1","pass1","")
$info1 = IniRead ($ini,"miner1","info1","")

Else
_iniSave()
EndIf
;_dataLoad()
If $firstrun Then _firstrun()
EndFunc
;--------------------------------------------------------------------------------------------------
;Func _dataLoad()
;Dim $tlay[8] = [$m1,$s1,$m2,$s2,$k,$m3,$m4,$e]	;слои
;EndFunc
;--------------------------------------------------------------------------------------------------
Func _firstrun()
   $hFile = FileOpen($ini, 1)
;   FileWriteLine($hFile, "$mpath" & @CRLF)
;   FileWriteLine($hFile, ";mode=0 Click mode" & @CRLF)
   FileClose($hFile)
   IniWrite($ini, "system", "firstrun", 0)
   $firstrun = 0
EndFunc