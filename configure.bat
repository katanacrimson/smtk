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

:TOOL_OPTIONS
set _HAS_NODE=0
set _BUILD_USE_PNGSQUEEZE=0
set _BUILD_USE_JSONVALIDATE=0
set _BUILD_USE_PATCHBUILDER=0
set _BUILD_USE_PREPAKHOOK=1
set _BUILD_USE_POSTPAKHOOK=1

:MOD_CONFIG
set _moddir=!argv!
set _pakname=
set _patchbasedir=
set _builddir=
set _srcdir=
set _sbassetsdir=
set _prepakhook=
set _postpakhook=
set _sbtoolsdir=

:MAIN
rem // check to see if SMTk has even been configured for this mod
if not exist "%_moddir%\config.bat" (
	goto :INIT_INSTALL
)
call %_moddir%\config.bat

if (%_pakname%) EQU () (
	REM // we need to punt the user into installing.
	goto :PROMPT_USER_INSTALL
)

if(%_patchbasedir%) EQU () (
	set _patchbasedir=%_moddir%\modified
)
if(%_builddir%) EQU () (
	set _builddir=%_moddir%\build
)
if(%_srcdir%) EQU () (
	set _srcdir=%_moddir%\src
)
if (%_sbassetsdir%) EQU () (
	set _sbassetsdir=%dirname%\StarboundAssets
)
if (%_BUILD_USE_PREPAKHOOK%) EQU () (
	set _BUILD_USE_PREPAKHOOK=1
)
if (%_BUILD_USE_POSTPAKHOOK%) EQU () (
	set _BUILD_USE_POSTPAKHOOK=1
)
set _prepakhook=%_moddir%\prepakhook.bat
set _postpakhook=%_moddir%\postpakhook.bat
@where node.exe 1>nul 2>nul
if errorlevel 1 (
	set _HAS_NODE=0
) else (
	set _HAS_NODE=1
)

REM // get the path to the Starbound tools we need
call %dirname%\getsbtoolpath.bat >nul

REM // done loading. throw vars over the fence
goto :EXPORT

:INIT_INSTALL
echo no config.bat file was found in the mod directory - creating one...
REM // copy over the user-facing scripts
@copy %dirname%\installables\config.example.bat %_moddir%\config.bat >nul 2>nul
if errorlevel 1 (
	echo unable to create config file in mod directory
	set iserror=1
	goto :END
)

@copy %dirname%\installables\make.bat %_moddir%\make.bat >nul 2>nul
@copy %dirname%\installables\jsonvalidate.bat %_moddir%\jsonvalidate.bat >nul 2>nul
@copy %dirname%\installables\patchbuilder.bat %_moddir%\patchbuilder.bat >nul 2>nul
@copy %dirname%\installables\pngsqueeze.bat %_moddir%\pngsqueeze.bat >nul 2>nul
@echo set smtkpath=%dirname% > %_moddir%\_smtkpath.bat 2>nul

goto :PROMPT_USER_INSTALL

:PROMPT_USER_INSTALL
REM // check if things aren't set, and set them if we need to.
echo please edit the config.bat file in your mod directory to configure the mod tools.
echo exiting...
set iserror=1
goto :END

:EXPORT

endlocal & (
	set smtkloaded=1
	set moddir=%_moddir%
	set pakname=%_pakname%
	set patchbasedir=%_patchbasedir%
	set builddir=%_builddir%
	set srcdir=%_srcdir%

	set prepakhook=%_prepakhook%
	set postpakhook=%_postpakhook%

	set sbassetsdir=%_sbassetsdir%
	set sbtoolsdir=%_sbtoolsdir%
	set smtklog=%_moddir%\smtk.log

	set HAS_NODE=%_HAS_NODE%
	set BUILD_USE_PNGSQUEEZE=%_BUILD_USE_PNGSQUEEZE%
	set BUILD_USE_JSONVALIDATE=%_BUILD_USE_JSONVALIDATE%
	set BUILD_USE_PATCHBUILDER=%_BUILD_USE_PATCHBUILDER%
	set BUILD_USE_PREPAKHOOK=%_BUILD_USE_PREPAKHOOK%
	set BUILD_USE_POSTPAKHOOK=%_BUILD_USE_POSTPAKHOOK%
)

goto :END

:END
exit /b %iserror%