set path=%path%;"%autoitdir%\Aut2Exe\"


set app=AiGUI
set app64=%app%_x64

set "outdir=%~d0%~p0"

cd /d "%outdir%"

upx.exe --ultra-brute %app64%.exe


pause

