import 'package:google_maps_flutter/google_maps_flutter.dart';
import './gps.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:collection';

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
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
        zoomControlsEnabled: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('Add place marker'),
        icon: Icon(Icons.account_circle_outlined),
        backgroundColor: Colors.amber[800],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _setMapStyle(GoogleMapController controller) async {
    String style = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    controller.setMapStyle(style);
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    final pos = await determinePosition();
    print(pos);

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 0,
        target: LatLng(pos.latitude, pos.longitude),
        tilt: 0,
        zoom: 16)));

    setState(() {
      _markers.add(Marker(
        markerId: MarkerId("0"),
        position: LatLng(pos.latitude, pos.longitude),
        infoWindow: InfoWindow(
          title: "Sveiki",
          snippet: "YEAH",
        ),
      ));
    });
  }
}
