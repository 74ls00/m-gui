#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <GuiImageList.au3>

_Main()

Func _Main()
    Local $hImage, $y = 80, $iIcon = 125, $btn[6], $rdo[6], $chk[6], $hImageSmall

    GUICreate("Назначает кнопке список изображений", 510, 400)

    $hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
   ; For $x = 6 To 11
     ;   _GUIImageList_AddIcon($hImage, "shell32.dll", $x, True)
		_GUIImageList_AddIcon($hImage, "shell32.dll", 6, True)
   ; Next

   ; $hImageSmall = _GUIImageList_Create(16, 16, 5, 3, 6)
 ;   For $x = 6 To 11
  ;      _GUIImageList_AddIcon($hImageSmall, "shell32.dll", $x)
    ;Next

    $btn[0] = GUICtrlCreateButton("Кнопка1", 10, 10, 110, 55)
    _GUICtrlButton_SetImageList($btn[0], $hImage)

  ;  $rdo[0] = GUICtrlCreateRadio("Радио Кнопка1", 160, 20, 120, 40)
   ; _GUICtrlButton_SetImageList($rdo[0], $hImageSmall)

   ; $chk[0] = GUICtrlCreateCheckbox("Check Кнопка1", 320, 20, 120, 40)
  ;  _GUICtrlButton_SetImageList($chk[0], $hImageSmall)

  ;  For $x = 1 To 5
    ;    $btn[$x] = GUICtrlCreateButton("Кнопка" & $x + 1, 10, $y - 10, 110, 55)
     ;   _GUICtrlButton_SetImageList($btn[$x], _GetImageListHandle("shell32.dll", $iIcon + $x, True), $x)
     ;   $rdo[$x] = GUICtrlCreateRadio("Радио Кнопка" & $x + 1, 160, $y, 120, 40)
     ;   _GUICtrlButton_SetImageList($rdo[$x], _GetImageListHandle("shell32.dll", $iIcon + $x), $x)
    ;   $chk[$x] = GUICtrlCreateCheckbox("Check Кнопка" & $x + 1, 320, $y, 120, 40)
    ;    _GUICtrlButton_SetImageList($chk[$x], _GetImageListHandle("shell32.dll", $iIcon + $x), $x)
   ;     $y += 60
    ;Next
    GUISetState()

    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop
        EndSwitch
    WEnd

    Exit
EndFunc   ;==>_Main

; Использование списка изображений, чтобы установить 1 изображение и текст на кнопке
Func _GetImageListHandle($sFile, $nIconID = 0, $fLarge = False)
    Local $iSize = 16
    If $fLarge Then $iSize = 32

    Local $hImage = _GUIImageList_Create($iSize, $iSize, 5, 3)
    If StringUpper(StringMid($sFile, StringLen($sFile) - 2)) = "BMP" Then
        _GUIImageList_AddBitmap($hImage, $sFile)
    Else
        _GUIImageList_AddIcon($hImage, $sFile, $nIconID, $fLarge)
    EndIf
    Return $hImage
EndFunc   ;==>_GetImageListHandle