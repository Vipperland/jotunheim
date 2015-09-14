@echo off
setlocal enableDelayedExpansion

echo . THIS TOLL WILL MINIFY ALL JS FILES

IF NOT EXIST ..\bin GOTO END
set dir=..\bin
IF EXIST ..\bin\js (set dir=..\bin\js)
IF EXIST ..\bin\extended (set dir=..\bin\extended)

echo %dir%

:JS
for /R %%a in (%dir%\*.js) do (
	set k=%%a
	IF /i "!k:~-7!"==".min.js" (
		ECHO .  [  ] SKIPPED %%a
	) ELSE (
		jsmin.exe <%%~fa >%%~dpa%%~na.min.js ""
		ECHO .  [OK] MINIFIED %%a
	)
)

:END
pause