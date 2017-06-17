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
set templogfile=%dirname%\.temp.jsonvalidate.log
pushd %dirname%

if (%smtkloaded%) NEQ (1) if (%moddir%) EQU () (
	echo tool.jsonvalidate.bat requires mod directory via argv if SMTk has not been already loaded. exiting...
	set iserror=1
	goto :END
) else if (%smtkloaded%) NEQ (1) (
	call configure.bat !argv!
	if errorlevel 1 (
		REM echo ERROR: Failed to init - configure.bat errored out.
		REM // this seems to barf if configure.bat doesn't find a config file on install...commented for now.
		set iserror=1
		goto :END
	)
)

if (%HAS_NODE%) NEQ (1) (
	call tee.bat : ERROR: node modules not installed - please cd into %dirname% and run "npm install".
	call tee.bat :   you may need to run "npm install --global --production windows-build-tools" as admin first.
	call tee.bat : this node-dependent utility is currently disabled.
	set iserror=1
	goto :END
)

call tee.bat : calling node.jsonvalidate.js to validate JSON files...
node.exe %dirname%\node.jsonvalidate.js > "%templogfile%" 2>&1
if errorlevel 1 (
	set iserror=1
)
for /f "tokens=*" %%i in (%templogfile%) do (
	call tee.bat : [jsonvalidate] %%i
)
del "%templogfile%"

if %iserror% EQU 1 (
	call tee.bat : node.jsonvalidate.js appears to have failed. exiting...
	goto :END
) else (
	call tee.bat : JSON files validated successfully.
)

goto :END

:END
popd
exit /b %iserror%