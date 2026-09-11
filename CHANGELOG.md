## 1.0.0

* Native XMPP socket: Android Smack 4.1, iOS vendored camtalk-ios-v2 XMPPFramework sources.
* Android enables Smack `ReconnectionManager` after connect, matching celebtube.
* Dart API: `NativeXmppClient` start / stop / send / goOnline / goOffline plus onMessage / onClosed / onAuthenticated.
* Fix Package.swift argument order so Flutter SPM can resolve the plugin.
