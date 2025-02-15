#!/bin/bash
# © Crown Copyright 2020 Met Office UK
# This software is licensed under the terms of the Apache Licence Version 2.0 which can be obtained at
# http://www.apache.org/licenses/LICENSE-2.0.

set -ex

name="json-schema-validator"
version=$1

if $MODULES; then
    set +x
    source $MODULESHOME/init/bash
    module load jedi-$JEDI_COMPILER
    module try-load cmake
    module load json
    module list
    set -x

    prefix="${PREFIX:-"/opt/modules"}/core/$name/$version"
    if [[ -d $prefix ]]; then
        [[ $OVERWRITE =~ [yYtT] ]] && ( echo "WARNING: $prefix EXISTS: OVERWRITING!";$SUDO rm -rf $prefix ) \
                                   || ( echo "WARNING: $prefix EXISTS, SKIPPING"; exit 1 )
    fi

else
    prefix=${JSON_ROOT:-"/usr/local"}
    JSON_DIR=${JSON_DIR:-$prefix/lib/cmake/nlohmann_json}
fi

cd $JEDI_STACK_ROOT/${PKGDIR:-"pkg"}

software="$name-$version"
tarfile="$version.tar.gz"
# url="https://github.com/pboettch/json-schema-validator/archive/$tarfile"
url="https://github.com/pboettch/json-schema-validator/archive/refs/tags/$tarfile"
[[ -d $software ]] || ( $WGET $url; tar -xf $tarfile )
[[ ${DOWNLOAD_ONLY} =~ [yYtT] ]] && exit 0
[[ -d $software ]] && cd $software || ( echo "$software does not exist, ABORT!"; exit 1 )
[[ -d build ]] && rm -rf build
mkdir -p build && cd build

[[ -n $JSON_DIR ]] || ( echo "Required json cmake configuration not found, ABORT!"; exit 1 )
cmake .. \
      -DCMAKE_INSTALL_PREFIX=$prefix \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_POLICY_DEFAULT_CMP0074=NEW \
      -DBUILD_SHARED_LIBS=Y \
      -Dnlohmann_json_DIR=$JSON_DIR \
      -DBUILD_TESTS=$MAKE_CHECK \
      -DBUILD_EXAMPLES=N
[[ $MAKE_CHECK =~ [yYtT] ]] && make test
$SUDO make install

# generate modulefile from template
$MODULES && update_modules core $name $version \
         || echo $name $version >> ${JEDI_STACK_ROOT}/jedi-stack-contents.log

exit 0
