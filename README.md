# flutter_xmpp

Flutter plugin that keeps the XMPP TCP session in native sockets.

- Android: [Smack 4.1](https://github.com/igniterealtime/Smack)
- iOS: [XMPPFramework](https://github.com/robbiehanson/XMPPFramework) via **Swift Package Manager** (not CocoaPods)

Dart owns packet JSON, DB, and UI. This package only connects, sends chat bodies, and forwards received bodies.

## Use

```yaml
dependencies:
  flutter_xmpp:
    git:
      url: https://github.com/adamdev718/flutter_xmpp.git
      ref: main
```

```dart
import 'package:flutter_xmpp/flutter_xmpp.dart';

final xmpp = NativeXmppClient.instance;
xmpp.onMessage = (body) { /* jsonDecode(body) */ };
xmpp.onAuthenticated = () {};
xmpp.onClosed = () {};

await xmpp.start(
  id: uid,
  password: xmppPassword,
  host: 'chat.example.com',
  port: 5222,
  resource: 'com.example.app',
);
await xmpp.send(toJid: '$peer@$host', body: json);
await xmpp.stop();
```

## iOS / SPM

XMPPFramework is declared in `ios/flutter_xmpp/Package.swift` (`branch: master`). The 4.0.0 CocoaPods tag does not ship `Package.swift`, so a version `from: "4.0.0"` pin will not resolve.

The **host app must have Flutter Swift Package Manager enabled**. Flutter 3.44+ turns this on by default. If iOS still compiles this plugin as a CocoaPod only, `import XMPPFramework` fails because the podspec does not pull XMPPFramework.

```sh
flutter config --enable-swift-package-manager
```

Or in the app `pubspec.yaml`:

```yaml
flutter:
  config:
    enable-swift-package-manager: true
```

Other iOS plugins can stay on CocoaPods. Flutter uses SPM for this plugin and CocoaPods for plugins that have no `Package.swift`.
