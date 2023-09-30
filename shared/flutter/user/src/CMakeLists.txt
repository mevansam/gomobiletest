# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

set(LIB    user)
set(LIB_GO ${LIB}_go)
set(LIB_C  ${LIB}_c)

project(${LIB}_library LANGUAGES C)

file(GLOB GO_SRCS ${CMAKE_CURRENT_SOURCE_DIR}/go/*.go)
file(GLOB C_SRCS  ${CMAKE_CURRENT_SOURCE_DIR}/*.c)

add_custom_target(gobuild
  DEPENDS ${GO_SRCS}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/go
  COMMAND env GOPATH=${GOPATH} go build -buildmode=c-archive -o "${CMAKE_CURRENT_BINARY_DIR}/lib${LIB_GO}.a" ${CMAKE_GO_FLAGS} ./...
  COMMENT "Building Go library"
)
add_library(${LIB_GO} STATIC IMPORTED GLOBAL)
add_dependencies(${LIB_GO} gobuild)
set_target_properties(${LIB_GO} 
  PROPERTIES
    IMPORTED_LOCATION ${CMAKE_CURRENT_BINARY_DIR}/lib${LIB_GO}.a
    INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_CURRENT_BINARY_DIR})

add_library(${LIB} SHARED ${C_SRCS})
target_link_libraries(${LIB} ${LIB_GO})

if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  target_link_options(${LIB} PRIVATE "-all_load")
else()
  target_link_options(${LIB} PRIVATE "--whole-archive")
endif()

target_compile_definitions(${LIB} PUBLIC DART_SHARED_LIB)

set_target_properties(${LIB}
  PROPERTIES
    PUBLIC_HEADER ${LIB}.h
    OUTPUT_NAME ${LIB}
)
