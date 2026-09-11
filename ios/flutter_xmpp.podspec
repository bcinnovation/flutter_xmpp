Pod::Spec.new do |s|
  s.name             = 'flutter_xmpp'
  s.version          = '0.0.1'
  s.summary          = 'Native XMPP for Flutter. iOS uses the vendored camtalk-ios-v2 XMPPFramework sources.'
  s.description      = <<-DESC
Android Smack and iOS XMPPFramework socket bridge.
iOS compiles CamTalkV2/libs/xmppframework (copied into ios/flutter_xmpp/xmppframework).
                       DESC
  s.homepage         = 'https://github.com/adamdev718/flutter_xmpp'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Mate Networks' => 'dev@matenetworks.com' }
  s.source           = { :path => '.' }
  s.source_files = [
    'flutter_xmpp/Sources/flutter_xmpp/**/*.swift',
    'flutter_xmpp/Sources/flutter_xmpp_core/**/*.{h,m}',
    'flutter_xmpp/xmppframework/Core/**/*.{h,m}',
    'flutter_xmpp/xmppframework/Authentication/**/*.{h,m}',
    'flutter_xmpp/xmppframework/Categories/**/*.{h,m}',
    'flutter_xmpp/xmppframework/Utilities/**/*.{h,m}',
    'flutter_xmpp/xmppframework/Extensions/Reconnect/**/*.{h,m}',
    'flutter_xmpp/xmppframework/Extensions/XEP-0199/**/*.{h,m}',
    'flutter_xmpp/xmppframework/Extensions/Roster/**/*.h',
    'flutter_xmpp/xmppframework/Extensions/XEP-0045/**/*.h',
    'flutter_xmpp/xmppframework/Extensions/CoreDataStorage/**/*.h',
    'flutter_xmpp/xmppframework/Vendor/CocoaAsyncSocket/**/*.{h,m}',
    'flutter_xmpp/xmppframework/Vendor/KissXML/**/*.{h,m}',
    'flutter_xmpp/xmppframework/Vendor/CocoaLumberjack/**/*.{h,m}',
    'flutter_xmpp/xmppframework/XMPPFramework.h',
  ]
  s.public_header_files = 'flutter_xmpp/Sources/flutter_xmpp_core/include/FlutterXmppEngine.h'
  s.vendored_libraries = 'flutter_xmpp/xmppframework/Vendor/libidn/libidn.a'
  s.libraries = 'xml2', 'resolv'
  s.frameworks = 'CFNetwork', 'Security', 'SystemConfiguration', 'CoreData'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'
  s.requires_arc = true
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
    'HEADER_SEARCH_PATHS' => '$(inherited) $(SDKROOT)/usr/include/libxml2 $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Core $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Authentication $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Authentication/Anonymous $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Authentication/Digest-MD5 $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Authentication/Plain $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Authentication/SCRAM-SHA-1 $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Authentication/Deprecated-Plain $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Authentication/Deprecated-Digest $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Authentication/X-Facebook-Platform $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Authentication/X-OAuth2-Google $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Categories $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Utilities $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Extensions/Reconnect $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Extensions/XEP-0199 $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Extensions/Roster $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Extensions/Roster/MemoryStorage $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Extensions/Roster/CoreDataStorage $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Extensions/XEP-0045 $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Extensions/XEP-0045/MemoryStorage $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Extensions/XEP-0045/CoreDataStorage $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Extensions/XEP-0045/HybridStorage $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Extensions/CoreDataStorage $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Vendor/CocoaAsyncSocket $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Vendor/KissXML $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Vendor/KissXML/Additions $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Vendor/KissXML/Categories $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Vendor/KissXML/Private $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Vendor/CocoaLumberjack $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Vendor/CocoaLumberjack/Extensions $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Vendor/libidn $(PODS_TARGET_SRCROOT)/flutter_xmpp/Sources/flutter_xmpp_core/include',
    'LIBRARY_SEARCH_PATHS' => '$(inherited) $(PODS_TARGET_SRCROOT)/flutter_xmpp/xmppframework/Vendor/libidn'
  }
  s.swift_version = '5.0'
end
