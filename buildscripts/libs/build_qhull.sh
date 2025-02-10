#!/bin/bash
# © Copyright 2020 UCAR
# This software is licensed under the terms of the Apache Licence Version 2.0 which can be obtained at
# http://www.apache.org/licenses/LICENSE-2.0.

set -ex

name="qhull"
version=$1

# Hyphenated version used for install prefix
compiler=$(echo $JEDI_COMPILER | sed 's/\//-/g')
mpi=$(echo $JEDI_MPI | sed 's/\//-/g')

# manage package dependencies here
if $MODULES; then
    set +x
    source $MODULESHOME/init/bash
    module load jedi-$JEDI_COMPILER
    module load jedi-$JEDI_MPI
    module list
    set -x

    ## prefix="${PREFIX:-"/opt/modules"}/$compiler/$name/$version"
    prefix="${PREFIX:-"/opt/modules"}/$compiler/$mpi/$name"           ## /$version"
    if [[ -d $prefix ]]; then
        [[ $OVERWRITE =~ [yYtT] ]] && ( echo "WARNING: $prefix EXISTS: OVERWRITING!";$SUDO rm -rf $prefix ) \
                                   || ( echo "WARNING: $prefix EXISTS, SKIPPING"; exit 1 )
    fi

else
    prefix=${SZIP_ROOT:-"/usr/local"}
fi

export FC=$MPI_FC
export CC=$MPI_CC
export CXX=$MPI_CXX


export FFLAGS+=" -fPIC"
export CFLAGS+=" -fPIC"
export CXXFLAGS+=" -fPIC"
export FCFLAGS="$FFLAGS"

cd ${JEDI_STACK_ROOT}/${PKGDIR:-"pkg"}

software=$name
url=http://www.qhull.org/download/$software-2020-src-$version.tgz 
[[ -d $software ]] || ( $WGET $url; tar -xf $software-2020-src-$version.tgz )
[[ ${DOWNLOAD_ONLY} =~ [yYtT] ]] && exit 0
[[ -d $software-2020.2 ]] && cd $software-2020.2 || ( echo "$software does not exist, ABORT!"; exit 1 )
[[ -d build_$compiler ]] && rm -rf build_$compiler
mkdir -p build_$compiler && cd build_$compiler

cmake -DCMAKE_INSTALL_PREFIX=$prefix ..
## /mnt/beegfs/jose.aravequia/opt-gnu/$compiler/$mpi/qhull ..

make V=$MAKE_VERBOSE -j${NTHREADS:-4}
[[ $MAKE_CHECK =~ [yYtT] ]] && make check
$SUDO make install

# generate modulefile from template
$MODULES && update_modules compiler $name $version \
         || echo $name $version >> ${JEDI_STACK_ROOT}/jedi-stack-contents.log
