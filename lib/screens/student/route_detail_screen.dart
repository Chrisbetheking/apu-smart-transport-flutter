import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/i18n/app_strings.dart';
import '../../models/booking.dart';
import '../../models/shuttle_route.dart';
import '../../screens/map/tracking_screen.dart';
import '../../services/booking_service.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/status_badge.dart';

class RouteDetailScreen extends StatelessWidget {
  const RouteDetailScreen({
    super.key,
    required this.route,
  });

  final ShuttleRoute route;

  @override
  Widget build(BuildContext context) {
    final t = AppLanguageScope.stringsOf(context);
    final lang = AppLanguageScope.languageOf(context);
    final bookingService = BookingScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.routeDetail),
        actions: const [LanguageToggle()],
      ),
      body: AnimatedBuilder(
        animation: bookingService,
        builder: (context, _) {
          final remainingSeats = bookingService.seatsForRoute(route);
          final status = remainingSeats <= 5 ? RouteStatus.limitedSeats : route.status;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Card(
                  elevation: 0,
                  color: AppColors.card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: BorderSide(color: AppColors.alpha(Colors.black, 0.06)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                route.routeName(lang),
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                            ),
                            StatusBadge(label: t.routeStatusLabel(status)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${route.startPoint(lang)} → ${route.destination(lang)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _DetailMetric(
                              icon: Icons.directions_bus_rounded,
                              title: t.bus,
                              value: route.busCode,
                            ),
                            _DetailMetric(
                              icon: Icons.compare_arrows_rounded,
                              title: t.direction,
                              value: route.direction(lang),
                            ),
                            _DetailMetric(
                              icon: Icons.schedule_rounded,
                              title: t.nextDeparture,
                              value: route.nextDepartureTime,
                            ),
                            _DetailMetric(
                              icon: Icons.timer_rounded,
                              title: t.estimatedDuration,
                              value: route.estimatedDuration(lang),
                            ),
                            _DetailMetric(
                              icon: Icons.speed_rounded,
                              title: t.averageSpeed,
                              value: '${route.averageSpeedKmh.toStringAsFixed(0)} km/h',
                            ),
                            _DetailMetric(
                              icon: Icons.event_seat_rounded,
                              title: t.availableSeats,
                              value: '$remainingSeats',
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Text(
                          t.stops,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                              ),
                        ),
                        const SizedBox(height: 12),
                        ...route.stops(lang).asMap().entries.map(
                              (entry) => _StopRow(
                                index: entry.key + 1,
                                name: entry.value,
                                isLast: entry.key == route.stops(lang).length - 1,
                              ),
                            ),
                        const SizedBox(height: 18),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            '${route.note(lang)} ${t.mapNote}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TrackingScreen(route: route),
                                  ),
                                ),
                                icon: const Icon(Icons.map_rounded),
                                label: Text(t.viewMap),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: remainingSeats > 0
                                    ? () => _bookSeat(context, bookingService, t)
                                    : null,
                                icon: const Icon(Icons.event_available_rounded),
                                label: Text(t.bookSeat),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _bookSeat(BuildContext context, BookingService bookingService, AppStrings t) {
    try {
      final booking = bookingService.reserveShuttle(route);
      _showConfirmation(context, booking, t);
    } on StateError {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.noSeats)),
      );
    }
  }

  void _showConfirmation(BuildContext context, Booking booking, AppStrings t) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(t.bookingConfirmed),
          content: Text('${t.bookingId}: ${booking.id}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(t.close),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pushNamed(context, '/bookings');
              },
              child: Text(t.viewBookings),
            ),
          ],
        );
      },
    );
  }
}

class _DetailMetric extends StatelessWidget {
  const _DetailMetric({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StopRow extends StatelessWidget {
  const _StopRow({
    required this.index,
    required this.name,
    required this.isLast,
  });

  final int index;
  final String name;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.primary,
              child: Text(
                '$index',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 28,
                color: AppColors.primarySoft,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
