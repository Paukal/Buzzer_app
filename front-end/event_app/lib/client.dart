import 'package:http/http.dart' as http;

Future<http.Response> fetchData() {
  return http.get(Uri.https('localhost:8081', '/'));
}
