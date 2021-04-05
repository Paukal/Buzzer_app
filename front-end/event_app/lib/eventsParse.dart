import './client.dart';
import 'package:flutter/material.dart';


class EventCollection {
  final List<Event> list;

  EventCollection(this.list);

  factory EventCollection.fromJson(List<dynamic> json) =>
      EventCollection(json.map((e) => Event.fromJson(e)).toList());
}

class Event {
  final int eventId;
  final String eventName;
  final String placeName;
  final String link;
  final String address;
  final String city;
  final String startDate;

  Event(this.eventId, this.eventName, this.placeName, this.link, this.address, this.city, this.startDate);

  factory Event.fromJson(List<dynamic> json) =>
      Event(json[0], json[1], json[2], json[3], json[4], json[5], json[6]);
}