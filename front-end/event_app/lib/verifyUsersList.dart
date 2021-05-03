/*
* Lets Go App
* Paulius Tomas Kalvers
* Listing of users to verify
* */

import 'package:event_app/verifyUserView.dart';
import 'package:flutter/material.dart';
import 'client.dart';
import 'menu.dart';

class VerifyUsersList extends StatefulWidget {
  @override
  _VerifyUsersListState createState() => _VerifyUsersListState();
}

class _VerifyUsersListState extends State<VerifyUsersList> {
  var s1 = LoggedInSingleton();

  @override
  Widget build(BuildContext context) {
    List<dynamic> userVerifyData;

    return Material(
        child: Stack(children: [
      FutureBuilder<List<dynamic>>(
        future: getUserListVerification(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            userVerifyData = snapshot.data!;
            if (userVerifyData.isNotEmpty) {
              return ListView.builder(
                  itemCount: userVerifyData.length,
                  itemBuilder: (BuildContext context, int index) {
                    final user = userVerifyData[index];

                    return InkWell(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 50,
                            color: Colors.amber[200],
                            child: Center(child: Text(user[1])),
                          ),
                        ],
                      ),
                      onTap: () {
                        _navigateAndDisplaySelection(context, user[1], user[2]);
                      },
                    );
                  });
            } else {
              return Center(
                  child: Text(
                'No users to show',
                textAlign: TextAlign.center,
              ));
            }
          } else {
            return Center(
                child: Text(
              'No users to show',
              textAlign: TextAlign.center,
            ));
          }
        },
      ),
    ]));
  }

  void _navigateAndDisplaySelection(BuildContext context, String userId, String photoData) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VerifyUserView(userId, photoData)),
    );

    setState(() {});
  }
}
