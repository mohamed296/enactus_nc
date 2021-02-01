import 'package:enactusnca/Screens/Events/event_details.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:enactusnca/services/event_services.dart';
import 'package:flutter/material.dart';

class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  Future<List> eventList;
  @override
  void initState() {
    eventList = EventServices().getListOfEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/back.jpg',
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: const Text('Events', style: TextStyle(color: kSacandColor)),
          ),
          body: FutureBuilder<List>(
            future: eventList,
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? const Center(child: CircularProgressIndicator())
                  : EventDetails(event: snapshot.data);
            },
          ),
        ),
      ],
    );
  }
}
