/*
* Lets Go App
* Paulius Tomas Kalvers
* Listing of events/places logic
* */

import 'package:flutter/material.dart';
import 'eventsParse.dart';
import 'placesParse.dart';
import 'client.dart';
import 'eventFilter.dart';
import 'placeFilter.dart';
import 'eventView.dart';
import 'placeView.dart';
import 'menu.dart';

class PlaceEventListLikes extends StatefulWidget {
  @override
  _PlaceEventListState createState() => _PlaceEventListState();
}

class _PlaceEventListState extends State<PlaceEventListLikes> {
  var s1 = LoggedInSingleton();

  late Future<List<Event>> eventList;
  late Future<List<Place>> placeList;

  String dropdownValue = 'Events';

  @override
  void initState() {
    super.initState();
    eventList = fetchEventListLiked();
    placeList = fetchPlaceListLiked();
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
                  if(events.isNotEmpty){

                  return ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (BuildContext context, int index) {
                        final event = events[index];

                        return InkWell(
                          child: Column(
                            children: <Widget>[
                              Image.network(event.photoUrl),
                              Container(
                                height: 50,
                                color: Colors.amber[200],
                                child: Center(child: Text(event.eventName)),
                              ),
                              Container(
                                height: 50,
                                color: Colors.amber[200],
                                child: Row(
                                  children: [
                                    s1.loggedIn
                                        ? IconButton(
                                      icon: event.liked
                                          ? const Icon(
                                          Icons.whatshot_outlined)
                                          : const Icon(
                                          Icons.whatshot_rounded),
                                      tooltip: 'Like',
                                      onPressed: () {
                                        setState(() {
                                          event.liked = !event.liked;

                                          if (event.liked == true) {
                                            pressedLikeEvent(event);
                                            eventList = fetchEventListLiked();
                                          } else {
                                            unpressedLikeEvent(event);
                                            eventList = fetchEventListLiked();
                                          }
                                        });
                                      },
                                    )
                                        : Container(),
                                    Text(" Comment "),
                                    Text(" Share"),
                                  ],
                                ),
                              ),
                              Container(
                                  alignment: Alignment.topLeft,
                                  height: 50,
                                  color: Colors.amber[200],
                                  child: Column(
                                    children: [
                                      Text("Likes: ${event.likeCount}",
                                          textAlign: TextAlign.right),
                                      Text("Seen: ${event.clicks}",
                                          textAlign: TextAlign.right),
                                      Text("Created by:",
                                          textAlign: TextAlign.left)
                                    ],
                                  ))
                            ],
                          ),
                          onTap: () {
                            _navigateAndDisplaySelection2(
                                context, event.eventId);

                            setState(() {
                              eventList = fetchEventListLiked();
                              eventClick(event.eventId.toString());
                            });
                          },
                        );
                      });
                }
                else {
                  return Center(
                      child: Text(
                        'No events to show',
                        textAlign: TextAlign.center,
                      ));
                }
                } else {
                  return Center(
                      child: Text(
                    'No events to show',
                    textAlign: TextAlign.center,
                  ));
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
                  if(places.isNotEmpty) {
                    return ListView.builder(
                        itemCount: places.length,
                        itemBuilder: (BuildContext context, int index) {
                          final place = places[index];

                          return InkWell(
                            child: Column(
                              children: <Widget>[
                                Image.network(place.photoUrl),
                                Container(
                                  height: 50,
                                  color: Colors.amber[200],
                                  child: Center(child: Text(place.placeName)),
                                ),
                                Container(
                                  height: 50,
                                  color: Colors.amber[200],
                                  child: Row(
                                    children: [
                                      s1.loggedIn
                                          ? IconButton(
                                        icon: place.liked
                                            ? const Icon(
                                            Icons.whatshot_outlined)
                                            : const Icon(
                                            Icons.whatshot_rounded),
                                        tooltip: 'Like',
                                        onPressed: () {
                                          setState(() {
                                            place.liked = !place.liked;

                                            if (place.liked == true) {
                                              pressedLikePlace(place);
                                              placeList = fetchPlaceListLiked();
                                            } else {
                                              unpressedLikePlace(place);
                                              placeList = fetchPlaceListLiked();
                                            }
                                          });
                                        },
                                      )
                                          : Container(),
                                      Text(" Comment "),
                                      Text(" Share"),
                                    ],
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.topLeft,
                                    height: 50,
                                    color: Colors.amber[200],
                                    child: Column(
                                      children: [
                                        Text("Likes: ${place.likeCount}",
                                            textAlign: TextAlign.right),
                                        Text("Seen: ${place.clicks}",
                                            textAlign: TextAlign.right),
                                        Text("Created by:",
                                            textAlign: TextAlign.left)
                                      ],
                                    ))
                              ],
                            ),
                            onTap: () {
                              _navigateAndDisplaySelection3(
                                  context, place.placeId);

                              setState(() {
                                placeList = fetchPlaceListLiked();
                                placeClick(place.placeId.toString());
                              });
                            },
                          );
                        });
                  }
                  else {
                    return Center(
                        child: Text(
                          'No places to show',
                          textAlign: TextAlign.center,
                        ));
                  }
                } else {
                  return Center(
                      child: Text(
                    'No places to show',
                    textAlign: TextAlign.center,
                  ));
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

  Future<void> pressedLikeEvent(Event event) async {
    event.likeId =
        await sendPressedLike(s1.userId, "event", event.eventId.toString());
  }

  void unpressedLikeEvent(Event event) {
    sendUnpressedLike(event.likeId);
  }

  Future<void> pressedLikePlace(Place place) async {
    place.likeId =
        await sendPressedLike(s1.userId, "place", place.placeId.toString());
  }

  void unpressedLikePlace(Place place) {
    sendUnpressedLike(place.likeId);
  }

  void _navigateAndDisplaySelection2(BuildContext context, int eventId) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventView(eventId.toString())),
    );

    setState(() {});
  }

  void _navigateAndDisplaySelection3(BuildContext context, int placeId) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlaceView(placeId.toString())),
    );

    setState(() {});
  }

}
