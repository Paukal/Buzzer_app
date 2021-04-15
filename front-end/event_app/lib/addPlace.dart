import 'package:flutter/material.dart';
import 'menu.dart';
import 'client.dart';

class AddPlace extends StatefulWidget {
  String city;
  String street;

  AddPlace(this.city, this.street);

  @override
  State<AddPlace> createState() => AddPlaceState(city, street);
}

class AddPlaceState extends State<AddPlace> {
  String city;
  String street;

  AddPlaceState(this.city, this.street);

  var s1 = LoggedInSingleton();
  bool public = false;
  bool popUpForVerify = false;
  final _formKey = GlobalKey<FormState>();

  String placeName = "";
  String placeType = 'restPlaces';
  String link = "";
  String userId = "";

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
        body: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              Column(children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Place name"),
                  onTap: () {
                    setState(() {
                      popUpForVerify = false;
                    });
                  },
                  onChanged: (String? newValue) {
                    setState(() {
                      placeName = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Field can't be empty";
                    }
                    return null;
                  },
                ),
                DropdownButton<String>(
                  value: placeType,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      placeType = newValue!;
                    });
                  },
                  items: <String>[
                    'restPlaces',
                    'sceneryPlaces',
                    'hikingTrails',
                    'forts',
                    'bikeTrails',
                    'streetArt',
                    'museums',
                    'architecture',
                    'nature',
                    'history',
                    'trails',
                    'expositions',
                    'parks',
                    'sculptures',
                    'churches',
                    'mounds'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Link to place page (optional)"),
                  onTap: () {
                    setState(() {
                      popUpForVerify = false;
                    });
                  },
                  onChanged: (String? newValue) {
                    setState(() {
                      link = newValue!;
                    });
                  },
                ),
                SwitchListTile(
                  onChanged: (bool value) {
                    if (s1.accVerified) {
                      setState(() {
                        public = !public;
                      });
                    } else {
                      setState(() {
                        popUpForVerify = true;
                      });
                    }
                  },
                  value: public,
                  title: new Text('Public place',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red)),
                ),
                popUpForVerify
                    ? Text("Need to verify account to make your place public")
                    : Container(),
                ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')));

                      userId = s1.userId;

                      sendNewPlaceDataToServer(placeName, placeType, link,
                          street, city, public.toString(), userId);
                    }
                  },
                  child: Text('Submit'),
                )
              ]),
            ])));
  }
}
