#!/bin/bash
set -e
SELF=`readlink -f $0`
DIR=`dirname $SELF`
if [ "$1" == "" ]; then
    NB_THREADS=$((`nproc`))
else
    NB_THREADS=$1
fi

# usage: ./bench.sh <nb_thread> (train|eval) <model_name>

case "$2" in
  train)
    step="training"
    ;;
  eval)
    step="inference"
    ;;
  *)
    echo "Error: Invalid mode '$2'. Expected 'train' or 'eval'."
    exit 1
    ;;
esac

cd $DIR

source venv-cpu/bin/activate

batch="--bs 32"
python3 benchmark/run.py ${3} -d cpu -t ${2} ${batch} > /tmp/pytorch.log
cat /tmp/pytorch.log | sed "s/^/${3} [$step]: /g" 1>&2

cd -
deactivate
