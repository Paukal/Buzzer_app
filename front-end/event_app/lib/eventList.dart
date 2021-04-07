import 'package:flutter/material.dart';
import 'eventsParse.dart';
import 'client.dart';
import 'eventFilter.dart';

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  late Future<List<Event>> eventList;

  bool filterDateToday = true;
  bool filterDateTomorrow = false;
  bool filterDateThisWeek = false;
  bool filterDateYesterday = false;
  bool filterDateLastWeek = false;

  @override
  void initState() {
    super.initState();
    eventList = assignList();
  }

  @override
  Widget build(BuildContext context) {
    List<Event> list;

    return Stack(children: [
      FutureBuilder<List<Event>>(
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
                });
          } else {
            return Text('Empty list');
          }
        },
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
    ]);
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
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

      eventList = assignList();
    });
  }

  Future<List<Event>> assignList() async {
    return await fetchEventList(filterDateToday, filterDateTomorrow,
        filterDateThisWeek, filterDateYesterday, filterDateLastWeek);
  }
}
