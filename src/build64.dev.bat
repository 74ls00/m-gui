@echo off

set "autoitdir=C:\Program Files (x86)\AutoIt3"
rem set "autoitdir=T:\Program Files (x86)\AutoIt3"
set path=%path%;"%autoitdir%\Aut2Exe\"
set "upxx="%autoitdir%\Aut2Exe\"upx.exe"
set "outdir=%~d0%~p0"
set "srcdir=%~d0%~p0"
set "icon=%srcdir%res\icon12.ico"
set app64=GUI_x64
set "upxend=u"
set "compind=w"
title build %app64%
taskkill /im %app64%*

set now=%DATE: =0% %TIME: =0%
for /f "tokens=1-7 delims=/-:., " %%a in ( "%now%" ) do (
set now=%%a%%b%%c.%%d%%e
)
set "now=%now:~-11%"
>"%srcdir%version.au3" echo Global Const $version = "  0.%now% dev"

 "%autoitdir%\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe" /in "%srcdir%aigui.au3" /out %outdir%%app64%w.exe /nopack /Gui 

rem "%autoitdir%\Aut2Exe\Aut2exe_x64.exe" /in "%srcdir%aigui.au3" /out %outdir%%app64%.exe /x64 /comp 4 /icon %icon% /gui

del %outdir%%app64%%compind%%upxend%.exe
%upxx% -9  -o "%outdir%%app64%%compind%%upxend%.exe" "%outdir%%app64%%compind%.exe" -k
rem del %outdir%%app64%%compind%.exe

timeout /t 1
