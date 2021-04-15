import 'package:flutter/material.dart';
import 'client.dart';
import 'eventsParse.dart';
import 'userEventUpdate.dart';

class UserEventView extends StatefulWidget {
  String eventId;

  UserEventView(this.eventId);

  @override
  _UserEventViewState createState() => _UserEventViewState(eventId);
}

class _UserEventViewState extends State<UserEventView> {
  String eventId;

  _UserEventViewState(this.eventId);

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
                            Align(
                                alignment: Alignment(0.8, -0.75),
                                child: SizedBox(
                                  width: 45, // <-- match_parent
                                  height: 35,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _navigateAndDisplaySelection(context, eventData);
                                    },
                                    child: const Icon(Icons.apps, size: 20),
                                  ),
                                )),
                            Align(
                                alignment: Alignment(0.8, -0.75),
                                child: SizedBox(
                                  width: 45, // <-- match_parent
                                  height: 35,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      deleteEvent();
                                    },
                                    child: const Icon(Icons.clear, size: 20),
                                  ),
                                )),
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

  void _navigateAndDisplaySelection(BuildContext context, Event event) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UserEventUpdate(event)),
    );

    setState(() {});
  }

  void deleteEvent() {
    sendDeleteEventDataToServer(eventId);
  }

  Future<Event> getEventInfo() async {
    return await fetchEventViewData(eventId);
  }
}
