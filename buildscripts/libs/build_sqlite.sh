#!/bin/bash
# © Copyright 2020 UCAR
# This software is licensed under the terms of the Apache Licence Version 2.0 which can be obtained at
# http://www.apache.org/licenses/LICENSE-2.0.
#
# SQLite - https://www.sqlite.org/
#
# SQLite is a C-language library that implements a small, fast, self-contained, high-reliability, full-featured, SQL database engine.
#

set -ex

name="sqlite"
version=$1

# Hyphenated version used for install prefix
compiler=$(echo $JEDI_COMPILER | sed 's/\//-/g')

initialize_prefix_compiler $name $version $compiler

# software="sqlite-autoconf-${version:0:1}${version:2:2}0${version:5:1}00"
software="sqlite-version-$version"
cd ${JEDI_STACK_ROOT}/${PKGDIR:-"pkg"}
tarname="version-$version.tar.gz"
url=https://github.com/sqlite/sqlite/archive/refs/tags/$tarname
##  url="https://www.sqlite.org/2020/$tarname"
[[ -d $software ]] || ( $WGET $url; tar -xf $tarname )
[[ ${DOWNLOAD_ONLY} =~ [yYtT] ]] && exit 0
[[ -d $software ]] && cd $software || ( echo "$software does not exist, ABORT!"; exit 1 )
[[ -d build ]] && rm -rf build  ## added
mkdir -p build && cd build      ## added to make a clean build
../configure --prefix=$prefix   ## modified to ../configure
make V=$MAKE_VERBOSE -j${NTHREADS:-4}
$SUDO make V=$MAKE_VERBOSE -j${NTHREADS:-4} install

# generate modulefile from template
$MODULES && update_modules compiler $name $version \
         || echo $name $version >> ${JEDI_STACK_ROOT}/jedi-stack-contents.log
