@echo off

set GB_SDK_HOME=d:\opt\gameboy
set EMU_HOME=%GB_SDK_HOME%\emulators\no$gmb
set RGBDS_HOME=%GB_SDK_HOME%\rgbds

set project_name=sokoban

set PROJECT_HOME=%~dp0

echo "Cleaning..."
del %project_name%.gb
del %project_name%.map
del %project_name%.sym

echo "Compiling dependencies..."

%RGBDS_HOME%\rgbasm95 -ovars.obj inc\vars.asm
%RGBDS_HOME%\rgbasm95 -omemory.obj inc\memory.asm
%RGBDS_HOME%\rgbasm95 -okeypad.obj inc\keypad.asm
%RGBDS_HOME%\rgbasm95 -oplayer.obj inc\player.asm

echo "Compiling project..."

%RGBDS_HOME%\rgbasm95 -o%project_name%.obj %project_name%.asm

echo "Generating linker input..."
echo [Objects]			>  LINK
echo vars.obj			>> LINK
echo memory.obj			>> LINK
echo keypad.obj			>> LINK
echo player.obj			>> LINK
echo %project_name%.obj	>> LINK
echo [Output]			>> LINK
echo %project_name%.gb	>> LINK

echo "Linking..."
%RGBDS_HOME%\xlink95 -m%project_name%.map -n%project_name%.sym LINK

echo "Fixing..."
%RGBDS_HOME%\rgbfix95 -p -v %project_name%.gb

del vars.obj
del memory.obj
del keypad.obj
del player.obj
del sokoban.obj
del LINK

start %EMU_HOME%\no$gmb %PROJECT_HOME%\%project_name%.gb
