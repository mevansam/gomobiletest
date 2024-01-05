## Use Case

1. Login
* User logs in
* User is presented with a greeting

2. Profile
* User clicks on profile link
* User is presented with his/her profile
   Fields: Full Name, Address, DOB, Age


Install Gomobile

Environment file `.envrc`
```
export GOROOT=/usr/local/go
export GOPATH=$(pwd)

export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export ANDROID_NDK_ROOT=$ANDROID_HOME/ndk-bundle

PATH_add $GOPATH/bin
PATH_add $ANDROID_HOME/platform-tools/
```

```
go install golang.org/x/mobile/cmd/gomobile@latest
```

Initialize go
```
cd go
go init appbricks.io/greeter
go mod tidy
```

Get dependencies framework and bind
```
go get golang.org/x/mobile/cmd/gomobile
```

Build framework for apple ios
```
cd common/go
gomobile bind \
  -o ../../shared/gomobile/apple/User.xcframework \
  -target=ios,iossimulator,macos \
  -ldflags=-w \
  ./greeter ./person
```

Build framework for apple android
```
cd ./common/go
gomobile bind \
  -o ../../shared/gomobile/android/User.aar \
  -target=android -androidapi 21 \
  -ldflags=-w \
  ./greeter ./person
```

Build shared package for flutter
```
cd ./shared/flutter
flutter create \
  --template=plugin_ffi \
  --platforms=ios,android,windows,linux,macos \
  user
flutter create \
  --template=package \
  ffi_helper
```
