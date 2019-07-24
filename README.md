# ChatCamp-iOS-UI-Kit
# ChatCamp UI Kit for iOS Apps
## Installation
### CocoaPods
[CocoaPods] is a dependency manager for Cocoa projects. You can install it with the following command:

```sh
$ gem install cocoapods
```
CocoaPods 1.1+ is required to build ChatCampUIKit.

To integrate ChatCampUIKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```sh
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'ChatCampUIKit', '~> 4.2'
end
```
Then, run the following command:

```sh
$ pod install
```

### Note: To use UIKit with Swift 4 (Swift versions prior to 4.2), please use ChatCamp iOS Uikit `swift-4.1` branch.

### Note: To use UIKit with Swift 3, please use ChatCamp iOS Uikit `swift3` branch.

[CocoaPods]: <https://cocoapods.org/>
