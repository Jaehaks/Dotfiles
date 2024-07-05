@echo off
doskey ls=ls --color=always $*
doskey ll=ls -al --color=always $*
doskey grep=grep -i --color=always $*
doskey zi=z -I $*
doskey zl=z -l $*
doskey zt=z -t $*
doskey lf=lfcd $*
@echo on
