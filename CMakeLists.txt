cmake_minimum_required(VERSION 3.5)
project(Bil395_HW1 C)

set(CMAKE_C_STANDARD 99)

#add_executable(Bil395_HW1 main.c)

find_package(BISON)
find_package(FLEX)

include_directories(${CMAKE_SOURCE_DIR})



FLEX_TARGET(MyScanner prog.lex  ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.c)
BISON_TARGET(MyParser prog.yacc ${CMAKE_CURRENT_BINARY_DIR}/y.tab.c COMPILE_FLAGS -d)

ADD_FLEX_BISON_DEPENDENCY(MyScanner MyParser)

include_directories(${CMAKE_CURRENT_BINARY_DIR})
add_executable(Interpreter
        ${BISON_MyParser_OUTPUTS}
        ${FLEX_MyScanner_OUTPUTS}
        )