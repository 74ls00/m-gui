rem @echo off

chcp 1251
cls
set prodir=%~d0%~p0
set outdir=%~d0%~p0
set "autoitdir=T:\Program Files (x86)\AutoIt3"

set app=dcon1
set app86=%app%(x86)
set app64=%app%



start /d "%autoitdir%\Aut2Exe" Aut2exe_x64.exe /in %prodir%%app%.au3 /out %outdir%%app64%.exe /x64 /console

rem  %comspec% /c %outdir%%app64%.exe
