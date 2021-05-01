/*
* Lets Go App
* Paulius Tomas Kalvers
* Single place preview logic
* */

import 'package:flutter/material.dart';
import 'client.dart';
import 'placesParse.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

class _LikeData {
  _LikeData(this.day, this.likes);

  final String day;
  final int likes;
}

class PlaceView extends StatefulWidget {
  String placeId;

  PlaceView(this.placeId);

  @override
  _PlaceViewState createState() => _PlaceViewState(placeId);
}

class _PlaceViewState extends State<PlaceView> {
  _PlaceViewState(this.placeId);

  late String placeId;
  late Future<Place> place;
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
    place = getPlaceInfo();

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
    Place placeData;
    ScrollController _controller = new ScrollController();

    return Material(
        child: FutureBuilder<Place>(
      future: place,
      builder: (BuildContext context, AsyncSnapshot<Place> snapshot) {
        if (snapshot.hasData) {
          placeData = snapshot.data!;
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(), // new
            controller: _controller,
            children: <Widget>[
              Image.network(placeData.photoUrl),
              Container(
                decoration: BoxDecoration(
                    color: Colors.orange[400],
                    border: Border.all(color: Colors.black, width: 0.4)),
                height: 55,
                width: 367,
                child: Center(
                    child: Text(placeData.placeName,
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
                  const Icon(Icons.approval),
                  Text("  ${placeData.placeType}")
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
                        onTap: () => launch(placeData.link))),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.orange[200]),
                height: 45,
                width: 367,
                child: Row(children: [
                  const Icon(Icons.add_location_rounded),
                  Text("  ${placeData.address}")
                ]),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.orange[200]),
                height: 45,
                width: 367,
                child: Row(children: [
                  const Icon(Icons.add_location_rounded),
                  Text("  ${placeData.city}")
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
    ));
  }

  Future<Place> getPlaceInfo() async {
    likeCounts = getLikeChart("place", placeId);

    return await fetchPlaceViewData(placeId);
  }
}
