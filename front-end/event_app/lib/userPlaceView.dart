import 'package:flutter/material.dart';
import 'client.dart';
import 'placesParse.dart';
import 'userPlaceUpdate.dart';

class UserPlaceView extends StatefulWidget {
  String placeId;

  UserPlaceView(this.placeId);

  @override
  _UserPlaceViewState createState() => _UserPlaceViewState(placeId);
}

class _UserPlaceViewState extends State<UserPlaceView> {
  String placeId;

  _UserPlaceViewState(this.placeId);

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
                            Align(
                                alignment: Alignment(0.8, -0.75),
                                child: SizedBox(
                                  width: 45, // <-- match_parent
                                  height: 35,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _navigateAndDisplaySelection(context, placeData);
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
                                      deletePlace();
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

  void _navigateAndDisplaySelection(BuildContext context, Place place) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UserPlaceUpdate(place)),
    );

    setState(() {});
  }

  void deletePlace() {
    sendDeletePlaceDataToServer(placeId);
  }

  Future<Place> getPlaceInfo() async {
    return await fetchPlaceViewData(placeId);
  }
}
