@echo off

REM  JTMz

setlocal enableextensions
cd /d %~dp0
if exist jtm\init.cmd pushd . && goto init
if exist ..\jtm\init.cmd pushd .. & goto init
goto :eof

:init
call jtm\init.cmd
title ֹͣ MySQL ����
goto check

:check
sc query |find /i "%mysql_service_name%" >nul 2>nul
if not errorlevel 1 (goto stop_mysql_service) else goto mysql_service_not_exist

:mysql_service_not_exist
echo -----------------------------------------------------------------
echo MySQL ����δ����
echo -----------------------------------------------------------------
set /p input=�Ƿ����?(Y/N)
if /i "%input%"=="y" goto stop_mysql_service
echo.
goto end

:stop_mysql_service
echo Shutting down MySQL, please wait ...
net stop %mysql_service_name%
%mysql_dir%\bin\mysqld.exe --remove %mysql_service_name%
echo.
goto end

:end
popd