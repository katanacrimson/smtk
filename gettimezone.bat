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

if (%utcoffset%) NEQ () (
	goto :OUT
)
for /f "Tokens=3" %%G in ('reg query HKLM\System\CurrentControlSet\Control\TimeZoneInformation /V ActiveTimeBias^|find "REG_DWORD"') do (
	set /a _utcoffset=%%G
)
set /a _utcoffset=(%_utcoffset% / 60) * -1

endlocal & (
	if %_utcoffset% GTR 0 (
		set utcoffset=UTC+%_utcoffset%
	) else if %_utcoffset% LSS 0 (
		set utcoffset=UTC%_utcoffset%
	) else (
		set utcoffset=UTC
	)
)

:OUT
echo %utcoffset%
