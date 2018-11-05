#!/bin/bash

### init
source env.sh
source vpltoolkit/toolkit.sh
[ ! "$RUNDIR" = "$PWD" ] && echo "⚠ RUNDIR is not set correctly!" && exit 0
CHECKINPUTS
cp inputs/mycat.c .

### run
CFLAGS="-std=c99 -Wall"
RTRACE "gcc $CFLAGS mycat.c -o mycat"
[ ! $? -eq 0 ] && RMALUS "Compilation" && exit 0
RTRACE "echo \"abcdef\" > mycat.in && cat mycat.in"
RTRACE "cat mycat.in | ./mycat | tee mycat.out"
RTRACE "diff mycat.in mycat.out"
REVAL "Program output" "valid" "invalid"
