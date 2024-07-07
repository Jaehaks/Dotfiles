@echo off
doskey ls=ls --color=always $*
REM doskey ll=ls -al --color=always $*
doskey ll=eza -al --icons=auto --sort=extension --time-style "+%%Y-%%m-%%d %%H:%%M:%%S" $*
doskey grep=grep -i --color=auto $*
doskey zi=z -I $*
doskey zl=z -l $*
doskey zt=z -t $*
doskey lf=lfcd $*
@echo on
