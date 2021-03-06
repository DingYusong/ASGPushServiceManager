#
# Be sure to run `pod lib lint ASGPushServiceManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ASGPushServiceManager'
  s.version          = '0.1.0'
  s.summary          = 'a push manager of umeng and jpush'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    provide a push manager of umeng and jpush
                       DESC

  s.homepage         = 'https://github.com/DingYusong/ASGPushServiceManager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'DingYusong' => 'dys90@qq.com' }
  s.source           = { :git => 'https://github.com/DingYusong/ASGPushServiceManager.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.source_files = 'ASGPushServiceManager/*'
  
  # s.resource_bundles = {
  #   'ASGPushServiceManager' => ['ASGPushServiceManager/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
    s.dependency 'JPush', '~> 3.0.2'
    s.dependency 'UMengPush', '~> 1.5.0'
end
