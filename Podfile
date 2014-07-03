platform :ios, '6.1'
pod 'MKNetworkKit'
post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Pods-acknowledgements.markdown', './Acknowledgements.markdown', :remove_destination => true);
end