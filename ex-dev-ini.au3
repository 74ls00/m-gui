; rename to dev-ini.au3
Func _load_dev_ini()

$info[0] = "ping ya.ru"
$server[0] = " -t ya.ru"
;$port[0] = ""
;$expath[0] = @SystemDir
$exname[0] = "ping.exe"
$exlog[0] = Null
$debug[0] = @SystemDir & $expath[0] & "\" & $exname[0] & $server[0] & $port[0] & $user[0] & $pass[0] & $exlog[0] & $params[0]
$typecmd[0] = 0

$info[1] = "CPU NH ZEC"
$server[1] = "-l zec.suprnova.cc:2142"
$user[1] = "-u user.cpu0"
$pass[1] = "-p pass"
$expath[1] = "nheqminer_suprnovav0.4a"
$exname[1] = "nheqminer.exe"
$exlog[1] = Null
$urlprofile[1] = "https://zec.suprnova.cc/index.php?page=dashboard"
$debug[1] = @WorkingDir & $expath[1] & "\" & $exname[1] & $server[1] & $user[1] & $pass[1] & $exlog[1] & $params[1]
$typecmd[1] = 1

ReDim $info[$windowTabs+2]
ReDim $server[$windowTabs+2]
ReDim $port[$windowTabs+2]
ReDim $expath[$windowTabs+2]
ReDim $exname[$windowTabs+2]
ReDim $exlog[$windowTabs+2]
ReDim $typecmd[$windowTabs+2]
ReDim $debug[$windowTabs+2]
ReDim $user[$windowTabs+2]
ReDim $pass[$windowTabs+2]
ReDim $urlprofile[$windowTabs+2]

$info[2] = "GPU0 dstm ZEC"
$server[2] = "--server zec.suprnova.cc"
$port[2] = "--port 2142"
$user[2] = "--user user.gpu0"
$pass[2] = "--pass pass"
$expath[2] = "zm_0.5.7_win"
$exname[2] = "zm.exe"
$exlog[2] = "--logfile=" & @WorkingDir & "\tmp\log.txt"
$urlprofile[2] = "https://zec.suprnova.cc/index.php?page=dashboard"
$debug[2] = @WorkingDir & $expath[2] & "\" & $exname[2] & $server[2] & $port[2] & $user[2] & $pass[2] & $exlog[2]
$typecmd[2] = 1

EndFunc