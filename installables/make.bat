@echo off
setlocal enabledelayedexpansion enableextensions
call _smtkpath.bat
call "%smtkpath%\smtk.bat" %cd%
endlocal & ( set smtkpath= )
pause