# gbc-sokoban

This is my first real approach to learn some assembly language. I chosed Z80 assembly for Gameboy Classic. Everybody knows this (not so) little handheld console as it became legend. I always wanted to have one and finally as a 34 I bought one. Playing on it is a real fun, but being a natural born programmer I ended up by tinkering with some code samples :)

So, here it is - my first attempt to write a simple game using Z80 assembly. It can be run on emulator like no$gmb. It won't probably run properly on real devide because it has never been prepared for that.

If you want to build it you need to download and install:
* [RGBDS assembler and linker](https://github.com/bentley/rgbds)
* [no$gmb emulator](http://problemkaputt.de/gmb.htm)

Then modify build.bat script setting up valid paths:

`set GB_SDK_HOME=d:\opt\gameboy`

`set EMU_HOME=%GB_SDK_HOME%\emulators\no$gmb`

`set RGBDS_HOME=%GB_SDK_HOME%\rgbds`

Most of comments in code are written in polish - sorry about that, but since polish is my native language it was easier for me to use it for documenting the code.
