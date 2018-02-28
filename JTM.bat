@echo off

REM  JTMz

setlocal enableextensions
cd /d %~dp0
if exist jtm\init.cmd pushd . && goto init
goto :eof

:init
call jtm\init.cmd
title auto JTMM %version%
goto menu

:menu
cls
echo Tomcat Port: %tomcat_port%
echo MySQL  Port: %mysql_port%
echo memcached  Port: 11211
echo -----------------------------------------------------------------
echo 1  -  启动Tomcat + MySQL + memcached     2  -  停止Tomcat + MySQL +memcached
echo 3  -  启动Tomcat                         4  -  停止Tomcat
echo 5  -  启动MySQL                          6  -  停止MySQL
echo 7  -  设置Tomcat端口                     8  -  设置MySQL端口
echo 9  -  检查端口状态（待完善）             10 -  设置MySQL root密码
echo 11  - 启动memcached                      12  - 停止memcached
echo -----------------------------------------------------------------
set /p input=请选择: 
cls
if "%input%"=="1" call :execute jtm\start.cmd
if "%input%"=="2" call :execute jtm\stop.cmd
if "%input%"=="3" call :execute jtm\tomcat_start.cmd
if "%input%"=="4" call :execute jtm\tomcat_stop.cmd
if "%input%"=="5" call :execute jtm\mysql_start.cmd
if "%input%"=="6" call :execute jtm\mysql_stop.cmd
if "%input%"=="7" call goto change_tomcat_port
if "%input%"=="8" call goto change_mysql_port
if "%input%"=="9" call goto check_port
if "%input%"=="10" call goto change_mysql_root_password
if "%input%"=="11" call :execute jtm\memcached_start.cmd
if "%input%"=="12" call :execute jtm\memcached_stop.cmd
goto end

:change_tomcat_port
cls
set /p new_tomcat_port=请输入 Tomcat 新端口(1-65535): 
if "%new_tomcat_port%"=="" goto change_tomcat_port
set CATALINA_HOME=%jtm_path%\%tomcat_dir%
%java% ChangeTomcatPort "%CATALINA_HOME%" "%new_tomcat_port%"
if errorlevel 1 pause & cls & goto change_tomcat_port
cls
set tomcat_port=%new_tomcat_port%
echo Tomcat 端口修改成功.
pause
sc query |find /i "%tomcat_service_name%" >nul 2>nul
if not errorlevel 1 goto restart_tomcat
goto end

:restart_tomcat
cls
echo 正在重新启动 Tomcat ...
net stop %tomcat_service_name% & net start %tomcat_service_name%
goto end

:change_mysql_port
cls
set /p new_mysql_port=请输入 MySQL 新端口(1-65535): 
if "%new_mysql_port%"=="" goto change_mysql_port
set MYSQL_HOME=%jtm_path%\%mysql_dir%
%java% ChangeMySQLPort "%MYSQL_HOME%" "%new_mysql_port%"
if errorlevel 1 pause & cls & goto change_mysql_port
cls
set mysql_port=%new_mysql_port%
echo MySQL 端口修改成功.
pause
sc query |find /i "%mysql_service_name%" >nul 2>nul
if not errorlevel 1 goto restart_mysql
goto end

:restart_mysql
cls
echo 正在重新启动 MySQL ...
net stop %mysql_service_name% & net start %mysql_service_name%
goto end

:change_mysql_root_password
cls
set /p new_mysql_root_password=请输入 root 新密码: 
if "%new_mysql_root_password%"=="" goto change_mysql_root_password
set jtm_temp=%jtm_path%\jtm\%RANDOM%.%RANDOM%
echo SET PASSWORD FOR 'root'@'localhost' = PASSWORD('%new_mysql_root_password%');>"%jtm_temp%"
if exist "%mysql_dir%\data\%COMPUTERNAME%.pid" net stop %mysql_service_name%
start /b %mysql_dir%\bin\mysqld.exe --defaults-file="%jtm_path%\%mysql_dir%\my.ini" --init-file="%jtm_temp%"
%mysql_dir%\bin\mysqladmin.exe shutdown -uroot -p"%new_mysql_root_password%"
%java% WaitMySQLStop "%COMPUTERNAME%" "%jtm_path%\%mysql_dir%"
echo.>"%jtm_temp%"
del "%jtm_temp%" /Q
net start %mysql_service_name%
cls
echo MySQL root 密码修改成功.
pause
goto end

:check_port
if not exist "jtm\netstat.exe" echo jtm\netstat.exe 不存在. & pause & exit
if not exist "jtm\tasklist.exe" echo jtm\tasklist.exe 不存在. & pause & exit
%java% CheckPort "%jtm_path%\jtm\netstat.exe" "%jtm_path%\jtm\tasklist.exe" "%tomcat_port%"
if not errorlevel 1 echo 端口 %tomcat_port% 未被占用.
%java% CheckPort "%jtm_path%\jtm\netstat.exe" "%jtm_path%\jtm\tasklist.exe" "%mysql_port%"
if not errorlevel 1 echo 端口 %mysql_port% 未被占用.
pause
goto menu

:execute
if exist %1 (call %1 && goto :eof) else echo %1 不存在. & pause & exit

:end
popd