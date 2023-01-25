@echo off

PowerShell.exe -NoProfile -ExecutionPolicy ByPass -File %~dp0modules\%~n0.ps1 %*
