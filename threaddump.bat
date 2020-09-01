@echo off

REM ####################
REM setting
REM ####################

set jdk_home=C:\Program Files\Java\jdk1.8.0_222
set waits=5
set times=5
set pid=10736
REM set pstools_dir=C:\app\PSTools

REM ####################
REM processing
REM ####################

set log_dir=%~dp0\log
set path=%jdk_home%\bin;%pstools_dir%;%path%

for /l %%n in (1,1,%times%) do (
  set time_tmp=%time: =0%
	set now=%date:/=%%time_tmp:~0,2%%time_tmp:~3,2%%time_tmp:~6,2%
	jstack.exe %pid% > %log_dir%\threaddump.%now%.log 2> %log_dir%\threaddump.%now%.err.log
	REM psexec -accepteula cmd /c "jstack.exe %pid% > %log_dir%\threaddump.%now%.log 2> %log_dir%\threaddump.%now%.err.log"
  timeout %waits%
)

exit