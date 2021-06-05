/*
* Lets Go App
* Paulius Tomas Kalvers
* Add place created by user logic
* */

import 'package:flutter/material.dart';
import 'menu.dart';
import 'client.dart';
import 'localDatabase.dart';
import 'myPlacesEvents.dart';

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
  String placeType = 'Rest places';
  String link = "";
  String userId = "";
  String photoUrl = "";

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
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(children: [
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
                Align(
                  alignment: Alignment(-1, 0),
                  child: DropdownButton<String>(
                    value: placeType,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        placeType = newValue!;
                      });
                    },
                    items: <String>[
                      'Rest places',
                      'Scenery places',
                      'Hiking trails',
                      'Forts',
                      'Bike trails',
                      'Street art',
                      'Museums',
                      'Architecture',
                      'Nature',
                      'History',
                      'Trails',
                      'Expositions',
                      'Parks',
                      'Sculptures',
                      'Churches',
                      'Mounds'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
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
                      photoUrl =
                          "https://www.marketing91.com/wp-content/uploads/2020/02/Definition-of-place-marketing.jpg";

                      if (placeType == "Rest places")
                        placeType = 'restPlaces';
                      else if (placeType == "Scenery places")
                        placeType = 'sceneryPlaces';
                      else if (placeType == "Hiking trails")
                        placeType = 'hikingTrails';
                      else if (placeType == "Forts")
                        placeType = 'forts';
                      else if (placeType == "Bike trails")
                        placeType = 'bikeTrails';
                      else if (placeType == "Street art")
                        placeType = 'streetArt';
                      else if (placeType == "Museums")
                        placeType = 'museums';
                      else if (placeType == "Architecture")
                        placeType = 'architecture';
                      else if (placeType == "Nature")
                        placeType = 'nature';
                      else if (placeType == "History")
                        placeType = 'history';
                      else if (placeType == "Trails")
                        placeType = 'trails';
                      else if (placeType == "Expositions")
                        placeType = 'expositions';
                      else if (placeType == "Parks")
                        placeType = 'parks';
                      else if (placeType == "Sculptures")
                        placeType = 'sculptures';
                      else if (placeType == "Churches")
                        placeType = 'churches';
                      else if (placeType == "Mounds")
                        placeType = 'mounds';

                      sendNewPlaceDataToServer(placeName, placeType, link,
                          street, city, public.toString(), userId, photoUrl);

                      var localDB = DB();
                      localDB.placesStored = false;

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyPlacesEvents()),
                      );
                    }
                  },
                  child: Text('Submit'),
                )
              ]),
            )));
  }
}
