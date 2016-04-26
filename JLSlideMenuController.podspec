#
# Be sure to run `pod lib lint JLSlideMenuController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "JLSlideMenuController"
  s.version          = "0.4.4"
  s.summary          = "JLSlideMenuController, a easy and cusmomizable way to create your slide menu"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = "This is a library that makes the hard work to control and create the slide menu for you. It allows you to create a completely customizable menu in a easy way using most of the time only the storyboard and its completely in Swift. I hope it will helps you make you app faster."

  s.homepage         = "https://github.com/josechagas/JLSlideMenuController"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "José Lucas" => "joselucas1994@yahoo.com.br" }
  s.source           = { :git => "https://github.com/josechagas/JLSlideMenuController.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/*.swift'
#s.resource_bundles = {
#    'JLSlideMenuController' => ['Pod/Assets/*.png']
#  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
