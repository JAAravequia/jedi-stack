#!/bin/bash
# © Copyright 2020 UCAR
# This software is licensed under the terms of the Apache Licence Version 2.0 which can be obtained at
# http://www.apache.org/licenses/LICENSE-2.0.

set -ex

name="atlas"
# source should be either ecmwf or jcsda (fork)
source=$1
version=$2

# Hyphenated version used for install prefix
compiler=$(echo $JEDI_COMPILER | sed 's/\//-/g')
mpi=$(echo $JEDI_MPI | sed 's/\//-/g')
isgnu=''
if [ "${JEDI_COMPILER::3}" = "gnu" ] ; then
   isgnu='-gnu'
fi
if $MODULES; then
    set +x
    source $MODULESHOME/init/bash
    module load jedi-$JEDI_COMPILER
    module load jedi-$JEDI_MPI
    module try-load cmake
    module try-load ecbuild
    module load eckit/ecmwf-$ver_ec
    module load fckit/ecmwf-$ver_fc
    module load cgal
    module load fftw/3.3.8
    ## module load boost/1.68.0
    export CGAL_DIR=$CGAL_ROOT                 # Path to directory containing CGALConfig.cmake
    export Eigen3_DIR=$EIGEN3_PATH               # Path to directory containing Eigen3Config.cmake
    export FFTW_PATH=$FFTW_DIR 

    export Qhull_DIR=/mnt/beegfs/jose.aravequia/opt${isgnu}/$compiler/$mpi/qhull
    module list 
    set -x

    prefix="${PREFIX:-"/opt/modules"}/$compiler/$mpi/$name/$source-$version"
    if [[ -d $prefix ]]; then
  [[ $OVERWRITE =~ [yYtT] ]] && ( echo "WARNING: $prefix EXISTS: OVERWRITING!";$SUDO rm -rf $prefix ) \
                                   || ( echo "WARNING: $prefix EXISTS, SKIPPING"; exit 1 )
    fi

else
    prefix=${ATLAS_ROOT:-"/usr/local"}
fi

export FC=$MPI_FC
export CC=$MPI_CC
export CXX=$MPI_CXX

software=$name
cd ${JEDI_STACK_ROOT}/${PKGDIR:-"pkg"}

[[ -d $software ]] || git clone https://github.com/$source/$software.git
[[ ${DOWNLOAD_ONLY} =~ [yYtT] ]] && exit 0
[[ -d $software ]] && cd $software || ( echo "$software does not exist, ABORT!"; exit 1 )
git fetch --tags
git checkout $version
[[ -d build ]] && $SUDO rm -rf build
mkdir -p build && cd build

# set install prefix and CMAKE_INSTALL_LIBDIR to make sure it installs as lib, not lib64
ecbuild --build=release -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_INSTALL_LIBDIR=lib ..
VERBOSE=$MAKE_VERBOSE make -j${NTHREADS:-4}
VERBOSE=$MAKE_VERBOSE $SUDO make -j${NTHREADS:-4} install

# generate modulefile from template
$MODULES && update_modules mpi $name $source-$version \
   || echo $name $source-$version >> ${JEDI_STACK_ROOT}/jedi-stack-contents.log
