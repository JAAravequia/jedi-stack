#!/bin/bash
# © Copyright 2020 UCAR
# This software is licensed under the terms of the Apache Licence Version 2.0 which can be obtained at
# http://www.apache.org/licenses/LICENSE-2.0.

set -ex

name="jedi-cmake"
version=$1

# Hyphenated version used for install prefix
compiler=$(echo $JEDI_COMPILER | sed 's/\//-/g')
mpi=$(echo $JEDI_MPI | sed 's/\//-/g')

if $MODULES; then
    set +x
    source $MODULESHOME/init/bash
    module load jedi-$JEDI_COMPILER
    [[ -z $mpi ]] || module load jedi-$JEDI_MPI
    module try-load szip
    module load hdf5
    module load netcdf
    module try-load udunits
    module load ecbuild 
    module list
    set -x

    prefix="${PREFIX:-"/opt/modules"}/$compiler/$mpi/$name/$version"

    if [[ -d $prefix ]]; then
        [[ $OVERWRITE =~ [yYtT] ]] && ( echo "WARNING: $prefix EXISTS: OVERWRITING!";$SUDO rm -rf $prefix ) \
                                || ( echo "WARNING: $prefix EXISTS, SKIPPING"; exit 1 )
    fi
else
    prefix=${NCO_ROOT:-"/usr/local"}
fi

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
export CXXFLAGS+=" -fPIC"
export FCFLAGS="$FFLAGS"

export LDFLAGS+=" -L$NETCDF_ROOT/lib -L$HDF5_ROOT/lib -L$SZIP_ROOT/lib"

gitURL="https://github.com/JCSDA/jedi-cmake.git"

cd ${JEDI_STACK_ROOT}/${PKGDIR:-"pkg"}

software=$name-$version
[[ -d $software ]] || ( git clone -b $version $gitURL $software )
[[ ${DOWNLOAD_ONLY} =~ [yYtT] ]] && exit 0
[[ -d $software ]] && cd $software || ( echo "$software does not exist, ABORT!"; exit 1 )
[[ -d build ]] && rm -rf build
mkdir -p build && cd build

ecbuild -DCMAKE_INSTALL_PREFIX:PATH=$prefix ..

make V=$MAKE_VERBOSE -j${NTHREADS:-4}
[[ $MAKE_CHECK =~ [yYtT] ]] && make check
$SUDO make install


