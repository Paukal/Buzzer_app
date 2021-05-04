/*
* Lets Go App
* Paulius Tomas Kalvers
* Update place created by user logic
* */

import 'package:flutter/material.dart';
import 'client.dart';
import 'placesParse.dart';

class UserPlaceUpdate extends StatefulWidget {

  Place place;

  UserPlaceUpdate(this.place);

  @override
  State<UserPlaceUpdate> createState() => UserPlaceUpdateState(place);
}

class UserPlaceUpdateState extends State<UserPlaceUpdate> {

  Place place;

  UserPlaceUpdateState(this.place);

  bool popUpForVerify = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    placeName = place.placeName;
    placeType = place.placeType;
    link = place.link;
    city = place.city;
    street = place.address;
    placeId = place.placeId.toString();
    public = place.public;

    if (placeType == "restPlaces")
      placeType = 'Rest places';
    else if (placeType == "sceneryPlaces")
      placeType = 'Scenery places';
    else if (placeType == "hikingTrails")
      placeType = 'Hiking trails';
    else if (placeType == "forts")
      placeType = 'Forts';
    else if (placeType == "bikeTrails")
      placeType = 'Bike trails';
    else if (placeType == "streetArt")
      placeType = 'Street art';
    else if (placeType == "museums")
      placeType = 'Museums';
    else if (placeType == "architecture")
      placeType = 'Architecture';
    else if (placeType == "nature")
      placeType = 'Nature';
    else if (placeType == "history")
      placeType = 'History';
    else if (placeType == "trails")
      placeType = 'Trails';
    else if (placeType == "expositions")
      placeType = 'Expositions';
    else if (placeType == "parks")
      placeType = 'Parks';
    else if (placeType == "sculptures")
      placeType = 'Sculptures';
    else if (placeType == "churches")
      placeType = 'Churches';
    else if (placeType == "mounds")
      placeType = 'Mounds';
  }

  late String placeName;
  late String placeType;
  late String link;
  late String city;
  late String street;
  late String placeId;
  late bool public;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text("Change place details"),
        ),
        body: Form(
            key: _formKey,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                Column(children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Place name"),
                  initialValue: placeName,
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
                  decoration:
                  InputDecoration(labelText: "Link to place page (optional)"),
                  initialValue: link,
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
                TextFormField(
                  initialValue: city,
                  decoration: InputDecoration(labelText: "city"),
                  onTap: () {
                    setState(() {
                      popUpForVerify = false;
                    });
                  },
                  onChanged: (String? newValue) {
                    setState(() {
                      city = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Field can't be empty";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: street,
                  decoration: InputDecoration(labelText: "Address"),
                  onTap: () {
                    setState(() {
                      popUpForVerify = false;
                    });
                  },
                  onChanged: (String? newValue) {
                    setState(() {
                      street = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Field can't be empty";
                    }
                    return null;
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

                      sendChangedPlaceDataToServer(placeId, placeName, placeType, link, street, city, public.toString());
                    }
                  },
                  child: Text('Submit'),
                )
              ]),
            )));
  }
}
