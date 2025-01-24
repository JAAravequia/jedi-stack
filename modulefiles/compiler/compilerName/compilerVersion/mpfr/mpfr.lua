#%Module1.0
## Module file created by JA Aravequia on 2024-05-30 22:35:22.38543
##
## mpfr@4.2.1%intel@2021.4.0 libs=shared,static arch=linux-rhel8-zen2
##
## Configure options: --with-gmp=/mnt/beegfs/jose.aravequia/opt-gnu/gnu9-9.4.0/gmp-6.2.1 --prefix=$PREFIX --enable-cxx --enable-shared --enable-static --with-pic
##


module-whatis "The MPFR library is a C library for multiple-precision floating-point computations with correct rounding."

proc ModulesHelp { } {
puts stderr "The MPFR library is a C library for multiple-precision floating-point"
puts stderr "computations with correct rounding."
}


prepend-path PKG_CONFIG_PATH "/mnt/beegfs/jose.aravequia/opt-gnu/gnu9-9.4.0/mpfr-4.2.1/lib/pkgconfig"
prepend-path CMAKE_PREFIX_PATH "/mnt/beegfs/jose.aravequia/opt-gnu/gnu9-9.4.0/mpfr-4.2.1/"

