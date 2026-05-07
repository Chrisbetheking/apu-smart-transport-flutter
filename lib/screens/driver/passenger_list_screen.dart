import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/i18n/app_strings.dart';
import '../../models/booking.dart';
import '../../services/booking_service.dart';
import '../../widgets/booking_card.dart';
import '../../widgets/language_toggle.dart';

class PassengerListScreen extends StatelessWidget {
  const PassengerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLanguageScope.stringsOf(context);
    final bookingService = BookingScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.passengerList),
        actions: const [LanguageToggle()],
      ),
      body: AnimatedBuilder(
        animation: bookingService,
        builder: (context, _) {
          final passengers = bookingService.shuttleBookings;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.alpha(Colors.black, 0.06)),
                      ),
                      child: Text(
                        t.passengerListDesc,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.45,
                            ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    ListView.separated(
                      itemCount: passengers.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final booking = passengers[index];
                        return BookingCard(
                          booking: booking,
                          showPassenger: true,
                          onCheckIn: booking.status == BookingStatus.reserved
                              ? () {
                                  bookingService.checkInPassenger(booking.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(t.checkInDone)),
                                  );
                                }
                              : null,
                          onComplete: booking.status == BookingStatus.checkedIn
                              ? () {
                                  bookingService.completeBooking(booking.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(t.completedDone)),
                                  );
                                }
                              : null,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
