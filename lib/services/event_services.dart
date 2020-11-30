import 'dart:convert';

import 'package:http/http.dart' as http;

class EventServices {
  Future<List> getListOfEvents() async {
    try {
      var response = await http.get("http://www.enactusnewcairo.org/api/events");
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } catch (e) {
      print(e);
      return null;
    }
  }
}

// DatabaseService<EventModel> eventDBS = DatabaseService<EventModel>("events",
//     fromDS: (id, data) => EventModel.fromJson(id, data), toMap: (event) => event.toMap());
