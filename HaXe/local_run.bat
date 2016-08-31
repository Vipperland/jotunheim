@echo off

echo . 
echo . 
echo .  THIS TOLL WILL MINIFY ALL JS FILES
echo . 
echo . 

call .\tools\minify bin\sirius
call .\tools\minify bin\sirius\plugins

echo . 
echo . 
echo .  DONE!
echo . 
echo . 

pause