# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(user_library VERSION 0.0.1 LANGUAGES C)

add_library(user SHARED
  "user.c"
)

set_target_properties(user PROPERTIES
  PUBLIC_HEADER user.h
  OUTPUT_NAME "user"
)

target_compile_definitions(user PUBLIC DART_SHARED_LIB)
