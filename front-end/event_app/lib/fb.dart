import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class FB extends StatefulWidget {
  final fb = FacebookLogin();

  @override
  _FBState createState() => _FBState();
}

class _FBState extends State<FB> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: OutlineButton(
            child: Text('Log In'),
            onPressed: () async {
              final fb = widget.fb;

              // Log in
              final res = await fb.logIn(permissions: [
                FacebookPermission.publicProfile,
                FacebookPermission.email,
                FacebookPermission.readInsights,
                FacebookPermission.userEvents
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
          ),
        ),
      ),
    );
  }
}