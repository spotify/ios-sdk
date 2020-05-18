#
#  Be sure to run `pod spec lint Spotify-SDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "Spotify-SDK"
  s.version      = "1.2.2"
  s.summary      = "Spotify SDK for iOS"
  s.description  = <<-DESC
  The Spotify iOS SDK allows your iOS application to authenticate users, as well as interact and always stay in sync with the main Spotify application running on the user’s device in the background.
                   DESC

  s.homepage = "https://developer.spotify.com/documentation/ios/"
  s.license  = { :type => "MIT", :file => "Licenses/MPMessagePack-LICENSE.md" }
  s.authors  = { "jackfreeman" => "jackfreeman@google.com", "Arielle Vaniderstine" => "hack@ariari.io", "Konstantinos Karagiannis" => "konstantinosk@spotify.com" }

  s.platform              = :ios
  s.ios.deployment_target = '9.0'

  s.source = { :git => "https://github.com/spotify/ios-sdk.git", :tag => "v#{s.version}" }

  s.source_files        = 'SpotifyiOS.framework/Versions/A/Headers/*{.h}'
  s.public_header_files = 'SpotifyiOS.framework/Versions/A/Headers/*{.h}'
  s.vendored_frameworks = 'SpotifyiOS.framework'
  s.exclude_files       = "DemoProjects"

end
