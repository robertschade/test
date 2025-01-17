# set(MY_MODS   my_module.f90
#               another_module.f90
#               CACHE INTERNAL "")
# add_library(mylib "${MY_MODS}")
# add_executable(my_exe main.f90)
# target_link_libraries(my_exe PRIVATE mylib)

set(OBJDIR ".")
set(SRCDIR "src")

set(F90PP ${CMAKE_BINARY_DIR}/src/f90pp)

set(LIBSRC  paw_trace.f90 
            paw_error.f90 
            paw_filehandler.f90 
            paw_clock.f90 
            paw_lock.f90 
            paw_timing.f90 
            paw_linkedlist.f90 
            paw_strings.f90 
            paw_dft.f90 
            paw_dftaddendum.f90 
            paw_constants.f90 
            paw_spherical.f90 
            paw_generalpurpose.f90 
            paw_report.f90 
            paw_periodictable.f90 
            paw_radial.f90 
            paw_schroedinger.f90 
            paw_atomlib.f90 
            paw_specialfunctions.f90 
            paw_usage.f90 
            paw_selftest.f90 
            paw_strcio.f90 
            paw_cell.f90 
            paw_pdos.f90 
            paw_banddata.f90 
            paw_library.f90 
            paw_polynom.f90 
            paw_dimer.f90  
            paw_lmtobasics.f90 
            paw_debug.f90 
            paw_brillouin.f90 
            paw_gaussian.f90 )

set(BINSRC  paw_driver.f90 
            paw_thermostat.f90 
            paw_isolate.f90 
            paw_assist.f90 
            paw_lists.f90 
            paw_constraints.f90 
            paw_lmto.f90 
            paw_simplelmto.f90 
            paw_dmft.f90 
            paw_fft.f90 
            paw_augmentation.f90 
            paw_softcore.f90 
            paw_classical.f90 
            paw_forcefield.f90 
            paw_atoms.f90 
            paw.f90 
            paw_efg.f90 
            paw_ioroutines.f90 
            paw_iotra.f90 
            paw_ionew.f90 
            paw_qmmm.f90 
            paw_cosmo.f90 
            paw_warmup.f90 
            paw_optfric.f90
            paw_setups.f90 
            paw_potential.f90 
            paw_occupations.f90 
            paw_pairpotential.f90 
            paw_graphics.f90 
            paw_waves1.f90 
            paw_waves2.f90 
            paw_mixer.f90 
            paw_cg.f90 
            paw_kpoints.f90 
            paw_vext.f90 
            paw_vdw.f90 
            paw_ci.f90 
            paw_opteels.f90 )
  
add_custom_command(
  OUTPUT ${CMAKE_BINARY_DIR}/src/f90pp
  COMMAND cp ${PROJECT_SOURCE_DIR}/src/Buildtools/F90PP/f90pp.in ${CMAKE_BINARY_DIR}/src/f90pp && chmod +x ${CMAKE_BINARY_DIR}/src/f90pp && cp ${PROJECT_SOURCE_DIR}/src/Buildtools/F90PP/f90pp.sed ${CMAKE_BINARY_DIR}/src/f90pp.sed
  COMMENT "F90PP"
)

add_custom_command(
  OUTPUT ${CMAKE_BINARY_DIR}/src/f90pp_tmplts.f90
  COMMAND ${CMAKE_BINARY_DIR}/src/f90pp -notemplates ${PROJECT_SOURCE_DIR}/src/Buildtools/F90PP/f90pp_tmplts.f90 > ${CMAKE_BINARY_DIR}/src/f90pp_tmplts.f90
  DEPENDS ${CMAKE_BINARY_DIR}/src/f90pp
  COMMENT "F90PP f90pp_tmplts.f90"
)

foreach(FILE ${LIBSRC})
  add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/src/${FILE}
    COMMAND ${CMAKE_BINARY_DIR}/src/f90pp ${PROJECT_SOURCE_DIR}/src/${FILE} > ${CMAKE_BINARY_DIR}/src/${FILE}
    DEPENDS f90pp_tmplts.x
    COMMENT "F90PP ${FILE}"
  )
  list(APPEND LIBOBJ ${CMAKE_BINARY_DIR}/src/${FILE})
endforeach()

foreach(FILE ${BINSRC})
  add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/src/${FILE}
    COMMAND cp ${PROJECT_SOURCE_DIR}/src/${FILE} ${CMAKE_BINARY_DIR}/src/${FILE}
    DEPENDS ${CMAKE_BINARY_DIR}/src/f90pp
    COMMENT "F90PP ${FILE}"
  )
  list(APPEND BINOBJ ${CMAKE_BINARY_DIR}/src/${FILE})
endforeach()


#
#           ${OBJDIR}/paw_localize.o  #removed
#           ${OBJDIR}/paw_pdos.o  #into library
#          ${OBJDIR}/paw_optic.o \   # removed
#  the following is for the QMMM of Woo and Margl
#          ${OBJDIR}/mm_paw_modules.o \
#          ${OBJDIR}/mm_paw_core_mm.o \
#          ${OBJDIR}/mm_paw_interface.o
#          ${OBJDIR}/paw_md
#

add_library(paw ${LIBOBJ})

set(X paw_dbg.x)
#add_executable(${X}  ${OBJDIR}/paw.f90)

add_executable(${X} ${BINOBJ})

add_executable(f90pp_tmplts.x f90pp_tmplts.f90)

target_link_libraries(${X} paw)
