#
# Be sure to run `pod lib lint MemexSwiftSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MemexSwiftSDK'
  s.version          = '1.2.1'
  s.summary          = 'Memex platform SDK.'

  s.description      = <<-DESC
Memex is new form of your external memory.
                       DESC

  s.homepage         = 'https://github.com/memexapp/memex-swift-sdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Adam Zdara' => 'zdaraa@gmail.com' }
  s.source           = { :git => 'https://github.com/memexapp/memex-swift-sdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = "Sources/*.swift"

  s.dependency 'ObjectMapper', '~> 3.0.0'
  s.dependency 'ReachabilitySwift', '~> 4.0-beta2'
  s.dependency 'KeychainSwift', '~> 9.0'

end
