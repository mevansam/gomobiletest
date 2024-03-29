#!/bin/sh -x

# go/clangwrap.sh - used by gobuild to invoke clang with the
# correct SDK when running on macOS to build iOS binaries.

SDK_PATH=`xcrun --sdk $SDK --show-sdk-path`
SDK_VERSION=$(echo "$(basename ${SDK_PATH})" | awk -F'[a-zA-Z.]+' '{print $2 "." $3}')

CLANG=`xcrun --sdk $SDK --find clang`

if [ "$GOARCH" == "amd64" ]; then
    CARCH="x86_64"
    TARGET="$CARCH-apple-ios$SDK_VERSION"
elif [ "$GOARCH" == "arm64" ]; then
    CARCH="arm64"
    TARGET="$CARCH-apple-ios$SDK_VERSION-simulator"
fi

exec $CLANG -arch $CARCH -target $TARGET -isysroot $SDK_PATH -mios-version-min=${IPHONEOS_DEPLOYMENT_TARGET} "$@"