#!/bin/bash
set -e
SELF=`readlink -f $0`
DIR=`dirname $SELF`
if [ "$1" == "" ]; then
    NB_THREADS=$((`nproc`))
else
    NB_THREADS=$1
fi

MODELS=("BERT_pytorch" "resnet50" "mobilenet_v3_large" "yolov3" "llama")

cd $DIR

source venv-cpu/bin/activate

for model in ${MODELS[@]}; do
    batch="--bs 32"
    python3 benchmark/run.py ${model} -d cpu -t train ${batch} > /tmp/pytorch.log
    cat /tmp/pytorch.log | sed "s/^/$model [training]: /g" 1>&2
    python3 benchmark/run.py ${model} -d cpu -t eval ${batch} > /tmp/pytorch.log
    cat /tmp/pytorch.log | sed "s/^/$model [inference]: /g" 1>&2
done

cd -
deactivate
