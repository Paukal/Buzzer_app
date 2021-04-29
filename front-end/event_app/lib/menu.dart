/*
* Lets Go App
* Paulius Tomas Kalvers
* User menu logic
* */

import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'client.dart';
import 'accVerification.dart';
import 'createPlaceEvent.dart';
import 'myPlacesEvents.dart';
import 'localDatabase.dart';
import 'placeEventListLikes.dart';

class Menu extends StatefulWidget {
  final fb = FacebookLogin();

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  var s1 = LoggedInSingleton();
  var localDB = DB();

  void _logInButtonChange() {
    setState(() {
      s1.loggedIn = !s1.loggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  s1.loggedIn ? getAccountButtons() : Container(),
                  getLogInOutButton(),
                ])),
      ),
    );
  }

  Widget getLogInOutButton() {
    if(!s1.loggedIn) {
      checkUser();
    }

    if (s1.loggedIn) {
      return OutlinedButton(
        child: Text('Log Out'),
        onPressed: () async {
          final fb = widget.fb;
          // Log out
          final res = await fb.logOut();
          localDB.deleteUser();
          localDB.deleteAllEvents();
          localDB.deleteAllPlaces();
          s1.deleteData();

          localDB.eventsStored = false;
          localDB.placesStored = false;

          _logInButtonChange();
        },
      );
    }

    return OutlinedButton(
      child: Text('Log in with Facebook'),
      onPressed: () async {
        final fb = widget.fb;

        // Log in
        final res = await fb.logIn(permissions: [
          FacebookPermission.publicProfile,
          FacebookPermission.email,
        ]);

        // Check result status
        switch (res.status) {
          case FacebookLoginStatus.success:
          // Logged in

          // Send this access token to server for validation and auth
            final accessToken = res.accessToken;
            print('Access Token: ${accessToken!.token}');

            // Get profile data
            final profile = await fb.getUserProfile();
            print('Hello, ${profile!.name}! You ID: ${profile.userId}');

            // Get email (since we request email permission)
            final email = await fb.getUserEmail();
            // But user can decline permission
            if (email != null) print('And your email is $email');

            s1.userId = profile.userId;

            if(profile.firstName != null) {
              s1.firstName = profile.firstName!;
            }
            if(profile.lastName != null) {
              s1.lastName = profile.lastName!;
            }
            if(email != null) {
              s1.email = email;
            }

            final resp = await sendUserDataToServer(s1.firstName, s1.lastName, s1.email, s1.userId);
            print(resp.body);

            await fetchUserData(s1.userId);

            _logInButtonChange();
            localDB.insertUser(profile.userId, accessToken.token);

            localDB.eventsStored = false;
            localDB.placesStored = false;

            break;
          case FacebookLoginStatus.cancel:
          // User cancel log in
            break;
          case FacebookLoginStatus.error:
          // Log in failed
            print('Error while log in: ${res.error}');
            break;
        }
      },
    );
  }

  Future<void> checkUser() async {
    try {
      Map<String, dynamic> userIdToken = await localDB.getUserLoginInfo();
      print(userIdToken.toString());

      String id = userIdToken.values.elementAt(0).toString();
      String token = userIdToken.values.elementAt(1).toString();

      Map<String, dynamic> userData = await getUserInfoFB(id, token);

      s1.firstName = userData.values.elementAt(0).toString();
      s1.lastName = userData.values.elementAt(1).toString();
      s1.email = userData.values.elementAt(2).toString();
      s1.userId = userData.values.elementAt(3).toString();

      await fetchUserData(s1.userId);

      localDB.eventsStored = false;
      localDB.placesStored = false;

      _logInButtonChange();

    } catch (err) {
      print("exception: $err");
    }
  }

  Widget getAccountButtons() {
    String name = s1.firstName;

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Hello, $name!"),
          OutlinedButton(
            child: Text('My likes'),
            onPressed: () {
              _navigateAndDisplaySelection4(context);
            },
          ),
          OutlinedButton(
            child: Text('My places/events'),
            onPressed: () {
              _navigateAndDisplaySelection3(context);
            },
          ),
          OutlinedButton(
            child: Text('Add place/event'),
            onPressed: () {
              _navigateAndDisplaySelection2(context);
            },
          ),
          s1.accVerified && !s1.sentVerificationPhoto ? Container() : OutlinedButton(
            child: Text('Verify account'),
            onPressed: () {
              _navigateAndDisplaySelection(context);
            },
          ),
          s1.admin ? OutlinedButton(
            child: Text('Verify users'),
            onPressed: () {
              _navigateAndDisplaySelection(context);
            },
          ) : Container(),
        ]);
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AccVerification()),
    );

    setState(() {});
  }

  void _navigateAndDisplaySelection2(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreatePlaceEvent()),
    );

    setState(() {});
  }

  void _navigateAndDisplaySelection3(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyPlacesEvents()),
    );

    setState(() {});
  }

  void _navigateAndDisplaySelection4(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PlaceEventListLikes()),
    );

    setState(() {});
  }
}

class LoggedInSingleton {
  static final LoggedInSingleton _singleton = LoggedInSingleton._internal();
  bool loggedIn = false;

  String userId = "-2";
  String firstName = "";
  String lastName = "";
  String email = "";
  bool accVerified = false;
  bool admin = false;
  bool sentVerificationPhoto = false;

  factory LoggedInSingleton() {
    return _singleton;
  }

  void deleteData() {
    userId = "-2";
    firstName = "";
    lastName = "";
    email = "";
    accVerified = false;
    admin = false;
    sentVerificationPhoto = false;
  }

  LoggedInSingleton._internal();
}
