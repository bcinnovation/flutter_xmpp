import 'package:flutter/services.dart';

/// Smack(Android) / XMPPFramework(iOS) 소켓만 담당한다.
class NativeXmppClient {
  static final NativeXmppClient instance = NativeXmppClient._();
  static const _channel = MethodChannel('flutter_xmpp');

  NativeXmppClient._();

  void Function(String body)? onMessage;
  void Function()? onClosed;
  void Function()? onAuthenticated;

  bool _listening = false;

  void ensureListening() {
    if (_listening) {
      return;
    }
    _listening = true;
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onMessage':
          final args = call.arguments as Map<dynamic, dynamic>;
          final body = args['body'] as String?;
          if (body != null && body.isNotEmpty) {
            onMessage?.call(body);
          }
          break;
        case 'onClosed':
          onClosed?.call();
          break;
        case 'onAuthenticated':
          onAuthenticated?.call();
          break;
      }
    });
  }

  Future<void> start({
    required String id,
    required String password,
    required String host,
    required int port,
    required String resource,
  }) {
    ensureListening();
    return _channel.invokeMethod<void>('start', {
      'id': id,
      'password': password,
      'host': host,
      'port': port,
      'resource': resource,
    });
  }

  Future<void> stop() {
    return _channel.invokeMethod<void>('stop');
  }

  Future<void> send({required String toJid, required String body}) {
    return _channel.invokeMethod<void>('send', {
      'to': toJid,
      'body': body,
    });
  }

  Future<void> goOnline() {
    return _channel.invokeMethod<void>('goOnline');
  }

  Future<void> goOffline() {
    return _channel.invokeMethod<void>('goOffline');
  }
}
