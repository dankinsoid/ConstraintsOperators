Pod::Spec.new do |s|
s.name             = 'ConstraintsOperators'
s.version          = '2.16.0'
s.summary          = 'A short description of ConstraintsOperators.'

s.description      = <<-DESC
TODO: Add long description of the pod here.
DESC

s.homepage         = 'https://github.com/dankinsoid/ConstraintsOperators'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Author' => 'example@gmail.com' }
s.source           = { :git => 'https://github.com/dankinsoid/ConstraintsOperators.git', :tag => s.version.to_s }

s.ios.deployment_target = '11.0'
s.swift_versions = '5.0'
s.source_files = 'Sources/ConstraintsOperators/**/*'
s.dependency 'VD', '~> 1.6.0'

# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end