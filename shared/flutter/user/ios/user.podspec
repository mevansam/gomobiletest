#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint user.podspec` to validate before publishing.
#

build_go_source = <<-EOS
!#/bin/bash

plugin_root="$(cd -P $(dirname ${PODS_TARGET_SRCROOT}) && pwd)"
plugin_build_dir=${plugin_root}/build
mkdir -p ${plugin_build_dir}

pushd ${plugin_build_dir}
cmake ../src && make go_build
popd

EOS

Pod::Spec.new do |s|
  s.name             = 'user'
  s.version          = '0.0.1'
  s.summary          = 'Flutter GoMobileTest User plugin.'
  s.description      = <<-DESC
Flutter GoMobileTest User FFI plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
  s.source              = { :path => '.' }
  s.source_files        = 'Classes/**/*'
  s.public_header_files = '${PODS_TARGET_SRCROOT}/../src/*.h'

  s.script_phase = { 
    :name => 'Build Go Source', 
    :script => build_go_source,
    :input_files => [
      '${BUILD_DIR}/../../../../../../../common/**/*',
      '${PODS_TARGET_SRCROOT}/../src/**/*',
    ], 
    :output_files => [
      '${PODS_TARGET_SRCROOT}/../build/libuser_go.a'
    ],
    :execution_position => :before_compile 
  }
  s.vendored_libraries = '${PODS_TARGET_SRCROOT}/../build/libuser_go.a'
  s.xcconfig = {
    'LIBRARY_SEARCH_PATHS' => '$(inherited) "$(BUILD_DIR)/../../../../../../../shared/flutter/user/build"',
    'OTHER_LDFLAGS' => '$(inherited) -all_load'
  }
  s.libraries = [
    'user_go'
  ]
  
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
