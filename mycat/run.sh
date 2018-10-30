#!/bin/bash

### 0) initialization
source env.sh
source vpltoolkit/toolkit.sh
[ ! "$RUNDIR" = "$PWD" ] && echo "⚠ RUNDIR is not set correctly!" && exit 0

CHECKINPUTS
COPYINPUTS

### 1) compilation
echo "-COMPILATION"
CFLAGS="-std=c99 -Wall"
TRACE "gcc $CFLAGS mycat.c -o mycat"
[ ! $? -eq 0 ] && echo "⚠ Compilation failure!" && exit 0

### 2) execution
echo "-EXECUTION"
TRACE "echo "abcdef" > mycat.in && cat mycat.in"
TRACE "cat mycat.in | ./mycat | tee mycat.out"
TRACE "diff -q mycat.in mycat.out"
[ ! $? -eq 0 ] && echo "⚠ Your program output is invalid!" && exit 0