@echo off
setlocal enabledelayedexpansion enableextensions
set NPP_HOME=D:\Apps\Notepad++

set ASM_FILES=
for /r . %%g in (*.asm) do set ASM_FILES=!ASM_FILES! %%g
set ASM_FILES=%ASM_FILES:~1%

set INC_FILES=
for /r . %%g in (*.inc) do set INC_FILES=!INC_FILES! %%g
set INC_FILES=%INC_FILES:~1%

start %NPP_HOME%\notepad++.exe -nosession %ASM_FILES% %INC_FILES%