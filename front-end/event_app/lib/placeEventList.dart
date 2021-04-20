import 'package:flutter/material.dart';
import 'eventsParse.dart';
import 'placesParse.dart';
import 'client.dart';
import 'eventFilter.dart';
import 'placeFilter.dart';
import 'eventView.dart';
import 'placeView.dart';

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
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
                            _navigateAndDisplaySelection2(
                                context, event.eventId);
                          },
                        );
                      });
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
                            _navigateAndDisplaySelection3(
                                context, place.placeId);
                          },
                        );
                      });
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
      Align(
          alignment: Alignment(0.8, -0.75),
          child: SizedBox(
            width: 45, // <-- match_parent
            height: 35,
            child: ElevatedButton(
              onPressed: () {
                _navigateAndDisplaySelection(context);
              },
              child: const Icon(Icons.navigation, size: 20),
            ),
          )),
    ]));
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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Processing Events')));

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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Processing Places')));

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
