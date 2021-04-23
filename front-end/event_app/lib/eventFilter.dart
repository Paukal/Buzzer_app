/*
* Lets Go App
* Paulius Tomas Kalvers
* Event filtering logic
* */

import 'package:flutter/material.dart';

class MapEventFilter extends StatefulWidget {
  bool today;
  bool tomorrow;
  bool thisWeek;
  bool yesterday;
  bool lastWeek;

  MapEventFilter(this.today, this.tomorrow, this.thisWeek, this.yesterday, this.lastWeek);

  @override
  State<MapEventFilter> createState() => MapEventFilterState(today, tomorrow, thisWeek, yesterday, lastWeek);
}

class MapEventFilterState extends State<MapEventFilter> {
  bool today;
  bool tomorrow;
  bool thisWeek;
  bool yesterday;
  bool lastWeek;

  MapEventFilterState(this.today, this.tomorrow, this.thisWeek, this.yesterday, this.lastWeek);

  void _onTodayChanged(bool? newValue) => setState(() {
        today = newValue == true;
      });

  void _onTomorrowChanged(bool? newValue) => setState(() {
        tomorrow = newValue == true;
      });

  void _onThisWeekChanged(bool? newValue) => setState(() {
        thisWeek = newValue == true;
      });

  void _onYesterdayChanged(bool? newValue) => setState(() {
        yesterday = newValue == true;
      });

  void _onLastWeekChanged(bool? newValue) => setState(() {
        lastWeek = newValue == true;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context, [today, tomorrow, thisWeek, yesterday, lastWeek]),
        ),
        title: Text("Filter"),
      ),
      body: Column(children: [
        CheckboxListTile(
            title: Text("Today"),
            value: today,
            onChanged: _onTodayChanged),
        CheckboxListTile(
            title: Text("Tomorrow"),
            value: tomorrow,
            onChanged: _onTomorrowChanged),
        CheckboxListTile(
            title: Text("This week"),
            value: thisWeek,
            onChanged: _onThisWeekChanged),
        CheckboxListTile(
            title: Text("Yesterday"),
            value: yesterday,
            onChanged: _onYesterdayChanged),
        CheckboxListTile(
            title: Text("Last week"),
            value: lastWeek,
            onChanged: _onLastWeekChanged),
      ]),
    );
  }
}
