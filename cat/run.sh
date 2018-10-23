#!/bin/bash

echo "=> Run \"$EXO\" in mode $MODE with RUNDIR=$RUNDIR..."

env

### 1) compilation
ECHO "-COMPILATION"
CFLAGS="-std=c99 -Wall"
gcc $CFLAGS cat.c
[ ! $? -eq 0 ] && ECHO "⚠ Compilation failure!" && exit 0

### 2) execution

ECHO "-EXECUTION"
./a.out
