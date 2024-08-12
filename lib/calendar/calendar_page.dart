import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/liqpay_service.dart'; // Ensure this is the correct path

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String? _selectedTimeSlot;

  // Define your time slots here, modified to a more detailed range if necessary
  final List<String> _timeSlots = [
    '09:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
    '12:00 PM - 01:00 PM',
    '01:00 PM - 02:00 PM',
    '02:00 PM - 03:00 PM',
    '03:00 PM - 04:00 PM',
    '04:00 PM - 05:00 PM',
    '05:00 PM - 06:00 PM',
    '06:00 PM - 07:00 PM',
    '07:00 PM - 08:00 PM',
    '08:00 PM - 09:00 PM',
  ];
  List<String> _availableTimeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking Calendar')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3,
              ),
              itemCount: _availableTimeSlots.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _bookTimeSlot(context, _availableTimeSlots[index]);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _availableTimeSlots[index],
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _bookTimeSlot(BuildContext context, String timeSlot) {
    // Example: Show a dialog or navigate to a different screen
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Booking"),
          content: Text("Do you want to book the slot at $timeSlot?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Perform the booking process
                Navigator.of(context).pop();
                // You might call another function here to handle the booking logic
              },
              child: Text("Book"),
            ),
          ],
        );
      },
    );
  }

  void _confirmBooking(
      BuildContext context, DateTime selectedDay, String timeSlot) async {
    try {
      double amount = 10.0; // Assume a booking fee
      bool paymentSuccessful =
          await LiqPayService().processPayment(amount, 'USD');

      if (paymentSuccessful) {
        String userId = FirebaseAuth.instance.currentUser!.uid;
        await saveBooking(userId, selectedDay, timeSlot);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Booking confirmed for $timeSlot on ${selectedDay.toLocal()}'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Payment failed. Please try again.'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to confirm booking: $e'),
      ));
    }
  }

  Future<void> saveBooking(
      String userId, DateTime date, String timeSlot) async {
    CollectionReference bookings =
        FirebaseFirestore.instance.collection('bookings');
    await bookings.add({
      'userId': userId,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'status': 'confirmed',
    });
  }
}
