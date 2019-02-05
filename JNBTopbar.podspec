#
# Be sure to run `pod lib lint JNBTopbar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JNBTopbar'
  s.version          = '1.0.1'
  s.summary          = 'A customizable top bar.'
  s.swift_version = '4.2'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Use this controller to easily show notification like infomation to users. Show content of any kind by providing your own view.
                       DESC

  s.homepage         = 'https://github.com/jnblanchard/JNBTopbar'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jnblanchard@mac.com' => 'jnblanchard@mac.com' }
  s.source           = { :git => 'https://github.com/jnblanchard/JNBTopbar.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/JohnBlanchard1'

  s.ios.deployment_target = '11.0'

  s.source_files = 'JNBTopbar/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JNBTopbar' => ['JNBTopbar/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
