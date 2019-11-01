#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flt_umengpush_common'
  s.version          = '1.0.0'
  s.summary          = 'A new Flutter plugin by umeng push common'
  s.description      = <<-DESC
A new Flutter plugin by umeng push common
                       DESC
  s.homepage         = 'https://www.bughub.dev/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'smile561607154@163.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'UMCCommon'

  s.ios.deployment_target = '8.0'
end

