@echo off
rem chcp 1251
cls
set "srcdir=%~d0%~p0src\"
set "main=%srcdir%aigui.au3"
set outdir=%~d0%~p0
set "autoitdir=T:\Program Files (x86)\AutoIt3"
set "upxx=T:\Devel\upx394w\upx.exe"

set app=AiGUI%app64%
set "icon=%srcdir%res\icon2.ico"
rem set app86=%app%(x86)
rem set app64=%app%_x64
set app64=%app%

echo З†Ґ•аи•≠®• ѓаЃж•бб†
taskkill /im %app%*

rem %date%=YYYY-MM-DD %time%=hH:mm:ss.ms
set now=%DATE: =0% %TIME: =0%
rem set now=%TIME: =0%
for /f "tokens=1-7 delims=/-:., " %%a in ( "%now%" ) do (
rem %%a - год %%b - мес€ц %%c - день %%d - часы %%e - минуты %%f - секунды %%g - сотые
set now=%%a%%b%%c.%%d%%e
rem set now=%%a%%b.%%c
)
set "now=%now:~-11%"
rem >"%~d0%~p0version.au3" echo Dim $version = "  0.%now%"
>"%srcdir%version.au3" echo Dim $version = "  0.%now%"


start /d "%autoitdir%\Aut2Exe" Aut2exe_x64.exe /in %main% /out %outdir%%app64%.exe /x64 /comp 4 /icon %icon% /gui

rem "%autoitdir%\Aut2Exe\upx.exe" -9  -o %outdir%%app64%u.exe %outdir%%app64%.exe
rem "%upxx%" -5 -o %outdir%%app64%u.exe %outdir%%app64%.exe

timeout /t 2




