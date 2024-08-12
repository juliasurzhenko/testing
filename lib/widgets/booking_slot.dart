import 'package:flutter/material.dart';
import 'package:test/models/booking_modal.dart';

class BookingSlot extends StatelessWidget {
  final Booking booking;

  BookingSlot({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, // Height for each slot
      color: booking.isBooked ? Colors.blue : Colors.orange,
      child: Center(
        child: Text(
          '${booking.startTime} - ${booking.endTime}',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
