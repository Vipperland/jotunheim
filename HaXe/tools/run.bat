@echo off

call .\tools\minify bin\sirius
call .\tools\minify bin\sirius\plugins

explorer "http://localhost:2000/index.html"