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

git clone https://github.com/pytorch/benchmark

rm -rf venv-intel; true
virtualenv -p python3 venv-intel
source venv-intel/bin/activate
pip3 install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu121
cd benchmark
python3 install.py
deactivate
cd ..

rm -rf venv-amd; true
virtualenv -p python3 venv-amd
source venv-amd/bin/activate
pip3 install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/rocm6.2.4
git clone https://github.com/pytorch/benchmark
cd benchmark
python3 install.py
deactivate
cd ..
