@echo off
REM SMTk - Starbound Mod Toolkit
REM 
REM @author katana <katana@odios.us>
REM @license MIT license <https://opensource.org/licenses/MIT>
REM 
REM Copyright 2017 Damian Bushong <katana@odios.us>
REM 
REM Permission is hereby granted, free of charge, to any person obtaining a 
REM copy of this software and associated documentation files (the "Software"), 
REM to deal in the Software without restriction, including without limitation 
REM the rights to use, copy, modify, merge, publish, distribute, sublicense, 
REM and/or sell copies of the Software, and to permit persons to whom the 
REM Software is furnished to do so, subject to the following conditions:
REM 
REM The above copyright notice and this permission notice shall be included 
REM in all copies or substantial portions of the Software.
REM
REM THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
REM OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
REM FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
REM THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
REM LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
REM ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR 
REM OTHER DEALINGS IN THE SOFTWARE.

setlocal enabledelayedexpansion enableextensions

:BASE_CONFIG
REM // DO. NOT. MODIFY. THESE.
REM // SERIOUSLY.  HERE BE DRAGONS.
set dirname=%~dp0
set dirname=%dirname:~0,-1%
set argv=%*
set iserror=0
set targetdir=!argv!
set templogfile=
set temp=
pushd %dirname%

if (%targetdir%) EQU () (
	set targetdir=%dirname%\StarboundAssets\
	if not exist "!targetdir!" (
		mkdir "!targetdir!"
	)
)

REM // get the path to the Starbound tools we need
set templogfile=%dirname%\.temp.getsbtoolpath.log
call %dirname%\getsbtoolpath.bat >"%templogfile%" 2>&1
if errorlevel 1 (
	for /f "tokens=*" %%i in (%templogfile%) do (
		echo : [getsbtoolpath] %%i
	)
	del "'%templogfile%"
	echo : [tool] ERROR: Failed to get Starbound tools path.
	set iserror=1
	goto :END
)
del "%templogfile%"

set templogfile=%dirname%\.temp.assetunpacker.log

for %%F in ("%_sbtoolsdir%") do set temp=%%~dpF
set assetfile=!temp:~0,-1!\assets\packed.pak

echo calling asset_unpacker.exe to unpack the Starbound assets file.
echo please wait - this usually takes a while...
call "%_sbtoolsdir%\asset_unpacker.exe" !assetfile! !targetdir! > "%templogfile%" 2>&1
if errorlevel 1 (
	set iserror=1
)
for /f "tokens=*" %%i in (%templogfile%) do (
	echo : [asset_unpacker] %%i
)
del "%templogfile%"

if %iserror% EQU 1 (
	echo asset_unpacker.exe appears to have failed. exiting...
	goto END
) else (
	echo : unpacked assets available at: !targetdir!
)

goto :END

:END
popd
exit /b %iserror%