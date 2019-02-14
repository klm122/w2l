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
apt-get install apt-utils git wget curl cmake build-essential apt-utils unzip apt-transport-https -y
apt-get install libboost-dev libboost-system-dev libboost-thread-dev libboost-test-dev libboost-all-dev zlib1g-dev bzip2 libbz2-dev liblzma-dev -y
apt-get install libfftw3-dev libfftw3-doc libsndfile-dev -y

# Install MKL - modified from https://github.com/eddelbuettel/mkl4deb/blob/master/script.sh
cd /tmp
wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
sh -c 'echo deb https://apt.repos.intel.com/mkl all main > /etc/apt/sources.list.d/intel-mkl.list'
apt-get update -y
apt-get install intel-mkl-64bit-2018.2-046 -y
update-alternatives --install /usr/lib/x86_64-linux-gnu/libblas.so     libblas.so-x86_64-linux-gnu      /opt/intel/mkl/lib/intel64/libmkl_rt.so 50
update-alternatives --install /usr/lib/x86_64-linux-gnu/libblas.so.3   libblas.so.3-x86_64-linux-gnu    /opt/intel/mkl/lib/intel64/libmkl_rt.so 50
update-alternatives --install /usr/lib/x86_64-linux-gnu/liblapack.so   liblapack.so-x86_64-linux-gnu    /opt/intel/mkl/lib/intel64/libmkl_rt.so 50
update-alternatives --install /usr/lib/x86_64-linux-gnu/liblapack.so.3 liblapack.so.3-x86_64-linux-gnu  /opt/intel/mkl/lib/intel64/libmkl_rt.so 50
echo "/opt/intel/lib/intel64"     >  /etc/ld.so.conf.d/mkl.conf
echo "/opt/intel/mkl/lib/intel64" >> /etc/ld.so.conf.d/mkl.conf
ldconfig
echo "MKL_THREADING_LAYER=GNU" >> /etc/environment

# LuaJIT and LuaRocks
git clone https://github.com/torch/luajit-rocks.git
cd luajit-rocks
mkdir build; cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/cache/usr -DWITH_LUAJIT21=OFF
make -j 4
make install
cd ../..

#KenLM
wget https://kheafield.com/code/kenlm.tar.gz
tar xfvz kenlm.tar.gz
rm kenlm.tar.gz
cd kenlm
mkdir build && cd build
(cd /cache; wget -O - https://bitbucket.org/eigen/eigen/get/3.2.8.tar.bz2 |tar xj)
cmake .. -DCMAKE_INSTALL_PREFIX=/cache/usr -DCMAKE_POSITION_INDEPENDENT_CODE=ON
make -j 4
make install
cp -a lib/* /softs/usr/lib
cd ../..

# OpenMPI
wget https://www.open-mpi.org/software/ompi/v3.0/downloads/openmpi-3.0.1.tar.bz2
tar xfj openmpi-3.0.1.tar.bz2
rm openmpi-3.0.1.tar.bz2 
cd openmpi-3.0.1; mkdir build; cd build
../configure --prefix=/cache/usr --enable-mpi-cxx --enable-shared --with-slurm --enable-mpi-ext=affinity
make -j 20 all
make install
cd ../..

MPI_CXX_COMPILER=mpicxx MPI_CXX_COMPILE_FLAGS="-O3" /cache/usr/luarocks make rocks/torchmpi-scm-1.rockspec
# TorchMPI
%runscript
exec /bin/bash "$@"
