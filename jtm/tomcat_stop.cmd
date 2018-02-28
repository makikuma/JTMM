@echo off

REM  JTMz

setlocal enableextensions
cd /d %~dp0
if exist jtm\init.cmd pushd . && goto init
if exist ..\jtm\init.cmd pushd .. & goto init
goto :eof

:init
call jtm\init.cmd
title ֹͣ Tomcat ����
goto check

:check
sc query |find /i "%tomcat_service_name%" >nul 2>nul
if not errorlevel 1 (goto stop_tomcat_service) else goto tomcat_service_not_exist

:tomcat_service_not_exist
echo -----------------------------------------------------------------
echo Tomcat ����δ����
echo -----------------------------------------------------------------
set /p input=�Ƿ����?(Y/N)
if /i "%input%"=="y" goto stop_tomcat_service
echo.
goto end

:stop_tomcat_service
echo Shutting down Tomcat, please wait ...
pushd %tomcat_dir%
net stop %tomcat_service_name%
bin\service.bat remove %tomcat_service_name%
popd
echo.
goto end

:end
popd