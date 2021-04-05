import 'package:flutter/material.dart';
import 'eventsParse.dart';
import 'client.dart';

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  late Future<List<Event>> eventList;

  @override
  void initState() {
    super.initState();
    eventList = assignList();
  }

  void _retry() {
    setState(() {
      eventList = assignList();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Event> list;

    return FutureBuilder<List<Event>>(
          future: eventList,
          builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
            if (snapshot.hasData) {
              list = snapshot.data!;
              return ListView.builder(


                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    final event = list[index];

                    return Column(
                      children: <Widget>[
                        Container(
                          height: 50,
                          color: Colors.amber[200],
                          child: Center(child: Text(event.eventName)),
                        ),
                      ],
                    );
                  }
              );
            } else {
              return Text('Empty list');
            }
          },
        );
    /*ListView(
    padding: const EdgeInsets.all(80),
    children: <Widget>[
        Container(
          height: 50,
          color: Colors.amber[600],
          child: const Center(child: Text('Entry A')),
        ),
        Container(
          height: 50,
          color: Colors.amber[500],
          child: const Center(child: Text('Entry B')),
        ),
        Container(
          height: 50,
          color: Colors.amber[100],
          child: const Center(child: Text('Entry C')),
        ),
        RaisedButton(
          onPressed: _retry,
          child: Text('Retry'),
        )
      ],
    );*/
  }

  Future<List<Event>> assignList() async {
    return await fetchData();
  }
}