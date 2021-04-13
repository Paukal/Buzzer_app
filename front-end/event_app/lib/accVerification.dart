import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

class AccVerification extends StatefulWidget {
  @override
  State<AccVerification> createState() => AccVerificationState();
}

class AccVerificationState extends State<AccVerification> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Account verification"),
      ),
      backgroundColor: Colors.white,
      body: Container(
          padding: EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: "Enter your number"),
                keyboardType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[+0-9]'))
                ], // Only numbers can be entered
              ),
            ],
          )),
    );
  }
}
