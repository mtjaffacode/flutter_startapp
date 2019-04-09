#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_startapp'
  s.version          = '0.0.1'
  s.summary          = 'StartApp Ads for flutter'
  s.description      = <<-DESC
StartApp Ads for flutter
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'StartAppSDK'
  s.dependency 'ChartboostSDK'

  s.ios.deployment_target = '8.0'
end

