#!/bin/bash

# default parameters
TIMEOUT=10
RUNDIR=$(mktemp -d)

LOCALDIR=""
REPOSITORY=""
URL=""

SUBDIR=""
INPUTDIR=""
VERBOSE="0"
GRAPHIC=0
MODE="RUN"
DOCKER="orel33/mydebian:latest"
DOCKERTIMEOUT="infinity" # default 900s
VPLTOOLKIT="https://github.com/orel33/vpltoolkit.git"
VERSION="master"    # VPL Toolkit branch
DOWNLOAD=0

### USAGE ###

USAGE() {
    echo "Usage: $0 <download> [options] <...>"
    echo "Start VPL Toolkit on localhost."
    echo "<download>"
    echo "    -l <localdir>: copy teacher files from local directory into <rundir>"
    echo "    -r <repository>: download teacher files from remote git repository"
    echo "    -w <url>: download teacher files from remote web site (not yet available)"
    echo "[options]:"
    echo "    -m <mode>: set execution mode to RUN, DEBUG or EVAL (default $MODE)"
    echo "    -g : enable graphic mode (default no)"
    echo "    -d <docker> : set docker image to be used (default $DOCKER)"
    echo "    -n <version> : set the branch/version of VPL Toolkit to use (default $VERSION)"
    echo "    -s <subdir>: copy files from repository/subdir into <rundir>"
    echo "    -i <inputdir>: student input directory"
    echo "    -v: enable verbose (default no)"
    echo "    -h: help"
    echo "<...>: extra arguments passed to START routine in VPL Toolkit"
    exit 0
}

### PARSE ARGUMENTS ###

GETARGS() {
    while getopts "gr:l:s:i:m:d:n:vh" OPT ; do
        case $OPT in
            g)
                GRAPHIC=1
            ;;
            d)
                DOCKER="$OPTARG"
            ;;
            m)
                grep -w $OPTARG <<< "RUN DEBUG EVAL" &> /dev/null
                [ $? -ne 0 ] && echo "⚠ Error: Invalid option \"-m $OPTARG\"" >&2 && USAGE
                MODE="$OPTARG"
            ;;
            n   )
                VERSION="$OPTARG"
            ;;
            l)
                ((DOWNLOAD++))
                LOCALDIR="$OPTARG"
            ;;
            r)
                ((DOWNLOAD++))
                REPOSITORY="$OPTARG"
            ;;
            w)
                ((DOWNLOAD++))
                URL="$OPTARG"
            ;;
            s)
                SUBDIR="$OPTARG"
            ;;
            i)
                INPUTDIR="$OPTARG"
            ;;
            v)
                VERBOSE=1
            ;;
            h)
                USAGE
            ;;
            \?)
                USAGE
            ;;
        esac
    done

    [ $DOWNLOAD -eq 0 ] && echo "⚠ Error: no download method selected!" >&2 && USAGE
    [ $DOWNLOAD -gt 1 ] && echo "⚠ Error: select only one download method!" >&2 && USAGE
    shift $((OPTIND-1))
    ARGS="$@"
}

############################################################################################
#                                           LOCAL RUN                                      #
############################################################################################

GETARGS $*

if [ $VERBOSE -eq 1 ] ; then
    echo "VPLTOOLKIT=$VPLTOOLKIT"
    echo "VERSION=$VERSION"
    echo "RUNDIR=$RUNDIR"
    echo "LOCALDIR=$LOCALDIR"
    echo "REPOSITORY=$REPOSITORY"
    echo "URL=$URL"
    echo "SUBDIR=$SUBDIR"
    echo "INPUTDIR=$INPUTDIR"
    echo "ARGS=$ARGS"
    echo "DOCKER=$DOCKER"
    echo "GRAPHIC=$GRAPHIC"
fi

### PULL DOCKER IMAGE ###

LOG="$RUNDIR/start.log"

if [ -n $DOCKER ] ; then 
    ( timeout $TIMEOUT docker pull $DOCKER ) &>> $LOG
    [ $? -ne 0 ] && echo "⚠ Error: Docker fails to pull image \"$DOCKER\"!" >&2 && exit 1
fi

### DOWNLOAD VPL TOOLKIT ###

( cd $RUNDIR && timeout $TIMEOUT git clone "$VPLTOOLKIT" --depth 1 -b "$VERSION" --single-branch ) &>> $LOG
[ $? -ne 0 ] && echo "⚠ Error: Git fails to clone \"$VPLTOOLKIT\" (branch $VERSION)!"  >&2 && exit 1
source $RUNDIR/vpltoolkit/start.sh

### LOCAL ###

if [ -n "$LOCALDIR" ] ; then
    [ -n "$SUBDIR" ] && SRCDIR="$LOCALDIR/$SUBDIR"
    [ ! -d $SRCDIR ] && echo "⚠ Error: invalid path \"$SRCDIR\"!"  >&2 && exit 1
    cp -rf $SRCDIR/* $RUNDIR/ &>> $LOG
fi

### REPOSITORY ###

if [ -n "$REPOSITORY" ] ; then
    BRANCH="master"
    DOWNLOAD "$REPOSITORY" "$BRANCH" "$SUBDIR"
fi

### WEB ###

# TODO: wget from URL

### START ###

START_OFFLINE "$INPUTDIR" $ARGS

# EOF