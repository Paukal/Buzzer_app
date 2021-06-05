/*
* Lets Go App
* Paulius Tomas Kalvers
* Single event preview logic
* */

import 'package:event_app/myPlacesEvents.dart';
import 'package:event_app/userEventUpdate.dart';
import 'package:flutter/material.dart';
import 'client.dart';
import 'eventsParse.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

class _LikeData {
  _LikeData(this.day, this.likes);

  final String day;
  final int likes;
}

class UserEventView extends StatefulWidget {
  String eventId;

  UserEventView(this.eventId);

  @override
  _UserEventViewState createState() => _UserEventViewState(eventId);
}

class _UserEventViewState extends State<UserEventView> {
  _UserEventViewState(this.eventId);

  late String eventId;
  late Future<Event> event;
  late Future<List<dynamic>> likeCounts;

  final DateTime now = DateTime.now();
  late String beforeSevenDays;
  late String beforeSixDays;
  late String beforeFiveDays;
  late String beforeFourDays;
  late String beforeThreeDays;
  late String beforeTwoDays;
  late String beforeOneDays;
  late String today;

  late List<_LikeData> data;

  @override
  void initState() {
    super.initState();
    event = getEventInfo();
    beforeSevenDays = now
        .subtract(Duration(
            days: 7,
            hours: 0,
            minutes: 0,
            seconds: 0,
            milliseconds: 0,
            microseconds: 0))
        .day
        .toString();
    beforeSixDays = now
        .subtract(Duration(
            days: 6,
            hours: 0,
            minutes: 0,
            seconds: 0,
            milliseconds: 0,
            microseconds: 0))
        .day
        .toString();
    beforeFiveDays = now
        .subtract(Duration(
            days: 5,
            hours: 0,
            minutes: 0,
            seconds: 0,
            milliseconds: 0,
            microseconds: 0))
        .day
        .toString();
    beforeFourDays = now
        .subtract(Duration(
            days: 4,
            hours: 0,
            minutes: 0,
            seconds: 0,
            milliseconds: 0,
            microseconds: 0))
        .day
        .toString();
    beforeThreeDays = now
        .subtract(Duration(
            days: 3,
            hours: 0,
            minutes: 0,
            seconds: 0,
            milliseconds: 0,
            microseconds: 0))
        .day
        .toString();
    beforeTwoDays = now
        .subtract(Duration(
            days: 2,
            hours: 0,
            minutes: 0,
            seconds: 0,
            milliseconds: 0,
            microseconds: 0))
        .day
        .toString();
    beforeOneDays = now
        .subtract(Duration(
            days: 1,
            hours: 0,
            minutes: 0,
            seconds: 0,
            milliseconds: 0,
            microseconds: 0))
        .day
        .toString();
    today = now.day.toString();

    data = [];
  }

  @override
  Widget build(BuildContext context) {
    Event eventData;
    ScrollController _controller = new ScrollController();

    return Scaffold(
        appBar: AppBar(
          title: Text("My event"),
        ),
        body: Material(
            child: FutureBuilder<Event>(
          future: event,
          builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
            if (snapshot.hasData) {
              eventData = snapshot.data!;
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(), // new
                controller: _controller,
                children: <Widget>[
                  Image.network(eventData.photoUrl),
                  Row(children: [
                    Align(
                        alignment: Alignment(0.9, -0.75),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.circular(10)),
                          width: 196.3,
                          height: 40,
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            color: Colors.white,
                            tooltip: 'Edit event',
                            onPressed: () {
                              _navigateAndDisplaySelection(context, eventData);
                            },
                          ),
                        )),
                    Align(
                        alignment: Alignment(0.9, -0.75),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.circular(10)),
                          width: 196.3,
                          height: 40,
                          child: IconButton(
                            icon: const Icon(Icons.clear),
                            color: Colors.white,
                            tooltip: 'Delete event',
                            onPressed: () {
                              deleteEvent();
                            },
                          ),
                        )),
                  ]),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.orange[400],
                        border: Border.all(color: Colors.black, width: 0.4)),
                    height: 55,
                    width: 367,
                    child: Center(
                        child: Text(eventData.eventName,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.center)),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.orange[200]),
                    height: 45,
                    width: 367,
                    child: Row(children: [
                      const Icon(Icons.account_balance_outlined),
                      Text("  ${eventData.placeName}")
                    ]),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.orange[200]),
                    height: 45,
                    width: 367,
                    child: Center(
                        child: new InkWell(
                            child: Row(children: [
                              const Icon(Icons.public),
                              new Text('  LINK')
                            ]),
                            onTap: () => launch(eventData.link))),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.orange[200]),
                    height: 45,
                    width: 367,
                    child: Row(children: [
                      const Icon(Icons.add_location_rounded),
                      Text("  ${eventData.address}")
                    ]),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.orange[200]),
                    height: 45,
                    width: 367,
                    child: Row(children: [
                      const Icon(Icons.add_location_rounded),
                      Text("  ${eventData.city}")
                    ]),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.orange[200]),
                    height: 45,
                    width: 367,
                    child: Row(children: [
                      const Icon(Icons.event),
                      Text("  ${eventData.startDate}")
                    ]),
                  ),
                  Container(
                      decoration: BoxDecoration(color: Colors.orange[100]),
                      child: FutureBuilder<List<dynamic>>(
                          future: likeCounts,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<dynamic>> snapshot) {
                            if (snapshot.hasData) {
                              data = [
                                _LikeData(beforeSevenDays, snapshot.data![0]),
                                _LikeData(beforeSixDays, snapshot.data![1]),
                                _LikeData(beforeFiveDays, snapshot.data![2]),
                                _LikeData(beforeFourDays, snapshot.data![3]),
                                _LikeData(beforeThreeDays, snapshot.data![4]),
                                _LikeData(beforeTwoDays, snapshot.data![5]),
                                _LikeData(beforeOneDays, snapshot.data![6]),
                                _LikeData(today, snapshot.data![7])
                              ];
                              return SfCartesianChart(
                                  primaryXAxis: CategoryAxis(),
                                  // Chart title
                                  title: ChartTitle(text: 'Popularity (likes)'),
                                  // Enable legend
                                  legend: Legend(isVisible: false),
                                  // Enable tooltip
                                  tooltipBehavior:
                                      TooltipBehavior(enable: true),
                                  series: <ChartSeries<_LikeData, String>>[
                                    LineSeries<_LikeData, String>(
                                        dataSource: data,
                                        xValueMapper: (_LikeData sales, _) =>
                                            sales.day,
                                        yValueMapper: (_LikeData sales, _) =>
                                            sales.likes,
                                        name: 'Likes',
                                        // Enable data label
                                        dataLabelSettings:
                                            DataLabelSettings(isVisible: true))
                                  ]);
                            } else {
                              return Center(
                                  child: Text(
                                'No data',
                                textAlign: TextAlign.center,
                              ));
                            }
                          })),
                ],
              );
            } else {
              return Center(
                  child: Text(
                'Nothing to show',
                textAlign: TextAlign.center,
              ));
            }
          },
        )));
  }

  Future<Event> getEventInfo() async {
    likeCounts = getLikeChart("event", eventId);

    return await fetchEventViewData(eventId);
  }

  void _navigateAndDisplaySelection(BuildContext context, Event ev) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserEventUpdate(ev)),
    );

    setState(() {
      event = getEventInfo();
    });
  }

  void deleteEvent() {
    sendDeleteEventDataToServer(eventId);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyPlacesEvents()),
    );
  }
}
