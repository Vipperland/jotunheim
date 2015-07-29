@echo off
setlocal enableDelayedExpansion

echo . THIS TOLL WILL MINIFY ALL JS FILES

IF NOT EXIST ..\bin GOTO END

:JS
for /R %%a in (..\bin\*.js) do (
	set k=%%a
	IF /i "!k:~-7!"==".min.js" (
		ECHO .  [  ] SKIPPED  %%a
	) ELSE (
		jsmin.exe <%%~fa >%%~dpa%%~na.min.js ""
		ECHO .  [OK] MINIFIED %%a
	)
)

:END
pause