@echo off
doskey ls=ls -al --color=always $*
doskey grep=grep -i --color=always $*
doskey zi=z -I $*
doskey zl=z -l $*
doskey zt=z -t $*
@echo on