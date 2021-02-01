import 'dart:convert';

import 'package:http/http.dart' as http;

class EventServices {
  Future<List> getListOfEvents() async {
    try {
      final response = await http.get("http://www.enactusnewcairo.org/api/events");
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse as List;
    } catch (e) {
      return null;
    }
  }
}
