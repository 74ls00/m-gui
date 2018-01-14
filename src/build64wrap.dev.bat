@set @x=0; /*
@echo off
set "autoitdir=C:\Program Files (x86)\AutoIt3"
set path=%path%;"%autoitdir%\Aut2Exe\"
set "xUPX="%autoitdir%\Aut2Exe\"upx.exe"
set app64=aGUI_x64e
set "srcdir=%~d0%~p0"
set "src_main=aigui.au3"
set "srctmp=~1251%src_main%"
set "outdir=%~d0%~p0"

title build %app64%
taskkill /im %app64%*

rem запись метки сборки в исходник
set now=%DATE: =0% %TIME: =0%
for /f "tokens=1-7 delims=/-:., " %%a in ( "%now%" ) do (
set now=%%a%%b%%c.%%d%%e
)
set "now=%now:~-11%"
>"%srcdir%version.au3" echo Global Const $version = "  0.%now% dev2"

rem перекодируем файл.
rem http://www.cyberforum.ru/post7145805.html
call :Recode "%srcdir%%src_main%" "%srcdir%%srctmp%" utf-8 windows-1251
:Recode in.[исходный файл] in.[результирующий файл] in.[кодировка исходного файла] in.[кодировка результирующего файла]
cscript.exe //nologo //e:jscript "%~f0" "%~1" "%~2" "%~3" "%~4"

rem собираем врапер если его нет, с вывлдом в консоль и иконкой которой, дефолтно нет.
if not exist "%autoitdir%\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe" (
echo Not Found "%autoitdir%\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe" ...
copy "%autoitdir%\Icons\au3.ico" "%autoitdir%\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.ico"

"%autoitdir%\Aut2Exe\Aut2exe_x64.exe" /in "%autoitdir%\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.au3" /out "%autoitdir%\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe" /x64 /console /icon "%autoitdir%\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.ico"
)

rem переходим в папку чтоб добавились ресурсы
cd /d "%srcdir%"
"%autoitdir%\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.exe" /in "%srcdir%%srctmp%" /out %outdir%%app64%w.exe /nopack /Gui 
rem удаляем временный перекодированый файл
del "%srcdir%%srctmp%"
rem удаляев старый финальных бинарник, upx это не умеет
del "%outdir%%app64%wu.exe"
%xUPX% -9  -o "%outdir%%app64%wu.exe" "%outdir%%app64%w.exe" -k
rem удаляем неупакованый бинарник если нужно
rem del "%outdir%%app64%w.exe"

rem тут был Exit /B , но консоль просто пойдёт по кругу
timeout /t 1
exit





 
*/with (new ActiveXObject('ADODB.Stream')) {
  Charset = WScript.Arguments(2);
  Open();
  LoadFromFile (WScript.Arguments(0));
  Text = ReadText();
  Close();
  Charset = WScript.Arguments(3);
  Open();
  WriteText (Text);
  SaveToFile (WScript.Arguments(1), 2);
  Close();
}