# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

set(LIB    user)
set(LIB_GO ${LIB}_go)
set(LIB_C  ${LIB}_c)

project(${LIB}_library LANGUAGES C)

get_filename_component(ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/.. ABSOLUTE)

file(GLOB GO_SRCS ${CMAKE_CURRENT_SOURCE_DIR}/go/*.go)
file(GLOB C_SRCS  ${CMAKE_CURRENT_SOURCE_DIR}/*.c)

add_custom_target(go_build
  DEPENDS ${GO_SRCS}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/go
  COMMAND env GOPATH=${GOPATH} go build -buildmode=c-archive -o "${CMAKE_CURRENT_BINARY_DIR}/lib${LIB_GO}.a" ${CMAKE_GO_FLAGS} ./...
  COMMENT "Building Go library"
)
add_library(${LIB_GO} STATIC IMPORTED GLOBAL)
add_dependencies(${LIB_GO} go_build)
set_target_properties(${LIB_GO} 
  PROPERTIES
    IMPORTED_LOCATION ${CMAKE_CURRENT_BINARY_DIR}/lib${LIB_GO}.a
    INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_CURRENT_BINARY_DIR})

add_library(${LIB} SHARED ${C_SRCS})
target_link_libraries(${LIB} ${LIB_GO})

if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  target_link_options(${LIB} PRIVATE "-all_load")
  set(SHARED_LIB_NAME lib${LIB}.dylib)
else()
  target_link_options(${LIB} PRIVATE "--whole-archive")
  set(SHARED_LIB_NAME lib${LIB}.so)
endif()

target_compile_definitions(${LIB} PUBLIC DART_SHARED_LIB)

set_target_properties(${LIB}
  PROPERTIES
    PUBLIC_HEADER ${LIB}.h
    OUTPUT_NAME ${LIB}
)

add_custom_target(test
  DEPENDS ${LIB}
  WORKING_DIRECTORY ${ROOT_DIR}
  COMMAND ${CMAKE_COMMAND} -E make_directory ${ROOT_DIR}/user.framework
  COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/${SHARED_LIB_NAME} ${ROOT_DIR}/user.framework/${LIB}
  COMMAND dart test ${ROOT_DIR}/test
  COMMENT "Running user plugin tests"
)
