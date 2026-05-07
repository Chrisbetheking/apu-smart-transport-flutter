import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/i18n/app_strings.dart';
import '../../models/booking.dart';
import '../../services/booking_service.dart';
import '../../widgets/booking_card.dart';
import '../../widgets/language_toggle.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLanguageScope.stringsOf(context);
    final bookingService = BookingScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.myBookings),
        actions: const [LanguageToggle()],
      ),
      body: AnimatedBuilder(
        animation: bookingService,
        builder: (context, _) {
          final bookings = bookingService.myBookings;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BookingsHeader(activeCount: bookings.where((b) => b.status != BookingStatus.cancelled).length, totalCount: bookings.length),
                    const SizedBox(height: 18),
                    if (bookings.isEmpty)
                      const _EmptyBookings()
                    else
                      ListView.separated(
                        itemCount: bookings.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final booking = bookings[index];
                          return BookingCard(
                            booking: booking,
                            onCancel: booking.status == BookingStatus.reserved
                                ? () => _confirmCancel(context, bookingService, booking, t)
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

  void _confirmCancel(
    BuildContext context,
    BookingService bookingService,
    Booking booking,
    AppStrings t,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(t.cancelBookingTitle),
          content: Text(t.cancelBookingMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(t.keepBooking),
            ),
            FilledButton(
              onPressed: () {
                bookingService.cancelBooking(booking.id);
                Navigator.pop(dialogContext);
              },
              child: Text(t.cancelBooking),
            ),
          ],
        );
      },
    );
  }
}

class _BookingsHeader extends StatelessWidget {
  const _BookingsHeader({required this.activeCount, required this.totalCount});

  final int activeCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final t = AppLanguageScope.stringsOf(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.alpha(Colors.black, 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.myBookings,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '${t.activeBookings}: $activeCount • ${t.status}: $totalCount',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
          ),
        ],
      ),
    );
  }
}

class _EmptyBookings extends StatelessWidget {
  const _EmptyBookings();

  @override
  Widget build(BuildContext context) {
    final t = AppLanguageScope.stringsOf(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.alpha(Colors.black, 0.06)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 44,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 14),
          Text(
            t.emptyBookings,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            t.emptyBookingsDesc,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }
}
