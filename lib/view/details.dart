import 'package:flutter/material.dart';
import 'package:swifty_companion/model/user.dart';

class Details extends StatefulWidget {
  const Details(this.user, { Key? key }) : super(key: key);
  final dynamic user;

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = User.fromJson(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.login!.toUpperCase()),
      ),
      body: Center(child: Text('HEllo ${user.login} - ${user.cursus_users?[1].skills?[0].name}'),),
    );
  }
}