Pod::Spec.new do |s|
  s.name     = 'AF+Image+Helper'
  s.version  = '1.02'
  s.platform = :ios
  s.license  = 'MIT'
  s.summary  = 'Convenience extension for UIImage and UIImageView in Swift'
  s.homepage = 'https://github.com/melvitax/AFImageHelper'
  s.author   = { 'Melvin Rivera' => 'melvin@allforces.com' }
  s.source   = { :git => 'https://github.com/melvitax/AFImageHelper.git', :tag => s.version.to_s }
  s.description = 'A collection of extensions for handling image creation from colors and gradients, cropping, scaling and fetching from the web with support for caching.'
  s.source_files = 'UIImage+AF+Additions/*'
  s.framework    = 'QuartzCore'
  s.requires_arc = true
end
