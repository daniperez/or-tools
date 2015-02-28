#
#  Generates SWIG stubs
#
function(generate_swig SWIG_FILE _SWIG_FILE 
                       OUTPUT_FILE _OUTPUT_FILE
                       OUTPUT_DIR _OUTPUT_DIR
                       PACKAGE _PACKAGE
                       MODULE _MODULE)

    set ( OUTPUT_FILE_FULL_PATH "${_OUTPUT_DIR}/${_OUTPUT_FILE}" )

    add_custom_command(
                       OUTPUT ${OUTPUT_FILE_FULL_PATH}
                       DEPENDS ${_SWIG_FILE}
                       COMMAND ${CMAKE_COMMAND} -E make_directory ${_OUTPUT_DIR}
                       COMMAND ${SWIG_EXECUTABLE}
                       ARGS    -c++ -java
                               -o ${OUTPUT_FILE_FULL_PATH}
                               -package ${_PACKAGE} 
                               -module ${_MODULE}
                               -outdir "${_OUTPUT_DIR}"
                               -I${CMAKE_SOURCE_DIR}/src
                               ${_SWIG_FILE}
                       COMMENT "Generating Java interface ${_SWIG_FILE} ...")

endfunction()

generate_swig(
    SWIG_FILE "${CMAKE_SOURCE_DIR}/src/constraint_solver/java/constraint_solver.swig"
    OUTPUT_FILE "constraint_solver_java_wrap.cc"
    OUTPUT_DIR "${CMAKE_BINARY_DIR}/constraint_solver"
    PACKAGE "com.google.ortools.constraintsolver"
    MODULE "operations_research_constraint_solver")

generate_swig(
    SWIG_FILE "${CMAKE_SOURCE_DIR}/src/algorithms/java/knapsack_solver.swig"
    OUTPUT_FILE "knapsack_solver_java_wrap.cc"
    OUTPUT_DIR "${CMAKE_BINARY_DIR}/algorithms"
    PACKAGE "com.google.ortools.algorithms"
    MODULE "operations_research_algorithms")

generate_swig(
    SWIG_FILE "${CMAKE_SOURCE_DIR}/src/graph/java/graph.swig"
    OUTPUT_FILE "graph_java_wrap.cc"
    OUTPUT_DIR "${CMAKE_BINARY_DIR}/graph"
    PACKAGE "com.google.ortools.graph"
    MODULE "operations_research_graph")

generate_swig(
    SWIG_FILE "${CMAKE_SOURCE_DIR}/src/linear_solver/java/linear_solver.swig"
    OUTPUT_FILE "linear_solver_java_wrap.cc"
    OUTPUT_DIR "${CMAKE_BINARY_DIR}/linear_solver"
    PACKAGE "com.google.ortools.linearsolver"
    MODULE "operations_research_linear_solver")

include_directories(${JNI_INCLUDE_DIRS})

ADD_LIBRARY( ortools_java SHARED  
    "${CMAKE_BINARY_DIR}/constraint_solver/constraint_solver_java_wrap.cc"
    "${CMAKE_BINARY_DIR}/algorithms/knapsack_solver_java_wrap.cc"
    "${CMAKE_BINARY_DIR}/graph/graph_java_wrap.cc"
    "${CMAKE_BINARY_DIR}/linear_solver/linear_solver_java_wrap.cc"
)

TARGET_LINK_LIBRARIES( ortools_java ${OR_TOOLS_LIBRARIES} ${JNI_LIBRARIES})
