import 'package:flutter/material.dart';
import 'package:flutter_xmpp/flutter_xmpp.dart';

void main() {
  NativeXmppClient.instance.ensureListening();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: Text('flutter_xmpp example')),
      ),
    );
  }
}
