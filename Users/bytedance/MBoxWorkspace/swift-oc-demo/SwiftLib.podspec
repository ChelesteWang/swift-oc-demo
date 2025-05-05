Pod::Spec.new do |s|
  s.name             = 'SwiftLib'
  s.version          = '0.1.0'
  s.summary          = 'Swift components for the demo app.'

  s.description      = <<-DESC
                     Contains Swift classes and SwiftUI views like MySwiftClass, MySwiftUIView, ComplexComponentView, and UIViewRepresentables.
                       DESC

  s.homepage         = 'https://example.com/SwiftLib' # Replace with actual URL if available
  s.license          = { :type => 'MIT', :file => 'LICENSE' } # Assuming MIT license, create LICENSE file later
  s.author           = { 'Your Name' => 'your.email@example.com' } # Replace with actual author info
  s.source           = { :git => 'https://example.com/SwiftLib.git', :tag => s.version.to_s } # Replace with actual git repo

  s.ios.deployment_target = '15.0' # Match project's deployment target
  s.swift_version = '5.0' # Specify Swift version

  # Define the source files relative to the podspec location
  # We will create the Classes directory and move files later
  s.source_files = 'SwiftLib/Classes/**/*.swift'

  # SwiftLib depends on ObjCLib because the UIViewRepresentables use Objective-C classes
  s.dependency 'ObjCLib', '~> 0.1.0' # Add dependency on the local ObjCLib pod

  # If this pod depends on other frameworks
  # s.frameworks = 'SwiftUI', 'Combine'

end