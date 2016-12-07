@echo off

call .\tools\minify bin\sirius
call .\tools\minify bin\sirius\plugins

explorer "http://127.0.0.11/"