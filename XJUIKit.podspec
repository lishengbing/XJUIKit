#
# Be sure to run `pod lib lint XJUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XJUIKit'
  s.version          = '0.0.1'
  s.summary          = 'XJUIKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  XJUIKit: XJ系列的UIkit组件
                       DESC

  s.homepage         = 'https://github.com/lishengbing/XJUIKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lishengbing' => 'chihiro2017@163.com' }
  s.source           = { :git => 'https://github.com/lishengbing/XJUIKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

#s.source_files = 'XJUIKit/Classes/**/*'
  
  s.subspec 'SLButton' do | b |
      
      b.source_files = 'XJUIKit/Classes/SLButton/**/*'
      
  end
  
  s.subspec 'SLTextField' do | f |
      
      f.source_files = 'XJUIKit/Classes/SLTextField/**/*'
      
  end
  
  s.subspec 'SLTextView' do | t |
      
      t.source_files = 'XJUIKit/Classes/SLTextView/**/*'
      
  end
  
   s.resource_bundles = {
     'XJUIKit' => ['XJUIKit/Assets/*.png']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
