Pod::Spec.new do |s|
  s.name             = 'curlite'
  s.version          = '0.1.0'
  s.summary          = 'A short description of curlite.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = "https://github.com/ViewInc/curlite/blob/master/README.md"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'papiguy' => 'nitin.khanna@viewglass.com' }
  s.source           = { :git => 'https://github.com/ViewInc/curlite', :tag => s.version.to_s }

  s.ios.deployment_target = '9.3'
  s.source_files = '**/*.{cpp,hpp}'
  s.exclude_files = 'examples/*.cpp'
  s.public_header_files = '**/*.hpp'
  s.frameworks = 'UIKit', 'Foundation'
  s.library = 'z'
  s.ios.xcconfig = {
         'LIBRARY_SEARCH_PATHS' => '"$(PODS_ROOT)/../../tps/curl/bin/ios"',
         'GCC_C_LANGUAGE_STANDARD' => 'c11',
         'CLANG_CXX_LANGUAGE_STANDARD' => 'gnu++14',
         'GCC_PREPROCESSOR_DEFINITIONS' => "$(inherited)",
         'OTHER_LDFLAGS' => '-ObjC -lcurl -lz -lstdc++',
         'HEADER_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/../../tps/curl/include/'
         }

end
