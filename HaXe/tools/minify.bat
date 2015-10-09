@echo off
setlocal enableDelayedExpansion

echo . THIS TOLL WILL MINIFY ALL JS FILES

set dir=%1

IF NOT EXIST %dir% GOTO END

echo Working on %dir%...

:JS
for /R %%a in (%dir%\*.js) do (
	set k=%%a
	IF /i "!k:~-7!"==".min.js" (
		ECHO .  [  ] SKIPPED %%a
	) ELSE (
		.\tools\jsmin.exe <%%~fa >%%~dpa%%~na.min.js "Rafael Moreira <vipperland@live.com>"
		ECHO .  [OK] MINIFIED %%a
	)
)

:END
::pause