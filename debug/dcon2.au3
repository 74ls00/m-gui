;N++ OEM866

;$sString = Null
;global $len0 = 140

for $n=0 to 20000

for $i = 0 to 150

local $sString =Random(0, 9, 1)

ConsoleWrite($sString )

Local $strl5 =  StringLen ( $sString )

next
ConsoleWrite(@CRLF )
next