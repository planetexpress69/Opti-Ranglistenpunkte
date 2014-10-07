source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '6.1'
pod 'MKNetworkKit'
pod 'FontAwesome+iOS'
post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-acknowledgements.markdown', './Acknowledgements.markdown', :remove_destination => true);
end
