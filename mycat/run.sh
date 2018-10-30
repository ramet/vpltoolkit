#!/bin/bash

### 0) initialization
source env.sh
source vpltoolkit/toolkit.sh
[ ! "$RUNDIR" = "$PWD" ] && echo "⚠ RUNDIR is not set correctly!" && exit 0

CHECKINPUTS
COPYINPUTS

# CHECK "inputs/mycat.c"
# cp inputs/mycat.c $RUNDIR

### 1) compilation
ECHO "-COMPILATION"
CFLAGS="-std=c99 -Wall"
TRACE "gcc $CFLAGS mycat.c -o mycat"
[ ! $? -eq 0 ] && ECHO "⚠ Compilation failure!" && EXIT

### 2) execution
ECHO "-EXECUTION"
TRACE "echo "abcdef" > mycat.in && cat mycat.in"
TRACE "cat mycat.in | ./mycat tee mycat.out"
TRACE "diff -q mycat.in mycat.out"
[ ! $? -eq 0 ] && ECHO "⚠ Your program output is invalid!" && EXIT