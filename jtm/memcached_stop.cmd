@echo off

REM  JTMz

setlocal enableextensions
cd /d %~dp0
if exist jtm\init.cmd pushd . && goto init
if exist ..\jtm\init.cmd pushd .. & goto init
goto :eof

:init
call jtm\init.cmd
title ֹͣ memcached ����
goto check

:check
sc query |find /i "memcached" >nul 2>nul
if not errorlevel 1 (goto stop_memcached_service) else goto memcached_service_not_exist

:memcached_service_not_exist
echo -----------------------------------------------------------------
echo memcached ����δ����
echo -----------------------------------------------------------------
set /p input=�Ƿ����?(Y/N)
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