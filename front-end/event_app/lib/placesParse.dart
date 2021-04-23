/*
* Lets Go App
* Paulius Tomas Kalvers
* Place object and place parsing logic
* */

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
  final String photoUrl;

  Place(this.placeId, this.placeName, this.placeType, this.link, this.address, this.city, this.public, this.userAddedID, this.photoUrl);

  factory Place.fromJson(List<dynamic> json) =>
      Place(json[0], json[1], json[2], json[3], json[4], json[5], json[6], json[7], json[8]);

  Map<String, dynamic> toMap() {
    return {
      'place_id': placeId,
      'place_name': placeName,
      'place_type': placeType,
      'link': link,
      'address': address,
      'city': city,
      'public': public,
      'user_added_id': userAddedID,
      'photo_url' : photoUrl,
    };
  }
}