# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

source 'https://github.com/CocoaPods/Specs.git'
source 'https://bitbucket.org/cybavo/specs_512.git'

target 'CYBAVOAuthDemo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CYBAVOAuthDemo
  pod 'CYBAVOLibmsec', '~> 1.0.0'
  pod 'ObjectMapper', '3.5.1'
  pod 'AlamofireObjectMapper', '5.2.1'
  pod 'Alamofire', '4.9.0'
  pod 'CryptoSwift', '1.0.0'
  pod 'SwiftyUserDefaults', '4.0.0'
  pod 'SwiftEventBus', :tag => '3.0.1', :git => 'https://github.com/cesarferreira/SwiftEventBus.git'
  pod 'Toast-Swift', '~> 4.0.0'
  pod 'SwiftOTP', '2.0.0'
  pod 'CYBAVOAuth', '~> 1.2.0'


end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        #config.build_settings['CODE_SIGNING_ALLOWED'] = 'YES'
        #config.build_settings.delete('CODE_SIGNING_REQUIRED')
        config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
        config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
        config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
    end
    # Required from CYBAVOAuth 1.2.239
    # installer.pods_project.targets.each do |target|
    #   target.build_configurations.each do |config|
    #     config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    #   end
    # end
end