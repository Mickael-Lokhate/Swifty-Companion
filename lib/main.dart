import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  oauth2.Client? client;

  @override
  Widget build(BuildContext context) {
    _intraAuthorization();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Center(child: Text('Swifty Companion'),),
    );
  }

  void _intraAuthorization() async {
    final authorizationEndpoint = Uri.parse('https://api.intra.42.fr/oauth/authorize');
    final uid = dotenv.env['FT_UID'];
    final secret = dotenv.env['FT_SECRET'];
    final credentialsFile = File('~/.swifty/cred.json');

    client = await oauth2.clientCredentialsGrant(authorizationEndpoint, uid, secret);
    if (client != null) {
      await credentialsFile.writeAsString(client!.credentials.toJson());
    }
  }
}
