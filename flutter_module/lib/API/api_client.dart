import 'package:flutter_module/api/Models/people.dart';
import 'package:flutter_module/api/secrets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  final Future<People> Function(int) getDetails;

  ApiClient({required this.getDetails});
}

extension ApiClientLive on ApiClient {
  static final ApiClient live = ApiClient(getDetails: _getDetails);
}

Future<People> _getDetails(int id) async {
  final request =
      _makeRequest('https://api.themoviedb.org/3/person/$id?language=en-US');
  final responseStream = await request.send();
  final response = await http.Response.fromStream(responseStream);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return People.fromJson(data);
  } else {
    throw Exception('Failed to load data');
  }
}

http.Request _makeRequest(String stringURL) {
  final url = Uri.parse(stringURL);
  final request = http.Request('GET', url);
  request.headers['Authorization'] = 'Bearer ${Secrets.accessToken}';
  request.headers['accept'] = 'application/json';
  return request;
}
