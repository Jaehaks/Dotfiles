@echo off
REM set EZA_COLOR for date(da)  [you must don't use double quotes]
set EZA_COLORS=da=38;2;90;241;188:*.pdf=38;2;255;100;100:*.pptx=38;2;255;150;100:*.PPTX=38;2;255;150;100:*.PPT=38;2;255;150;100:*.ppt=38;2;255;150;100:*.xlsx=38;2;200;255;200:*.xls=38;2;200;255;200:*.csv=38;2;200;255;200:*.lnk=38;2;255;255;150:
set _ZL_ADD_ONCE=1
set _ZL_MATCH_MODE=1
set _ZL_NO_CHECK=1


doskey ls=ls --color=always $*
doskey ll=eza -al --icons=auto --sort=extension --time-style "+%%Y-%%m-%%d %%H:%%M:%%S" $*
doskey grep=grep -i --color=auto $*
doskey zi=z -I $*
doskey zl=z -l $*
doskey zt=z -t $*
doskey lf=lfcd $*
@echo on
