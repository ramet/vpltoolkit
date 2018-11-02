#!/bin/bash

### 0) initialization
source env.sh
source vpltoolkit/toolkit.sh
[ ! "$RUNDIR" = "$PWD" ] && echo "⚠ RUNDIR is not set correctly!" && exit 0
CHECKINPUTS
COPYINPUTS
GRADE=0

### compilation
TITLE "COMPILATION"
CFLAGS="-std=c99 -Wall"
TRACE "gcc $CFLAGS mycat.c -o mycat &> warnings"
[ $? -ne 0 ] && FAILURE "Compilation" X "errors"
[ -s warnings ] && FAILURE "Compilation" 20 "warnings"
[ -x mycat ] && SUCCESS "Linking" 30

### execution
TITLE "EXECUTION"
TRACE "echo \"abcdef\" > mycat.in"
TRACE "cat mycat.in | ./mycat > mycat.out"
[ $? -ne 0 ] && FAILURE "Return" 10 "bad status"
TRACE "diff -q mycat.in mycat.out"
EVAL "Program output" 70 0 "valid" "invalid"
EXIT