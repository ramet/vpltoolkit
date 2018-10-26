#!/bin/bash

### 0) load vplmodel
source env.sh
source vplmodel/toolkit.sh

[ "$RUNDIR" = "$PWD" ] && echo "⚠ RUNDIR is not correctly set!" && exit 0

echo "=> Run \"$EXO\" in mode $MODE with RUNDIR=$RUNDIR..."

### prepare & check inputs
cd $RUNDIR
CHECK "inputs/mycat.c"

GRADE=0

### 1) compilation
ECHO "-COMPILATION"
CFLAGS="-std=c99 -Werror"
cp inputs/mycat.c $RUNDIR
TRACE "gcc $CFLAGS mycat.c -o mycat"
[ ! $? -eq 0 ] && ECHO "⚠ Compilation failure!" && EXIT
ECHO "✓ Success!"

CFLAGS="-std=c99 -Wall"
gcc $CFLAGS solution.c -o solution
[ ! $? -eq 0 ] && ECHO "⚠ Oups... VPL Script Error!" && exit 0

### 2) execution

ECHO "-EXECUTION"

echo "abcdef" > mycat.in

cat mycat.in | ./mycat > mycat.out
[ ! $? -eq 0 ] && ECHO "⚠ Execution failure!" && EXIT

cat mycat.in | ./solution > solution.out 2> /dev/null
[ ! $? -eq 0 ] && ECHO "⚠ Oups... VPL Script Error!" && exit 0

diff -q mycat.out solution.out &> /dev/null
[ ! $? -eq 0 ] && ECHO "⚠ Your program is invalid!" && EXIT
ECHO "✓ Success!"

### Grade

BONUS=100
GRADE=$((GRADE+BONUS))
EXIT