@echo off

setlocal enableDelayedExpansion

set dir=%1
set skip=0

IF NOT EXIST %dir% GOTO SCRIPT_END

:SCRIPT_START
for /R %%a in (%dir%\*.js) do (
	set k=%%a
	IF /i "!k:~-7!"==".min.js" (
		::ECHO .  [  ] SKIPPED %%a
		set skip=0
	) ELSE (
		jsmin.exe <%%~fa >%%~dpa%%~na.min.js "Rafael Moreira <vipperland@live.com>"
		ECHO .  [OK] MINIFIED %%a
	)
)

GOTO SCRIPT_VOID

:SCRIPT_END
pause


:SCRIPT_VOID