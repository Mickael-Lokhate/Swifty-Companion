import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oauth2/oauth2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swifty_companion/view/details.dart';

class Search extends StatefulWidget {
  const Search({ Key? key }) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Client? client;
  late TextEditingController searchController;
  String searchError = '';

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Swifty Companion'),
        ),
        body: _buildBody(),
      )
    );
  }

  Widget _buildBody() {
     if (client != null && searchError.isEmpty) {
      return _buildSearchBar();
    } else if (client != null && searchError.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSearchBar(),
          Text('Sorry, $searchError...', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)
        ],
      );
    } 
    else {
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

  Widget _buildSearchBar() {
    return Center(
      child: ListTile(
        autofocus: true,
        leading: const Icon(Icons.search, color: Colors.black54, size: 28,),
        title: TextField(
          autofocus: true,
          autocorrect: true,
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search a login...',
            hintStyle: TextStyle(color: Colors.black54, fontSize: 18, fontStyle: FontStyle.italic),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.black54),
          onSubmitted: _searchLogin,
        ),
      ),
    );
  }

  void _searchLogin(String val) async {
    if (client != null) {
      try {
        setState(() {
          searchError = '';
        });
        final String response = await client!.read(Uri.parse('https://api.intra.42.fr/v2/users/$val'));
        final jsonResponse = jsonDecode(response);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  Details(jsonResponse)));
      } on ExpirationException catch(e) {
        debugPrint('token expire : $e');
        setState(() {
          searchError = ' the token expire, please retry your search';
        });
        // _intraAuthorization();
        // print('ask another token');
        // _searchLogin(val);
        // print('relaunch login');
        return;
      }
      catch (error) {
        setState(() {
          searchError = 'no user found';
        });
        print('Error on search request : $error');
      }
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
      var fileContent = await credentialsFile.readAsString();
      if (fileContent.isNotEmpty) {
        var credentials = Credentials.fromJson(fileContent);
        print('Access : ${credentials.accessToken} - Refresh : ${credentials.refreshToken} - Expiration : ${credentials.expiration}');
        if (credentials.expiration!.isAfter(DateTime.now())) {
          setState(() {
            client = Client(credentials, identifier: dotenv.env['FT_UID'], secret: dotenv.env['FT_SECRET']);
          });
          return ;
        }
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