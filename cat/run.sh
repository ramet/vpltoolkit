#!/bin/bash

### 0) load vplmodel
echo "=> Run \"$EXO\" in mode $MODE with RUNDIR=$RUNDIR..."
source $RUNDIR/vplmodel/vplmodel.sh
ECHO "hello world!"

env | grep VPL
pwd
ls
cat vpl_environment.sh

### 1) compilation
ECHO "-COMPILATION"
CFLAGS="-std=c99 -Wall"
gcc $CFLAGS cat.c
[ ! $? -eq 0 ] && ECHO "⚠ Compilation failure!" && exit 0

### 2) execution

ECHO "-EXECUTION"
./a.out
