/*
* Lets Go App
* Paulius Tomas Kalvers
* Listing of user created events/places logic
* */

import 'package:flutter/material.dart';
import 'package:social_share/social_share.dart';
import 'commentView.dart';
import 'eventsParse.dart';
import 'placesParse.dart';
import 'client.dart';
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

    return Scaffold(
        appBar: AppBar(title: Text("My created"),),
    body:  Material(
        child: Stack(children: [
          dropdownValue == 'Events'
              ? FutureBuilder<List<Event>>(
            future: eventList,
            builder:
                (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {

              if (snapshot.hasData) {
                events = snapshot.data!;
                if (events.isNotEmpty) {
                  return ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (BuildContext context, int index) {
                        final event = events[index];

                        return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            width: 400,
                            height: 400,
                            child: InkWell(
                              child: Column(
                                children: <Widget>[
                                  Image.network(event.photoUrl, width: 367),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.orange[400],
                                        border: Border.all(
                                            color: Colors.black, width: 0.4)),
                                    height: 45,
                                    width: 367,
                                    child:
                                    Center(child: Text(event.eventName, style: TextStyle(
                                      fontSize: 18.0,
                                    ), textAlign: TextAlign.center)),
                                  ),
                                  Container(
                                    height: 40,
                                    width: 367,
                                    color: Colors.orange[200],
                                    child: Row(
                                      children: [
                                        s1.loggedIn
                                            ? IconButton(
                                          icon: event.liked
                                              ? const Icon(Icons
                                              .whatshot_outlined)
                                              : const Icon(Icons
                                              .whatshot_rounded),
                                          tooltip: 'Like',
                                          onPressed: () {
                                            setState(() {
                                              event.liked =
                                              !event.liked;

                                              if (event.liked == true) {
                                                pressedLikeEvent(event);
                                                eventList =
                                                    assignEventList();
                                              } else {
                                                unpressedLikeEvent(
                                                    event);
                                                eventList =
                                                    assignEventList();
                                              }
                                            });
                                          },
                                        )
                                            : Container(),
                                        s1.loggedIn
                                            ? IconButton(
                                          icon: const Icon(Icons
                                              .add_comment_outlined),
                                          tooltip: 'Like',
                                          onPressed: () {
                                            _navigateAndDisplaySelection4(
                                                context,
                                                "event",
                                                event.eventId);
                                          },
                                        )
                                            : Container(),
                                        IconButton(
                                          icon: const Icon(Icons.email),
                                          tooltip: 'Like',
                                          onPressed: () async {
                                            SocialShare.shareSms(
                                              "Come visit ${event.eventName} at ${event.placeName} at ${event.startDate}",
                                              //url: "\nhttps://google.com/",
                                              trailingText: "\nhello",
                                            ).then((data) {
                                              print(data);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.topLeft,
                                      height: 30,
                                      width: 367,
                                      color: Colors.orange[200],
                                      child: Row(
                                        children: [
                                          Text("${event.likeCount} likes    ",
                                              textAlign: TextAlign.right),
                                          Text("${event.clicks} taps   ",
                                              textAlign: TextAlign.right),
                                          /*Text("    Created by:   ",
                                                textAlign: TextAlign.left)*/
                                        ],
                                      ))
                                ],
                              ),
                              onTap: () {
                                _navigateAndDisplaySelection(
                                    context, event.eventId);

                                setState(() {
                                  eventList = assignEventList();
                                  eventClick(event.eventId.toString());
                                });
                              },
                            ));
                      });
                } else {
                  return Center(
                      child: Text(
                        'No events to show. Maybe still loading?',
                        textAlign: TextAlign.center,
                      ));
                }
              } else {
                return Center(
                    child: Text(
                      'No events to show. Maybe still loading?',
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
                if (places.isNotEmpty) {
                  return ListView.builder(
                      itemCount: places.length,
                      itemBuilder: (BuildContext context, int index) {
                        final place = places[index];

                        return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            width: 400,
                            height: 400,
                            child: InkWell(
                              child: Column(
                                children: <Widget>[
                                  Image.network(place.photoUrl, width: 367),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.orange[400],
                                        border: Border.all(
                                            color: Colors.black, width: 0.4)),
                                    height: 45,
                                    width: 367,
                                    child:
                                    Center(child: Text(place.placeName, style: TextStyle(
                                      fontSize: 18.0,
                                    ), textAlign: TextAlign.center)),
                                  ),
                                  Container(
                                    height: 40,
                                    width: 367,
                                    color: Colors.orange[200],
                                    child: Row(
                                      children: [
                                        s1.loggedIn
                                            ? IconButton(
                                          icon: place.liked
                                              ? const Icon(Icons
                                              .whatshot_outlined)
                                              : const Icon(Icons
                                              .whatshot_rounded),
                                          tooltip: 'Like',
                                          onPressed: () {
                                            setState(() {
                                              place.liked =
                                              !place.liked;

                                              if (place.liked == true) {
                                                pressedLikePlace(place);
                                                placeList =
                                                    assignPlaceList();
                                              } else {
                                                unpressedLikePlace(
                                                    place);
                                                placeList =
                                                    assignPlaceList();
                                              }
                                            });
                                          },
                                        )
                                            : Container(),
                                        s1.loggedIn
                                            ? IconButton(
                                          icon: const Icon(Icons
                                              .add_comment_outlined),
                                          tooltip: 'Like',
                                          onPressed: () {
                                            _navigateAndDisplaySelection4(
                                                context,
                                                "place",
                                                place.placeId);
                                          },
                                        )
                                            : Container(),
                                        IconButton(
                                          icon: const Icon(Icons.email),
                                          tooltip: 'Like',
                                          onPressed: () async {
                                            SocialShare.shareSms(
                                              "Come visit ${place.placeName} which is a ${place.placeType}",
                                              //url: "\nhttps://google.com/",
                                              trailingText: "\nhello",
                                            ).then((data) {
                                              print(data);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.topLeft,
                                      height: 30,
                                      width: 367,
                                      color: Colors.orange[200],
                                      child: Row(
                                        children: [
                                          Text("${place.likeCount} likes    ",
                                              textAlign: TextAlign.right),
                                          Text("${place.clicks} taps   ",
                                              textAlign: TextAlign.right),
                                          /*Text("    Created by:   ",
                                                textAlign: TextAlign.left)*/
                                        ],
                                      ))
                                ],
                              ),
                              onTap: () {
                                _navigateAndDisplaySelection2(
                                    context, place.placeId);

                                setState(() {
                                  placeList = assignPlaceList();
                                  placeClick(place.placeId.toString());
                                });
                              },
                            ));
                      });
                } else {
                  return Center(
                      child: Text(
                        'No places to show. Maybe still loading?',
                        textAlign: TextAlign.center,
                      ));
                }
              } else {
                return Center(
                    child: Text(
                      'No places to show. Maybe still loading?',
                      textAlign: TextAlign.center,
                    ));
              }
            },
          )
              : Container(),
          Positioned(
            top: 20,
            right: 310,
            left: 15,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white70, borderRadius: BorderRadius.circular(10)),
                height: 30,
                child: DropdownButton<String>(
                  value: dropdownValue,
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.indigo),
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
                )),
          ),
        ])));
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

  void _navigateAndDisplaySelection4(
      BuildContext context, String object, int objectId) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CommentView(object, objectId)),
    );

    setState(() {});
  }

  Future<List<Event>> assignEventList() async {
    return await fetchUserEventData(s1.userId);
  }

  Future<List<Place>> assignPlaceList() async {
    return await fetchUserPlaceData(s1.userId);
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
}
