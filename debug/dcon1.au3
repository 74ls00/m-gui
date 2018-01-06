;N++ OEM866

;$sString = Null
;global $len0 = 140

for $i = 0 to 200000

; 389778 > 390221 390570.
; 389777 > 390885
; 389776 > 390578 390525
; 378770 > 39257 39246 39278 379193 o379380 379255
; 368770 > 369438 369448  . 369275

;  378770 > 379174 379644 o379167 

;




;Do

;local $vTemp1 = Random(0, 1, 0)
;local $vTemp1 = 1
;Local $temp2 = $sString
;local $sString = $temp2 & $vTemp1
;local $sString = $temp2 & $vTemp1 & $temp2
local $sString =Random(0, 9, 1)

ConsoleWrite($sString )

Local $strl5 =  StringLen ( $sString )
;Local $sStringE = @CRLF & "Длинна строки = " & $strl5 & @CRLF
;ConsoleWriteError($sStringE )

;Until $strl5 > $len0
next