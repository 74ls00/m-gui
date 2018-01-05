#include <GuiButton.au3>
#include <GuiImageList.au3>


Func _aigbaseTab()

GUICtrlCreateGroup("", 15 , $StrTool-5 , $WWidth-30 , $THeight+5)
GUICtrlCreateLabel($NameGUI & " - интерфейс", 20, $StrTool+5, $WWidth-40, 60)
GUICtrlSetFont(-1, 10.5, 400, 0 , "Arial" , 5)
GUICtrlSetBkColor(-1, 0x00FF00)

GUICtrlCreateLabel("kk", 20, $StrTool+80)
GUICtrlSetBkColor(-1, 0x00FF09)
GUICtrlCreateLabel("индикатор2", 160, $StrTool+80)
GUICtrlSetBkColor(-1, 0x00FF09)

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "devmgr.dll", 4, True)
$btnDM = GUICtrlCreateButton("Диспетчер устройств", 25, $WHeight-95, 157, 40)
_GUICtrlButton_SetImageList($btnDM, $hImage)

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "taskmgr.exe", 0, True)
$btnTM = GUICtrlCreateButton("Диспетчер задач", 187, $WHeight-95, 147, 40)
_GUICtrlButton_SetImageList($btnTM, $hImage)

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "cmd.exe", 0, True)
$btnCM = GUICtrlCreateButton("Командная строка", 339, $WHeight-95, 150, 40)
_GUICtrlButton_SetImageList($btnCM, $hImage)

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "shell32.dll", 21, True)
$btnST = GUICtrlCreateButton("Настройки", 494, $WHeight-95, 150, 40)
_GUICtrlButton_SetImageList($btnST, $hImage)

$hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
_GUIImageList_AddIcon($hImage, "calc.exe", 0, True)
$btnCA = GUICtrlCreateButton("Калькулятор", 494, $WHeight-140, 150, 40)
_GUICtrlButton_SetImageList($btnCA, $hImage)

EndFunc
