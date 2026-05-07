import 'package:flutter/material.dart';

import '../../core/i18n/app_strings.dart';
import '../../models/booking.dart';
import '../../services/booking_service.dart';
import '../../widgets/booking_card.dart';
import '../../widgets/language_toggle.dart';

class BookingsOverviewScreen extends StatelessWidget {
  const BookingsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLanguageScope.stringsOf(context);
    final bookingService = BookingScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.bookingsOverview),
        actions: const [LanguageToggle()],
      ),
      body: AnimatedBuilder(
        animation: bookingService,
        builder: (context, _) {
          final bookings = bookingService.bookings;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 880),
                child: ListView.separated(
                  itemCount: bookings.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return BookingCard(
                      booking: booking,
                      showPassenger: true,
                      onComplete: booking.status == BookingStatus.checkedIn
                          ? () => bookingService.completeBooking(booking.id)
                          : null,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
