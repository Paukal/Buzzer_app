import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'eventsParse.dart';
import 'dart:convert';

Future<List<Event>> fetchData() async {
  var url = Uri.parse('http://10.0.2.2:8081'); //instead of localhost
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