#!/bin/bash

### 0) load vplmodel
source env.sh
source vplmodel/toolkit.sh

[ ! "$RUNDIR" = "$PWD" ] && echo "⚠ RUNDIR is not set correctly!" && exit 0

### prepare & check inputs
cd $RUNDIR
CHECK "inputs/mycat.c"

GRADE=0

### 1) compilation

ECHO "-COMPILATION"

CFLAGS="-std=c99 -Werror"
# CFLAGS="-std=c99 -Wall"
cp inputs/mycat.c $RUNDIR
TRACE "gcc $CFLAGS mycat.c -o mycat"
[ ! $? -eq 0 ] && ECHO "⚠ Compilation failure!" && EXIT
ECHO "✓ Success!" && SCORE 20

### 2) execution

ECHO "-EXECUTION"

echo "abcdef" > mycat.in
cat mycat.in | ./mycat > mycat.out
[ ! $? -eq 0 ] && ECHO "⚠ Execution failure!" && EXIT
diff -q mycat.in mycat.out &> /dev/null
[ ! $? -eq 0 ] && ECHO "⚠ Your program output is invalid!" && EXIT
ECHO "✓ Success!" && SCORE 80
EXIT