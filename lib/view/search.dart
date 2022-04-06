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
  bool waiting = false;

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
        backgroundColor: const Color.fromARGB(255, 49, 49, 49),
        appBar: AppBar(
          title: const Text('Swifty Companion'),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset("assets/images/bg.png").image
            )
          ),
          child: _buildBody(),
        )
      )
    );
  }

  Widget _buildBody() {
    if (client != null && waiting) {
      return Center (
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            Text('Getting the user from 42 API...', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),)
          ],
        )
      );
    }
    else if (client != null && searchError.isEmpty) {
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
        leading: const Icon(Icons.search, color: Colors.white60, size: 28,),
        title: TextField(
          autocorrect: true,
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search a login...',
            hintStyle: TextStyle(color: Colors.white60, fontSize: 24, fontStyle: FontStyle.italic,),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white60, fontSize: 24),
          onSubmitted: _searchLogin,
        ),
      ),
    );
  }

  void _searchLogin(String val) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (client != null) {
      setState(() {
        waiting = true;
      });
      try {
        setState(() {
          searchError = '';
        });
        final String response = await client!.read(Uri.parse('https://api.intra.42.fr/v2/users/${val.toLowerCase()}'));
        final jsonResponse = jsonDecode(response);
        setState(() {
          waiting = false;
        });
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Details(jsonResponse))); 
      } on ExpirationException catch(e) {
        debugPrint('token expire : $e');
        setState(() {
          searchError = ' the token expire, please retry your search';
          waiting = false;
          searchController.text = '';
        });
        _intraAuthorization();
        try {
          setState(() {
            searchError = '';
            waiting = true;
          });
          final String response = await client!.read(Uri.parse('https://api.intra.42.fr/v2/users/${val.toLowerCase()}'));
          final jsonResponse = jsonDecode(response);
          setState(() {
            waiting = false;
          });
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Details(jsonResponse))); 
        } catch (error) {
          setState(() {
            waiting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sorry can\'t fetch the API, please try again in few seconds')));
        }
        return;
      }
      catch (error) {
        setState(() {
          searchError = 'no user found';
          waiting = false;
          searchController.text = '';
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