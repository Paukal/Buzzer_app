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
import 'commentView.dart';
import 'package:social_share/social_share.dart';

class PlaceEventList extends StatefulWidget {
  @override
  _PlaceEventListState createState() => _PlaceEventListState();
}

class _PlaceEventListState extends State<PlaceEventList> {
  var s1 = LoggedInSingleton();

  late Future<List<Event>> eventList;
  late Future<List<Place>> placeList;

  String dropdownValue = 'Events';

  //event filters:
  bool filterDateToday = true;
  bool filterDateTomorrow = false;
  bool filterDateThisWeek = false;
  bool filterDateYesterday = false;
  bool filterDateLastWeek = false;

  //place filters:
  bool restPlaces = true; //poilsiavietes
  bool sceneryPlaces = false; //apzvalgos aiksteles
  bool hikingTrails = false; //pesciuju takai
  bool forts = false;
  bool bikeTrails = false; //dviraciu marsrutai
  bool streetArt = false;
  bool museums = false;
  bool architecture = false;
  bool nature = false;
  bool history = false;
  bool trails = false; //marsrutai
  bool expositions = false;
  bool parks = false;
  bool sculptures = false; //skulpturos ir paminklai
  bool churches = false;
  bool mounds = false; //piliakalniai

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
                                  _navigateAndDisplaySelection2(
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
                                  _navigateAndDisplaySelection3(
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
        top: 90,
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
      Align(
          alignment: Alignment(0.9, -0.75),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(50)),
            width: 40,
            height: 40,
            child: IconButton(
              icon: const Icon(Icons.apps),
              color: Colors.white,
              tooltip: 'Filters',
              onPressed: () {
                _navigateAndDisplaySelection(context);
              },
            ),
          )),
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

  void _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    if (dropdownValue == 'Events') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Processing Events')));

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MapEventFilter(
                filterDateToday,
                filterDateTomorrow,
                filterDateThisWeek,
                filterDateYesterday,
                filterDateLastWeek)),
      );

      setState(() {
        filterDateToday = result[0];
        filterDateTomorrow = result[1];
        filterDateThisWeek = result[2];
        filterDateYesterday = result[3];
        filterDateLastWeek = result[4];

        eventList = assignEventList();
      });
    }

    if (dropdownValue == 'Places') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Processing Places')));

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlaceFilter(
                restPlaces,
                sceneryPlaces,
                hikingTrails,
                forts,
                bikeTrails,
                streetArt,
                museums,
                architecture,
                nature,
                history,
                trails,
                expositions,
                parks,
                sculptures,
                churches,
                mounds)),
      );

      setState(() {
        restPlaces = result[0]; //poilsiavietes
        sceneryPlaces = result[1]; //apzvalgos aiksteles
        hikingTrails = result[2]; //pesciuju takai
        forts = result[3];
        bikeTrails = result[4]; //dviraciu marsrutai
        streetArt = result[5];
        museums = result[6];
        architecture = result[7];
        nature = result[8];
        history = result[9];
        trails = result[10]; //marsrutai
        expositions = result[11];
        parks = result[12];
        sculptures = result[13]; //skulpturos ir paminklai
        churches = result[14];
        mounds = result[15]; //piliakalniai

        placeList = assignPlaceList();
      });
    }
  }

  Future<List<Event>> assignEventList() async {
    return await fetchEventList(filterDateToday, filterDateTomorrow,
        filterDateThisWeek, filterDateYesterday, filterDateLastWeek);
  }

  Future<List<Place>> assignPlaceList() async {
    return await fetchPlaceList(
        restPlaces,
        sceneryPlaces,
        hikingTrails,
        forts,
        bikeTrails,
        streetArt,
        museums,
        architecture,
        nature,
        history,
        trails,
        expositions,
        parks,
        sculptures,
        churches,
        mounds);
  }
}
