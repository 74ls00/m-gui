
Global $windowTabs
Global $info[$windowTabs+1],$server[$windowTabs+1],$port[$windowTabs+1],$user[$windowTabs+1],$pass[$windowTabs+1]
Global $devr[$windowTabs+1],$expath[$windowTabs+1],$exname[$windowTabs+1],$exlog[$windowTabs+1],$params[$windowTabs+1]
Global $debug[$windowTabs+1],$exlpid[$windowTabs+1],$useregflg[$windowTabs+1],$urlprofile[$windowTabs+1]
Global $typecmd[$windowTabs+1]

Func _load_dev_ini()

$info[0] = "ping 8.8.8.8"
$server[0] = " -t 8.8.8.8"
;$expath[0] = @SystemDir
$exname[0] = "ping.exe"
$exlog[0] = Null
$debug[0] = @SystemDir & $expath[0] & "\" & $exname[0] & $server[0] & $port[0] & $user[0] & $pass[0] & $exlog[0] & $params[0]
$typecmd[0] = 0

$info[1] = "CPU NH ZEC"
$server[1] = " -l zec.suprnova.cc:2142"
$user[1] = " -u user.cpu0"
$pass[1] = " -p pass"
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

$info[2] = "GPU0 dstm sn ZEC"
$server[2] = "--server zec.suprnova.cc"
$port[2] = "--port 2142"
$user[2] = "--user user.gpu0"
$pass[2] = "--pass pass"
$expath[2] = "zm_0.5.7_win"
$exname[2] = "zm.exe"
$exlog[2] = '--logfile="' & @WorkingDir & '\tmp\log.txt"'
$urlprofile[2] = "https://zec.suprnova.cc/index.php?page=dashboard"
$debug[2] = @WorkingDir & $expath[2] & "\" & $exname[2] & $server[2] & $port[2] & $user[2] & $pass[2] & $exlog[2]
$typecmd[2] = 2

$info[4] = "GPU0 dstm fl ZEC"
$server[4] = "--server eu1-zcash.flypool.org"
$port[4] = "--port 3333"
$user[4] = "--user x1LUDzq477c7777hhhhngfdcvbfrgvfU2Ro"
$devr[4] = ".ZM_gpu0"
$expath[4] = "zm_0.5.7_win"
$exname[4] = "zm.exe"
$exlog[4] = '--logfile="' & @WorkingDir & '\tmp\log.txt"'
$urlprofile[4] = "https://zcash.flypool.org/miners/x1LUDzq477c7777hhhhngfdcvbfrgvfU2Ro"
$debug[4] = @WorkingDir & $expath[4] & "\" & $exname[4] & $server[4] & $port[4] & $user[4] & $pass[4] & $exlog[4]
$typecmd[4] = 2

$info[3] = "CPU NH ZEC fl"
$server[3] = " -l eu1-zcash.flypool.org:3333"
$user[3] = " -u x10UDzq477c7777hhhhngfdcvbfrgvfU2Ro"
$devr[3] = ".cpu0"
$expath[3] = "nheqminer_0.3a_flypool"
$exname[3] = "nheqminer.exe"
$exlog[3] = Null
$urlprofile[3] = "https://zcash.flypool.org/miners/x1LUDzq477c7777hhhhngfdcvbfrgvfU2Ro"
$debug[3] = @WorkingDir & $expath[3] & "\" & $exname[3] & $server[3] & $user[3] & $pass[3] & $exlog[3] & $params[3]
$typecmd[3] = 1


EndFunc