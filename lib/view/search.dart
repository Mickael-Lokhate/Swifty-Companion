import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oauth2/oauth2.dart';
import 'package:path_provider/path_provider.dart';

class Search extends StatefulWidget {
  const Search({ Key? key }) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Client? client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swifty Companion'),
      ),
      body: _buildSearchBar(),
    );
  }

  Widget _buildSearchBar() {
     if (client != null) {
      return const Center(child: Text('Search'),);
    } else {
      _intraAuthorization();
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            CircularProgressIndicator(strokeWidth: 5.0, semanticsLabel: 'Connecting to 42 API...',),
            Text('Connecting to 42 API...', style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),)
          ],
        ),
      );
        
      
    } 
  }

  void _intraAuthorization() async {
    final path = await _getLocalPath();
    final authorizationEndpoint = Uri.parse('https://api.intra.42.fr/oauth/token');
    final uid = dotenv.env['FT_UID'];
    final secret = dotenv.env['FT_SECRET'];
    print('Creating file...');
    final credentialsFile = await File('$path/.swifty/cred.json').create(recursive: true);
    print('File created');

    if (credentialsFile.existsSync()) {
      print('Reading credentials...');
      var credentials = Credentials.fromJson(await credentialsFile.readAsString());
      print('Access : ${credentials.accessToken} - Refresh : ${credentials.refreshToken} - Expiration : ${credentials.expiration}');
      if (credentials.expiration!.isAfter(DateTime.now())) {
        setState(() {
          client = Client(credentials, identifier: dotenv.env['FT_UID'], secret: dotenv.env['FT_SECRET']);
        });
        return ;
      }
    }

    try {
      print('Ask authorization to 42...');
      final tmpClient = await clientCredentialsGrant(authorizationEndpoint, uid, secret);
      setState(() {
        client = tmpClient;
      });
    } catch (e) {
      print('error auth : $e');
    }
    
    if (client != null && credentialsFile.existsSync()) {
      print('Writing credentials...');
      await credentialsFile.writeAsString(client!.credentials.toJson());
    }
  }

  Future<String> _getLocalPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }
}