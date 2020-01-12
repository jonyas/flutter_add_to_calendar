import 'package:add_to_calendar/add_to_calendar.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: _Home());
  }
}

class _Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  String title = '';
  String location = '';
  String description = '';
  DateTime startDate;
  DateTime endDate;
  TextEditingController endDateController = TextEditingController();
  bool allDay = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Add to calendar Plugin Demo'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Event title:',
                  ),
                  onChanged: (String value) => setState(() {
                    title = value;
                  }),
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Event description: (Optional)',
                  ),
                  onChanged: (String value) => setState(() {
                    description = value;
                  }),
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Event location: (Optional)',
                  ),
                  onChanged: (String value) => setState(() {
                    location = value;
                  }),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final DateTime picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2015, 8),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != startDate)
                      setState(() {
                        startDate = picked;
                      });
                  },
                  child: Text(startDate != null ? startDate.toIso8601String() : 'Select start date'),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final DateTime picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2015, 8),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != endDate)
                      setState(() {
                        endDate = picked;
                      });
                  },
                  child: Text(endDate != null ? endDate.toIso8601String() : 'Select end date'),
                ),
                Row(
                  children: [
                    Text('All day'),
                    Checkbox(
                      value: allDay,
                      onChanged: (checked) {
                        setState(() {
                          endDate = null;
                          endDateController.clear();
                          allDay = checked;
                        });
                      },
                    ),
                  ],
                ),
                RaisedButton(
                  child: const Text('Add to calendar'),
                  onPressed: title.isEmpty || startDate == null
                      ? null
                      : () {
                          return AddToCalendar.addToCalendar(
                            title: title,
                            startTime: startDate,
                            endTime: endDate,
                            location: location,
                            description: description,
                            isAllDay: allDay == true ? true : null,
                          );
                        },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
