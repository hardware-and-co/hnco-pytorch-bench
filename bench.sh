#!/bin/bash
set -e
SELF=`readlink -f $0`
DIR=`dirname $SELF`
if [ "$1" == "" ]; then
    NB_THREADS=$((`lscpu | grep "^Processeur(s)" | sed -E "s/.* ([0-9]+)/\1/g"`))
else
    NB_THREADS=$1
fi

cd $DIR

if [ "`cat /proc/cpuinfo | grep GenuineIntel`" != "" ]; then
    source venv-intel/bin/activate
else
    source venv-amd/bin/activate
fi

python3 benchmark/run.py <model> -d cpu -t eval --profile
python3 benchmark/run.py <model> -d cpu -t train --profile

cd -
deactivate
