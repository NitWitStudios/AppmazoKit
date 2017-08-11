Pod::Spec.new do |s|
  s.name             = 'AppmazoKit'
  s.version          = '1.0.0'
  s.summary          = 'AppmazoKit is a collection of commonly used boilerplate features.' 
  s.description      = <<-DESC
An incredible collection of common UI components, extensions and more!
                       DESC
 
  s.homepage         = 'https://github.com/Appmazo/AppmazoKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'James Hickman' => 'james@appmazo.com' }
  s.source           = { :git => 'https://github.com/Appmazo/AppmazoKit.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'
  s.source_files = 'AppmazoKit/*'
 
end
