#!/bin/bash
# © Copyright 2020 UCAR
# This software is licensed under the terms of the Apache Licence Version 2.0 which can be obtained at
# http://www.apache.org/licenses/LICENSE-2.0.

# OBS.: To build the value should be on char of: yYtT

# Minimal JEDI Stack
export      STACK_BUILD_CMAKE=N  # Y
export       STACK_BUILD_SZIP=N  # Y
export    STACK_BUILD_UDUNITS=N  # Y
export       STACK_BUILD_ZLIB=N  # Y
export       STACK_BUILD_JPEG=N  # Y 
export        STACK_BUILD_PNG=N  # Y 
export     STACK_BUILD_LAPACK=N  # Y
export STACK_BUILD_BOOST_HDRS=N  # Y  
export       STACK_BUILD_FFTW=N  # Y
export     STACK_BUILD_EIGEN3=N  # Y
export       STACK_BUILD_BUFR=N  # Y
export    STACK_BUILD_ECBUILD=N  # Y
export       STACK_BUILD_CGAL=N  # Y
export     STACK_BUILD_GITLFS=N  # Y
export   STACK_BUILD_GSL_LITE=N  # Y
export   STACK_BUILD_PYBIND11=N  # Y
export       STACK_BUILD_HDF5=N  # Y
export    STACK_BUILD_PNETCDF=N  # Y
export     STACK_BUILD_NETCDF=N  # Y
export      STACK_BUILD_NCCMP=N  # Y
export      STACK_BUILD_ECKIT=N  # Y
export      STACK_BUILD_FCKIT=N  # Y
export      STACK_BUILD_ATLAS=Y  # Y

# Optional Additions
export        STACK_BUILD_PYJEDI=N  # Y
export      STACK_BUILD_NCEPLIBS=N  # Y for skylab / N mpas-bundle
export        STACK_BUILD_JASPER=N  # Y
export     STACK_BUILD_ARMADILLO=N  ##  don´t have libs/buildscript
export        STACK_BUILD_XERCES=N
export        STACK_BUILD_TKDIFF=N
export           STACK_BUILD_ODC=N  # Y
export          STACK_BUILD_PROJ=N  # Needs TIFF .  N not using it ?? 
export          STACK_BUILD_GPTL=N  ## don´t work 
export           STACK_BUILD_NCO=N  
export           STACK_BUILD_PIO=N  # Y 
export    STACK_BUILD_BOOST_FULL=N
export          STACK_BUILD_ESMF=N  # Y
export      STACK_BUILD_BASELIBS=N  ### To build GEOS NASA/GSFC
export     STACK_BUILD_PDTOOLKIT=N
export          STACK_BUILD_TAU2=N  ## Require PDTOOLKIT

export          STACK_BUILD_GEOS=N
export        STACK_BUILD_SQLITE=N  # Y
export         STACK_BUILD_qhull=N
export           STACK_BUILD_FMS=N  # Y
export          STACK_BUILD_JSON=N  # Y
export STACK_BUILD_JSON_SCHEMA_VALIDATOR=N  # Y
export        STACK_BUILD_ECFLOW=N  # N

export    STACK_BUILD_jedi_cmake=Y
