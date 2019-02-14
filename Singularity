Bootstrap: docker
From: ubuntu:latest
%files
%environment
# Update bashrc file to include mkl
export PATH=/cache/usr/bin:$PATH
export INTEL_DIR=/opt/intel/lib/intel64
export MKL_DIR=/opt/intel/mkl/lib/intel64
export MKL_INC_DIR=/opt/intel/mkl/include
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$INTEL_DIR:$MKL_DIR
export CMAKE_LIBRARY_PATH=$LD_LIBRARY_PATH
export CMAKE_INCLUDE_PATH=$CMAKE_INCLUDE_PATH:$MKL_INC_DIR
export EIGEN3_ROOT=/cache/eigen-eigen-07105f7124f9
%post
mkdir -p /softs/usr/lib
mkdir -p /softs/usr/bin
mkdir -p /cache/usr/bin
mkdir -p /cache/eigen-eigen-07105f7124f9

# Install dependencies
apt-get update -y
apt-get install git wget curl cmake build-essential apt-utils unzip apt-transport-https -y
apt-get install libboost-dev libboost-system-dev libboost-thread-dev libboost-test-dev libboost-all-dev zlib1g-dev bzip2 libbz2-dev liblzma-dev -y
apt-get install libfftw3-dev libfftw3-doc libsndfile-dev -y

git clone https://github.com/torch/distro.git /cache/usr/torch --recursive
cd torch; bash install-deps;
./install.sh

apt-get install libopenmpi-dev openmpi-bin libhdf5-openmpi-dev




%./Preprocess_Data.sh
%runscript
exec /bin/bash "$@"
