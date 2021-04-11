import 'package:flutter/material.dart';
import './map.dart';

class AddEvent extends StatefulWidget {
  double latitude;
  double longitude;

  AddEvent(this.latitude, this.longitude);

  @override
  State<AddEvent> createState() => AddEventState(latitude, longitude);
}

class AddEventState extends State<AddEvent> {
  double latitude;
  double longitude;

  AddEventState(this.latitude, this.longitude);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Add a new event"),
      ),
      body: Column(children: [

      ]),
    );
  }
}
