// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:event_app/eventsParse.dart';
import 'package:event_app/placesParse.dart';
import 'package:event_app/userPlaceUpdate.dart';
import 'package:flutter/material.dart';
import 'package:event_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:event_app/client.dart';
import 'package:event_app/accVerification.dart';
import 'package:event_app/addEvent.dart';
import 'package:event_app/addPlace.dart';
import 'package:event_app/commentView.dart';
import 'package:event_app/createPlaceEvent.dart';
import 'package:event_app/eventFilter.dart';
import 'package:event_app/placeEventList.dart';
import 'package:event_app/placeFilter.dart';
import 'package:event_app/userEventUpdate.dart';

String eventData = '[[1, "KASTYTIS KERBEDIS, Šlagerių koncertas ", "Renginių Oazė", '
    '"https://renginiai.kasvyksta.lt/351/kaunas/renginiu-oaze", '
    '"Baltų pr. 16", "Kaunas", "2021-07-30 19:00:00", true, "-1", '
    '"https://renginiai.kasvyksta.lt/uploads/events/46175/thumb/kerbedis-001.png", "0"], '
    '[2, "Tradicinis labdaros koncertas „Aš noriu matyti pavasarį“", '
    '"Kauno valstybinė filharmonija", "https://renginiai.kasvyksta.lt/30/kaunas/kauno-filharmonija",'
    ' "L.Sapiegos gatvė 5", "Kaunas", "2021-07-11 14:00:00", true, "-1",'
    ' "https://renginiai.kasvyksta.lt/uploads/events/81283/thumb/291673c0.jpg", "16"]]';

String placeData = '[[1, "Raudondvario dvaro pilis", "architecture",'
    ' "https://www.kaunorajonas.lt/lankytinos-vietos/raudondvario-dvaro-ansamblis/", '
    '"Raudondvario dvaro pilis", "Kaunas", true, "-1", '
    '"https://www.kaunorajonas.lt/data/tourism_objects/list/1._raudondvario_dvaras_wm.jpg", "0"],'
    ' [2, "Kauno rajono muziejus", "museums", "https://www.kaunorajonas.lt/lankytinos-vietos/kauno-rajono-muziejus/",'
    ' "Kauno rajono muziejus", "Kaunas", true, "-1", '
    '"https://www.kaunorajonas.lt/data/tourism_objects/list/stiklo_perpus.jpg", "0"]]';

void main() {
  testClient();
  testWidgetLogic();
}

void testWidgetLogic() {
  testWidgets('main.dart widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('MAP'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    /*await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);*/
  });

  testWidgets('accVerification.dart widget test', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new AccVerification())
    );

    await tester.pumpWidget(testWidget);

    expect(find.byIcon(Icons.camera_alt), findsOneWidget);
  });

  testWidgets('addEvent.dart widget test', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new AddEvent("0","0","0"))
    );

    await tester.pumpWidget(testWidget);

    expect(find.text("Submit"), findsOneWidget);
    expect(find.text("Event name"), findsOneWidget);
    expect(find.text("Add a new event"), findsOneWidget);
  });

  testWidgets('addPlace.dart widget test', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new AddPlace("0","0"))
    );

    await tester.pumpWidget(testWidget);

    expect(find.text("Submit"), findsOneWidget);
    expect(find.text("Place name"), findsOneWidget);
    expect(find.text("Add a new place"), findsOneWidget);
  });

  testWidgets('commentView.dart widget test', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new CommentView("0",0))
    );

    await tester.pumpWidget(testWidget);

    expect(find.text("Type comment"), findsOneWidget);
  });

  testWidgets('createPlaceEvent.dart widget test', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new CreatePlaceEvent())
    );

    await tester.pumpWidget(testWidget);

    expect(find.text("Add place/event"), findsOneWidget);
    expect(find.text("Address..."), findsOneWidget);
  });

  testWidgets('createPlaceEvent.dart widget test', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new CreatePlaceEvent())
    );

    await tester.pumpWidget(testWidget);

    expect(find.text("Add place/event"), findsOneWidget);
    expect(find.text("Address..."), findsOneWidget);
  });

  testWidgets('eventFilter.dart widget test', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new MapEventFilter(true,true,true,true,true))
    );

    await tester.pumpWidget(testWidget);

    expect(find.text("Filter"), findsOneWidget);
    expect(find.text("Today"), findsOneWidget);
    expect(find.text("Tomorrow"), findsOneWidget);
    expect(find.text("This week"), findsOneWidget);
    expect(find.text("Yesterday"), findsOneWidget);
    expect(find.text("Last week"), findsOneWidget);
  });

  testWidgets('placeEventList.dart widget test', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new PlaceEventList())
    );

    await tester.pumpWidget(testWidget);

    expect(find.text("Events"), findsOneWidget);
    expect(find.text("Places"), findsOneWidget);
  });

  testWidgets('placeEventListLikes.dart widget test', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new PlaceEventList())
    );

    await tester.pumpWidget(testWidget);

    expect(find.text("Events"), findsOneWidget);
    expect(find.text("Places"), findsOneWidget);
  });

  testWidgets('placeFilter.dart widget test', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new PlaceFilter(true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true))
    );

    await tester.pumpWidget(testWidget);

    expect(find.text("Rest places"), findsOneWidget);
    expect(find.text("Scenery places"), findsOneWidget);
    expect(find.text("Hiking trails"), findsOneWidget);
    expect(find.text("Forts"), findsOneWidget);
    expect(find.text("Bike trails"), findsOneWidget);
    expect(find.text("Street art"), findsOneWidget);

    expect(find.text("Museums"), findsOneWidget);
    expect(find.text("Architecture"), findsOneWidget);
    expect(find.text("Nature"), findsOneWidget);
    expect(find.text("History"), findsOneWidget);
  });

  testWidgets('userEventUpdate.dart widget test', (WidgetTester tester) async {
    Event event = Event(0, "0", "0", "0", "0", "0", "0", true, "0", "0", "0");

    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new UserEventUpdate(event))
    );

    await tester.pumpWidget(testWidget);

    expect(find.text("Change event details"), findsOneWidget);
    expect(find.text("Event name"), findsOneWidget);
    expect(find.text("Link to event page (optional)"), findsOneWidget);
    expect(find.text("city"), findsOneWidget);
    expect(find.text("Start date"), findsOneWidget);
    expect(find.text("Address"), findsOneWidget);
    expect(find.text('Public event'), findsOneWidget);
  });

  testWidgets('userPlaceUpdate.dart widget test', (WidgetTester tester) async {
    Place place = Place(0, "0", "restPlaces", "0", "0", "0", true, "0", "0", "0");

    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new UserPlaceUpdate(place))
    );

    await tester.pumpWidget(testWidget);

    expect(find.text("Change place details"), findsOneWidget);
    expect(find.text("Place name"), findsOneWidget);
    expect(find.text("Link to place page (optional)"), findsOneWidget);
    expect(find.text("city"), findsOneWidget);
    expect(find.text("Address"), findsOneWidget);
    expect(find.text('Public place'), findsOneWidget);

    expect(find.text("Rest places"), findsOneWidget);
    expect(find.text("Scenery places"), findsOneWidget);
    expect(find.text("Hiking trails"), findsOneWidget);
    expect(find.text("Forts"), findsOneWidget);
    expect(find.text("Bike trails"), findsOneWidget);
    expect(find.text("Street art"), findsOneWidget);
    expect(find.text("Museums"), findsOneWidget);
    expect(find.text("Architecture"), findsOneWidget);
    expect(find.text("Nature"), findsOneWidget);
    expect(find.text("History"), findsOneWidget);
  });
}



void testClient() {
  test('client.dart API fetchEventData()', () async {
    var response = await fetchEventData(
        testResponse: eventData);

    expect(response.first.address, "Baltų pr. 16");
  });

  test('client.dart API fetchPlaceData()', () async {
    var response = await fetchPlaceData(
        testResponse: placeData);

    expect(response.first.address, "Raudondvario dvaro pilis");
  });

  test('client.dart API fetchUserData()', () async {
    var response = await fetchUserData("0",
        testResponse:
        '[["3098133687080603", "Alhamedas", "Zabovicius", "a.zajanckovskis@gmail.com", false, false]]');

    expect(response.first[0], "3098133687080603");
  });

  test('client.dart API fetchUserEventData()', () async {
    var response = await fetchUserEventData("0",
        testResponse: eventData);

    expect(response.first.address, "Baltų pr. 16");
  });

  test('client.dart API fetchUserPlaceData()', () async {
    var response = await fetchUserPlaceData("0",
        testResponse: placeData);

    expect(response.first.address, "Raudondvario dvaro pilis");
  });

  test('client.dart API fetcEventViewData()', () async {
    var response = await fetchEventViewData("0",
        testResponse: eventData);

    expect(response.address, "Baltų pr. 16");
  });

  test('client.dart API fetchPlaceViewData()', () async {
    var response = await fetchPlaceViewData("0",
        testResponse: placeData);

    expect(response.address, "Raudondvario dvaro pilis");
  });

  test('client.dart API getLikeStatus()', () async {
    var response = await getLikeStatus("0", "0", "0",
        testResponse: '[[63, "3098133687080603", "place", "68", "2021-04-30 16:37:00"]]');

    expect(response, "63");
  });

  test('client.dart API getLikeCount()', () async {
    var response = await getLikeCount("0", "0",
        testResponse: '20');

    expect(response, "20");
  });

  test('client.dart API getClickCount()', () async {
    var response = await getClickCount("0", "0",
        testResponse: '20');

    expect(response, "20");
  });

  test('client.dart API getLikeChart()', () async {
    var response = await getLikeChart("0", "0",
        testResponse: '[20,30,40]');

    expect(response.first, 20);
  });

  test('client.dart API getComments()', () async {
    var response = await getComments("0", "0",
        testResponse: '[[7, "2931185377152652", "Paulius", "place", "68", "2021-04-25 03:45:00", "koment"]]');

    expect(response.list.first.comment, "koment");
  });

  test('client.dart API getUserListVerification()', () async {
    var response = await getUserListVerification(
        testResponse: '[["3098133687080603", "Alhamedas", "Zabovicius", "a.zajanckovskis@gmail.com", false, false]]');

    expect(response.first[0], "3098133687080603");
  });
}
