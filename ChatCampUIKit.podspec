Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '9.0'
s.swift_version = '4.2'
s.name = "ChatCampUIKit"
s.summary = "ChatCamp iOS UI Kit"
s.description  = "UI Kit for ChatCamp iOS SDK"
s.requires_arc = true
s.version = "4.2.9"
s.license = { :type => "MIT", :file => "LICENSE" }
s.authors = {"Saurabh Gupta" => "saurabh.gupta@iflylabs.com", "Shashwat Srivastava"=>"shashwat@iflylabs.com", "Shubham Gupta"=>"shubham@iflylabs.com"}
s.homepage = "https://chatcamp.io"
s.source = { :git => "https://github.com/ChatCamp/ChatCamp-iOS-UI-Kit.git", :tag => "v#{s.version}"}

s.ios.frameworks = ["AVKit", "Photos", "AVFoundation", "MobileCoreServices", "SafariServices", "MapKit", "UIKit", "Foundation"]
s.dependency 'ChatCamp', '~> 4.2'
s.dependency 'DKImagePickerController'
s.dependency 'DKCamera'
s.dependency 'DKPhotoGallery'
s.dependency 'Alamofire', '~> 4.7'
s.dependency 'MBProgressHUD'


s.source_files = "ChatCampUIKit/**/*.{swift}"
s.resources = "ChatCampUIKit/**/*.{png,jpeg,jpg,storyboard,xib}"
end
