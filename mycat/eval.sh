#!/bin/bash

### 0) initialization
source env.sh
source vpltoolkit/toolkit.sh
[ ! "$RUNDIR" = "$PWD" ] && echo "⚠ RUNDIR is not set correctly!" && exit 0

CHECKINPUTS
COPYINPUTS
GRADE=0

# CHECK "inputs/mycat.c"
# cp inputs/mycat.c $RUNDIR

### 1) compilation
ECHO "-COMPILATION"
CFLAGS="-std=c99 -Wall"
TRACEV "gcc $CFLAGS mycat.c -o mycat &> warnings"
[ ! $? -eq 0 ] && ECHO "⚠ Compilation failure!" && EXIT
[ -s warnings ] && ECHO "⚠ Compilation warnings!" && SCORE -20
ECHO "✓ Success!" && SCORE 30
ECHO

### 2) execution
ECHO "-EXECUTION"
TRACEV "echo "abcdef" > mycat.in"
TRACEV "cat mycat.in | ./mycat > mycat.out"
[ ! $? -eq 0 ] && ECHO "⚠ Execution failure!" && EXIT
TRACEV "diff -q mycat.in mycat.out"
[ ! $? -eq 0 ] && ECHO "⚠ Your program output is invalid!" && EXIT
ECHO "✓ Success!" && SCORE 70
EXIT