/*
* Lets Go App
* Paulius Tomas Kalvers
* Single place preview logic
* */

import 'package:event_app/userPlaceUpdate.dart';
import 'package:flutter/material.dart';
import 'client.dart';
import 'myPlacesEvents.dart';
import 'placesParse.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

class _LikeData {
  _LikeData(this.day, this.likes);

  final String day;
  final int likes;
}

class UserPlaceView extends StatefulWidget {
  String placeId;

  UserPlaceView(this.placeId);

  @override
  _UserPlaceViewState createState() => _UserPlaceViewState(placeId);
}

class _UserPlaceViewState extends State<UserPlaceView> {
  _UserPlaceViewState(this.placeId);

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

    return Scaffold(
        appBar: AppBar(
          title: Text("My place"),
        ),
        body: Material(
            child: FutureBuilder<Place>(
          future: place,
          builder: (BuildContext context, AsyncSnapshot<Place> snapshot) {
            if (snapshot.hasData) {
              placeData = snapshot.data!;

              String placeType = placeData.placeType;

              if (placeType == "restPlaces")
                placeType = 'Rest places';
              else if (placeType == "sceneryPlaces")
                placeType = 'Scenery places';
              else if (placeType == "hikingTrails")
                placeType = 'Hiking trails';
              else if (placeType == "forts")
                placeType = 'Forts';
              else if (placeType == "bikeTrails")
                placeType = 'Bike trails';
              else if (placeType == "streetArt")
                placeType = 'Street art';
              else if (placeType == "museums")
                placeType = 'Museums';
              else if (placeType == "architecture")
                placeType = 'Architecture';
              else if (placeType == "nature")
                placeType = 'Nature';
              else if (placeType == "history")
                placeType = 'History';
              else if (placeType == "trails")
                placeType = 'Trails';
              else if (placeType == "expositions")
                placeType = 'Expositions';
              else if (placeType == "parks")
                placeType = 'Parks';
              else if (placeType == "sculptures")
                placeType = 'Sculptures';
              else if (placeType == "churches")
                placeType = 'Churches';
              else if (placeType == "mounds") placeType = 'Mounds';

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(), // new
                controller: _controller,
                children: <Widget>[
                  Image.network(placeData.photoUrl),
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
                            tooltip: 'Edit place',
                            onPressed: () {
                              _navigateAndDisplaySelection(context, placeData);
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
                            tooltip: 'Delete place',
                            onPressed: () {
                              deletePlace();
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
                      Text("  $placeType")
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

  void _navigateAndDisplaySelection(BuildContext context, Place pl) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserPlaceUpdate(pl)),
    );

    setState(() {
      place = getPlaceInfo();
    });
  }

  void deletePlace() {
    sendDeletePlaceDataToServer(placeId);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyPlacesEvents()),
    );
  }

  Future<Place> getPlaceInfo() async {
    likeCounts = getLikeChart("place", placeId);

    return await fetchPlaceViewData(placeId);
  }
}
