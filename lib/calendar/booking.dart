import 'package:flutter/material.dart';

class TimeSlotSelection extends StatefulWidget {
  final DateTime selectedDay;

  TimeSlotSelection({required this.selectedDay});

  @override
  _TimeSlotSelectionState createState() => _TimeSlotSelectionState();
}

class _TimeSlotSelectionState extends State<TimeSlotSelection> {
  List<String> _availableTimeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
  ];

  String? _selectedTimeSlot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Select a time slot:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _availableTimeSlots.length,
            itemBuilder: (context, index) {
              String timeSlot = _availableTimeSlots[index];
              return ListTile(
                title: Text(timeSlot),
                leading: Radio<String>(
                  value: timeSlot,
                  groupValue: _selectedTimeSlot,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedTimeSlot = value;
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
