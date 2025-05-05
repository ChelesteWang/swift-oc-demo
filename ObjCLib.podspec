Pod::Spec.new do |s|
  s.name             = 'ObjCLib'
  s.version          = '0.1.0'
  s.summary          = 'Objective-C components for the demo app.'

  s.description      = <<-DESC
                     Contains Objective-C classes like MyObjectiveCClass, MyObjCUIView, and MyObjCViewController.
                       DESC

  s.homepage         = 'https://example.com/ObjCLib' # Replace with actual URL if available
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' } # Assuming MIT license, create LICENSE file later
  s.author           = { 'Your Name' => 'your.email@example.com' } # Replace with actual author info
  s.source           = { :git => 'https://example.com/ObjCLib.git', :tag => s.version.to_s } # Replace with actual git repo
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '15.0' # Match project's deployment target

  # Define the source files relative to the podspec location
  # We will create the Classes directory and move files later
  s.source_files = 'ObjCLib/Classes/**/*.{h,m}'

  # If this pod needs public headers
  # s.public_header_files = 'Pod/Classes/**/*.h'

  # If this pod depends on other frameworks or pods
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

  # Specify Swift version if mixing Swift/ObjC within the pod (not needed here)
  # s.swift_version = '5.0'
end