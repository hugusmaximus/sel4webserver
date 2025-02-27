#
# Copyright 2019, Data61
# Commonwealth Scientific and Industrial Research Organisation (CSIRO)
# ABN 41 687 119 230.
#
# This software may be distributed and modified according to the terms of
# the BSD 2-Clause license. Note that NO WARRANTY is provided.
# See "LICENSE_BSD2.txt" for details.
#
# @TAG(DATA61_BSD)
#

set(DOCSITE_DIR "${CMAKE_CURRENT_LIST_DIR}" CACHE STRING "")
set(DOCSITE_RUN_SCRIPT "${DOCSITE_DIR}/unpack_site.sh" CACHE STRING "")
mark_as_advanced(DOCSITE_DIR DOCSITE_RUN_SCRIPT)

macro(docsite_build_site_tar outfile)
    include(ExternalProject)
    ExternalProject_Add(
        docsite
        GIT_REPOSITORY
        https://github.com/SEL4PROJ/docs.git
        GIT_SHALLOW
        TRUE
        GIT_PROGRESS
        TRUE
        CONFIGURE_COMMAND
        "" # Don't run configure command
        BUILD_ALWAYS
        ON
        BUILD_IN_SOURCE
        TRUE
        BUILD_COMMAND
        "make;build"
        INSTALL_COMMAND
        "rm;-rf;_site/Hardware/CEI_TK1_SOM/"
        COMMAND
        "tar;-cvzf;site.tar.gz;_site/"
        COMMAND
        "mv;site.tar.gz;${CMAKE_CURRENT_BINARY_DIR}"
        EXCLUDE_FROM_ALL
    )
    include(external-project-helpers)
    DeclareExternalProjObjectFiles(docsite ${CMAKE_CURRENT_BINARY_DIR} FILES site.tar.gz)
    set(${outfile} ${CMAKE_CURRENT_BINARY_DIR}/site.tar.gz)
endmacro()

macro(docsite_install_to_overlay overlay)

    AddFileToOverlayDir("S90unpack_site" ${DOCSITE_RUN_SCRIPT} "etc/init.d" ${overlay})
    docsite_build_site_tar(site_tar)
    AddFileToOverlayDir("site.tar.gz" ${site_tar} "var" ${overlay})

endmacro()

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(docsite DEFAULT_MSG DOCSITE_DIR DOCSITE_RUN_SCRIPT)
