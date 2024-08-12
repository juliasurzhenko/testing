class Booking {
  final String startTime;
  final String endTime;
  final bool isBooked;

  Booking(
      {required this.startTime, required this.endTime, this.isBooked = false});
}
