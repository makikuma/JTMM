@echo off

REM  JTMz

setlocal enableextensions
cd /d %~dp0
if exist jtm\init.cmd pushd . && goto init
if exist ..\jtm\init.cmd pushd .. & goto init
goto :eof

:init
call jtm\init.cmd
title ֹͣ Tomcat �� MySQL ����
call :execute jtm\tomcat_stop.cmd
echo.
call :execute jtm\mysql_stop.cmd
echo.
call :execute jtm\memcached_stop.cmd

:execute
if exist %1 (call %1 && goto :eof) else echo %1 ������. & pause & exit