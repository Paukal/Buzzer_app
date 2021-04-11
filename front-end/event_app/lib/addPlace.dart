import 'package:flutter/material.dart';
import './map.dart';

class AddPlace extends StatefulWidget {
  double latitude;
  double longitude;

  AddPlace(this.latitude, this.longitude);

  @override
  State<AddPlace> createState() => AddPlaceState(latitude, longitude);
}

class AddPlaceState extends State<AddPlace> {
  double latitude;
  double longitude;

  AddPlaceState(this.latitude, this.longitude);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Add a new place"),
      ),
      body: Column(children: [

      ]),
    );
  }
}
