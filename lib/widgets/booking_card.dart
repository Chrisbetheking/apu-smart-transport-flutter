import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/i18n/app_strings.dart';
import '../models/booking.dart';
import 'status_badge.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.booking,
    this.onCancel,
    this.onCheckIn,
    this.onComplete,
    this.showPassenger = false,
  });

  final Booking booking;
  final VoidCallback? onCancel;
  final VoidCallback? onCheckIn;
  final VoidCallback? onComplete;
  final bool showPassenger;

  @override
  Widget build(BuildContext context) {
    final t = AppLanguageScope.stringsOf(context);
    final lang = AppLanguageScope.languageOf(context);

    return Card(
      elevation: 0,
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: AppColors.alpha(Colors.black, 0.06)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    booking.type == BookingType.shuttle
                        ? Icons.directions_bus_rounded
                        : Icons.local_parking_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.title(lang),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        booking.details(lang),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.35,
                            ),
                      ),
                    ],
                  ),
                ),
                StatusBadge(label: t.bookingStatus(booking.status), compact: true),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _Info(label: t.bookingId, value: booking.id),
                _Info(label: t.type, value: t.bookingType(booking.type)),
                _Info(label: t.nextDeparture, value: booking.time(lang)),
                if (showPassenger) _Info(label: t.passenger, value: booking.passengerName),
              ],
            ),
            if (onCancel != null || onCheckIn != null || onComplete != null) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  if (onCheckIn != null)
                    FilledButton.tonalIcon(
                      onPressed: onCheckIn,
                      icon: const Icon(Icons.how_to_reg_rounded),
                      label: Text(t.checkIn),
                    ),
                  if (onComplete != null)
                    FilledButton.tonalIcon(
                      onPressed: onComplete,
                      icon: const Icon(Icons.done_all_rounded),
                      label: Text(t.markCompleted),
                    ),
                  if (onCancel != null)
                    OutlinedButton.icon(
                      onPressed: onCancel,
                      icon: const Icon(Icons.cancel_outlined),
                      label: Text(t.cancelBooking),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}
