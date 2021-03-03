#!/bin/bash

# export GB_SDK_HOME=d:\opt\gameboy
# export EMU_HOME=%GB_SDK_HOME%\emulators\no$gmb
# export RGBDS_HOME=%GB_SDK_HOME%\rgbds

export project_name=sokoban

export PROJECT_HOME=.

echo "Cleaning..."
rm -f $project_name.gb
rm -f $project_name.map
rm -f $project_name.sym

echo "Compiling dependencies..."

rgbasm -Wno-obsolete -ovars.obj inc/vars.asm
rgbasm -Wno-obsolete -omemory.obj inc/memory.asm
rgbasm -Wno-obsolete -okeypad.obj inc/keypad.asm
rgbasm -Wno-obsolete -oplayer.obj inc/player.asm
rgbasm -Wno-obsolete -ocrate.obj inc/crate.asm

echo "Compiling project..."

rgbasm -Wno-obsolete -o$project_name.obj $project_name.asm

# echo "Generating linker input..."
# echo [Objects] >  LINK
# echo vars.obj >> LINK
# echo memory.obj >> LINK
# echo keypad.obj >> LINK
# echo player.obj >> LINK
# echo crate.obj >> LINK
# echo $project_name.obj >> LINK
# echo [Output] >> LINK
# echo $project_name.gb >> LINK

echo "Linking..."
rgblink -m $project_name.map -n $project_name.sym -o $project_name.gb vars.obj memory.obj keypad.obj player.obj crate.obj $project_name.obj

echo "Fixing..."
rgbfix -v $project_name.gb

rm -f vars.obj
rm -f memory.obj
rm -f keypad.obj
rm -f player.obj
rm -f crate.obj
rm -f sokoban.obj
rm -f LINK

#if exist %project_name%.gb start %EMU_HOME%\no$gmb %PROJECT_HOME%\%project_name%.gb
