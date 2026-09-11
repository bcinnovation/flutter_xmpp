Pod::Spec.new do |s|
  s.name             = 'flutter_xmpp'
  s.version          = '0.0.1'
  s.summary          = 'Native XMPP for Flutter. iOS XMPPFramework is resolved via Swift Package Manager, not CocoaPods.'
  s.description      = <<-DESC
Android Smack and iOS XMPPFramework socket bridge.
XMPPFramework is declared in ios/flutter_xmpp/Package.swift (SPM).
                       DESC
  s.homepage         = 'https://github.com/adamdev718/flutter_xmpp'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Mate Networks' => 'dev@matenetworks.com' }
  s.source           = { :path => '.' }
  s.source_files = 'flutter_xmpp/Sources/flutter_xmpp/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }
  s.swift_version = '5.0'
end
