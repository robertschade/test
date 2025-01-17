cmake_minimum_required(VERSION 3.9)

project(my_project VERSION 0.1
        DESCRIPTION "CP-PAW"
        LANGUAGES Fortran)
enable_language(Fortran C)

# Currently setting the Fortran compiler to use -std=gnu, change this if you
# want a specific standard
# set(FVERSION "-std=f95")
# set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${FVERSION}")


#
# compiler flags for the fortran compiler
#----------------------------------------
get_filename_component (Fortran_COMPILER_NAME ${CMAKE_Fortran_COMPILER} NAME)

if (Fortran_COMPILER_NAME MATCHES "gfortran.*")

  set (CMAKE_Fortran_FLAGS "-c -I${FFTDIR}/include -I${LIBXCDIR}/include -g -O3 -fdollar-ok -funroll-loops -fomit-frame-pointer -march=native -std=f2008 -pedantic -fbacktrace -fdump-core -fimplicit-none -fcheck=bounds,do,mem,pointer,recursion -ffpe-trap=invalid,zero,overflow -ffpe-summary=invalid,zero,overflow -fexternal-blas -Wall -Wextra -Wline-truncation -Wuninitialized -Wno-maybe-uninitialized")

elseif (Fortran_COMPILER_NAME MATCHES "ifort.*")

  set (CMAKE_Fortran_FLAGS "-c")

endif()

# Source code
include_directories("src")

add_subdirectory(src)

install(TARGETS paw_dbg.x     DESTINATION "bin")

# set(X paw_murnaghan.x)
# add_executable(${X}  ${OBJDIR}/paw.f90)
# target_link_library(${X} paw)
# add_executable (${X} ${OBJECTS})

# set(X paw_stpa.x)
# target_link_library($X paw)
# add_executable ($X ${OBJECTS})

# set(X paw_stpreport.x)
# target_link_library($X paw)
# add_executable ($X ${OBJECTS})

# set(X paw_stpreport.x)
# target_link_library($X paw)
# add_executable ($X ${OBJECTS})

