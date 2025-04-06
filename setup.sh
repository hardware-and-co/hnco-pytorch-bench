#!/bin/bash
set -e
SELF=`readlink -f $0`
DIR=`dirname $SELF`
if [ "$1" == "" ]; then
    NB_THREADS=$((`nproc`))
else
    NB_THREADS=$1
fi
cd $DIR

if [ ! -d benchmark ]; then
    git clone https://github.com/pytorch/benchmark
fi

#rm -rf venv-nvidia; true
#virtualenv -p python3.12 venv-intel
#source venv-intel/bin/activate
#pip3 install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu129
#cd benchmark
#python3 install.py
#deactivate
#cd ..
#
#rm -rf venv-amd; true
#virtualenv -p python3.12 venv-amd
#source venv-amd/bin/activate
#pip3 install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.4
#cd benchmark
#python3 install.py
#deactivate
#cd ..

rm -rf venv-cpu; true
virtualenv -p python3.12 venv-cpu
source venv-cpu/bin/activate
pip3 install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
cd benchmark
python3 install.py
deactivate
cd ..
