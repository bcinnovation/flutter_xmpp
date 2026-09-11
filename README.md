# flutter_xmpp

Flutter plugin that keeps the XMPP TCP session in native sockets.

- Android: [Smack 4.1](https://github.com/igniterealtime/Smack)
- iOS: the same XMPPFramework **source tree** Camtalk iOS already uses (`camtalk-ios-v2/CamTalkV2/libs/xmppframework`), vendored at `ios/flutter_xmpp/Sources/flutter_xmpp_core/xmppframework`

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

## iOS

XMPPFramework is **not** fetched from CocoaPods or GitHub SPM. The plugin compiles the copied iOS-v2 sources (Core, auth, Reconnect, AutoPing, CocoaAsyncSocket, KissXML, CocoaLumberjack, `libidn.a`).

Host apps still run `pod install` for Flutter's CocoaPods plugins. This plugin's podspec compiles the vendored `.m` files; it does not add `pod 'XMPPFramework'`.
