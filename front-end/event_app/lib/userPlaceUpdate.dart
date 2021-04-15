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
          title: Text("Change event details"),
        ),
        body: Form(
            key: _formKey,
            child: Column(children: <Widget>[
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
                    if (public) {
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
                  title: new Text('Public event',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red)),
                ),
                popUpForVerify
                    ? Text("Need to verify account to make your event public")
                    : Container(),
                ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')));


                      sendChangedPlaceDataToServer(placeId, placeName, placeType, link, street, city, public.toString());
                    }
                  },
                  child: Text('Submit'),
                )
              ]),
            ])));
  }
}
