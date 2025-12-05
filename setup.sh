#!/bin/bash
set -e
SELF=`readlink -f $0`
DIR=`dirname $SELF`
cd $DIR

if [ ! -d benchmark ]; then
    git clone https://github.com/pytorch/benchmark
fi

if [ "$1" == "nvidia" ]; then
    rm -rf venv-nvidia; true
    virtualenv -p python3.12 venv-nvidia
    source venv-nvidia/bin/activate
    pip3 install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu129
    cd benchmark
    python3 install.py
    deactivate
    cd ..
fi

if [ "$1" == "amd" ]; then
    rm -rf venv-amd; true
    virtualenv -p python3.12 venv-amd
    source venv-amd/bin/activate
    pip3 install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.4
    cd benchmark
    python3 install.py
    deactivate
    cd ..
fi

if [ "$1" == "cpu" ]; then
    rm -rf venv-cpu; true
    virtualenv -p python3.12 venv-cpu
    source venv-cpu/bin/activate
    pip3 install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
    cd benchmark
    python3 install.py
    deactivate
    cd ..
fi
