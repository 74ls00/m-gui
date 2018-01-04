;  @AZJIO пример программы с внешними языковыми файлами
;https://pastebin.com/SmZMnWjc

#include <ComboConstants.au3>

;=============================================================
; создаём два языковых файла En.lng и Ru.lng. В скрипте они не обязательны, нужны для этого примера. Добавлен флаг 32, чтобы включить поддержку Юникода
If Not FileExists(@ScriptDir & '\Lang') Then DirCreate(@ScriptDir & '\Lang')
$hFile = FileOpen(@ScriptDir & '\Lang\En.lng', 2 + 32)
If $hFile <> -1 Then
	FileWrite($hFile, _
			'[lng]' & @CRLF & _
			'1=My Programs' & @CRLF & _
			'2=Open' & @CRLF & _
			'3=Open File' & @CRLF & _
			'4=Example choice language' & @CRLF & _
			'5=Select' & @CRLF & _
			'6=Language')
	FileClose($hFile)
EndIf

$hFile = FileOpen(@ScriptDir & '\Lang\Ru.lng', 2 + 32)
If $hFile <> -1 Then
	FileWrite($hFile, _
			'[lng]' & @CRLF & _
			'1=Моя программа' & @CRLF & _
			'2=Открыть' & @CRLF & _
			'3=Открыть файл' & @CRLF & _
			'4=Пример выбора языка' & @CRLF & _
			'5=Выбор' & @CRLF & _
			'6=Языковой файл')
	FileClose($hFile)
EndIf
;=============================================================

#NoTrayIcon
Global $LangPath, $Ini = @ScriptDir & '\prog_set.ini'

; создаём файл настроек с языковым параметром. Используется при первом запуске.
If Not FileExists($Ini) Then
	$hFile = FileOpen($Ini, 2)
	If $hFile <> -1 Then
		FileWrite($hFile, _
				'[Set]' & @CRLF & _
				'Lang=none')
		FileClose($hFile)
	EndIf
EndIf

; По умолчанию устанавливаем англоязычный интерфейс, в случае отсутствия языковых файлов.
Global $aLngDef[7][2] = [[ _
		6, 6],[ _
		'1', 'My Programs'],[ _
		'2', 'Open'],[ _
		'3', 'Open File'],[ _
		'4', 'Example choice language'],[ _
		'5', 'Select'],[ _
		'6', 'Language']]

; Ru
; если русская локализация, то русский язык. Эта фишка необязательна, но удобство в том, чтобы на родном языке не требовался файл русификации
If @OSLang = 0419 Then
	Dim $aLngDef[7][2] = [[ _
			6, 6],[ _
			'1', 'Моя программа'],[ _
			'2', 'Открыть'],[ _
			'3', 'Открыть файл'],[ _
			'4', 'Пример выбора языка'],[ _
			'5', 'Выбор'],[ _
			'6', 'Языковой файл']]
EndIf

Global $aLng[7] = [6]

_SetLangCur($aLngDef) ; изначально устанавливаем по умолчанию, на случай если языковой файл окажется неправильный и не применится ко всем элементам

; применяем языковой файл, если указан.
$LangPath = IniRead($Ini, 'Set', 'Lang', 'none') ; читаем значение параметра lng в глобальную переменную $LangPath
If $LangPath <> 'none' And FileExists(@ScriptDir & '\Lang\' & $LangPath) Then ; если не по умолчанию и файл существует, то
	$aLngINI = IniReadSection(@ScriptDir & '\Lang\' & $LangPath, 'lng')
	If Not @error Then _SetLangCur($aLngINI)
EndIf
$aLngINI = 0

$hGui = GUICreate($aLng[1], 250, 100)
$Button = GUICtrlCreateButton($aLng[2], 10, 60, 99, 22)
GUICtrlSetTip(-1, $aLng[3])
$Label = GUICtrlCreateLabel($aLng[4], 10, 5, 153, 15)
; $Checkbox = GUICtrlCreateCheckbox ($aLng[5], 10, 50, 55, 22)

; Поиск языковых файлов, для добавления в список Combo
$LangList = 'none'
$search = FileFindFirstFile(@ScriptDir & '\Lang\*.lng')
If $search <> -1 Then
	While 1
		$hFile = FileFindNextFile($search)
		If @error Then ExitLoop
		$LangList &= '|' & $hFile
	WEnd
EndIf
FileClose($search)

GUICtrlCreateLabel('Language', 10, 33, 75, 17) ; Обычно этот текст не рекомендуется переводить, так как случайное переключение на непонятный язык приведёт к трудностям восстановления родного языка, так как не понятно какой пункт в меню кликать.
$ComboLang = GUICtrlCreateCombo('', 85, 30, 70, 22, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, $LangList, $LangPath)

GUISetState()

While 1
	Switch GUIGetMsg()
		Case $ComboLang
			_SetLang()
		Case -3
			Exit
	EndSwitch
WEnd

; функция смены языка
Func _SetLang()
	Local $aLngINI
	$LangPath = GUICtrlRead($ComboLang)
	If $LangPath <> 'none' And FileExists(@ScriptDir & '\Lang\' & $LangPath) Then ; если по умолчанию и файл существует, то
		$aLngINI = IniReadSection(@ScriptDir & '\Lang\' & $LangPath, 'lng')
		If Not @error Then
			_SetLangCur($aLngINI)
			_SetLang2()
			IniWrite($Ini, 'Set', 'Lang', $LangPath)
		EndIf
	Else ; если нет файла или выбран "none", то используем язык встроенный в программу
		_SetLangCur($aLngDef)
		_SetLang2()
		$LangPath = 'none'
		IniWrite($Ini, 'Set', 'Lang', 'none')
	EndIf
EndFunc   ;==>_SetLang

Func _SetLangCur($aLng2D)
	; генерируем переменные массива
	Local $tmp
	For $i = 1 To $aLng2D[0][0]
		If StringInStr($aLng2D[$i][1], '\n') Then $aLng2D[$i][1] = StringReplace($aLng2D[$i][1], '\n', @CRLF) ; Обеспечивает перенос строк, который не поддерживает ini
		$tmp = Number($aLng2D[$i][0])
		If $tmp > 0 And $tmp <= $aLng[0] Then $aLng[$tmp] = $aLng2D[$i][1] ; добавление текста, если его параметр является число используемое как индекс массива
		; Фактически если переданный в $tmp параметр не является числом в диапазоне индексов массива, то он будет отброшен. Массив не вызывает ошибки, так как число не превысит количество элементов массива.
	Next
EndFunc   ;==>_SetLangCur

; функция обновления текстов интерфейса
Func _SetLang2()
	; недостаточно обновить имена в переменных, их нужно сменить в видимом интерфейсе программы
	WinSetTitle($hGui, '', $aLng[1]) ; сменить имя окна, если это окно настройки
	GUICtrlSetData($Label, $aLng[4])
	GUICtrlSetData($Button, $aLng[2])
	GUICtrlSetTip($Button, $aLng[3])
	; смена языка взависимости от состояния чекбокса
	; If $TrCh = 0 Then
		; GUICtrlSetTip($Checkbox, $aLng[5])
	; Else
		; GUICtrlSetTip($Checkbox, $aLng[6])
	; EndIf
EndFunc   ;==>_SetLang2