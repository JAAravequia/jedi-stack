#%Module1.0
## Module file created by spack (https://github.com/spack/spack) on 2022-06-23 10:04:37.733562
##
## gmp@6.2.1%intel@2021.4.0 libs=shared,static arch=linux-rhel8-zen2/yyf4kjz
##
## Configure options: --enable-cxx --enable-shared --enable-static --with-pic
##


module-whatis "GMP is a free library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating-point numbers."

proc ModulesHelp { } {
puts stderr "GMP is a free library for arbitrary precision arithmetic, operating on"
puts stderr "signed integers, rational numbers, and floating-point numbers."
}


prepend-path LD_LIBRARY_PATH "/mnt/beegfs/jose.aravequia/opt-gnu/gnu9-9.4.0/gmp-6.2.1/lib"
prepend-path PKG_CONFIG_PATH "/mnt/beegfs/jose.aravequia/opt-gnu/gnu9-9.4.0/gmp-6.2.1/lib/pkgconfig"
prepend-path CMAKE_PREFIX_PATH "/mnt/beegfs/jose.aravequia/opt-gnu/gnu9-9.4.0/gmp-6.2.1/"

