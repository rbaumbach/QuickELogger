Pod::Spec.new do |spec|
  spec.name                  = 'QuickELogger'
  spec.version               = '0.0.1'
  spec.summary               = 'A quick and simple way to log messages to disk in your iPhone or iPad app'
  spec.homepage              = 'https://github.com/rbaumbach/Quick-E-Logger'
  spec.license               = { :type => 'MIT', :file => 'MIT-LICENSE.txt' }
  spec.author                = { 'Ryan Baumbach' => 'github@ryan.codes' }
  spec.source                = { :git => 'https://github.com/rbaumbach/Quick-E-Logger.git', :tag => spec.version.to_s }
  spec.requires_arc          = true
  spec.platform              = :ios
  spec.ios.deployment_target = '10.0'
  spec.source_files          = 'QuickELogger/Source/**/*.{swift}'
  spec.swift_version         = '5.1'
end
