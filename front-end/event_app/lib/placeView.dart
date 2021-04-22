import 'package:flutter/material.dart';
import 'client.dart';
import 'placesParse.dart';

class PlaceView extends StatefulWidget {
  String placeId;

  PlaceView(this.placeId);

  @override
  _PlaceViewState createState() => _PlaceViewState(placeId);
}

class _PlaceViewState extends State<PlaceView> {
  String placeId;

  _PlaceViewState(this.placeId);

  late Future<Place> place;

  @override
  void initState() {
    super.initState();
    place = getPlaceInfo();
  }

  @override
  Widget build(BuildContext context) {
    Place placeData;

    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FutureBuilder<Place>(
                    future: place,
                    builder: (BuildContext context,
                        AsyncSnapshot<Place> snapshot) {
                      if (snapshot.hasData) {
                        placeData = snapshot.data!;
                        return Column(
                          children: <Widget>[
                            Image.network(placeData.photoUrl),
                            Container(
                              height: 50,
                              color: Colors.amber[200],
                              child: Center(child: Text(placeData.placeName)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.amber[200],
                              child: Center(child: Text(placeData.placeType)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.amber[200],
                              child: Center(child: Text(placeData.link)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.amber[200],
                              child: Center(child: Text(placeData.address)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.amber[200],
                              child: Center(child: Text(placeData.city)),
                            ),
                            Container(
                              height: 50,
                              color: Colors.amber[200],
                              child: Center(child: Text(placeData.public.toString())),
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

  Future<Place> getPlaceInfo() async {
    return await fetchPlaceViewData(placeId);
  }
}
