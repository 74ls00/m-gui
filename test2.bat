chcp 1251
cls
set prodir=%~d0%~p0
set outdir=%~d0%~p0
set "autoitdir=T:\Program Files (x86)\AutoIt3"
set "upxx=T:\Devel\upx394w\upx.exe"

set app=test2
set app86=%app%(x86)
set app64=%app%x64

taskkill /im %app%*


start /d "%autoitdir%\Aut2Exe" Aut2exe_x64.exe /in %prodir%%app%.au3 /out %outdir%%app64%.exe /x64 /comp 4 /gui /icon %prodir%res\icon3.ico

rem "%autoitdir%\Aut2Exe\upx.exe" -9  -o %outdir%%app64%u.exe %outdir%%app64%.exe
rem "%upxx%" -5 -o %outdir%%app64%u.exe %outdir%%app64%.exe







