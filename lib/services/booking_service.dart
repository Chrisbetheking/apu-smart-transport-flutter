import '../models/booking.dart';

class BookingService {
  static final List<Booking> _bookings = [];

  static List<Booking> get bookings => _bookings;

  static void addBooking(Booking booking) {
    _bookings.add(booking);
  }

  static void cancelBooking(Booking booking) {
    booking.status = 'Cancelled';
  }
}
