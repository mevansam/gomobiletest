# go_mobile_tester

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Clean Build

```
flutter clean && \
  rm -fr ../../../shared/flutter/user/user.framework/ && \
  rm -fr ../../../shared/flutter/user/build/ && \
  rm -fr ../../../shared/flutter/user/android/.cxx && \
  rm -fr ios/Pods && \
  rm -fr ios/.symlinks && \
  rm -fr macos/Pods && \
  rm -fr macos/.symlinks && \
  go clean -cache && \
  flutter pub get
```
