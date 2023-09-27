@ECHO OFF
color 05
ECHO Loading CometRP 1.0...
timeout /t 2 /nobreak >nul
ECHO Starting CometRP 1.0...
timeout /t 3 /nobreak >nul
color 07
cls

D:\[Comet]\Comet1.0\server-files\FXServer.exe +exec cfg/server.cfg +set onesync on