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

# ====================================
# Generate JNI library with SWIG stubs
# ====================================
include_directories(${JNI_INCLUDE_DIRS})

add_library( ortools_java SHARED  
    "${SWIG_OUTPUT_DIR}/constraint_solver/constraint_solver_java_wrap.cc"
    "${SWIG_OUTPUT_DIR}/algorithms/knapsack_solver_java_wrap.cc"
    "${SWIG_OUTPUT_DIR}/graph/graph_java_wrap.cc"
    "${SWIG_OUTPUT_DIR}/linear_solver/linear_solver_java_wrap.cc"
)

target_link_libraries( ortools_java ${OR_TOOLS_LIBRARIES} ${JNI_LIBRARIES})

# ==========
# Compile 
# ==========
add_custom_command(
   OUTPUT ${CMAKE_BINARY_DIR}/
   DEPENDS ortools_java 
   COMMAND ${Java_JAVAC_EXECUTABLE} -d ${CMAKE_BINARY_DIR} -C ${CMAKE_BINARY_DIR} 
           ${CMAKE_SOURCE_DIR}/com/google/ortools/*.java
           COMMENT "Compiling java samples ...")

#$(JAVAC_BIN) -d $(OBJ_DIR) $(SRC_DIR)$Scom$Sgoogle$Sortools$Sconstraintsolver$S*.java $(GEN_DIR)$Scom$Sgoogle$Sortools$Sconstraintsolver$S*.java $(GEN_DIR)$Scom$Sgoogle$Sortools$Salgorithms$S*.java $(GEN_DIR)$Scom$Sgoogle$Sortools$Sgraph$S*.java $(GEN_DIR)$Scom$Sgoogle$Sortools$Slinearsolver$S*.java


# ==========
# Create jar
# ==========
set(OR_TOOLS_JAR com.google.ortools.jar)

add_custom_command(
   OUTPUT ${CMAKE_BINARY_DIR}/${OR_TOOLS_JAR}
   DEPENDS ortools_java 
   COMMAND ${Java_JAR_EXECUTABLE} cf ${OR_TOOLS_JAR} -C ${CMAKE_BINARY_DIR} com/google/ortools/
   COMMENT "Generating ${OR_TOOLS_JAR} ...")

