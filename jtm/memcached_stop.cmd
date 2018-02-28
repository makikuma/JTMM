@echo off

REM  JTMz

setlocal enableextensions
cd /d %~dp0
if exist jtm\init.cmd pushd . && goto init
if exist ..\jtm\init.cmd pushd .. & goto init
goto :eof

:init
call jtm\init.cmd
title 停止 memcached 服务
goto check

:check
sc query |find /i "memcached" >nul 2>nul
if not errorlevel 1 (goto stop_memcached_service) else goto memcached_service_not_exist

:memcached_service_not_exist
echo -----------------------------------------------------------------
echo memcached 服务未启动
echo -----------------------------------------------------------------
set /p input=是否继续?(Y/N)
if /i "%input%"=="y" goto stop_memcached_service
echo.
goto end

:stop_memcached_service
echo Shutting down memcached, please wait ...
net stop memcached
sc delete memcached
echo.
goto end

:end
pause
exit