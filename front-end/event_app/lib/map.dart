import 'package:google_maps_flutter/google_maps_flutter.dart';
import './gps.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:geocoding/geocoding.dart';
import 'eventsParse.dart';
import 'client.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = HashSet<Marker>();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(54.898521, 23.903597),
    zoom: 10,
  );

  Future<List<Event>> assignList() async {
    return await fetchData();
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
      _goToTheLake();
    },
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: true,
    ),

    ],
    );
    }

    Future<List<Location>> getCoords(List<Event> list) async {
      Iterator<Event> it = list.iterator;
      it.moveNext();

      List<Location> locations = await locationFromAddress(it.current.address);
      List<Location> temp;

      while(it.moveNext()) {
        try {
          temp = await locationFromAddress(it.current.address);
          locations.add(temp.first);
        } catch(err) {
          final address = it.current.address;
          print("$err. Address: $address. Trying to search with place name.");
          try {
            temp = await locationFromAddress(it.current.placeName);
            locations.add(temp.first);
          } catch(err) {
            final place = it.current.placeName;
            print("$err. Place name: $place");
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

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    //final pos = await determinePosition();
    final eventList = await assignList();
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

      while(it.moveNext()) {
        _markers.add(Marker(
          markerId: MarkerId("$markId"),
          position: LatLng(it.current.latitude, it.current.longitude),
          infoWindow: InfoWindow(
            title: eventList.elementAt(markId).eventName,
            snippet: eventList.elementAt(markId).startDate + "0",
          ),
        ));

        markId++;
      }
    });
  }
}
