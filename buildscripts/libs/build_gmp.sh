#!/bin/bash 
# © Copyright 2025 INPE
# This software is licensed under the terms of the Apache Licence Version 2.0 which can be obtained at
# http://www.apache.org/licenses/LICENSE-2.0.

set -ex

name="gmp"
version=$1

software=$name-$version

# Hyphenated version used for install prefix
compiler=$(echo $JEDI_COMPILER | sed 's/\//-/g')
mpi=$(echo $JEDI_MPI | sed 's/\//-/g')

set +x
source $MODULESHOME/init/bash
module load jedi-$JEDI_COMPILER
[[ -z $mpi ]] || module load jedi-$JEDI_MPI 
module list
set -x

if [[ ! -z $mpi ]]; then
    export FC=$MPI_FC
    export CC=$MPI_CC
    export CXX=$MPI_CXX
else
    export FC=$SERIAL_FC
    export CC=$SERIAL_CC
    export CXX=$SERIAL_CXX
fi

export F77=$FC

export FFLAGS+=" -fPIC"
export CFLAGS+=" -fPIC"

cd ${JEDI_STACK_ROOT}/${PKGDIR:-"pkg"}

url="https://gmplib.org/download/gmp/${software}.tar.xz" 
[[ -d $software ]] || ( curl -fLO $url; tar -xf $software.tar.xz )
[[ ${DOWNLOAD_ONLY} =~ [yYtT] ]] && exit 0
[[ -d $software ]] && cd $software || ( echo "$software does not exist, ABORT!"; exit 1 )
[[ -d build ]] && rm -rf build
mkdir -p build && cd build

prefix="${PREFIX:-"/opt/modules"}/$compiler/$mpi/$name/$version"
if [[ -d $prefix ]]; then
    [[ $OVERWRITE =~ [yYtT] ]] && ( echo "WARNING: $prefix EXISTS: OVERWRITING!";$SUDO rm -rf $prefix ) \
                               || ( echo "WARNING: $prefix EXISTS, SKIPPING"; exit 1 )
fi

[[ -z $mpi ]] || ( export MPICC=$MPI_CC; extra_conf="--enable-mpi" )

../configure --prefix=$prefix --enable-cxx --enable-shared --enable-static --with-pic 

make V=$MAKE_VERBOSE -j${NTHREADS:-4}
[[ $MAKE_CHECK =~ [yYtT] ]] && make check
$SUDO make install

export GMP_DIR=${prefix}

# generate modulefile from template
[[ -z $mpi ]] && modpath=compiler || modpath=mpi
$MODULES && update_modules $modpath $name $version \
         || echo $name $version >> ${JEDI_STACK_ROOT}/jedi-stack-contents.log

cp gmpxx.h $GMP_DIR/include
export GMP_INC=$GMP_DIR/include
export GMP_LIB=$GMP_DIR/lib

