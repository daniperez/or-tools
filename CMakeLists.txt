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

find_package ( GFlags   REQUIRED )

find_package ( Protobuf REQUIRED )

#
# Sparse Hash
#
find_path ( SPARSEHASH_INCLUDE_DIR "google/dense_hash_map" )

if(NOT SPARSEHASH_INCLUDE_DIR)
    message(SEND_ERROR "Sparse Hash is required. Set SPARSEHASH_INCLUDE_DIR to the location of the headers")
endif()

message(STATUS "Sparse Hash headers : ${SPARSEHASH_INCLUDE_DIR}")


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

#
# Python.h
#

#
# Java
#

#
# Mono
#

# Generated code

# This allows to find the other protos when compiling a proto
set ( PROTOBUF_IMPORT_DIRS "${CMAKE_SOURCE_DIR}/src/" )

PROTOBUF_GENERATE_CPP ( OR_TOOLS_GENERATED_CODE OR_TOOLS_GENERATED_HEADERS "${CMAKE_SOURCE_DIR}/src/sat/boolean_problem.proto" )
PROTOBUF_GENERATE_CPP ( OR_TOOLS_GENERATED_CODE OR_TOOLS_GENERATED_HEADERS "${CMAKE_SOURCE_DIR}/src/sat/sat_parameters.proto" )
PROTOBUF_GENERATE_CPP ( OR_TOOLS_GENERATED_CODE OR_TOOLS_GENERATED_HEADERS "${CMAKE_SOURCE_DIR}/src/linear_solver/linear_solver2.proto" )
PROTOBUF_GENERATE_CPP ( OR_TOOLS_GENERATED_CODE OR_TOOLS_GENERATED_HEADERS "${CMAKE_SOURCE_DIR}/src/constraint_solver/model.proto" )
PROTOBUF_GENERATE_CPP ( OR_TOOLS_GENERATED_CODE OR_TOOLS_GENERATED_HEADERS "${CMAKE_SOURCE_DIR}/src/constraint_solver/assignment.proto" )
PROTOBUF_GENERATE_CPP ( OR_TOOLS_GENERATED_CODE OR_TOOLS_GENERATED_HEADERS "${CMAKE_SOURCE_DIR}/src/constraint_solver/search_limit.proto" )
PROTOBUF_GENERATE_CPP ( OR_TOOLS_GENERATED_CODE OR_TOOLS_GENERATED_HEADERS "${CMAKE_SOURCE_DIR}/src/constraint_solver/demon_profiler.proto" )
PROTOBUF_GENERATE_CPP ( OR_TOOLS_GENERATED_CODE OR_TOOLS_GENERATED_HEADERS "${CMAKE_SOURCE_DIR}/src/glop/parameters.proto" )
PROTOBUF_GENERATE_CPP ( OR_TOOLS_GENERATED_CODE OR_TOOLS_GENERATED_HEADERS "${CMAKE_SOURCE_DIR}/src/bop/bop_parameters.proto" )

# -------------------------------------------------------------------
# HEADERS & COMPILE FLAGS 
# -------------------------------------------------------------------
include_directories ( "${CMAKE_SOURCE_DIR}/src"
                      "${CMAKE_CURRENT_BINARY_DIR}"
                      "${GFLAGS_INCLUDE_DIR}"
                      "${SPARSEHASH_INCLUDE_DIR}" )

set ( CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++11" )

# -------------------------------------------------------------------
# TARGETS 
# -------------------------------------------------------------------

file ( GLOB_RECURSE OR_TOOLS_SOURCES "${CMAKE_SOURCE_DIR}/src/*.cc" )

add_library(OR_TOOLS_LIBRARIES ${OR_TOOLS_SOURCES} ${OR_TOOLS_GENERATED_CODE})

# algorithms  base  bop  com  constraint_solver  flatzinc  glop  graph  linear_solver  lp_data  old_flatzinc  ortools  sat  util
#add_library ( OR_TOOLS_LIBRARIES
#    # Algorithms
#    "src/algorithms/dynamic_partition.cc"
#    "src/algorithms/find_graph_symmetries.cc"
#    "src/algorithms/knapsack_solver.cc"
#    "src/algorithms/dynamic_permutation.cc"
#    "src/algorithms/hungarian.cc"
#    "src/algorithms/sparse_permutation.cc"
#    # Base
#    "src/base/bitmap.cc"
#    "src/base/join.cc"
#    "src/base/random.cc"
#    "src/base/stringprintf.cc"
#    "src/base/time_support.cc
#    "src/base/callback.cc"
#    "src/base/logging.cc"
#    "src/base/recordio.cc"
#    "src/base/sysinfo.cc"
#    "src/base/file.cc"
#    "src/base/mutex.cc"
#    "src/base/split.cc        src/base/threadpool.cc
#src/base/filelinereader.cc  src/base/numbers.cc  src/base/stringpiece.cc  src/base/timer.cc


target_link_libraries ( OR_TOOLS_LIBRARIES "${GFLAGS_LIBRARY}"
                                           "${PROTOBUF_LIBRARIES}" )
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
