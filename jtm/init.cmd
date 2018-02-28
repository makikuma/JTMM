@echo off

REM  JTMz

for /d %%d in (*) do (
 if exist %%d\bin\java.exe set jdk_dir=%%d
 if exist %%d\bin\tomcat7.exe set tomcat_dir=%%d
 if exist %%d\bin\mysqld.exe set mysql_dir=%%d
 if exist %%d\memcached.exe set memcached_dir=%%d
)
if "%jdk_dir%"=="" echo JDK does not exist. & pause 
if "%tomcat_dir%"=="" echo Tomcat does not exist. & pause 
if "%mysql_dir%"=="" echo MySQL does not exist & pause 
if "%memcached_dir%"=="" echo memcached does not exist & pause 

set jtm_path=%cd%
set class_path=.;%jtm_path%\%jdk_dir%\lib;%jtm_path%\%jdk_dir%\lib\tools.jar;%jtm_path%\jtm\jtm.jar
set java="%jtm_path%\%jdk_dir%\bin\java.exe" -classpath "%class_path%"

%java% CheckPath "%jtm_path%"

if errorlevel 1 echo. & pause 

%java% WriteConfig "%jtm_path%\jtm\config.cmd" "%jtm_path%\%tomcat_dir%" "%jtm_path%\%mysql_dir%"

if exist jtm\config.cmd (call jtm\config.cmd && goto :eof) else echo jtm\config.cmd ²»´æÔÚ.