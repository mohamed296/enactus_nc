import 'package:enactusnca/Events/addEvent.dart';
import 'package:enactusnca/Models/event.dart';
import 'package:enactusnca/Widgets/constants.dart';
import 'package:enactusnca/services/event_ser.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends StatefulWidget {
  static String id = 'Calender';
  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<EventModel> events) {
    Map<DateTime, List<dynamic>> data = {};
    events.forEach((event) {
      DateTime date =
          DateTime(event.eventDate.year, event.eventDate.month, event.eventDate.day, 12);
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Colors.white60,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Events',
          style: TextStyle(color: KSacandColor),
        ),
        //   backgroundColor: KMainColor,
      ),
      body: StreamBuilder<List<EventModel>>(
          stream: eventDBS.streamList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<EventModel> allEvents = snapshot.data;
              if (allEvents.isNotEmpty) {
                _events = _groupEvents(allEvents);
              }
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TableCalendar(
                    events: _events,
                    initialCalendarFormat: CalendarFormat.month,
                    calendarStyle: CalendarStyle(
                        todayColor: KSacandColor,
                        selectedColor: KMainColor,
                        todayStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          //  color: Colors.white,
                        )),
                    headerStyle: HeaderStyle(
                        centerHeaderTitle: true,
                        formatButtonDecoration: BoxDecoration(
                          color: KSacandColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        formatButtonTextStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0),
                        formatButtonShowsNext: false),
                    startingDayOfWeek: StartingDayOfWeek.friday,
                    // onDaySelected: (data, events) {},
                    calendarController: _controller,
                  ),
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
          // backgroundColor: KMainColor,
          child: Icon(
            Icons.add,
            //   color: KSacandColor,
          ),
          onPressed: () => Navigator.pushNamed(context, AddEventPage.id)),
    );
  }
}
