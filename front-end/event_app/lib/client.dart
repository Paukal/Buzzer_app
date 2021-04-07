import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'eventsParse.dart';
import 'dart:convert';

Future<List<Event>> fetchEventList(bool filterDateToday, bool filterDateTomorrow, bool filterDateThisWeek, bool filterDateYesterday, bool filterDateLastWeek) async {
  List<Event> list =  await fetchEventData();
  List<Event> filteredList = new List.empty(growable: true);
  final DateTime now = DateTime.now();

  if(filterDateLastWeek){
    Iterator<Event> it = list.iterator;
    while(it.moveNext()){
      final date = DateTime.parse(it.current.startDate);
      if(date.difference(now).inDays < -1 && DateTime.parse(it.current.startDate).isBefore(now)){
        filteredList.add(it.current);
      }
    }
  }
  if(filterDateYesterday){
    Iterator<Event> it = list.iterator;
    while(it.moveNext()){
      final date = DateTime.parse(it.current.startDate);
      if(date.difference(now).inDays == -1 && DateTime.parse(it.current.startDate).isBefore(now)){
        filteredList.add(it.current);
      }
    }
  }
  if(filterDateThisWeek){
    Iterator<Event> it = list.iterator;
    while(it.moveNext()){
      final date = DateTime.parse(it.current.startDate);
      if(date.difference(now).inDays > 1 && DateTime.parse(it.current.startDate).isAfter(now)){
        filteredList.add(it.current);
      }
    }
  }
  if(filterDateTomorrow){
    Iterator<Event> it = list.iterator;
    while(it.moveNext()){
      final date = DateTime.parse(it.current.startDate);
      if(((date.year - now.year == 0 && date.month - now.month == 0 && date.day - now.day == 1) || date.difference(now).inDays == 1) && DateTime.parse(it.current.startDate).isAfter(now)){
        filteredList.add(it.current);
      }
    }
  }
  if(filterDateToday){
    Iterator<Event> it = list.iterator;
    while(it.moveNext()){
      final date = DateTime.parse(it.current.startDate);
      if(date.difference(now).inDays == 0 && DateTime.parse(it.current.startDate).isAfter(now)){
        filteredList.add(it.current);
      }
    }
  }
  return filteredList;
}

Future<List<Event>> fetchEventData() async {
  var url = Uri.parse('http://10.0.2.2:8081/events'); //instead of localhost
  var response = await http.get(url);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  List<dynamic> stringList = jsonDecode(response.body);
  EventCollection collection = EventCollection.fromJson(stringList);


  print('Parsed: ${collection.list.first.address}');


  return collection.list;
}

//for testing
_write(String text) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/file.txt');
  print('${file.path} isAbsolute? ${file.isAbsolute}');

  await file.writeAsString(text);
}