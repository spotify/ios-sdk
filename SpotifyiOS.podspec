#
#  Be sure to run `pod spec lint SpotifyiOS.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "SpotifyiOS"
  spec.version      = "1.2.2"
  spec.summary      = "SDK for communicating with Spotify iOS app"
  spec.description  = <<-DESC
  The Spotify iOS SDK allows your iOS application to authenticate users, as well as interact and always stay in sync with the main Spotify application running on the user’s device in the background.
                   DESC
  spec.homepage     = "https://github.com/spotify/ios-sdk"
  spec.license      = { :type => "MIT", :file => "Licenses/MPMessagePack-LICENSE.md" }
  spec.author       = { "leighroybrown" => "leighjbrown@live.co.uk" }
  spec.source       = { :git => "https://github.com/spotify/ios-sdk.git", :tag => "v#{spec.version}" }

  spec.source_files = 'SpotifyiOS.framework/Versions/A/Headers/*', 'SpotifyiOS.xcframework'
  spec.public_header_files = 'SpotifyiOS.framework/Versions/A/Headers/*'
  spec.vendored_frameworks = 'SpotifyiOS.xcframework'
  spec.exclude_files = 'docs', 'DemoProjects', 'Licenses', 'README.md', 'CHANGELOG.md', 'img'
  spec.platform = :ios
  spec.ios.deployment_target = '9.0'
end
