import 'package:enactusnca/Screens/Events/event_details.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:enactusnca/services/event_services.dart';
import 'package:flutter/material.dart';

class Events extends StatefulWidget {
  static String id = 'events';
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
  // CalendarController _controller;
  // Map<DateTime, List<dynamic>> _events;
  // List<dynamic> _selectedEvents;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = CalendarController();
  //   _events = {};
  //   _selectedEvents = [];
  // }

  // Map<DateTime, List<dynamic>> _groupEvents(List<EventModel> events) {
  //   Map<DateTime, List<dynamic>> data = {};
  //   events.forEach((event) {
  //     DateTime date =
  //         DateTime(event.eventDate.year, event.eventDate.month, event.eventDate.day, 12);
  //     if (data[date] == null) data[date] = [];
  //     data[date].add(event);
  //   });
  //   return data;
  // }

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
            title: Text('Events', style: TextStyle(color: KSacandColor)),
          ),
          body: FutureBuilder<List>(
            future: eventList,
            // stream: eventDBS.streamList(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(child: CircularProgressIndicator())
                  : EventDetails(event: snapshot.data);
              // if (snapshot.hasData) {
              //   List<EventModel> allEvents = snapshot.data;
              //   if (allEvents.isNotEmpty) {
              //     _events = _groupEvents(allEvents);
              //   }
              // }

              // return SingleChildScrollView(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       TableCalendar(
              //         events: _events,
              //         initialCalendarFormat: CalendarFormat.month,
              //         calendarStyle: CalendarStyle(
              //             todayColor: KSacandColor,
              //             selectedColor: KMainColor,
              //             todayStyle: TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 20.0,
              //               //  color: Colors.white,
              //             )),
              //         headerStyle: HeaderStyle(
              //             centerHeaderTitle: true,
              //             formatButtonDecoration: BoxDecoration(
              //               color: KSacandColor,
              //               borderRadius: BorderRadius.circular(20),
              //             ),
              //             formatButtonTextStyle: TextStyle(
              //                 color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0),
              //             formatButtonShowsNext: false),
              //         startingDayOfWeek: StartingDayOfWeek.friday,
              //         // onDaySelected: (data, events) {},
              //         calendarController: _controller,
              //       ),
              //     ],
              //   ),
              // );
            },
          ),
          // floatingActionButton: FloatingActionButton(
          //     // backgroundColor: KMainColor,
          //     child: Icon(
          //       Icons.add,
          //       //   color: KSacandColor,
          //     ),
          //     onPressed: () => Navigator.pushNamed(context, AddEventPage.id)),
        ),
      ],
    );
  }
}
