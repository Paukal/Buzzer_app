import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'eventsParse.dart';

class DB {
  static final DB _singleton = DB._internal();

  factory DB() {
    return _singleton;
  }

  DB._internal();

  bool eventsStored = false;
  bool placesStored = false;

  Future<Database> init() async {
    Future<Database> initial;

    WidgetsFlutterBinding.ensureInitialized();
    // Open the database and store the reference.
    initial = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'eventsPlaces.db'),
      // When the database is first created, create a table.
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE events(event_id INTEGER PRIMARY KEY, event_name TEXT, "
          "place_name TEXT, link TEXT, address TEXT, city TEXT, start_date "
          "TEXT, public TEXT, user_added_id INTEGER);"
          "CREATE TABLE users(user_id TEXT PRIMARY KEY, access_token TEXT);",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
      return db.execute(
            "CREATE TABLE users(user_id TEXT PRIMARY KEY, access_token TEXT);",
      );
    },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 4,
    );

    return initial;
  }

  Future<void> insertEvent(Event event) async {
    final Database db = await init();

    await db.insert(
      'events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    eventsStored = true;
  }

  Future<void> insertEvents(List<Event> events) async {
    final Database db = await init();
    Iterator<Event> it = events.iterator;

    while (it.moveNext()) {
      await db.insert(
        'events',
        it.current.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    eventsStored = true;
  }

  Future<List<Event>> events() async {
    final Database db = await init();
    final List<Map<String, dynamic>> maps = await db.query('events');

    return List.generate(maps.length, (i) {
      return Event(
        maps[i]['event_id'],
        maps[i]['event_name'],
        maps[i]['place_name'],
        maps[i]['link'],
        maps[i]['address'],
        maps[i]['city'],
        maps[i]['start_date'],
        maps[i]['public'] == "true",
        maps[i]['user_added_id'].toString(),
      );
    });
  }

  Future<void> updateEvent(Event event) async {
    final db = await init();

    await db.update(
      'events',
      event.toMap(),
      where: "event_id = ?",
      whereArgs: [event.eventId],
    );
  }

  Future<void> deleteEvent(int id) async {
    final db = await init();

    await db.delete(
      'events',
      where: "event_id = ?",
      whereArgs: [id],
    );
  }

  Future<void> insertUser(String id, String token) async {
    final Database db = await init();

    await db.insert(
      'users',
      {'user_id': id, 'access_token': token},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>> getUserLoginInfo() async {
    final Database db = await init();
    final List<Map<String, dynamic>> maps = await db.query('users');

    return maps[0];
  }
}
