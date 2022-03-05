
Pod::Spec.new do |s|
  s.name             = 'Spotify-Kit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Spotify-Kit.'
  s.description      = <<-DESC
SpotifyKit for iOS and macOS.
                       DESC
  s.homepage         = 'https://github.com/AfrazCodes/SpotifyKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Afraz Siddiqui' => 'hello@iosacademy.io' }
  s.source           = { :git => 'https://github.com/AfrazCodes/SpotifyKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'SpotifyKit/Classes/**/*'
end
