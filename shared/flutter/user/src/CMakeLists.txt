# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

set(LIB    user)
set(LIB_GO ${LIB}_go)

project(${LIB}_library LANGUAGES C)

get_filename_component(ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/.. ABSOLUTE)

file(GLOB GO_SRCS ${CMAKE_CURRENT_SOURCE_DIR}/go/*.go)
file(GLOB C_SRCS  ${CMAKE_CURRENT_SOURCE_DIR}/*.c)

# Targets for building apple ios/macos libraries
add_custom_target(go_build_iphoneos_arm64
  DEPENDS ${GO_SRCS}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/go
  COMMENT "Building Go iOS iPhone arm64 library"
  COMMAND go clean -cache
  COMMAND env 
    IPHONEOS_DEPLOYMENT_TARGET=12.0 
    GOOS=darwin 
    GOARCH=arm64 
    SDK=iphoneos
    CC=${CMAKE_CURRENT_SOURCE_DIR}/go/clangwrap-ios.sh
    CGO_ENABLED=1
    CGO_CFLAGS="-fembed-bitcode"
    go build -buildmode=c-archive -tags ios -o "${CMAKE_CURRENT_BINARY_DIR}/lib${LIB_GO}_iphoneos_arm64.a" ${CMAKE_GO_FLAGS} ./...
)
add_custom_target(go_build_iphonesimulator_arm64
  DEPENDS ${GO_SRCS}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/go
  COMMENT "Building Go iOS iPhone Simulator arm64 library"
  COMMAND go clean -cache
  COMMAND env 
    IPHONEOS_DEPLOYMENT_TARGET=12.0 
    GOOS=darwin 
    GOARCH=arm64 
    SDK=iphonesimulator
    CC=${CMAKE_CURRENT_SOURCE_DIR}/go/clangwrap-ios.sh
    CGO_ENABLED=1
    CGO_CFLAGS="-fembed-bitcode"
    go build -buildmode=c-archive -tags ios -o "${CMAKE_CURRENT_BINARY_DIR}/lib${LIB_GO}_iphonesimulator_arm64.a" ${CMAKE_GO_FLAGS} ./...
)
add_custom_target(go_build_iphonesimulator_amd64
  DEPENDS ${GO_SRCS}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/go
  COMMENT "Building Go iOS iPhone Simulator amd64 library"
  COMMAND go clean -cache
  COMMAND env 
    IPHONEOS_DEPLOYMENT_TARGET=12.0 
    GOOS=darwin 
    GOARCH=amd64 
    SDK=iphonesimulator
    CC=${CMAKE_CURRENT_SOURCE_DIR}/go/clangwrap-ios.sh
    CGO_ENABLED=1
    CGO_CFLAGS="-fembed-bitcode"
    go build -buildmode=c-archive -tags ios -o "${CMAKE_CURRENT_BINARY_DIR}/lib${LIB_GO}_iphonesimulator_amd64.a" ${CMAKE_GO_FLAGS} ./...
)
add_custom_target(go_build_macosx_arm64
  DEPENDS ${GO_SRCS}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/go
  COMMENT "Building Go macOS arm64 library"
  COMMAND go clean -cache
  COMMAND env 
    MACOSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET} 
    GOOS=darwin 
    GOARCH=arm64 
    CGO_ENABLED=1
    go build -buildmode=c-archive -tags macos -o "${CMAKE_CURRENT_BINARY_DIR}/lib${LIB_GO}_macosx_arm64.a" ${CMAKE_GO_FLAGS} ./...
)
add_custom_target(go_build_macosx_amd64
  DEPENDS ${GO_SRCS}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/go
  COMMENT "Building Go macOS amd64 library"
  COMMAND go clean -cache
  COMMAND env 
    MACOSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET} 
    GOOS=darwin 
    GOARCH=amd64 
    CGO_ENABLED=1
    go build -buildmode=c-archive -tags macos -o "${CMAKE_CURRENT_BINARY_DIR}/lib${LIB_GO}_macosx_amd64.a" ${CMAKE_GO_FLAGS} ./...
)

# Targets for building apple android libraries
add_custom_target(go_build_android_armeabi-v7a
  DEPENDS ${GO_SRCS}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/go
  BYPRODUCTS lib${LIB_GO}_armeabi-v7a.so
  COMMENT "Building Go Android armv7a library"
  COMMAND go clean -cache
  COMMAND env 
    GOOS=android 
    GOARCH=arm 
    GOARM=7
    CC=${CMAKE_CURRENT_SOURCE_DIR}/go/clangwrap-android.sh
    CGO_ENABLED=1
    go build -buildmode=c-shared -tags android -o "${CMAKE_CURRENT_BINARY_DIR}/lib${LIB_GO}_armeabi-v7a.so" ${CMAKE_GO_FLAGS} ./...
)
add_custom_target(go_build_android_arm64-v8a
  DEPENDS ${GO_SRCS}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/go
  BYPRODUCTS lib${LIB_GO}_arm64-v8a.so
  COMMENT "Building Go Android arm64 library"
  COMMAND go clean -cache
  COMMAND env 
    GOOS=android 
    GOARCH=arm64 
    CC=${CMAKE_CURRENT_SOURCE_DIR}/go/clangwrap-android.sh
    CGO_ENABLED=1
    go build -buildmode=c-shared -tags android -o "${CMAKE_CURRENT_BINARY_DIR}/lib${LIB_GO}_arm64-v8a.so" ${CMAKE_GO_FLAGS} ./...
)
add_custom_target(go_build_android_x86
  DEPENDS ${GO_SRCS}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/go
  BYPRODUCTS lib${LIB_GO}_x86.so
  COMMENT "Building Go Android 386 library"
  COMMAND env 
    GOOS=android 
    GOARCH=386 
    CC=${CMAKE_CURRENT_SOURCE_DIR}/go/clangwrap-android.sh
    CGO_ENABLED=1
    go build -buildmode=c-shared -tags android -o "${CMAKE_CURRENT_BINARY_DIR}/lib${LIB_GO}_x86.so" ${CMAKE_GO_FLAGS} ./...
)
add_custom_target(go_build_android_x86_64
  DEPENDS ${GO_SRCS}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/go
  BYPRODUCTS lib${LIB_GO}_x86_64.so
  COMMENT "Building Go Android amd64 library"
  COMMAND env 
    GOOS=android 
    GOARCH=amd64 
    CC=${CMAKE_CURRENT_SOURCE_DIR}/go/clangwrap-android.sh
    CGO_ENABLED=1
    go build -buildmode=c-shared -tags android -o "${CMAKE_CURRENT_BINARY_DIR}/lib${LIB_GO}_x86_64.so" ${CMAKE_GO_FLAGS} ./...
)

# Build final shared go library for linking
if(DEFINED ENV{PLATFORM_NAME})

  # Multi-platform go build for Apple systems
  #
  # For XCode builds PLATFORM_NAME environment variable 
  # will be set by the XCode build system to one of:
  # - macosx for macOS builds
  # - iphoneos for iOS builds
  # - iphonesimulator for iOS simulator builds
  #
  if($ENV{PLATFORM_NAME} STREQUAL "iphoneos")
    add_custom_target(go_build
      COMMENT "Building single library module for iOS iphone systems"
      COMMAND make go_build_iphoneos_arm64
      COMMAND cp 
        "${CMAKE_CURRENT_BINARY_DIR}/lib${LIB_GO}_iphoneos_arm64.a"
        "${CMAKE_CURRENT_BINARY_DIR}/lib${LIB_GO}.a"
    )
  else()
    add_custom_target(go_build
      COMMENT "Building single multi-arch library module for Darwin systems"
      COMMAND make go_build_\${PLATFORM_NAME}_arm64 go_build_\${PLATFORM_NAME}_amd64
      COMMAND lipo 
        "${CMAKE_CURRENT_BINARY_DIR}/lib${LIB_GO}_\${PLATFORM_NAME}_arm64.a" 
        "${CMAKE_CURRENT_BINARY_DIR}/lib${LIB_GO}_\${PLATFORM_NAME}_amd64.a" 
        -create -output "${CMAKE_CURRENT_BINARY_DIR}/lib${LIB_GO}.a"
    )
  endif()

elseif(NOT DEFINED ANDROID_ABI)

  # Multi-platform go build for platforms other than Apple and Android
  add_custom_target(go_build
    DEPENDS ${GO_SRCS}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/go
    COMMENT "Building Go library"
    COMMAND go clean -cache
    COMMAND env 
      go build -buildmode=c-archive -o "${CMAKE_CURRENT_BINARY_DIR}/lib${LIB_GO}.a" ${CMAKE_GO_FLAGS} ./...
  )
endif()

if(DEFINED ANDROID_ABI)
  # For Android the go library is built as a shared library
  add_library(${LIB_GO} SHARED IMPORTED)
  add_dependencies(${LIB_GO} go_build_android_${ANDROID_ABI})
  set_target_properties(${LIB_GO} 
    PROPERTIES
      IMPORTED_LOCATION ${CMAKE_CURRENT_BINARY_DIR}/lib${LIB_GO}_${ANDROID_ABI}.so
      INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_CURRENT_BINARY_DIR})
else()
  # For all other platforms the go library is built as a static library
  add_library(${LIB_GO} STATIC IMPORTED GLOBAL)
  add_dependencies(${LIB_GO} go_build)
  set_target_properties(${LIB_GO} 
    PROPERTIES
      IMPORTED_LOCATION ${CMAKE_CURRENT_BINARY_DIR}/lib${LIB_GO}.a
      INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_CURRENT_BINARY_DIR})
endif()

add_library(${LIB} SHARED ${C_SRCS})
target_link_libraries(${LIB} ${LIB_GO})

if(DEFINED ANDROID_ABI)
  set(SHARED_LIB_NAME lib${LIB}.so)
else()
  # Ensure all symbols are included in the final linked library
  if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    target_link_options(${LIB} PRIVATE "-Wl,-all_load")
    set(SHARED_LIB_NAME lib${LIB}.dylib)
  else()
    target_link_options(${LIB} PRIVATE "-Wl,--whole-archive")
    set(SHARED_LIB_NAME lib${LIB}.so)
  endif()
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
  COMMAND ${CMAKE_COMMAND} -E make_directory ${ROOT_DIR}/${LIB}.framework
  COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/${SHARED_LIB_NAME} ${ROOT_DIR}/${LIB}.framework/${LIB}
  COMMAND dart test ${ROOT_DIR}/test
  COMMENT "Running ${LIB} plugin tests"
)
