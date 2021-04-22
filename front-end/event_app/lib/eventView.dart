import 'package:flutter/material.dart';
import 'client.dart';
import 'eventsParse.dart';

class EventView extends StatefulWidget {
  String eventId;

  EventView(this.eventId);

  @override
  _EventViewState createState() => _EventViewState(eventId);
}

class _EventViewState extends State<EventView> {
  String eventId;

  _EventViewState(this.eventId);

  late Future<Event> event;

  @override
  void initState() {
    super.initState();
    event = getEventInfo();
  }

  @override
  Widget build(BuildContext context) {
    Event eventData;

    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FutureBuilder<Event>(
                    future: event,
                    builder: (BuildContext context,
                        AsyncSnapshot<Event> snapshot) {
                      if (snapshot.hasData) {
                        eventData = snapshot.data!;
                        return Column(
                          children: <Widget>[
                            Image.network(eventData.photoUrl),
                            Container(
                              height: 50,
                              color: Colors.amber[200],
                              child: Center(child: Text(eventData.eventName)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.amber[200],
                              child: Center(child: Text(eventData.placeName)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.amber[200],
                              child: Center(child: Text(eventData.link)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.amber[200],
                              child: Center(child: Text(eventData.address)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.amber[200],
                              child: Center(child: Text(eventData.city)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.amber[200],
                              child: Center(child: Text(eventData.startDate)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.amber[200],
                              child: Center(child: Text(eventData.public.toString())),
                            ),
                          ],
                        );
                      } else {
                        return Text('Empty list');
                      }
                    },
                  )
                ])),
      ),
    );
  }

  Future<Event> getEventInfo() async {
    return await fetchEventViewData(eventId);
  }
}
