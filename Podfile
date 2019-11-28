source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings!

def shared_pods
  pod 'Capsule', '0.0.8'
  pod 'Utensils', '0.0.4'
end

target :QuickELogger do
  pod 'SwiftLint', '0.31.0'

  shared_pods
end

target :Specs do
    pod 'Quick'
    pod 'Nimble'

    shared_pods
end

target :IntegrationSpecs do
    pod 'Quick'
    pod 'Nimble'

    shared_pods
end
