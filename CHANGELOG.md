## 1.0.4

* iOS: stop reporting `onClosed` when `connectWithTimeout:` fails with `XMPPStreamInvalidState`. `XMPPReconnect` leaves the stream in `STATE_XMPP_CONNECTING`, where `isConnected` is still NO, so a `start` during reconnect marked a healthy stream as closed and left the Dart connection flag stale.
* iOS: `start` re-emits `onAuthenticated` for an already authenticated stream, matching the Android resync.
* iOS: report authentication failures. `xmppStream:didNotAuthenticate:` was not implemented and the `authenticateWithPassword:` error was discarded, so Dart never learned that login failed.

## 1.0.3

* Android: log in once per connect. Smack's `connect()` re-runs `login()` by itself when the connection had authenticated before, so the extra login in `ConnectionListener.connected` threw `AlreadyLoggedInException` on every foreground reconnect and reported the still live session to Dart as `onClosed`.
* Android: `start()` re-emits `onAuthenticated` when the socket is already connected and authenticated, so Dart can resync a stale disconnected state.

## 1.0.2

* Provide arm64 `stringprep` stubs so XMPPStringPrep links under Flutter SPM. The old `libidn.a` is i386/armv7-only and SPM does not link raw `.a` files.

## 1.0.1

* Split iOS SPM into Swift (`flutter_xmpp`) and Clang (`flutter_xmpp_core`) trees. KissXML `DDXML.swift` is excluded so Xcode no longer reports mixed language source files.

## 1.0.0

* Native XMPP socket: Android Smack 4.1, iOS vendored camtalk-ios-v2 XMPPFramework sources.
* Android enables Smack `ReconnectionManager` after connect, matching celebtube.
* Dart API: `NativeXmppClient` start / stop / send / goOnline / goOffline plus onMessage / onClosed / onAuthenticated.
* Fix Package.swift argument order so Flutter SPM can resolve the plugin.
