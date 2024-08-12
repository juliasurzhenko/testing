import 'package:flutter/material.dart';
import 'package:test/models/booking_modal.dart';
import 'package:test/widgets/booking_slot.dart';

class CourtColumn extends StatelessWidget {
  final String courtName;
  final List<Booking> bookings;

  CourtColumn({required this.courtName, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            courtName,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          ...bookings.map((booking) => BookingSlot(booking: booking)).toList(),
        ],
      ),
    );
  }
}
