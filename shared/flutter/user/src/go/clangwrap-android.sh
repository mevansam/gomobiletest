#!/bin/sh

# go/clangwrap.sh - used by gobuild to invoke clang with the
# correct SDK when running on macOS to build iOS binaries.

if [[ -z $CLANG_PATH ]]; then
    ANDROID_SDK="${HOME}/Library/Android/sdk"
    NDK_PATH="${ANDROID_SDK}/ndk/$(ls -tr ${ANDROID_SDK}/ndk | tail -1)"
    NDK_PREBUILD_PATH="${NDK_PATH}/toolchains/llvm/prebuilt"
    NDK_BIN_PATH="${NDK_PREBUILD_PATH}/$(ls -tr ${NDK_PREBUILD_PATH} | tail -1)/bin"

    if [ "$GOARCH" == "arm" ]; then
        CARCH="armv7a"
    elif [ "$GOARCH" == "arm64" ]; then
        CARCH="aarch64"
    elif [ "$GOARCH" == "386" ]; then
        CARCH="i686"
    elif [ "$GOARCH" == "amd64" ]; then
        CARCH="x86_64"
    else
        echo "Unknown GOARCH: $GOARCH"
        exit 1
    fi

    CLANG="$(ls ${NDK_BIN_PATH} | grep "^$CARCH-.*-clang$" | sort | tail -1)"
    CLANG_PATH=${NDK_BIN_PATH}/${CLANG}
fi

exec $CLANG_PATH "$@"