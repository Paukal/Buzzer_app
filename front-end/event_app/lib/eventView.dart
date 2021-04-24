/*
* Lets Go App
* Paulius Tomas Kalvers
* Single event preview logic
* */

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

class EventView extends StatefulWidget {
  String eventId;

  EventView(this.eventId);

  @override
  _EventViewState createState() => _EventViewState(eventId);
}

class _EventViewState extends State<EventView> {
  _EventViewState(this.eventId);

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

    return Material(
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
                child: Center(
                    child: new InkWell(
                        child: new Text('LINK'),
                        onTap: () => launch(eventData.link))),
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
              FutureBuilder<List<dynamic>>(
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
                          tooltipBehavior: TooltipBehavior(enable: true),
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
                  }),
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
    ));
  }

  Future<Event> getEventInfo() async {
    likeCounts = getLikeChart("event", eventId);

    return await fetchEventViewData(eventId);
  }
}
