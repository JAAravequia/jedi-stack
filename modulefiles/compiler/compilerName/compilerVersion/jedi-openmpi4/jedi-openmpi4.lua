help([[
]])

local pkgName    = myModuleName()
local pkgVersion = myModuleVersion()
local pkgNameVer = myModuleFullName()

local hierA        = hierarchyA(pkgNameVer,1)
local compNameVer  = hierA[1]
local compNameVerD = compNameVer:gsub("/","-")

conflict(pkgName)
conflict("jedi-mpich","jedi-impi")

local mpi = pathJoin("openmpi4",pkgVersion)
load(mpi)
prereq(mpi)

local opt = os.getenv("JEDI_OPT") or os.getenv("OPT") or "/opt/modules"

local mpath = pathJoin(opt,"modulefiles/mpi",compNameVer,"jedi-openmpi4",pkgVersion)
prepend_path("MODULEPATH", mpath)

local mpath = pathJoin(opt,"modulefiles/mpi",compNameVer,"openmpi4",pkgVersion)
prepend_path("MODULEPATH", mpath)

setenv("MPI_FC",  "mpifort")
setenv("MPI_CC",  "mpicc")
setenv("MPI_CXX", "mpicxx")

whatis("Name: ".. pkgName)
whatis("Version: " .. pkgVersion)
whatis("Category: library")
whatis("Description: OpenMPI library")
