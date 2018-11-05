#!/bin/bash

### initialization
source env.sh
source vpltoolkit/toolkit.sh
[ ! "$RUNDIR" = "$PWD" ] && echo "⚠ RUNDIR is not set correctly!" && exit 0
CHECKINPUTS
cp inputs/mycat.c .
GRADE=0

### compilation
TITLE "COMPILATION"
CFLAGS="-std=c99 -Wall"
WFLAGS="-Wl,--wrap=system"
TRACE "gcc $CFLAGS $WFLAGS mycat.c -o mycat |& tee warnings"
[ $? -ne 0 ] && MALUS "Compilation" X "errors"
[ -s warnings ] && MALUS "Compilation" 20 "warnings"
[ -x mycat ] && BONUS "Linking" 30

### execution
TITLE "EXECUTION"
TRACE "echo \"abcdef\" > mycat.in"
TRACE "cat mycat.in | ./mycat > mycat.out"
[ $? -ne 0 ] && MALUS "Return" 10 "bad status"
TRACE "diff -q mycat.in mycat.out"
EVAL "Program output" 70 0 "valid" "invalid"
EXIT