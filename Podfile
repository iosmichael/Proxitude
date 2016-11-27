# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Proxitude' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
    pod 'ImagePicker'
    pod 'Lightbox', git: 'https://github.com/hyperoslo/Lightbox.git', branch: 'swift-3'
    pod 'JSQMessagesViewController'
    pod 'Firebase/Core'
    pod 'Firebase/Auth'
    pod 'Firebase/Database'
    pod 'Firebase/Storage'
    pod 'GoogleSignIn'
  # Pods for Proxitude

  target 'ProxitudeTests' do
    inherit! :search_paths
    pod 'Firebase/Core'
    pod 'Firebase/Auth'
    pod 'Firebase/Database'
    pod 'Firebase/Storage'
    # Pods for testing
  end

  target 'ProxitudeUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
