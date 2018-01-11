#include <dev-ini.au3>
#include <Encoding.au3> ; http://autoit-script.ru/index.php?topic=510.0
$myini = @WorkingDir & "\myconf.ini"
$sysini = @WorkingDir & "\system.ini"
$windowTabs=4
;$exlpid[0] = [4]

 ;MsgBox(4096, "lll" , $windowTabs)


Select
Case FileExists($myini)
_readTab()
EndSelect

Func _readTab()
   $windowTabs = IniRead ($myini,"system","tabs", 1)
   If $windowTabs > 15 Then $windowTabs = 15
EndFunc

Global $strLimit=600000 ;! ��������  � ini
Global $sLine[$windowTabs+1]
Global $info[$windowTabs+1],$server[$windowTabs+1],$port[$windowTabs+1],$user[$windowTabs+1],$pass[$windowTabs+1]
Global $devr[$windowTabs+1],$expath[$windowTabs+1],$exname[$windowTabs+1],$exlog[$windowTabs+1],$params[$windowTabs+1]
Global $debug[$windowTabs+1],$exlpid[$windowTabs+1],$useregflg[$windowTabs+1],$urlprofile[$windowTabs+1],$typecmd[$windowTabs+1]

;--------------------------------------------------------------------------------------------------
Func _iniDefLoad()
For $i=0 To $windowTabs
$info[$i] = $i		; ������ .�������� �������
$devr[$i] = Null	; ���. ����������
$server[$i] = Null	; ��������. ������
$port[$i] = Null	; ��������. ����
$user[$i] = Null	; ��������. ������������
$pass[$i] = Null	; ��������. ������
$expath[$i] = Null	; ���� � ���������
$exname[$i] = Null	; ���������.exe
$exlog[$i] = Null	; ��������. ���� � ����
$params[$i] = Null	; �������������� ���������
$typecmd[$i] = 0 ; ��� �������. 1 ����� @WorkingDir . 0 ��� ����
$debug[$i] = @WorkingDir & $expath[$i] & "\" & $exname[$i] & $server[$i] & $port[$i] & $user[$i] & $devr[$i] & $pass[$i] & $exlog[$i] & $params[$i] ; �����. ���������� �������
$exlpid[$i] = Null	; pid ���������� ��������
$useregflg[$i] = 0	; 1 = ������������ ��������������� �� ���� , 0 = ������������
$urlprofile[$i] = "http:/www#"
Next
 ;MsgBox(4096,"_iniDefLoad",$info[0])
EndFunc
;--------------------------------------------------------------------------------------------------
Func _iniSave()

Select
   Case Not FileExists($myini)
   _iniDefLoad()   ; ���������  ��������� ���������
   _load_dev_ini() ; ��������� ������ ��������� ������������
EndSelect

   For $i=0 To $windowTabs
Local $process = "miner"
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
IniWrite($myini, "system", "tabs", $windowTabs)
EndFunc
;--------------------------------------------------------------------------------------------------
Func _iniLoad()
Select
   Case FileExists($myini)
_readTab()

   For $i = 0 To $windowTabs
Local $process = "miner"
$info[$i] = IniRead ($myini,$process & $i,"info", $i)
If $info[$i] = "" Then $info[$i] = $i ; ������  �� ���� ��� ��� ������ �������� �������
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
   Next

Case Else
   _iniSave()
EndSelect
EndFunc
;--------------------------------------------------------------------------------------------------
Func _sLine()
   For $i = 0 To $windowTabs
Select ; ��� ����. 0=��� ����. 1=�������� � ��������� � ����. 2=��� 1, � �������� ����� �����������
      Case $typecmd[$i] = 4
$sLine[$i] = _Encoding_ANSIToOEM(@WorkingDir & '\' & $expath[$i] & '\' & $exname[$i]) & $server[$i] & $port[$i] & $user[$i] & $devr[$i] & $pass[$i] & $exlog[$i] & $params[$i] & @CRLF

   Case $typecmd[$i] = 5
$sLine[$i] = _Encoding_ANSIToOEM(@WorkingDir & '\' & $expath[$i] & '\' & $exname[$i] & $server[$i] & $port[$i] & $user[$i] & $devr[$i] & $pass[$i] & $exlog[$i] & $params[$i]) & @CRLF

Case $typecmd[$i] = 3
$sLine[$i] = _Encoding_ANSIToOEM('"' & @WorkingDir & '\' & $expath[$i] & '\' & $exname[$i] & '" ' & $server[$i] & $port[$i] & $user[$i] & $devr[$i] & $pass[$i] & $exlog[$i] & $params[$i]) & @CRLF

Case $typecmd[$i] = 6
;$sLine[$i] =  @WorkingDir & "\" & $expath[$i] & "\" & $exname[$i] & " " & $server[$i] & " " & $port[$i] & " " & $user[$i] & $devr[$i] & " " & $pass[$i] & " " & $exlog[$i] & " " & $params[$i] & @CRLF
$sLine[$i] =  @WorkingDir & '\' & $expath[$i] & '\' & $exname[$i] & ' ' & $server[$i] & ' ' & $port[$i] & ' ' & $user[$i] & $devr[$i] & ' ' & $pass[$i] & ' ' & $exlog[$i] & ' ' & $params[$i] & @CRLF

Case $typecmd[$i] = 0 ; ��� �����. ���������.exe ������ ���� ���������������������� ������ ��� ���������(������� ������)
$sLine[$i] = $exname[$i] & " " & $server[$i] & " " & $port[$i] & " " & $user[$i] & $devr[$i] & " " & $pass[$i] & " " & $exlog[$i] & " " & $params[$i] & @CRLF

Case $typecmd[$i] = 1 ; � ����� ���������. "(����1251>866)" ��������1��������2��������3(...)(������� ������)
;$sLine[$i] = '"' & _Encoding_ANSIToOEM(@WorkingDir & '\' & $expath[$i] & '\' & $exname[$i]) & '" ' & $server[$i] & $port[$i] & $user[$i] & $devr[$i] & $pass[$i] & $exlog[$i] & $params[$i] & @CRLF
$sLine[$i] = '"' & _Encoding_ANSIToOEM(@WorkingDir & '\' & $expath[$i] & '\' & $exname[$i]) & '" ' & $server[$i] & $port[$i] & $user[$i] & $devr[$i] & $pass[$i] & _Encoding_ANSIToOEM($exlog[$i]) & $params[$i] & @CRLF


; � ����� ���������. "(����1251>866)" ������ ���� ���������������������� ������ ��� ���������(������� ������)
Case $typecmd[$i] = 2
;$sLine[$i] = '"' & _Encoding_ANSIToOEM(@WorkingDir & '\' & $expath[$i] & '\' & $exname[$i]) & '" ' & $server[$i] & " " & $port[$i] & " " & $user[$i] & $devr[$i] & " " & $pass[$i] & " " & $exlog[$i] & " " & $params[$i] & @CRLF
$sLine[$i] = '"' & _Encoding_ANSIToOEM(@WorkingDir & '\' & $expath[$i] & '\' & $exname[$i]) & '" ' & $server[$i] & " " & $port[$i] & " " & $user[$i] & $devr[$i] & " " & $pass[$i] & " " & _Encoding_ANSIToOEM($exlog[$i]) & " " & $params[$i] & @CRLF


EndSelect
   Next
EndFunc

