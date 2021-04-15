import 'package:flutter/material.dart';

class PlaceFilter extends StatefulWidget {
  bool restPlaces; //poilsiavietes
  bool sceneryPlaces; //apzvalgos aiksteles
  bool hikingTrails; //pesciuju takai
  bool forts;
  bool bikeTrails; //dviraciu marsrutai
  bool streetArt;
  bool museums;
  bool architecture;
  bool nature;
  bool history;
  bool trails; //marsrutai
  bool expositions;
  bool parks;
  bool sculptures; //skulpturos ir paminklai
  bool churches;
  bool mounds; //piliakalniai

  PlaceFilter(this.restPlaces, this.sceneryPlaces, this.hikingTrails,
      this.forts, this.bikeTrails, this.streetArt, this.museums, this.architecture, this.nature,
      this.history, this.trails, this.expositions, this.parks, this.sculptures,
      this.churches, this.mounds);

  @override
  State<PlaceFilter> createState() => PlaceFilterState(restPlaces, sceneryPlaces, hikingTrails,
      forts, bikeTrails, streetArt, museums, architecture, nature,
      history, trails, expositions, parks, sculptures,
      churches, mounds);
}

class PlaceFilterState extends State<PlaceFilter> {
  bool restPlaces; //poilsiavietes
  bool sceneryPlaces; //apzvalgos aiksteles
  bool hikingTrails; //pesciuju takai
  bool forts;
  bool bikeTrails; //dviraciu marsrutai
  bool streetArt;
  bool museums;
  bool architecture;
  bool nature;
  bool history;
  bool trails; //marsrutai
  bool expositions;
  bool parks;
  bool sculptures; //skulpturos ir paminklai
  bool churches;
  bool mounds; //piliakalniai

  PlaceFilterState(this.restPlaces, this.sceneryPlaces, this.hikingTrails,
      this.forts, this.bikeTrails, this.streetArt, this.museums, this.architecture, this.nature,
      this.history, this.trails, this.expositions, this.parks, this.sculptures,
      this.churches, this.mounds);

  void _onRestPlacesChanged(bool? newValue) => setState(() {
    restPlaces = newValue == true;
  });

  void _onSceneryPlacesChanged(bool? newValue) => setState(() {
    sceneryPlaces = newValue == true;
  });

  void _onHikingTrailsChanged(bool? newValue) => setState(() {
    hikingTrails = newValue == true;
  });

  void _onFortsChanged(bool? newValue) => setState(() {
    forts = newValue == true;
  });

  void _onBikeTrailsChanged(bool? newValue) => setState(() {
    bikeTrails = newValue == true;
  });

  void _onStreetArtChanged(bool? newValue) => setState(() {
    streetArt = newValue == true;
  });

  void _onMuseumsChanged(bool? newValue) => setState(() {
    museums = newValue == true;
  });

  void _onArchitectureChanged(bool? newValue) => setState(() {
    architecture = newValue == true;
  });

  void _onNatureChanged(bool? newValue) => setState(() {
    nature = newValue == true;
  });

  void _onHistoryChanged(bool? newValue) => setState(() {
    history = newValue == true;
  });

  void _onTrailsChanged(bool? newValue) => setState(() {
    trails = newValue == true;
  });

  void _onExpositionsChanged(bool? newValue) => setState(() {
    expositions = newValue == true;
  });

  void _onParksChanged(bool? newValue) => setState(() {
    parks = newValue == true;
  });

  void _onSculpturesChanged(bool? newValue) => setState(() {
    sculptures = newValue == true;
  });

  void _onChurchesChanged(bool? newValue) => setState(() {
    churches = newValue == true;
  });

  void _onMoundsChanged(bool? newValue) => setState(() {
    mounds = newValue == true;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context, [restPlaces, sceneryPlaces, hikingTrails,
            forts, bikeTrails, streetArt, museums, architecture, nature,
            history, trails, expositions, parks, sculptures,
            churches, mounds]),
        ),
        title: Text("Filter"),
      ),
      body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
        CheckboxListTile(
            title: Text("Rest places"),
            value: restPlaces,
            onChanged: _onRestPlacesChanged),
        CheckboxListTile(
            title: Text("Scenery places"),
            value: sceneryPlaces,
            onChanged: _onSceneryPlacesChanged),
        CheckboxListTile(
            title: Text("Hiking trails"),
            value: hikingTrails,
            onChanged: _onHikingTrailsChanged),
        CheckboxListTile(
            title: Text("Forts"),
            value: forts,
            onChanged: _onFortsChanged),
        CheckboxListTile(
            title: Text("Bike trails"),
            value: bikeTrails,
            onChanged: _onBikeTrailsChanged),
        CheckboxListTile(
            title: Text("Street art"),
            value: streetArt,
            onChanged: _onStreetArtChanged),
        CheckboxListTile(
            title: Text("Museums"),
            value: museums,
            onChanged: _onMuseumsChanged),
        CheckboxListTile(
            title: Text("Architecture"),
            value: architecture,
            onChanged: _onArchitectureChanged),
        CheckboxListTile(
            title: Text("Nature"),
            value: nature,
            onChanged: _onNatureChanged),
        CheckboxListTile(
            title: Text("History"),
            value: history,
            onChanged: _onHistoryChanged),
        CheckboxListTile(
            title: Text("Trails"),
            value: trails,
            onChanged: _onTrailsChanged),
        CheckboxListTile(
            title: Text("Expositions"),
            value: expositions,
            onChanged: _onExpositionsChanged),
        CheckboxListTile(
            title: Text("Parks"),
            value: parks,
            onChanged: _onParksChanged),
        CheckboxListTile(
            title: Text("Sculptures"),
            value: sculptures,
            onChanged: _onSculpturesChanged),
        CheckboxListTile(
            title: Text("Churches"),
            value: churches,
            onChanged: _onChurchesChanged),
        CheckboxListTile(
            title: Text("Mounds"),
            value: mounds,
            onChanged: _onMoundsChanged),
      ]),
    );
  }
}
