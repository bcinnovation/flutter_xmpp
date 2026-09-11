import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_xmpp/flutter_xmpp.dart';

void main() {
  test('NativeXmppClient is a singleton', () {
    expect(
      identical(NativeXmppClient.instance, NativeXmppClient.instance),
      isTrue,
    );
  });
}
