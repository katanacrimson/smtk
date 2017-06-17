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
set iserror=0
set sbtoolsdir=
set packerexe=asset_packer.exe
set rootdir=%~dp0
set temp=

REM todos:
REM  - support 32bit GOG install
REM  - support Starbound Unstable via Steam

REM /**
REM  *
REM  * Rough flow should be like this:
REM  *  - find asset_packer.exe
REM  *     - check STARBOUND_PATH
REM  *     - then check system PATH
REM  *     - look for a Steam-based Starbound installation in Windows registry, then check there
REM  *     - look for a GOG-based Starbound installation, then check there
REM  *     - bail out and fail if not found
REM  *
REM  */

echo looking for asset_packer.exe...
REM // while most users will *not* have the STARBOUND_PATH env var defined, we'll still check it first.
REM // relying on it first it allows the end user to dictate where we should look in the event 
REM // that there's multiple installations.
REM // this can be extremely useful if developing for an unstable version, older version, etc.
if "%sbtoolsdir%" == "" ( call :CHECK_STARBOUND_PATH )
if "%sbtoolsdir%" == "" ( call :CHECK_PATH )
if "%sbtoolsdir%" == "" ( call :CHECK_STEAM )
if "%sbtoolsdir%" == "" ( call :CHECK_GOG )

REM // FAIL!
if "%sbtoolsdir%" == "" (
	goto :NO_TOOLS_FOUND
) else (
	goto :RETURN_RESULT
)
REM // in the event that reality decides to pull a fast one on us, make sure we exit.
goto :END
exit %iserror%

:CHECK_STARBOUND_PATH
REM // we'll try seeing if the %STARBOUND_PATH% env variable is even set. if so, we're in luck.
echo checking STARBOUND_PATH for asset_packer...
if defined STARBOUND_PATH (
	if exist "%STARBOUND_PATH%\%packerexe%" (
		echo found asset_packer via STARBOUND_PATH.
		set sbtoolsdir=%STARBOUND_PATH%
		exit /b
	)
	if exist "%STARBOUND_PATH%\win32\%packerexe%" (
		echo found asset_packer via STARBOUND_PATH.
		set sbtoolsdir=%STARBOUND_PATH%\win32
		exit /b
	)

	echo found STARBOUND_PATH env var, but could not find asset_packer.exe (wat?!)
	echo please verify that you're pointing STARBOUND_PATH to the correct location.
	echo now looking elsewhere...
) else (
	echo STARBOUND_PATH env var not set. looking elsewhere...
)

exit /b

:CHECK_PATH
REM // determine if asset_packer is in $PATH
echo checking system PATH for asset_packer...
for /f %%i in ('where %packerexe% 2^>nul') do set temp=%%i
REM @where /q %packerexe%
if errorlevel 0 (
	echo found asset_packer via system PATH.
	for %%F in ("%temp%") do set temp=%%~dpF
	set sbtoolsdir=!temp:~0,-1!
	exit /b
) else (
	set sbtoolsdir=
	echo asset_packer not in system PATH, looking elsewhere...
)

exit /b

:CHECK_STEAM
REM // we need to get the Steam installation directory for Starbound if it's installed from there.
REM // @note: 211820 is the SteamApp ID for Starbound.
echo checking for Steam installation of Starbound...
set steam_install=
@for /f "tokens=1,2*" %%A in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 211820" /v InstallLocation 2^>nul') do @if %%A==InstallLocation set steam_install=%%C
if not "%steam_install%" == "" (
	REM // it's installed via steam! let's make a sanity check that the asset_packer is there, though.
	REM // (this first case shouldn't happen - but let's just check anyways)
	if exist "%steam_install%\%packerexe%" (
		echo found asset_packer in Starbound Steam install directory.
		set sbtoolsdir=%steam_install%
		exit /b
	)
	if exist "%steam_install%\win32\%packerexe%" (
		echo found asset_packer in Starbound Steam install directory.
		set sbtoolsdir=%steam_install%\win32
		exit /b
	)

	echo found Starbound Steam installation location, but could not find asset_packer.exe (wat?!)
	echo please verify that the Starbound Steam installation is not corrupt or outdated.
	echo now looking elsewhere...
) else (
	echo could not locate a Steam install of Starbound, looking elsewhere...
)

exit /b

:CHECK_GOG
REM // we need to get the GOG installation directory for Starbound if it's installed from there.
REM // @note: 1452598881 is the GOG gameID for Starbound.
REM // @todo: adapt for a 32bit system?
echo checking for gog installation of Starbound...
set gog_install=
@for /f "tokens=1,2*" %%A in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\GOG.com\Games\1452598881" /v PATH 2^>nul') do @if %%A==PATH set gog_install=%%C
if not "%gog_install%" == "" (
	REM // it's installed via GOG! let's make a sanity check that the asset_packer is there, though.
	REM // (this first case shouldn't happen - but let's just check anyways)
	if exist "%gog_install%\%packerexe%" (
		echo found asset_packer in Starbound GOG install directory.
		set sbtoolsdir=%gog_install%
		exit /b
	)
	if exist "%gog_install%\win32\%packerexe%" (
		echo found asset_packer in Starbound GOG install directory.
		set sbtoolsdir=%gog_install%\win32
		exit /b
	)

	echo found Starbound GOG installation location, but could not find asset_packer?!
	echo please verify that the Starbound GOG installation is not corrupt or outdated.
	echo now looking elsewhere...
) else (
	echo could not locate a GOG install of Starbound, looking elsewhere...
)

exit /b

:NO_TOOLS_FOUND
REM // welp. no packer found...we're doomed.
echo could not find the Starbound asset_packer.exe executable.
echo please ensure Starbound is installed, and if so, try setting the 
echo STARBOUND_PATH env variable to the root directory of your Starbound installation.
set iserror=1
goto END

:RETURN_RESULT

REM // quick sanity check...
if "%sbtoolsdir%" == "" (
	goto NO_PACKER_FOUND
)

echo found tools at: %sbtoolsdir%
endlocal & (
	set _sbtoolsdir=%sbtoolsdir%
)
goto :END

:END
exit /b %iserror%