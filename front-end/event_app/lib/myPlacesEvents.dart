import 'package:flutter/material.dart';
import 'eventsParse.dart';
import 'placesParse.dart';
import 'client.dart';
import 'eventFilter.dart';
import 'menu.dart';
import 'userEventView.dart';
import 'userPlaceView.dart';

class MyPlacesEvents extends StatefulWidget {
  @override
  _MyPlacesEventsState createState() => _MyPlacesEventsState();
}

class _MyPlacesEventsState extends State<MyPlacesEvents> {
  late Future<List<Event>> eventList;
  late Future<List<Place>> placeList;

  String dropdownValue = 'Events';

  var s1 = LoggedInSingleton();

  @override
  void initState() {
    super.initState();
    eventList = assignEventList();
    placeList = assignPlaceList();
  }

  @override
  Widget build(BuildContext context) {
    List<Event> events;
    List<Place> places;

    return Material(
        child: Stack(children: [
      dropdownValue == 'Events'
          ? FutureBuilder<List<Event>>(
              future: eventList,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
                if (snapshot.hasData) {
                  events = snapshot.data!;
                  return ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (BuildContext context, int index) {
                        final event = events[index];

                        return InkWell(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 50,
                                color: Colors.amber[200],
                                child: Center(child: Text(event.eventName)),
                              ),
                            ],
                          ),
                          onTap: () {
                            _navigateAndDisplaySelection(context, event.eventId);
                          },
                        );
                      });
                } else {
                  return Text('Empty list');
                }
              },
            )
          : Container(),
      dropdownValue == 'Places'
          ? FutureBuilder<List<Place>>(
              future: placeList,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Place>> snapshot2) {
                if (snapshot2.hasData) {
                  places = snapshot2.data!;
                  return ListView.builder(
                      itemCount: places.length,
                      itemBuilder: (BuildContext context, int index) {
                        final place = places[index];

                        return InkWell(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 50,
                              color: Colors.amber[200],
                              child: Center(child: Text(place.placeName)),
                            ),
                          ],
                        ),
                          onTap: () {
                            _navigateAndDisplaySelection2(context, place.placeId);
                          },);
                      });
                } else {
                  return Text('Empty list');
                }
              },
            )
          : Container(),
      Positioned(
        top: 60,
        right: 310,
        left: 15,
        child: DropdownButton<String>(
          value: dropdownValue,
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
              dropdownValue = newValue!;
            });
          },
          items: <String>['Events', 'Places']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    ]));
  }

  void _navigateAndDisplaySelection(BuildContext context, int eventId) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UserEventView(eventId.toString())),
    );

    setState(() {});
  }

  void _navigateAndDisplaySelection2(BuildContext context, int placeId) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UserPlaceView(placeId.toString())),
    );

    setState(() {});
  }

  Future<List<Event>> assignEventList() async {
    return await fetchUserEventData(s1.userId);
  }

  Future<List<Place>> assignPlaceList() async {
    return await fetchUserPlaceData(s1.userId);
  }
}
