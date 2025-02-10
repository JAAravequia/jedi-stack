#!/bin/bash 

# export PREFIX=/mnt/beegfs/jose.aravequia/opt/intel-2021.4.0/gmp-6.2.1   # Change this to install GMP wherever you want.
source='gmp'
version='6.2.1'
software=${source}-${version}
export GMP_DIR=${JEDI_OPT}/${compiler}/${mpi}/$source/$version   
prefix=${JEDI_OPT}/${compiler}/${mpi}/$source/$version 
    # # /mnt/beegfs/jose.aravequia/opt-new/gnu9-9.4.0/openmpi4-4.1.1/gmp/6.2.1

# assuming it is called at ./buildscript directory of jedi-stack

cd ../pkg 

curl -fLO https://gmplib.org/download/gmp/${software}.tar.xz
tar -xf ${software}.tar.xz
cd ${software}
make clean
make distclean-generic
./configure --prefix=$GMP_DIR --enable-cxx --enable-shared --enable-static --with-pic
make -j8 all
make install
cp gmpxx.h $GMP_DIR/include
export GMP_INC=$GMP_DIR/include
export GMP_LIB=$GMP_DIR/lib

## Download and compile GNU mpfr  
# Requirements : GMP
#
# See : www.mpfr.org 
source='mpfr'
version='4.2.1'
software=${source}-${version}
export GMP_DIR=${JEDI_OPT}/${compiler}/${mpi}/$source/$version   
prefix=${JEDI_OPT}/${compiler}/${mpi}/$source/$version 


wget https://www.mpfr.org/mpfr-current/mpfr-4.2.1.tar.xz 

tar -xf mpfr-4.2.1.tar.xz
cd mpfr-4.2.1
export MPFR_DIR=/mnt/beegfs/jose.aravequia/opt-gnu/gnu9-9.4.0/mpfr/4.2.1
./configure --prefix=$MPFR_DIR --enable-cxx --enable-shared --enable-static --with-pic --with-gmp=$GMP_DIR
make -j8 all
make install


