#
# Be sure to run `pod lib lint AFDateHelper.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name = "AFImageHelper"
    s.version = "3.2.2"
    s.summary = "Image Extensions for Swift 3.0"
    s.description = <<-DESC
A collection of extensions for handling image creation from colors and gradients; Manipulating by cropping and scaling; Background fetching from the web with support for caching.
    DESC
    s.homepage = "https://github.com/melvitax/ImageHelper"
    s.screenshots = "https://raw.githubusercontent.com/melvitax/ImageHelper/master/Screenshot.png"
    s.license = 'MIT'
    s.author = { "Melvin Rivera" => "melvitax@gmail.com" }
    s.source = { :git => "https://github.com/melvitax/ImageHelper.git", :tag => s.version.to_s }
    s.social_media_url = 'https://twitter.com/melvitax'

    s.platforms = { :ios => '8.4', :tvos => '9.0' }
    s.ios.deployment_target = "8.4"
    s.tvos.deployment_target = "9.0"

    s.xcconfig = { 'SWIFT_VERSION' => '3.0' }

    s.source_files = "Sources/**/*.{h,swift}"

end
