@set @x=0; /*
@echo off
set "autoitdir=C:\Program Files (x86)\AutoIt3"
set path=%path%;"%autoitdir%\Aut2Exe\"
set "xUPX="%autoitdir%\Aut2Exe\"upx.exe"
rem set app64=aGUI_x64d
set app64=GUI_x64
rem set "srcdir=%~d0%~p0"
set "srcdir=%~d0%~p0src\"
set "src_main=aigui"
set "outdir=%~d0%~p0"

title build %app64%
taskkill /im %app64%*

rem запись метки сборки в исходник
set now=%DATE: =0% %TIME: =0%
for /f "tokens=1-7 delims=/-:., " %%a in ( "%now%" ) do (
set now=%%a%%b%%c.%%d%%e
)
set "now=%now:~-11%"
rem >"%srcdir%version.au3" echo Global Const $version = "  0.%now% dev3"
>"%srcdir%version.au3" echo Global Const $version = "  0.%now%"

rem собираем врапер если его нет, с выводом в консоль и иконкой которой, дефолтно нет.
if not exist "%autoitdir%\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe" (
echo Not Found "%autoitdir%\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe" ...
copy "%autoitdir%\Icons\au3.ico" "%autoitdir%\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.ico"

"%autoitdir%\Aut2Exe\Aut2exe_x64.exe" /in "%autoitdir%\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.au3" /out "%autoitdir%\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe" /x64 /console /icon "%autoitdir%\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.ico"
)

rem переходим в папку чтоб добавились ресурсы
cd /d "%srcdir%"
"%autoitdir%\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe" /in "%srcdir%%src_main%.au3" /out %outdir%%app64%w.exe /nopack /Gui 

timeout /t 1
exit /b


