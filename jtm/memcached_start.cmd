@echo off

REM  JTMz

setlocal enableextensions
cd /d %~dp0
if exist jtm\init.cmd pushd . && goto init
if exist ..\jtm\init.cmd pushd .. & goto init
goto :eof

:init
call jtm\init.cmd
title 启动 memcached 服务
goto check

:check
sc query |find /i "memcached" >nul 2>nul
if not errorlevel 1 (goto memcached_service_exist) else goto start_memcached_service

:memcached_service_exist
echo -----------------------------------------------------------------
echo memcached 服务已经启动
echo -----------------------------------------------------------------
set /p input=是否继续?(Y/N)
if /i "%input%"=="y" goto start_memcached_service
echo.
goto end

:start_memcached_service
echo Starting memcached, please wait ...
if not exist "jtm\netstat.exe" echo jtm\netstat.exe 不存在. & pause & exit
if not exist "jtm\tasklist.exe" echo jtm\tasklist.exe 不存在. & pause & exit
%memcached_dir%\memcached.exe -d install & net start memcached
echo.
goto end

:end
pause