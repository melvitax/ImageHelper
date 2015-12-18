#
# Be sure to run `pod lib lint AFDateHelper.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = "AFImageHelper"
    s.version          = "3.0.2"
    s.summary          = "Image Extensions for Swift 2.0"
    s.description      = <<-DESC
A collection of extensions for handling image creation from colors and gradients; Manipulating by cropping and scaling; Background fetching from the web with support for caching.
    DESC
    s.homepage         = "https://github.com/melvitax/AFImageHelper"
    s.screenshots     = "https://raw.githubusercontent.com/melvitax/AFImageHelper/master/Screenshot.png"
    s.license          = 'MIT'
    s.author           = { "Melvin Rivera" => "melvin@allforces.com" }
    s.source           = { :git => "https://github.com/melvitax/AFImageHelper.git", :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/melvitax'

    s.platform     = :ios, '8.0'
    s.requires_arc = true

    s.source_files = 'AFImageHelper/**/*'
    #s.resource_bundles = {}

    # s.public_header_files
    # s.frameworks = 'QuartzCore'
    # s.dependency
end

