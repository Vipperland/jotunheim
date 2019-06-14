@echo off

echo . 
echo . 
echo .  THIS TOOL WILL MINIFY ALL JS FILES
echo . 
echo . 

call ..\tools\minify bin\jotun
call ..\tools\minify bin\jotun\plugins

echo . 
echo . 
echo .  DONE!
echo . 
echo . 

pause
