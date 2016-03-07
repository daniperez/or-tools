cmake_minimum_required ( VERSION 2.6 )

# -------------------------------------------------------------------
# MAIN 
# -------------------------------------------------------------------
set ( OR_TOOLS_VERSION_MAJOR 1 )
set ( OR_TOOLS_VERSION_MINOR 0 )
set ( OR_TOOLS_VERSION_PATCH 0 )
set ( OR_TOOLS_VERSION_REL   0 )

# -------------------------------------------------------------------
# PACKAGING
# -------------------------------------------------------------------
set ( CPACK_PACKAGE_VERSION_MAJOR "${OR_TOOLS_VERSION_MAJOR}" )
set ( CPACK_PACKAGE_VERSION_MINOR "${OR_TOOLS_VERSION_MINOR}" )
set ( CPACK_PACKAGE_VERSION_PATCH "${OR_TOOLS_VERSION_PATCH}" )
set ( CPACK_RPM_PACKAGE_VERSION
      "${OR_TOOLS_VERSION_MAJOR}.${OR_TOOLS_VERSION_MINOR}.${OR_TOOLS_VERSION_PATCH}" )
set ( CPACK_RPM_PACKAGE_RELEASE
      "${OR_TOOLS_VERSION_REL}" )
set ( CPACK_PACKAGE_FILE_NAME
      "${CPACK_RPM_PACKAGE_NAME}-${CPACK_RPM_PACKAGE_VERSION}-${CPACK_RPM_PACKAGE_RELEASE}" )

# -------------------------------------------------------------------
# DEPENDENCIES 
# -------------------------------------------------------------------
# CMake scripts path
set ( CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/ )

# ...................................................................
  # Meant to find /usr/lib/cmake/gflags/gflags-config.cmake
  # distributed by https://github.com/schuhschuh/gflags
  set ( GFLAGS_NAMESPACE "gflags" )
  find_package ( gflags 2.1.1 REQUIRED )
# ...................................................................
  find_package ( Protobuf 3 REQUIRED )
# ...................................................................
  find_path ( SPARSEHASH_INCLUDE_DIR "google/dense_hash_map" )

  if(NOT SPARSEHASH_INCLUDE_DIR)
      message(SEND_ERROR "Sparse Hash is required. Set SPARSEHASH_INCLUDE_DIR to the location of the headers")
  endif()

  message(STATUS "Sparse Hash headers : ${SPARSEHASH_INCLUDE_DIR}")
# ...................................................................
  find_package ( FLEX REQUIRED )
# ...................................................................
  find_package ( BISON REQUIRED )
# ...................................................................

#
# COIN-OR CLP / CBC
#

#
# COIN-OR Coin LP
#

#
# GLPK
#

# 
# SCIP
#

# 
# Sulum
#

#
# GUROBI
#

# CPLEX

#
# (not implemented yet)
#

#
# Swig (GLPK, CLP, CBC, SCIP, SLM, CPLEX, GUROBI, CPLEX) 
#
find_package(SWIG)
# include(${SWIG_USE_FILE})


#
# Python.h
#

#
# Java
#
find_package(JNI)
find_package(Java COMPONENTS Development)
include(UseJava)

#
# Mono
#

# -------------------------------------------------------------------
# GENERATED CODE
# -------------------------------------------------------------------

#
# Flex & Bison
#
#make_directory(${CMAKE_BINARY_DIR}/old_flatzinc)
#BISON_TARGET(OLD_FLATZINC_PARSER "src/old_flatzinc/flatzinc.yy" "${CMAKE_BINARY_DIR}/old_flatzinc/flatzinc.tab.cc" )
#FLEX_TARGET(OLD_FLATZINC_SCANNER "src/old_flatzinc/flatzinc.lex" "${CMAKE_BINARY_DIR}/old_flatzinc/flatzinc.yy.cc" )
#ADD_FLEX_BISON_DEPENDENCY(OLD_FLATZINC_SCANNER OLD_FLATZINC_PARSER)

#make_directory(${CMAKE_BINARY_DIR}/flatzinc)
#BISON_TARGET(FLATZINC_PARSER "src/flatzinc/parser.yy" "${CMAKE_BINARY_DIR}/flatzinc/parser.tab.cc" )
#FLEX_TARGET(FLATZINC_SCANNER "src/flatzinc/parser.lex" "${CMAKE_BINARY_DIR}/flatzinc/parser.yy.cc" )
#ADD_FLEX_BISON_DEPENDENCY(FLATZINC_SCANNER FLATZINC_PARSER)

#
# Protobuf 
#

# This allows to find the other protos when compiling a proto
set ( PROTOBUF_IMPORT_DIRS "${CMAKE_SOURCE_DIR}/src" )

PROTOBUF_GENERATE_CPP ( OR_TOOLS_GENERATED_CODE OR_TOOLS_GENERATED_HEADERS "${CMAKE_SOURCE_DIR}/src/sat/boolean_problem.proto" )
PROTOBUF_GENERATE_CPP ( OR_TOOLS_GENERATED_CODE OR_TOOLS_GENERATED_HEADERS "${CMAKE_SOURCE_DIR}/src/sat/sat_parameters.proto" )
PROTOBUF_GENERATE_CPP ( OR_TOOLS_GENERATED_CODE OR_TOOLS_GENERATED_HEADERS "${CMAKE_SOURCE_DIR}/src/graph/flow_problem.proto" )
PROTOBUF_GENERATE_CPP ( OR_TOOLS_GENERATED_CODE OR_TOOLS_GENERATED_HEADERS "${CMAKE_SOURCE_DIR}/src/linear_solver/linear_solver.proto" )
PROTOBUF_GENERATE_CPP ( OR_TOOLS_GENERATED_CODE OR_TOOLS_GENERATED_HEADERS "${CMAKE_SOURCE_DIR}/src/constraint_solver/search_limit.proto" )
PROTOBUF_GENERATE_CPP ( OR_TOOLS_GENERATED_CODE OR_TOOLS_GENERATED_HEADERS "${CMAKE_SOURCE_DIR}/src/constraint_solver/model.proto" )
PROTOBUF_GENERATE_CPP ( OR_TOOLS_GENERATED_CODE OR_TOOLS_GENERATED_HEADERS "${CMAKE_SOURCE_DIR}/src/constraint_solver/assignment.proto" )
PROTOBUF_GENERATE_CPP ( OR_TOOLS_GENERATED_CODE OR_TOOLS_GENERATED_HEADERS "${CMAKE_SOURCE_DIR}/src/constraint_solver/demon_profiler.proto" )
PROTOBUF_GENERATE_CPP ( OR_TOOLS_GENERATED_CODE OR_TOOLS_GENERATED_HEADERS "${CMAKE_SOURCE_DIR}/src/constraint_solver/solver_parameters.proto" )
PROTOBUF_GENERATE_CPP ( OR_TOOLS_GENERATED_CODE OR_TOOLS_GENERATED_HEADERS "${CMAKE_SOURCE_DIR}/src/constraint_solver/routing_parameters.proto" )
PROTOBUF_GENERATE_CPP ( OR_TOOLS_GENERATED_CODE OR_TOOLS_GENERATED_HEADERS "${CMAKE_SOURCE_DIR}/src/constraint_solver/routing_enums.proto" )
PROTOBUF_GENERATE_CPP ( OR_TOOLS_GENERATED_CODE OR_TOOLS_GENERATED_HEADERS "${CMAKE_SOURCE_DIR}/src/glop/parameters.proto" )
PROTOBUF_GENERATE_CPP ( OR_TOOLS_GENERATED_CODE OR_TOOLS_GENERATED_HEADERS "${CMAKE_SOURCE_DIR}/src/bop/bop_parameters.proto" )

# -------------------------------------------------------------------
# HEADERS & COMPILE FLAGS 
# -------------------------------------------------------------------
message("[TODO] DON'T INCLUDE ALL!")
include_directories ( "${CMAKE_SOURCE_DIR}/src"
                      "${CMAKE_CURRENT_BINARY_DIR}"
                      "${PROTOBUF_INCLUDE_DIRS}"
                      "${gflags_INCLUDE_DIR}"
                      "${SPARSEHASH_INCLUDE_DIR}" )

set ( CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++11" )

# -------------------------------------------------------------------
# TARGETS 
# -------------------------------------------------------------------

file(GLOB_RECURSE OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/*.cc")

# The following files weren't compiled in the original Makefile:
list(REMOVE_ITEM OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/glop/matrix_utils.cc")
list(REMOVE_ITEM OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/glop/proto_driver.cc")
list(REMOVE_ITEM OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/lp_data/png_dump.cc")
# I don't get to compile the flex/bison code:
list(REMOVE_ITEM OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/old_flatzinc/booleans.cc")
list(REMOVE_ITEM OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/old_flatzinc/flatzinc_constraints.cc")
list(REMOVE_ITEM OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/old_flatzinc/fz_search.cc")
list(REMOVE_ITEM OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/old_flatzinc/registry.cc")
list(REMOVE_ITEM OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/old_flatzinc/flatzinc.cc")
list(REMOVE_ITEM OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/old_flatzinc/fz.cc")
list(REMOVE_ITEM OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/old_flatzinc/parser.cc")
list(REMOVE_ITEM OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/flatzinc/constraints.cc")
list(REMOVE_ITEM OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/flatzinc/flatzinc_constraints.cc")
list(REMOVE_ITEM OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/flatzinc/fz.cc")
list(REMOVE_ITEM OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/flatzinc/model.cc")
list(REMOVE_ITEM OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/flatzinc/parallel_support.cc")
list(REMOVE_ITEM OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/flatzinc/parser.cc")
list(REMOVE_ITEM OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/flatzinc/parser_main.cc")
list(REMOVE_ITEM OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/flatzinc/presolve.cc")
list(REMOVE_ITEM OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/flatzinc/sat_constraint.cc")
list(REMOVE_ITEM OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/flatzinc/search.cc")
list(REMOVE_ITEM OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/flatzinc/sequential_support.cc")
list(REMOVE_ITEM OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/flatzinc/solver.cc")

add_library(OR_TOOLS_LIBRARIES SHARED ${OR_TOOLS_SOURCES} 
                                      ${OR_TOOLS_GENERATED_CODE}
                                      ${BISON_OLD_FLATZINC_PARSER_OUTPUTS}
                                      ${FLEX_OLD_FLATZINC_SCANNER_OUTPUTS} 
                                      ${BISON_FLATZINC_PARSER_OUTPUTS} 
                                      ${FLEX_FLATZINC_SCANNER_OUTPUTS} ) 

target_link_libraries (OR_TOOLS_LIBRARIES ${gflags_LIBRARIES}
                                          ${PROTOBUF_LIBRARIES} 
                                          ${FLEX_LIBRARIES} )

set_target_properties(OR_TOOLS_LIBRARIES PROPERTIES OUTPUT_NAME "ortools")


#
# Java libraries
#
message("[TODO] WRITE THE VALUE OF THE JAVA VARIABLES TO STDOUT TO SHOW THE USER WHAT'S MISSING")
if (DEFINED Java_JAVAC_EXECUTABLE AND
    DEFINED Java_JAR_EXECUTABLE AND
    DEFINED Java_JAVAC_EXECUTABLE AND 
    JAVA_FOUND AND SWIG_FOUND AND JNI_FOUND)
    include("CMakeLists.java")
endif()


# add_custom_target (
#              check
#              COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure 
#              COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target package 
#              COMMAND rpmlint ${CPACK_PACKAGE_FILE_NAME}.rpm
#              DEPENDS ${check_DEPS}
#              )

install ( TARGETS OR_TOOLS_LIBRARIES
              RUNTIME DESTINATION bin
              LIBRARY DESTINATION lib
              ARCHIVE DESTINATION share/${PROJECT_NAME} )

# feature_summary()
