/*
* Lets Go App
* Paulius Tomas Kalvers
* Update event created by user logic
* */

import 'package:flutter/material.dart';
import 'client.dart';
import 'eventsParse.dart';

class UserEventUpdate extends StatefulWidget {
  Event event;

  UserEventUpdate(this.event);

  @override
  State<UserEventUpdate> createState() => UserEventUpdateState(event);
}

class UserEventUpdateState extends State<UserEventUpdate> {
  Event event;

  UserEventUpdateState(this.event);

  bool popUpForVerify = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    eventName = event.eventName;
    placeName = event.placeName;
    link = event.link;
    city = event.city;
    street = event.address;
    startDate = event.startDate;
    eventId = event.eventId.toString();
    public = event.public;
  }

  late String eventName;
  late String placeName;
  late String link;
  late String city;
  late String street;
  late String startDate;
  late String eventId;
  late bool public;

  @override
  Widget build(BuildContext context) {
    ScrollController _controller = new ScrollController();

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
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(), // new
                  controller: _controller,
                  children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: "Event name"),
                  initialValue: eventName,
                  onTap: () {
                    setState(() {
                      popUpForVerify = false;
                    });
                  },
                  onChanged: (String? newValue) {
                    setState(() {
                      eventName = newValue!;
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
                  decoration:
                      InputDecoration(labelText: "Place name (optional)"),
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
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Link to event page (optional)"),
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
                TextFormField(
                  initialValue: startDate,
                  decoration: InputDecoration(labelText: "Start date"),
                  keyboardType: TextInputType.datetime,
                  onTap: () {
                    setState(() {
                      popUpForVerify = false;
                    });
                  },
                  onChanged: (String? newValue) {
                    setState(() {
                      startDate = newValue!;
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

                      sendChangedEventDataToServer(
                          eventId,
                          eventName,
                          placeName,
                          link,
                          street,
                          city,
                          startDate,
                          public.toString());
                    }
                  },
                  child: Text('Submit'),
                )
              ]),
            )));
  }
}
