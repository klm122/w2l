Bootstrap: docker
From: nvidia/cuda:9.1-cudnn7-devel-ubuntu16.04
%environment
export APT_INSTALL="apt-get install -y --no-install-recommends"
export DEBIAN_FRONTEND=noninteractive
export PIP_INSTALL="python3 -m pip --no-cache-dir install --upgrade"
export MKLROOT=/opt/intel/mkl
export KENLM_ROOT_DIR=/softs/kenlm

%post
%%%%%
export APT_INSTALL="apt-get install -y --no-install-recommends"
export DEBIAN_FRONTEND=noninteractive
export PIP_INSTALL="python3 -m pip --no-cache-dir install --upgrade"
export MKLROOT=/opt/intel/mkl
export KENLM_ROOT_DIR=/softs/kenlm

mkdir /softs
cd /softs
    rm -rf /var/lib/apt/lists/* \
           /etc/apt/sources.list.d/cuda.list \
           /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get update && \
     $APT_INSTALL \
        build-essential \
        ca-certificates \
        cmake \
        wget \
        git \
        vim \
        emacs \
        nano \
        htop \
        g++ \
        # ssh for OpenMPI
        openssh-server openssh-client \
        # OpenMPI
        libopenmpi-dev libomp-dev \
        # nccl: for flashlight
        libnccl2 libnccl-dev \
        # for libsndfile
        autoconf automake autogen build-essential libasound2-dev \
        libflac-dev libogg-dev libtool libvorbis-dev pkg-config python \
        # for Intel's Math Kernel Library (MKL)
        cpio \
        # FFTW
        libfftw3-dev \
        # for kenlm
        zlib1g-dev libbz2-dev liblzma-dev libboost-all-dev \
        # gflags
        libgflags-dev libgflags2v5 \
        # for glog
        libgoogle-glog-dev libgoogle-glog0v5 \
        # for receipts data processing
        sox && \
# ==================================================================
# python (for receipts data processing)
# ------------------------------------------------------------------
     $APT_INSTALL \
        software-properties-common \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    $APT_INSTALL \
        python3.6 \
        python3.6-dev \
        && \
    wget -O ~/get-pip.py \
        https://bootstrap.pypa.io/get-pip.py && \
    python3.6 ~/get-pip.py && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python3 && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python && \
    $PIP_INSTALL \
        setuptools \
        && \
    $PIP_INSTALL \
        sox \
        tqdm && \
# ==================================================================
# arrayfire https://github.com/arrayfire/arrayfire/wiki/
# ------------------------------------------------------------------
    cd /tmp && git clone --recursive https://github.com/arrayfire/arrayfire.git && \
    cd arrayfire && git checkout v3.6.2 && \
    mkdir build && cd build && \
    CXXFLAGS=-DOS_LNX cmake .. -DCMAKE_BUILD_TYPE=Release -DAF_BUILD_CPU=OFF -DAF_BUILD_OPENCL=OFF -DAF_BUILD_EXAMPLES=OFF && \
    make -j8 && \
    make install && \
# ==================================================================
# flashlight https://github.com/facebookresearch/flashlight.git
# ------------------------------------------------------------------
# If the driver is not found (during docker build) the cuda driver api need to be linked against the
# libcuda.so stub located in the lib[64]/stubs directory
    ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/lib/x86_64-linux-gnu/libcuda.so.1 && \
    cd /softs && git clone --recursive https://github.com/facebookresearch/flashlight.git && \
    cd /softs/flashlight && mkdir -p build && \
    cd build && cmake .. -DCMAKE_BUILD_TYPE=Release -DFLASHLIGHT_BACKEND=CUDA && \
    make -j8 && make install && \
# ==================================================================
# libsndfile https://github.com/erikd/libsndfile.git
# ------------------------------------------------------------------
    cd /tmp && git clone https://github.com/erikd/libsndfile.git && \
    cd libsndfile && git checkout bef2abc9e888142203953addc31c50a192e496e5 && \
    ./autogen.sh && ./configure --enable-werror && \
    make && make check && make install && \
# ==================================================================
# MKL https://software.intel.com/en-us/mkl
# ------------------------------------------------------------------
    cd /tmp && wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB && \
    apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB && \
    wget https://apt.repos.intel.com/setup/intelproducts.list -O /etc/apt/sources.list.d/intelproducts.list && \
    sh -c 'echo deb https://apt.repos.intel.com/mkl all main > /etc/apt/sources.list.d/intel-mkl.list' && \
    apt-get update && DEBIAN_FRONTEND=noninteractive $APT_INSTALL intel-mkl-64bit-2018.4-057 && \
# ==================================================================
# KenLM https://github.com/kpu/kenlm
# ------------------------------------------------------------------
    cd /softs && git clone https://github.com/kpu/kenlm.git && \
    cd kenlm && git checkout e47088ddfae810a5ee4c8a9923b5f8071bed1ae8 && \
    mkdir build && cd build && \
    cmake .. && \
    make -j8 && make install && \
# ==================================================================
# config & cleanup
# ------------------------------------------------------------------
    ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/*

mkdir /softs/wav2letter
cp . /softs/wav2letter

# ==================================================================
# wav2letter with GPU backend
# ------------------------------------------------------------------
    cd /softs/wav2letter && mkdir -p build && \
    cd build && cmake .. -DCMAKE_BUILD_TYPE=Release -DW2L_CRITERION_BACKEND=CUDA && \
    make -j8

%%%%%
%runscript
exec /bin/bash "$@"
