@echo off

call .\tools\minify bin\jotun
call .\tools\minify bin\jotun\plugins

explorer "https://jotunheim.dev.localhost/"
pause;