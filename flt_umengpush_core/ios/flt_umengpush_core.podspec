#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flt_umengpush_core'
  s.version          = '1.0.0'
  s.summary          = 'A new Flutter plugin by umeng push core'
  s.description      = <<-DESC
A new Flutter plugin by umeng push core
                       DESC
  s.homepage         = 'https://www.bughub.dev/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'smile561607154@163.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'UMCPush'

  s.ios.deployment_target = '8.0'
end

