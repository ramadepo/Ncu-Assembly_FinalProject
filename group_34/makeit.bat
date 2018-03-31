path D:\masm32\BIN;%path%
set include=D:\masm32\INCLUDE
set lib=D:\masm32\LIB
set ml=/coff /link /SUBSYSTEM:WINDOWS

@echo off

if not exist group_34.rc goto over1
\masm32\bin\rc /v group_34.rc
\masm32\bin\cvtres /machine:ix86 group_34.res
 :over1

if exist "group_34.obj" del "group_34.obj"
if exist "group_34.exe" del "group_34.exe"

\masm32\bin\ml /c /coff "group_34.asm"
if errorlevel 1 goto errasm

if not exist group_34.obj goto nores

\masm32\bin\Link /SUBSYSTEM:WINDOWS "group_34.obj" group_34.res
 if errorlevel 1 goto errlink

dir "group_34.*"
goto TheEnd

:nores
 \masm32\bin\Link /SUBSYSTEM:WINDOWS "group_34.obj"
 if errorlevel 1 goto errlink
dir "group_34.*"
goto TheEnd

:errlink
 echo _
echo Link error
goto TheEnd

:errasm
 echo _
echo Assembly Error
goto TheEnd

:TheEnd

pause
