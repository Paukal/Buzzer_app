import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:geocoding/geocoding.dart';
import 'addPlace.dart';
import 'addEvent.dart';


class CreatePlaceEvent extends StatefulWidget {
  @override
  State<CreatePlaceEvent> createState() => CreatePlaceEventState();
}

class CreatePlaceEventState extends State<CreatePlaceEvent> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = HashSet<Marker>();

  String dropdownValue1 = 'Event';
  String dropdownValue2 = 'Public';

  bool showAddButton = false;

  late double latitude;
  late double longitude;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(54.898521, 23.903597),
    zoom: 10,
  );

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    String text = '';

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text("Add place/event"),
        ),
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                _setMapStyle(controller); //from mapstyle.withgoogle.com
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              markers: _markers,
            ),
            Positioned(
              top: 10,
              right: 15,
              left: 15,
              child: Container(
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.go,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15),
                            hintText: "Address..."),
                        onChanged: (value) {
                          text = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setLocation(text);
                        },
                        child: Text('Search'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 60,
              right: 315,
              left: 15,
              child: DropdownButton<String>(
                value: dropdownValue1,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue1 = newValue!;
                  });
                },
                items: <String>['Event', 'Place']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Positioned(
              top: 60,
              right: 225,
              left: 95,
              child: DropdownButton<String>(
                value: dropdownValue2,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue2 = newValue!;
                  });
                },
                items: <String>['Public', 'Private']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            showAddButton
                ? Positioned(
                    top: 60,
                    right: 135,
                    left: 185,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _addPlaceEvent(context);
                        },
                        child: Text('Add'),
                      ),
                    ),
                  )
                : Container(),
          ],
        ));
  }

  void setLocation(String address) async {
    print(address);
    List<Location> locations = await locationFromAddress(address);

    final GoogleMapController controller = await _controller.future;
    _markers.clear();

    latitude = locations.first.latitude;
    longitude = locations.first.longitude;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 0,
        target: LatLng(latitude, longitude),
        tilt: 0,
        zoom: 16)));

    setState(() {
      showAddButton = true;
      int markId = 0;

      _markers.add(Marker(
        markerId: MarkerId("$markId"),
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(
            //title: placeList.elementAt(markId).placeName,
            //snippet: placeList.elementAt(markId).placeType,
            ),
      ));
    });
  }

  void _addPlaceEvent(BuildContext context) {
    if(dropdownValue1 == 'Event') {
      _navigateAndDisplaySelection(context);
    }
    else if(dropdownValue1 == 'Place') {
      _navigateAndDisplaySelection2(context);
    }
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEvent(latitude, longitude)),
    );

    setState(() {});
  }

  void _navigateAndDisplaySelection2(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddPlace(latitude, longitude)),
    );

    setState(() {});
  }

  void _setMapStyle(GoogleMapController controller) async {
    String style = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    controller.setMapStyle(style);
  }
}
