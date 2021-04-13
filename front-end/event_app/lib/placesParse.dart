import './client.dart';
import 'package:flutter/material.dart';


class PlaceCollection {
  final List<Place> list;

  PlaceCollection(this.list);

  factory PlaceCollection.fromJson(List<dynamic> json) =>
      PlaceCollection(json.map((e) => Place.fromJson(e)).toList());
}

class Place {
  final int placeId;
  final String placeName;
  final String placeType;
  final String link;
  final String address;
  final String city;
  final bool public;
  final String userAddedID;

  Place(this.placeId, this.placeName, this.placeType, this.link, this.address, this.city, this.public, this.userAddedID);

  factory Place.fromJson(List<dynamic> json) =>
      Place(json[0], json[1], json[2], json[3], json[4], json[5], json[6], json[7]);
}