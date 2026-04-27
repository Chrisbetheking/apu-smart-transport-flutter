import 'package:flutter/material.dart';
import '../../services/booking_service.dart';
import '../../models/booking.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  void addBooking() {
    BookingService.addBooking(
      Booking(id: DateTime.now().toString(), title: "Bus Booking"),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookings = BookingService.bookings;

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: addBooking,
            child: const Text("Add Booking"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (_, index) {
                final b = bookings[index];
                return ListTile(
                  title: Text(b.title),
                  subtitle: Text(b.status),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
