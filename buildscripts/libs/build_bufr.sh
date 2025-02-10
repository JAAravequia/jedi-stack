#!/bin/bash
# © Copyright 2020 UCAR
# © Copyright 2020 NOAA/NCEP/EMC
# This software is licensed under the terms of the Apache Licence Version 2.0 which can be obtained at
# http://www.apache.org/licenses/LICENSE-2.0.

set -ex

name="bufr"
# source should either be noaa-emc or jcsda
source=$1
version=$2

# Hyphenated version used for install prefix
compiler=$(echo $JEDI_COMPILER | sed 's/\//-/g')

# manage package dependencies here
if $MODULES; then
    set +x
    source $MODULESHOME/init/bash
    module load jedi-$JEDI_COMPILER
    module try-load cmake
    module list
    set -x

    prefix="${PREFIX:-"/opt/modules"}/$compiler/$name/$source/$version"
    if [[ -d $prefix ]]; then
    [[ $OVERWRITE =~ [yYtT] ]] && ( echo "WARNING: $prefix EXISTS: OVERWRITING!";$SUDO rm -rf $prefix ) \
                                   || ( echo "WARNING: $prefix EXISTS, SKIPPING"; exit 1 )
    fi

else
    prefix=${BUFR_ROOT:-"/usr/local"}
fi

export FC=$SERIAL_FC
export F90=$SERIAL_FC
export CC=$SERIAL_CC

software=NCEPLIBS-bufr

# Release git tag name
numversion=$(echo $version | cut -d'.' -f1-2 )$(echo $version |cut -d'.' -f3)

if [[ ${source} == "jcsda-internal" ]]
then
  gitOrg="JCSDA-internal"
else
  gitOrg="${source}"
fi

if (( $(echo "$numversion <= 12.0" | bc -l) )); then
    tag=bufr_v$version      ### up to version 12.0.0
else
    tag=v$version           ### after 12.0.0
fi

cd ${JEDI_STACK_ROOT}/${PKGDIR:-"pkg"}
[[ -d $software ]] || git clone https://github.com/$gitOrg/$software.git
[[ ${DOWNLOAD_ONLY} =~ [yYtT] ]] && exit 0
[[ -d $software ]] && cd $software || ( echo "$software does not exist, ABORT!"; exit 1 )
git fetch
git checkout --detach $tag
#[[ -d build ]] && rm -rf build
[[ -d build ]] && $SUDO rm -rf build
mkdir -p build && cd build

cmake -DENABLE_PYTHON=ON -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_INSTALL_LIBDIR=lib ..
VERBOSE=$MAKE_VERBOSE make -j${NTHREADS:-4}
VERBOSE=$MAKE_VERBOSE $SUDO make install

# generate modulefile from template
pythonVersion=$(`which python3` -c 'import sys;print(sys.version_info[0],".",sys.version_info[1],sep="")')
$MODULES && update_modules compiler $name $source-$version $pythonVersion \
         || echo $name $source-$version >> ${JEDI_STACK_ROOT}/jedi-stack-contents.log
