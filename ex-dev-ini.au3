; rename to dev-ini.au3


Func _load_dev_ini()

$info[0] = "CPU NH ZEC"
$server[0] = " -l zec.suprnova.cc:2142"
$user[0] = " -u user.rig0"
$pass[0] = " -p pass"
$expath[0] = "nheqminer_suprnovav0.4a"
$exname[0] = "nheqminer.exe"
$exlog[0] = Null
$urlprofile[0] = "https://zec.suprnova.cc/index.php?page=dashboard"

$debug[0] = @WorkingDir & $expath[0] & "\" & $exname[0] & $server[0] & $user[0] & $pass[0] & $exlog[0] & $params[0]

$info[1] = "GPU0 dstm ZEC"
$server[1] = " --server zec.suprnova.cc"
$port[1] = " --port 2142"
$user[1] = " --user user.rig1"
$pass[1] = " --pass pass"
$expath[1] = "zm_0.5.7_win"
$exname[1] = "zm.exe"
$exlog[1] = " --logfile=" & @WorkingDir & "\tmp\log.txt"
$urlprofile[1] = "https://zec.suprnova.cc/index.php?page=dashboard"

$debug[1] = @WorkingDir & $expath[1] & "\" & $exname[1] & $server[1] & $port[1] & $user[1] & $pass[1] & $exlog[1] & $params[1]

EndFunc