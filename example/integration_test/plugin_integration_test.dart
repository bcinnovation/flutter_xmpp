import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_xmpp/flutter_xmpp.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('client singleton is available', (WidgetTester tester) async {
    expect(NativeXmppClient.instance, isNotNull);
  });
}
