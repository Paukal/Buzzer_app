import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'gps.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:geocoding/geocoding.dart';
import 'eventsParse.dart';
import 'placesParse.dart';
import 'client.dart';
import 'eventFilter.dart';
import 'placeFilter.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = HashSet<Marker>();

  bool showEvents = true;
  bool showPlaces = false;

  //event filters:
  bool filterDateToday = true;
  bool filterDateTomorrow = false;
  bool filterDateThisWeek = false;
  bool filterDateYesterday = false;
  bool filterDateLastWeek = false;

  //place filters:
  bool restPlaces = true; //poilsiavietes
  bool sceneryPlaces = true; //apzvalgos aiksteles
  bool hikingTrails = true; //pesciuju takai
  bool forts = false;
  bool bikeTrails = false; //dviraciu marsrutai
  bool streetArt = false;
  bool museums = false;
  bool architecture = false;
  bool nature = true;
  bool history = false;
  bool trails = false; //marsrutai
  bool expositions = false;
  bool parks = true;
  bool sculptures = false; //skulpturos ir paminklai
  bool churches = false;
  bool mounds = true; //piliakalniai

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(54.898521, 23.903597),
    zoom: 10,
  );

  Future<List<Event>> assignEventList() async {
    return await fetchEventList(filterDateToday, filterDateTomorrow,
        filterDateThisWeek, filterDateYesterday, filterDateLastWeek);
  }

  Future<List<Place>> assignPlaceList() async {
    return await fetchPlaceList(restPlaces, sceneryPlaces, hikingTrails,
        forts, bikeTrails, streetArt, museums, architecture, nature,
        history, trails, expositions, parks, sculptures,
        churches, mounds);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _setMapStyle(controller); //from mapstyle.withgoogle.com
            _markEvents();
          },
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: true,
        ),
        Align(
          alignment: Alignment(0, -0.75),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.event),
                color: Colors.white,
                tooltip: 'Show events',
                onPressed: () {
                  setState(() {
                    showEvents = true;
                    showPlaces = false;

                    _markers.clear();
                    _markEvents();
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.add_location_rounded),
                color: Colors.white,
                tooltip: 'Show places',
                onPressed: () {
                  setState(() {
                    showEvents = false;
                    showPlaces = true;

                    _markers.clear();
                    _markPlaces();
                  });
                },
              ),
            ],
          ),
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
                child: const Icon(Icons.apps, size: 20),
              ),
            )),
      ],
    );
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    if(showEvents) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MapEventFilter(
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

        _markers.clear();
        _markEvents();
      });
    }

    if(showPlaces) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PlaceFilter(
                    restPlaces, sceneryPlaces, hikingTrails,
                    forts, bikeTrails, streetArt, museums, architecture, nature,
                    history, trails, expositions, parks, sculptures,
                    churches, mounds)),
      );

      setState(() {
        restPlaces = result[0]; //poilsiavietes
        sceneryPlaces = result[1]; //apzvalgos aiksteles
        hikingTrails = result[2]; //pesciuju takai
        forts = result[3];
        bikeTrails = result[4]; //dviraciu marsrutai
        streetArt = result[5];
        museums = result[6];
        architecture = result[7];
        nature = result[8];
        history = result[9];
        trails = result[10]; //marsrutai
        expositions = result[11];
        parks = result[12];
        sculptures = result[13]; //skulpturos ir paminklai
        churches = result[14];
        mounds = result[15]; //piliakalniai

        _markers.clear();
        _markPlaces();
      });
    }
  }

  Future<List<Location>> getCoords(List list) async {
    Iterator it = list.iterator;
    it.moveNext();

    List<Location> locations = await locationFromAddress(it.current.address + ", " + it.current.city);
    List<Location> temp;

    while (it.moveNext()) {
      try {
        temp = await locationFromAddress(it.current.address);
        locations.add(temp.first);
      } catch (err) {
        final address = it.current.address;
        print("$err. Address: $address. Trying to search with place name.");
        try {
          temp = await locationFromAddress(it.current.placeName);
          locations.add(temp.first);
        } catch (err) {
          final place = it.current.placeName;
          print("$err. Place name: $place");
          try {
            temp = await locationFromAddress(it.current.city);
            locations.add(temp.first);
            print("Added city coordinates");
          } catch (err) {
            final city = it.current.city;
            print("$err. City: $place");
          }
        }
      }
    }
    return locations;
  }

  void _setMapStyle(GoogleMapController controller) async {
    String style = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    controller.setMapStyle(style);
  }

  Future<void> _markEvents() async {
    final GoogleMapController controller = await _controller.future;
    //final pos = await determinePosition();
    try {
      final eventList = await assignEventList();
      final pos = await getCoords(eventList);
      print(pos);

      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          bearing: 0,
          target: LatLng(pos.first.latitude, pos.first.longitude),
          tilt: 0,
          zoom: 16)));

      setState(() {
        Iterator<Location> it = pos.iterator;
        int markId = 0;

        while (it.moveNext()) {
          _markers.add(Marker(
            markerId: MarkerId("$markId"),
            position: LatLng(it.current.latitude, it.current.longitude),
            infoWindow: InfoWindow(
              title: eventList.elementAt(markId).eventName,
              snippet: eventList.elementAt(markId).startDate,
            ),
          ));

          markId++;
        }
      });
    } catch (err) {
        print("exception: $err");
    }
  }

  Future<void> _markPlaces() async {
    final GoogleMapController controller = await _controller.future;
    //final pos = await determinePosition();
    try {
      final placeList = await assignPlaceList();
      final pos = await getCoords(placeList);
      print(pos);

      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          bearing: 0,
          target: LatLng(pos.first.latitude, pos.first.longitude),
          tilt: 0,
          zoom: 16)));

      setState(() {
        Iterator<Location> it = pos.iterator;
        int markId = 0;

        while (it.moveNext()) {
          _markers.add(Marker(
            markerId: MarkerId("$markId"),
            position: LatLng(it.current.latitude, it.current.longitude),
            infoWindow: InfoWindow(
              title: placeList.elementAt(markId).placeName,
              snippet: placeList.elementAt(markId).placeType,
            ),
          ));

          markId++;
        }
      });
    } catch (err) {
      print("exception: $err");
    }
  }
}
