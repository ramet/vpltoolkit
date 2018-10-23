#!/bin/bash
VPLMODEL="https://github.com/orel33/vplmodel.git"
MODE="RUN"
REPOSITORY="https://github.com/orel33/vplmodel.git"
BRANCH="demo"
EXO="cat"
DEBUG=1
VERBOSE=1
RUNDIR=$(mktemp -d)


[ ! $# -eq 1 ] && echo "⚠ Usage: $0 INPUTDIR" && exit 0
INPUTDIR=$1
[ ! -d "$INPUTDIR" ] && echo "⚠ Directory \"$INPUTDIR\" is missing!" && exit 0
cp -rf $INPUTDIR/* $RUNDIR/

cd $RUNDIR && git clone $VPLMODEL &> /dev/null && cd -
source $RUNDIR/vplmodel/toolkit.sh
START

# explicit run
source $RUNDIR/vplmodel/vpl_execution
