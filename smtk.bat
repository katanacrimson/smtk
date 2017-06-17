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
set moddir=!argv!
pushd %dirname%

REM // todo REMOVE!
REM set moddir=%dirname%

REM // todo: lots of comments and output

call configure.bat %moddir%
if errorlevel 1 (
	goto :END
)

if (%HAS_NODE%) EQU (0) (
	call tee.bat : WARNING: node.exe not found on system.
	call tee.bat : node-dependent utilities are disabled.
)

if (%HAS_NODE%) EQU (1) if not exist "%dirname%\node_modules\" (
	call tee.bat : WARNING: node modules not installed - please cd into %dirname% and run "npm install".
	call tee.bat :  - you may need to run "npm install --global --production windows-build-tools" as admin first.
	call tee.bat : node-dependent utilities are disabled.
	set HAS_NODE=0
)

REM // see if we have node and if we have the patches feature enabled
REM // we need to see, also, if there's been any unpacked assets identified for us.
REM //   if not, tell the user to run tool.unpackassets.bat and wait
if (%HAS_NODE%) EQU (1) if (%BUILD_USE_PATCHBUILDER%) EQU (1) if not exist "%sbassetsdir%\" (
	call tee.bat : WARNING: no unpacked starbound assets found.
	call tee.bat : please either set the path to your unpacked Starbound assets in your config file,
	call tee.bat :   or run the file %dirname%\tool.unpackassets.bat
	call tee.bat : the patchbuilder feature is disabled.
)
if (%HAS_NODE%) EQU (1) if (%BUILD_USE_PATCHBUILDER%) EQU (1) if exist "%sbassetsdir%\" (
	call tool.patchbuilder.bat
	if errorlevel 1 (
		call tee.bat : ERROR: tool.patchbuilder.bat appears to have failed.
		set iserror=1
		goto :END
	)
)

REM // see if we have node and if we want to use the png squeezer
if (%HAS_NODE%) EQU (1) if (%BUILD_USE_PNGSQUEEZE%) EQU (1) (
	call tool.pngsqueeze.bat
	if errorlevel 1 (
		call tee.bat : ERROR: tool.pngsqueeze.bat appears to have failed.
		set iserror=1
		goto :END
	)
)

REM // see if we have node and if we want to use the JSON validator
if (%HAS_NODE%) EQU (1) if (%BUILD_USE_JSONVALIDATE%) EQU (1) (
	call tool.jsonvalidate.bat
	if errorlevel 1 (
		call tee.bat : ERROR: tool.jsonvalidate.bat appears to have failed.
		set iserror=1
		goto :END
	)
)

REM // in the event that you need to do special things before the pak is built 
REM // (move files around, move files out of the srcdir, etc.)
REM // you can use a pre-pak hook.
REM // this hook should be a bat file named "prepakhook.bat" and be located in the root directory 
REM // for the mod.
if exist "%prepakhook%" if (%BUILD_USE_PREPAKHOOK%) EQU (1) (
	call tee.bat found pre-pak hook, executing...
	call "%prepakhook%"
	REM // if the pre-pak hook returned a non-zero error code, explode
	if errorlevel 1 (
		call tee.bat pre-pak hook returned a failure code.
		call tee.bat something might have went wrong.
		set iserror=1
		goto :END
	)
	call tee.bat pre-pak hook complete.
)

call tool.makepak.bat
if errorlevel 1 (
	call tee.bat tool.makepak.bat appears to have failed.
	set iserror=1
	goto :END
)

REM // in the event that you need to do special things after the pak is built 
REM // (if you want to rename the pak file, copy it, auto commit it, whatever)
REM // you can use a post-pak hook which will get passed the path to the built pak file.
REM // this hook should be a bat file named "postpakhook.bat" and be located in the root directory 
REM // for the mod.
if exist "%postpakhook%" if (%BUILD_USE_POSTPAKHOOK%) EQU (1) (
	call tee.bat found post-pak hook, executing...
	call "%postpakhook%" "%builddir%\%pakname%"
	REM // if the post-pak hook returned a non-zero error code, explode
	if errorlevel 1 (
		call tee.bat post-pak hook returned a failure code.
		call tee.bat something might have went wrong.
		set iserror=1
		goto :END
	)
	call tee.bat post-pak hook complete.
)

:END

REM // cleanup our vars...
endlocal & (
	set smtkloaded=
	set moddir=
	set pakname=
	set patchbasedir=
	set builddir=
	set srcdir=
	set prepakhook=
	set postpakhook=
	set sbassetsdir=
	set sbtoolsdir=
	set smtklog=

	set HAS_NODE=
	set BUILD_USE_PNGSQUEEZE=
	set BUILD_USE_JSONVALIDATE=
	set BUILD_USE_PATCHBUILDER=
	set BUILD_USE_PREPAKHOOK=
	set BUILD_USE_POSTPAKHOOK=
)
popd

exit /b %iserror%