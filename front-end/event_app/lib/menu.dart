import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'client.dart';
import 'accVerification.dart';
import 'createPlaceEvent.dart';

class Menu extends StatefulWidget {
  final fb = FacebookLogin();

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  var s1 = LoggedInSingleton();

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
    if (s1.loggedIn) {
      return OutlinedButton(
        child: Text('Log Out'),
        onPressed: () async {
          final fb = widget.fb;
          // Log out
          final res = await fb.logOut();

          _logInButtonChange();
        },
      );
    }

    return OutlinedButton(
      child: Text('Log In'),
      onPressed: () async {
        final fb = widget.fb;

        // Log in
        final res = await fb.logIn(permissions: [
          FacebookPermission.publicProfile,
          FacebookPermission.email,
          FacebookPermission.readInsights,
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

            final resp = await sendUserDataToServer(
                profile.firstName!, profile.lastName!, email!, profile.userId);
            print(resp.body);

            _logInButtonChange();

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

  Widget getAccountButtons() {
    if (!s1.accVerified) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OutlinedButton(
              child: Text('Add place/event'),
              onPressed: () {
                _navigateAndDisplaySelection2(context);
              },
            )
          ]);
    }
    return OutlinedButton(
      child: Text('Verify account'),
      onPressed: () {
        _navigateAndDisplaySelection(context);
      },
    );
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
}

class LoggedInSingleton {
  static final LoggedInSingleton _singleton = LoggedInSingleton._internal();
  bool loggedIn = false;
  bool accVerified = false;

  factory LoggedInSingleton() {
    return _singleton;
  }

  LoggedInSingleton._internal();
}
