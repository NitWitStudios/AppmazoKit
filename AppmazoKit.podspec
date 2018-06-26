#
# Be sure to run `pod lib lint AppmazoKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AppmazoKit'
  s.version          = '1.0.0'
  s.summary          = 'AppmazoKit is a collection of commonly used boilerplate code, UI elements and class extensions.'
  s.swift_version    = '4.1'

  s.description      = <<-DESC
AppmazoKit is broken into three categories: Managers, UI Elements and Class Extensions.
The Managers are great for simplifying common app flows like permissions, location services, biometric authentication and more.
The UI Elements contain frequently used UI for quick app prototyping and implementation.
The Class Extensions contain a lot of useful extensions of existing classes that should have been availble by default.
                       DESC

  s.homepage         = 'https://github.com/appmazo/AppmazoKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'appmazo' => 'jhickman@appmazo.com' }
  s.source           = { :git => 'https://github.com/Appmazo/AppmazoKit.git', :tag => s.version }

  s.ios.deployment_target = '11.0'

  s.source_files = 'AppmazoKit/Classes/**/*.*'
  s.resources = 'AppmazoKit/Assets/**/*.*'

end
