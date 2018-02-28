@echo off

REM  JTMz
REM  http://zhurouyoudu.com

setlocal enableextensions
cd /d %~dp0
if exist jtm\init.cmd pushd . && goto init
if exist ..\jtm\init.cmd pushd .. & goto init
goto :eof

:init
call jtm\init.cmd
title ���� MySQL ����
goto check

:check
sc query |find /i "%mysql_service_name%" >nul 2>nul
if not errorlevel 1 (goto mysql_service_exist) else goto start_mysql_service

:mysql_service_exist
echo -----------------------------------------------------------------
echo MySQL �����Ѿ�����
echo -----------------------------------------------------------------
set /p input=�Ƿ����?(Y/N)
if /i "%input%"=="y" goto start_mysql_service
echo.
goto end

:start_mysql_service
echo Starting MySQL, please wait ...
if not exist "jtm\netstat.exe" echo jtm\netstat.exe ������. & pause 
if not exist "jtm\tasklist.exe" echo jtm\tasklist.exe ������. & pause 
%java% CheckPort "%jtm_path%\jtm\netstat.exe" "%jtm_path%\jtm\tasklist.exe" "%mysql_port%"
if errorlevel 1 pause & echo. & goto end
%mysql_dir%\bin\mysqld.exe --install %mysql_service_name% --defaults-file="%jtm_path%\%mysql_dir%\my.ini"
net start %mysql_service_name%
echo.
goto end

:end
popd