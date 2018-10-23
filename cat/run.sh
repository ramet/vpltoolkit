#!/bin/bash

### 0) load vplmodel
echo "=> Run \"$EXO\" in mode $MODE with RUNDIR=$RUNDIR..."
source $RUNDIR/vplmodel/toolkit.sh
# source $RUNDIR/vpl_environment.sh

# $RUNDIR <-- you start here
# $RUNDIR/vplmodel/*
# $RUNDIR/GIT/$EXO/*

# ECHO "hello world!"

# if eval $TEST ; then
#     [ ! -z "$MSGOK" ] && ECHO "✓ $MSGOK [+$BONUS]"
#     GRADE=$((GRADE+BONUS))
#     eval $CMDOK
# else
#     [ ! -z "$MSGKO" ] && ECHO "⚠ $MSGKO [-$MALUS]"
#     GRADE=$((GRADE-MALUS))
#     eval $CMDKO
# fi

### check inputs
CHECK "mycat.c"
GRADE=0


### 1) compilation
ECHO "-COMPILATION"
CFLAGS="-std=c99 -Wall"
TRACE "gcc $CFLAGS mycat.c -o mycat"
[ ! $? -eq 0 ] && ECHO "⚠ Compilation failure!" && exit 0

TRACE "cp $RUNDIR/GIT/$EXO/solution.c $RUNDIR && gcc $CFLAGS solution.c -o solution"
[ ! $? -eq 0 ] && ECHO "⚠ VPL Script Error!" && exit 0

### 2) execution

ECHO "-EXECUTION"

echo "abcdef" | ./mycat > mycat.out
[ ! $? -eq 0 ] && ECHO "⚠ Execution failure!" && exit 0
echo "abcdef" | ./solution > solution.out
[ ! $? -eq 0 ] && ECHO "⚠ VPL Script Error!" && exit 0

TRACE "diff -q mycat.out solution.out"
[ ! $? -eq 0 ] && ECHO "⚠ Your program is invalid!" && exit 0

ECHO "✓ Success!"
BONUS=100
GRADE=$((GRADE+BONUS))
EXIT