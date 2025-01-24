
### Baseado em https://github.com/JCSDA/jedi-stack

## https://github.com/JCSDA/jedi-stack/blob/master/doc/Build.md


module reload gnu9 
module reload  openmpi4 
module load cmake-3.24.2-gcc-9.4.0-s7wmakm
module load libgit2-1.3.1-gcc-11.2.0-76kuboz 
module load python-3.9.15-gcc-9.4.0-f466wuv

module load curl-7.85.0-gcc-9.4.0-qbney7y
export JEDI_COMPILER=gnu9/9.4.0
export JEDI_MPI=openmpi4/4.1.1

# export JEDI_COMPILER=gnu9/9.4.0 
# export JEDI_MPI=openmpi/4.1.1

export JEDI_OPT=/mnt/beegfs/jose.aravequia/opt-new
###    PASSOS FEITOS :
 [buildscripts]> $ ./setup_environment.sh egeon-gnu


# For lmod modules
## . /usr/local/opt/lmod/init/profile
. /opt/ohpc/admin/lmod/lmod/init/profile

./setup_environment.sh egeon-gnu

## para ler os modulos do core:

module use $JEDI_OPT/modulefiles/core

### Cria os modulos básicos associados ao compilador e mpi
./setup_modules.sh egeon-gnu

## compila as bibliotecas e apps , e gera modulos 
./build_stack.sh egeon-gnu

### APOS COMPILAÇAO COMPLETA :: 



module use -a $JEDI_OPT/modulefiles/compiler/$JEDI_COMPILER
module use -a $JEDI_OPT/modulefiles/mpi/$JEDI_COMPILER/$JEDI_MPI

module load jedi-$JEDI_COMPILER
module load jedi-$JEDI_MPI

module load netcdf/4.7.4
 
## Teste para ver se carregou o módulo correto:
which nc-config 
## verifique se aponta para  /mnt/beegfs/jose.aravequia/opt-gnu//impi-2021.4.0/netcdf/4.7.4/bin/nc-config

module load ecbuild/ecmwf-3.6.1


export CGAL_DIR=$CGAL_ROOT                 # Path to directory containing CGALConfig.cmake
export Eigen3_DIR=$EIGEN3_PATH               # Path to directory containing Eigen3Config.cmake
export FFTW_PATH=$FFTW_DIR
export Qhull_DIR=/mnt/beegfs/jose.aravequia/opt-gnu/gnu9-9.4.0/openmpi4-4.1.1/qhull
##               /mnt/beegfs/jose.aravequia/opt/intel-2021.4.0/impi-2021.4.0/qhull
export nlohmann_json_DIR=/mnt/beegfs/jose.aravequia/opt/core/json/3.9.1/include/nlohmann
export CODE=$JEDI_SRC
export BUILD=$JEDI_BUILD
