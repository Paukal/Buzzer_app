/*
* Lets Go App
* Paulius Tomas Kalvers
* Requests, responses and communication with server logic
* */

import 'package:http/http.dart' as http;
import 'eventsParse.dart';
import 'placesParse.dart';
import 'dart:convert';
import 'localDatabase.dart';
import 'menu.dart';
import 'commentView.dart';

var s1 = LoggedInSingleton();

Future<List<Event>> fetchEventList(
    bool filterDateToday,
    bool filterDateTomorrow,
    bool filterDateThisWeek,
    bool filterDateYesterday,
    bool filterDateLastWeek) async {
  var localDB = DB();

  List<Event> list;
  if (!localDB.eventsStored) {
    List<Event> tempList;
    tempList = await fetchEventData();
    await localDB.insertEvents(tempList);
  }
  list = await localDB.events();

  List<Event> filteredList = new List.empty(growable: true);
  final DateTime now = DateTime.now();

  if (filterDateLastWeek) {
    Iterator<Event> it = list.iterator;
    while (it.moveNext()) {
      final date = DateTime.parse(it.current.startDate);
      if (date.difference(now).inDays < -1 &&
          date.difference(now).inDays > -8 &&
          DateTime.parse(it.current.startDate).isBefore(now)) {
        filteredList.add(it.current);
      }
    }
  }
  if (filterDateYesterday) {
    Iterator<Event> it = list.iterator;
    while (it.moveNext()) {
      final date = DateTime.parse(it.current.startDate);
      if ((date.day - now.day == -1 || date.day - now.day > 26) &&
          date.difference(now).inDays == -1 &&
          DateTime.parse(it.current.startDate).isBefore(now)) {
        filteredList.add(it.current);
      }
    }
  }
  if (filterDateThisWeek) {
    Iterator<Event> it = list.iterator;
    while (it.moveNext()) {
      final date = DateTime.parse(it.current.startDate);
      if (date.difference(now).inDays > 1 &&
          date.difference(now).inDays < 8 &&
          DateTime.parse(it.current.startDate).isAfter(now)) {
        filteredList.add(it.current);
      }
    }
  }
  if (filterDateTomorrow) {
    Iterator<Event> it = list.iterator;
    while (it.moveNext()) {
      final date = DateTime.parse(it.current.startDate);
      if ((date.day - now.day == 1 || date.day - now.day < 0) &&
          (date.difference(now).inDays == 1) &&
          DateTime.parse(it.current.startDate).isAfter(now)) {
        filteredList.add(it.current);
      }
    }
  }
  if (filterDateToday) {
    Iterator<Event> it = list.iterator;
    while (it.moveNext()) {
      final date = DateTime.parse(it.current.startDate);
      if (date.difference(now).inDays == 0 &&
          date.day == now.day) {
        filteredList.add(it.current);
      }
    }
  }
  for (int i = 0; i < filteredList.length; i++) {
    await getEventLikesClicks(filteredList[i]);
  }

  return filteredList;
}

Future<List<Event>> fetchEventListLiked() async {
  var localDB = DB();

  List<Event> list;
  if (!localDB.eventsStored) {
    List<Event> tempList;
    tempList = await fetchEventData();
    await localDB.insertEvents(tempList);
  }
  list = await localDB.events();
  List<Event> filteredList = new List.empty(growable: true);

  for (int i = 0; i < list.length; i++) {
    await getEventLikesClicks(list[i]);
    if(list[i].liked == true){
      filteredList.add(list[i]);
    }
  }

  return filteredList;
}

Future<List<Event>> fetchEventData() async {
  var url = Uri.parse('http://10.0.2.2:8081/events?userId=${s1.userId}'); //instead of localhost
  var response = await http.get(url);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  try {
    if (response.body.isNotEmpty) {
      List<dynamic> stringList = jsonDecode(response.body);
      EventCollection collection = EventCollection.fromJson(stringList);
      print('Parsed: ${collection.list.first.address}');

      return collection.list;
    }
  } catch (err) {
    print("Exception: $err");
  }

  return List.empty();
}

Future<void> getEventLikesClicks(Event event) async {
  var s1 = LoggedInSingleton();
  if(s1.loggedIn) {
    event.likeId =
    await getLikeStatus(s1.userId, "event", event.eventId.toString());

    if (event.likeId != "") {
      event.liked = true;
    }
  }
  event.likeCount = await getLikeCount("event", event.eventId.toString());
  event.clicks = await getClickCount("event", event.eventId.toString());
}

Future<List<Place>> fetchPlaceList(
    bool restPlaces,
    bool sceneryPlaces,
    bool hikingTrails,
    bool forts,
    bool bikeTrails,
    bool streetArt,
    bool museums,
    bool architecture,
    bool nature,
    bool history,
    bool trails,
    bool expositions,
    bool parks,
    bool sculptures,
    bool churches,
    bool mounds) async {
  var localDB = DB();

  List<Place> list;
  if (!localDB.placesStored) {
    List<Place> tempList;
    tempList = await fetchPlaceData();
    await localDB.insertPlaces(tempList);
  }
  list = await localDB.places();

  List<Place> filteredList = new List.empty(growable: true);

  if (restPlaces) {
    Iterator<Place> it = list.iterator;
    while (it.moveNext()) {
      if (it.current.placeType == "restPlaces") {
        filteredList.add(it.current);
      }
    }
  }

  if (sceneryPlaces) {
    Iterator<Place> it = list.iterator;
    while (it.moveNext()) {
      if (it.current.placeType == "sceneryPlaces") {
        filteredList.add(it.current);
      }
    }
  }
  if (hikingTrails) {
    Iterator<Place> it = list.iterator;
    while (it.moveNext()) {
      if (it.current.placeType == "hikingTrails") {
        filteredList.add(it.current);
      }
    }
  }
  if (forts) {
    Iterator<Place> it = list.iterator;
    while (it.moveNext()) {
      if (it.current.placeType == "forts") {
        filteredList.add(it.current);
      }
    }
  }
  if (bikeTrails) {
    Iterator<Place> it = list.iterator;
    while (it.moveNext()) {
      if (it.current.placeType == "bikeTrails") {
        filteredList.add(it.current);
      }
    }
  }
  if (streetArt) {
    Iterator<Place> it = list.iterator;
    while (it.moveNext()) {
      if (it.current.placeType == "streetArt") {
        filteredList.add(it.current);
      }
    }
  }
  if (museums) {
    Iterator<Place> it = list.iterator;
    while (it.moveNext()) {
      if (it.current.placeType == "museums") {
        filteredList.add(it.current);
      }
    }
  }
  if (architecture) {
    Iterator<Place> it = list.iterator;
    while (it.moveNext()) {
      if (it.current.placeType == "architecture") {
        filteredList.add(it.current);
      }
    }
  }
  if (nature) {
    Iterator<Place> it = list.iterator;
    while (it.moveNext()) {
      if (it.current.placeType == "nature") {
        filteredList.add(it.current);
      }
    }
  }
  if (history) {
    Iterator<Place> it = list.iterator;
    while (it.moveNext()) {
      if (it.current.placeType == "history") {
        filteredList.add(it.current);
      }
    }
  }
  if (trails) {
    Iterator<Place> it = list.iterator;
    while (it.moveNext()) {
      if (it.current.placeType == "trails") {
        filteredList.add(it.current);
      }
    }
  }
  if (expositions) {
    Iterator<Place> it = list.iterator;
    while (it.moveNext()) {
      if (it.current.placeType == "expositions") {
        filteredList.add(it.current);
      }
    }
  }
  if (parks) {
    Iterator<Place> it = list.iterator;
    while (it.moveNext()) {
      if (it.current.placeType == "parks") {
        filteredList.add(it.current);
      }
    }
  }
  if (sculptures) {
    Iterator<Place> it = list.iterator;
    while (it.moveNext()) {
      if (it.current.placeType == "sculptures") {
        filteredList.add(it.current);
      }
    }
  }
  if (churches) {
    Iterator<Place> it = list.iterator;
    while (it.moveNext()) {
      if (it.current.placeType == "churches") {
        filteredList.add(it.current);
      }
    }
  }
  if (mounds) {
    Iterator<Place> it = list.iterator;
    while (it.moveNext()) {
      if (it.current.placeType == "mounds") {
        filteredList.add(it.current);
      }
    }
  }

  for (int i = 0; i < filteredList.length; i++) {
    await getPlaceLikesClicks(filteredList[i]);
  }

  return filteredList;
}

Future<List<Place>> fetchPlaceListLiked() async {
  var localDB = DB();

  List<Place> list;
  if (!localDB.placesStored) {
    List<Place> tempList;
    tempList = await fetchPlaceData();
    await localDB.insertPlaces(tempList);
  }
  list = await localDB.places();
  List<Place> filteredList = new List.empty(growable: true);

  for (int i = 0; i < list.length; i++) {
    await getPlaceLikesClicks(list[i]);
    if(list[i].liked == true){
      filteredList.add(list[i]);
    }
  }

  return filteredList;
}

Future<List<Place>> fetchPlaceData() async {
  var url = Uri.parse('http://10.0.2.2:8081/places?userId=${s1.userId}'); //instead of localhost
  var response = await http.get(url);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  try {
    if (response.body.isNotEmpty) {
      List<dynamic> stringList = jsonDecode(response.body);
      PlaceCollection collection = PlaceCollection.fromJson(stringList);
      print('Parsed: ${collection.list.first.address}');

      return collection.list;
    }
  } catch (err) {
    print("Exception: $err");
  }

  return List.empty();
}

Future<void> getPlaceLikesClicks(Place place) async {
  var s1 = LoggedInSingleton();
  if(s1.loggedIn) {
    place.likeId =
    await getLikeStatus(s1.userId, "place", place.placeId.toString());

    if (place.likeId != "") {
      place.liked = true;
    }
  }
  place.likeCount = await getLikeCount("place", place.placeId.toString());
  place.clicks = await getClickCount("place", place.placeId.toString());
}

Future<http.Response> sendUserDataToServer(
    String name, String lastName, String email, String id) {
  var url = Uri.parse('http://10.0.2.2:8081/user/connected');

  return http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'first_name': name,
      'last_name': lastName,
      'email': email,
      'id': id,
    }),
  );
}

Future<void> fetchUserData(String userId) async {
  var url = Uri.parse('http://10.0.2.2:8081/user/data?userId=$userId'); //instead of localhost
  var response = await http.get(url);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  try {
    if (response.body.isNotEmpty) {
      List<dynamic> stringList = jsonDecode(response.body);
      s1.accVerified = stringList[0][4];
      s1.admin = stringList[0][5];
    }
  } catch (err) {
    print("Exception: $err");
  }
}

Future<http.Response> sendNewEventDataToServer(
    String eventName,
    String placeName,
    String link,
    String address,
    String city,
    String startDate,
    String public,
    String userId,
    String photoUrl) {
  var url = Uri.parse('http://10.0.2.2:8081/user/event');

  return http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'event_name': eventName,
      'place_name': placeName,
      'link': link,
      'address': address,
      'city': city,
      'start_date': startDate,
      'public': public,
      'user_id': userId,
      "photo_url" : photoUrl,
    }),
  );
}

Future<http.Response> sendNewPlaceDataToServer(
    String placeName,
    String placeType,
    String link,
    String address,
    String city,
    String public,
    String userId,
    String photoUrl) {
  var url = Uri.parse('http://10.0.2.2:8081/user/place');

  return http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'place_name': placeName,
      'place_type': placeType,
      'link': link,
      'address': address,
      'city': city,
      'public': public,
      'user_id': userId,
      'photo_url' : photoUrl,
    }),
  );
}

Future<List<Event>> fetchUserEventData(String userId) async {
  var url = Uri.parse(
      'http://10.0.2.2:8081/user/events?userId=$userId'); //instead of localhost
  var response = await http.get(url);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  List<dynamic> stringList = jsonDecode(response.body);
  EventCollection collection = EventCollection.fromJson(stringList);

  print('Parsed: ${collection.list.first.address}');

  return collection.list;
}

Future<List<Place>> fetchUserPlaceData(String userId) async {
  var url = Uri.parse(
      'http://10.0.2.2:8081/user/places?userId=$userId'); //instead of localhost
  var response = await http.get(url);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  List<dynamic> stringList = jsonDecode(response.body);
  PlaceCollection collection = PlaceCollection.fromJson(stringList);

  print('Parsed: ${collection.list.first.address}');

  return collection.list;
}

Future<Event> fetchEventViewData(String eventId) async {
  var url = Uri.parse(
      'http://10.0.2.2:8081/eventview?eventId=$eventId'); //instead of localhost
  var response = await http.get(url);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  List<dynamic> stringList = jsonDecode(response.body);
  EventCollection collection = EventCollection.fromJson(stringList);

  print('Parsed: ${collection.list.first.address}');

  return collection.list.first;
}

Future<http.Response> sendChangedEventDataToServer(
    String eventId,
    String eventName,
    String placeName,
    String link,
    String address,
    String city,
    String startDate,
    String public) {
  var url = Uri.parse('http://10.0.2.2:8081/user/event/update');

  return http.put(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'event_id': eventId,
      'event_name': eventName,
      'place_name': placeName,
      'link': link,
      'address': address,
      'city': city,
      'start_date': startDate,
      'public': public,
    }),
  );
}

void sendDeleteEventDataToServer(String eventId) async {
  var url = Uri.parse(
      'http://10.0.2.2:8081/user/event/delete?eventId=$eventId'); //instead of localhost
  var response = await http.delete(url);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}

Future<Place> fetchPlaceViewData(String placeId) async {
  var url = Uri.parse(
      'http://10.0.2.2:8081/placeview?placeId=$placeId'); //instead of localhost
  var response = await http.get(url);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  List<dynamic> stringList = jsonDecode(response.body);
  PlaceCollection collection = PlaceCollection.fromJson(stringList);

  print('Parsed: ${collection.list.first.address}');

  return collection.list.first;
}

Future<http.Response> sendChangedPlaceDataToServer(
    String placeId,
    String placeName,
    String placeType,
    String link,
    String address,
    String city,
    String public) {
  var url = Uri.parse('http://10.0.2.2:8081/user/place/update');

  return http.put(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'place_id': placeId,
      'place_name': placeName,
      'place_type': placeType,
      'link': link,
      'address': address,
      'city': city,
      'public': public,
    }),
  );
}

void sendDeletePlaceDataToServer(String placeId) async {
  var url = Uri.parse(
      'http://10.0.2.2:8081/user/place/delete?placeId=$placeId'); //instead of localhost
  var response = await http.delete(url);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}

Future<Map<String, dynamic>> getUserInfoFB(
    String userId, String accessToken) async {
  var url = Uri.parse(
      'https://graph.facebook.com/$userId?fields=first_name,last_name,email&access_token=$accessToken'); //instead of localhost
  var response = await http.get(url);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  Map<String, dynamic> collection = jsonDecode(response.body);

  print('Parsed: $collection');

  return collection;
}

Future<String> sendPressedLike(
    String userId, String object, String objectId) async {
  final DateTime now = DateTime.now();
  var url = Uri.parse('http://10.0.2.2:8081/like/press');

  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'user_id': userId,
      'object': object,
      'object_id': objectId,
      'date': now.toString(),
    }),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  return response.body;
}

void sendUnpressedLike(String likeId) async {
  var url = Uri.parse(
      'http://10.0.2.2:8081/like/unpress?likeId=$likeId'); //instead of localhost
  var response = await http.delete(url);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}

Future<String> getLikeStatus(String userId, String object, String objectId) async {
  var url = Uri.parse(
      'http://10.0.2.2:8081/user/like?userId=$userId&object=$object&objectId=$objectId'); //instead of localhost
  var response = await http.get(url);

  if(response.body!="[]"){
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    List<dynamic> stringList = jsonDecode(response.body);

    return (stringList[0][0]).toString();
  }

  return "";
}

Future<String> getLikeCount(String object, String objectId) async {
  var url = Uri.parse(
      'http://10.0.2.2:8081/like/count?&object=$object&objectId=$objectId'); //instead of localhost
  var response = await http.get(url);

  if(response.body!="[]"){
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return response.body;
  }

  return "";
}

Future<http.Response> eventClick(
    String eventId) {
  var url = Uri.parse('http://10.0.2.2:8081/event/click');

  return http.put(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'event_id': eventId,
    }),
  );
}

Future<http.Response> placeClick(
    String placeId) {
  var url = Uri.parse('http://10.0.2.2:8081/place/click');

  return http.put(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'place_id': placeId,
    }),
  );
}

Future<String> getClickCount(String object, String objectId) async {
  var url = Uri.parse(
      'http://10.0.2.2:8081/click/count?&object=$object&objectId=$objectId'); //instead of localhost
  var response = await http.get(url);

  if(response.body!="[]"){
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return response.body;
  }

  return "";
}

Future<List<dynamic>> getLikeChart(String object, String objectId) async {
  var url = Uri.parse(
      'http://10.0.2.2:8081/like/chart?&object=$object&objectId=$objectId'); //instead of localhost
  var response = await http.get(url);

  if(response.body!="[]"){
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    List<dynamic> stringList = jsonDecode(response.body);

    return stringList;
  }

  return List.empty();
}

Future<CommentCollection> getComments(String object, String objectId) async {
  var url = Uri.parse(
      'http://10.0.2.2:8081/comments?&object=$object&objectId=$objectId'); //instead of localhost
  var response = await http.get(url);

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  List<dynamic> stringList = jsonDecode(response.body);
  CommentCollection collection = CommentCollection.fromJson(stringList);

  return collection;
}

Future<String> sendComment(
    String userId, String userName,String object, String objectId, String comment) async {
  final DateTime now = DateTime.now();
  var url = Uri.parse('http://10.0.2.2:8081/comment/new');

  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'user_id': userId,
      'user_name': userName,
      'object': object,
      'object_id': objectId,
      'date': now.toString(),
      'comment' : comment
    }),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  return response.body;
}