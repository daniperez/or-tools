# ==========================================
# Generates SWIG C++ stubs and Java wrappers
# ==========================================
function(generate_swig SWIG_FILE _SWIG_FILE 
                       OUTPUT_FILE _OUTPUT_FILE
                       OUTPUT_DIR _OUTPUT_DIR
                       PACKAGE _PACKAGE
                       MODULE _MODULE)

    set ( OUTPUT_FILE_FULL_PATH "${_OUTPUT_DIR}/${_OUTPUT_FILE}" )

    add_custom_command(
                       OUTPUT ${OUTPUT_FILE_FULL_PATH}
                       DEPENDS ${_SWIG_FILE} OR_TOOLS_LIBRARIES
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

set(SWIG_OUTPUT_DIR "${CMAKE_BINARY_DIR}/com/google/ortools/")

generate_swig(
    SWIG_FILE "${CMAKE_SOURCE_DIR}/src/constraint_solver/java/constraint_solver.swig"
    OUTPUT_FILE "constraint_solver_java_wrap.cc"
    OUTPUT_DIR "${SWIG_OUTPUT_DIR}/constraint_solver"
    PACKAGE "com.google.ortools.constraintsolver"
    MODULE "operations_research_constraint_solver")

generate_swig(
    SWIG_FILE "${CMAKE_SOURCE_DIR}/src/algorithms/java/knapsack_solver.swig"
    OUTPUT_FILE "knapsack_solver_java_wrap.cc"
    OUTPUT_DIR "${SWIG_OUTPUT_DIR}/algorithms"
    PACKAGE "com.google.ortools.algorithms"
    MODULE "operations_research_algorithms")

generate_swig(
    SWIG_FILE "${CMAKE_SOURCE_DIR}/src/graph/java/graph.swig"
    OUTPUT_FILE "graph_java_wrap.cc"
    OUTPUT_DIR "${SWIG_OUTPUT_DIR}/graph"
    PACKAGE "com.google.ortools.graph"
    MODULE "operations_research_graph")

generate_swig(
    SWIG_FILE "${CMAKE_SOURCE_DIR}/src/linear_solver/java/linear_solver.swig"
    OUTPUT_FILE "linear_solver_java_wrap.cc"
    OUTPUT_DIR "${SWIG_OUTPUT_DIR}/linear_solver"
    PACKAGE "com.google.ortools.linearsolver"
    MODULE "operations_research_linear_solver")

generate_swig(
    SWIG_FILE "${CMAKE_SOURCE_DIR}/src/linear_solver/java/linear_solver.swig"
    OUTPUT_FILE "linear_solver_java_wrap.cc"
    OUTPUT_DIR "${SWIG_OUTPUT_DIR}/linear_solver"
    PACKAGE "com.google.ortools.linearsolver"
    MODULE "operations_research_linear_solver")


# ====================================
# Generate JNI library with SWIG stubs
# ====================================
include_directories(${JNI_INCLUDE_DIRS})

add_library( OR_TOOLS_JAVA_LIBRARIES SHARED  
    "${SWIG_OUTPUT_DIR}/constraint_solver/constraint_solver_java_wrap.cc"
    "${SWIG_OUTPUT_DIR}/algorithms/knapsack_solver_java_wrap.cc"
    "${SWIG_OUTPUT_DIR}/graph/graph_java_wrap.cc"
    "${SWIG_OUTPUT_DIR}/linear_solver/linear_solver_java_wrap.cc"
)

target_link_libraries( OR_TOOLS_JAVA_LIBRARIES ${OR_TOOLS_LIBRARIES} ${JNI_LIBRARIES})

set_target_properties( OR_TOOLS_JAVA_LIBRARIES PROPERTIES OUTPUT_NAME "ortools_java")

# ==========
# Create jar
# ==========

set ( OR_TOOLS_JAVA_FILES
    ${CMAKE_BINARY_DIR}/com/google/ortools/algorithms/*.java
    ${CMAKE_BINARY_DIR}/com/google/ortools/graph/*.java
    ${CMAKE_BINARY_DIR}/com/google/ortools/constraint_solver/*.java
    ${CMAKE_BINARY_DIR}/com/google/ortools/linear_solver/*.java
    ##
    ${CMAKE_SOURCE_DIR}/src/com/google/ortools/constraintsolver/JavaDecisionBuilder.java
)

set (OR_TOOLS_JAR ${CMAKE_BINARY_DIR}/ortools-${CPACK_RPM_PACKAGE_VERSION}.jar)

add_custom_command(TARGET OR_TOOLS_JAVA_LIBRARIES POST_BUILD
                   COMMAND ${CMAKE_COMMAND} -E make_directory classes
                   COMMAND ${Java_JAVAC_EXECUTABLE} -d classes ${OR_TOOLS_JAVA_FILES}
                   COMMAND ${Java_JAR_EXECUTABLE} cf ${OR_TOOLS_JAR} -C classes .
                   COMMAND ${Java_JAR_EXECUTABLE} uf ${OR_TOOLS_JAR} $<TARGET_FILE_NAME:OR_TOOLS_JAVA_LIBRARIES>
                   COMMAND ${Java_JAR_EXECUTABLE} uf ${OR_TOOLS_JAR} $<TARGET_FILE_NAME:OR_TOOLS_LIBRARIES>
                   COMMENT "Generating ${OR_TOOLS_JAR}...")
