import 'dart:convert';

import 'package:http/http.dart' as http;

class EventServices {
  Future<List> getListOfEvents() async {
    try {
      final response = await http.get("http://www.enactusnewcairo.org/api/events");
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } catch (e) {
      return null;
    }
  }
}

// DatabaseService<EventModel> eventDBS = DatabaseService<EventModel>("events",
//     fromDS: (id, data) => EventModel.fromJson(id, data), toMap: (event) => event.toMap());
