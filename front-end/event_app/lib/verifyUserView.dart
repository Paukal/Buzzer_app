/*
* Lets Go App
* Paulius Tomas Kalvers
* Single event preview logic
* */

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'client.dart';
import 'package:url_launcher/url_launcher.dart';

class VerifyUserView extends StatefulWidget {
  final String userId;
  final String photoDataBaseSF;

  VerifyUserView(this.userId, this.photoDataBaseSF);

  @override
  _VerifyUserViewState createState() =>
      _VerifyUserViewState(userId, photoDataBaseSF);
}

class _VerifyUserViewState extends State<VerifyUserView> {
  final String userId;
  String photoDataBaseSF;

  _VerifyUserViewState(this.userId, this.photoDataBaseSF);

  late Uint8List photoDataBin;

  @override
  void initState() {
    super.initState();

    //sometimes the photo binary array gets corrupted, so to compensate
    //we add random bytes to end, otherwise error is shown
    if (photoDataBaseSF.length % 4 != 0) {
      int count = 4 - (photoDataBaseSF.length % 4);
      print(count);

      for (int i = 0; i < count; i++) {
        photoDataBaseSF += "+";
      }
    }

    photoDataBin = base64Decode(photoDataBaseSF);
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> userData;
    ScrollController _controller = new ScrollController();

    return Material(
        child: FutureBuilder<List<dynamic>>(
      future: fetchUserData(userId, forAdminVerification: true),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          userData = snapshot.data!;
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(), // new
            controller: _controller,
            children: <Widget>[
              Image.memory(photoDataBin),
              Container(
                height: 50,
                color: Colors.amber[200],
                child:
                    Center(child: Text("user id: ${userData.elementAt(0)[0]}")),
              ),
              Container(
                height: 50,
                color: Colors.amber[200],
                child: Center(child: Text(userData.elementAt(0)[1])),
              ),
              Container(
                height: 50,
                color: Colors.amber[200],
                child: Center(child: Text(userData.elementAt(0)[2])),
              ),
              Container(
                height: 50,
                color: Colors.amber[200],
                child: Center(
                    child: userData.elementAt(0)[3] != ""
                        ? Text(userData.elementAt(0)[3])
                        : Text("No email to show")),
              ),
              OutlinedButton(
                child: Text('Verify'),
                onPressed: () {
                  adminVerifyUser(userId);
                },
              ),
            ],
          );
        } else {
          return Center(
              child: Text(
            'Nothing to show',
            textAlign: TextAlign.center,
          ));
        }
      },
    ));
  }
}
