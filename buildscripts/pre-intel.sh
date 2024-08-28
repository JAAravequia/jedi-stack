
### Baseado em https://github.com/JCSDA/jedi-stack

## https://github.com/JCSDA/jedi-stack/blob/master/doc/Build.md


module swap gnu9 intel/2021.4.0
module swap openmpi4 impi/2021.4.0

source /opt/intel/oneapi/mkl/2021.4.0/env/vars.sh

module load cmake-3.22.3-gcc-9.4.0-ev6hras 
module load libgit2-1.3.1-gcc-11.2.0-76kuboz
module load python-3.9.13-gcc-9.4.0-moxjnc6

module load curl-7.85.0-gcc-11.2.0-yxw2lyk

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64

# module load openssl-1.1.1q-gcc-9.4.0-6zaz2vm
# export  OPENSSL_ROOT_DIR=/home/public/spack/opt/spack/linux-rhel8-zen2/gcc-9.4.0/openssl-1.1.1q-6zaz2vmcy666hqsqrrvxru4damhk7soo

export JEDI_COMPILER=intel/2021.4.0 
export JEDI_MPI=impi/2021.4.0

# export JEDI_COMPILER=gnu9/9.4.0 
# export JEDI_MPI=openmpi/4.1.1

export JEDI_OPT=/mnt/beegfs/jose.aravequia/opt
###    PASSOS FEITOS :
 [buildscripts]> $ ./setup_environment.sh egeon


# For lmod modules
## . /usr/local/opt/lmod/init/profile
. /opt/ohpc/admin/lmod/lmod/init/profile

./setup_environment.sh egeon-intel

## para ler os modulos do core:
module use
module use -a $JEDI_OPT/modulefiles/core

### Cria os modulos básicos associados ao compilador e mpi
./setup_modules.sh egeon-intel

## compila as bibliotecas e apps , e gera modulos 
./build_stack.sh egeon-intel

### APOS COMPILAÇAO COMPLETA :: 

module load jedi-intel/2021.4.0
module load jedi-impi/2021.4.0

module use -a $JEDI_OPT/modulefiles/mpi/intel/2021.4.0/impi/2021.4.0
module use -a $JEDI_OPT/modulefiles/compiler/intel/2021.4.0
module load jedi-impi/2021.4.0
module load netcdf/4.7.4
 
## Teste para ver se carregou o módulo correto:
which nc-config 
## verifique se aponta para  /mnt/beegfs/jose.aravequia/opt/intel-2021.4.0/impi-2021.4.0/netcdf/4.7.4/bin/nc-config

module load ecbuild/ecmwf-3.6.1


