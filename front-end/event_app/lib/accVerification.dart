import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      body: new Container(
          padding: const EdgeInsets.all(40.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new TextField(
                decoration: new InputDecoration(labelText: "Enter your number"),
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
