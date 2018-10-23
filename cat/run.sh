#!/bin/bash

### 0) load vplmodel
echo "=> Run \"$EXO\" in mode $MODE with RUNDIR=$RUNDIR..."
source $RUNDIR/vplmodel/vplmodel.sh
source $RUNDIR/vpl_environment.sh

# $RUNDIR <-- you start here
# $RUNDIR/vplmodel/*
# $RUNDIR/GIT/$EXO/*

ECHO "hello world!"

### 1) compilation
ECHO "-COMPILATION"
CFLAGS="-std=c99 -Wall"
gcc $CFLAGS mycat.c -o mycat
[ ! $? -eq 0 ] && ECHO "⚠ Compilation failure!" && exit 0

cp $RUNDIR/GIT/$EXO/solution.c $RUNDIR
gcc $CFLAGS solution.c -o solution
[ ! $? -eq 0 ] && ECHO "⚠ VPL Script Error!" && exit 0

### 2) execution

ECHO "-EXECUTION"

echo "abcdef" | ./mycat > mycat.out
[ ! $? -eq 0 ] && ECHO "⚠ Execution failure!" && exit 0
echo "abcdef" | ./solution > solution.out
[ ! $? -eq 0 ] && ECHO "⚠ VPL Script Error!" && exit 0

diff mycat.out solution.out

