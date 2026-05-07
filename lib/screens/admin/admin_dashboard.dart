import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/i18n/app_strings.dart';
import '../../models/booking.dart';
import '../../services/booking_service.dart';
import '../../services/demo_data_service.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/summary_card.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLanguageScope.stringsOf(context);
    final bookingService = BookingScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.adminDashboard),
        actions: [
          const LanguageToggle(),
          IconButton(
            tooltip: t.switchRole,
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
            icon: const Icon(Icons.swap_horiz_rounded),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: bookingService,
        builder: (context, _) {
          final delayed = DemoDataService.delayedRouteCount;
          final active = bookingService.activeBookingCount;
          final parkingUsed = DemoDataService.totalParkingCapacity - bookingService.totalAvailableParkingSlots;
          final completed = bookingService.bookings.where((b) => b.status == BookingStatus.completed).length;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AdminHero(activeBookings: active, parkingUsed: parkingUsed),
                    const SizedBox(height: 22),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        final columns = width >= 900 ? 4 : width >= 640 ? 2 : 1;
                        return GridView.count(
                          crossAxisCount: columns,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: columns == 1 ? 1.9 : 1.05,
                          children: [
                            SummaryCard(
                              title: t.totalRoutes,
                              value: '${DemoDataService.shuttleRoutes.length}',
                              description: t.routeBrowsingDesc,
                              icon: Icons.alt_route_rounded,
                              onTap: () => Navigator.pushNamed(context, '/admin-routes'),
                            ),
                            SummaryCard(
                              title: t.activeBookings,
                              value: '$active',
                              description: '${t.bookingStatus(BookingStatus.completed)}: $completed',
                              icon: Icons.receipt_long_rounded,
                              onTap: () => Navigator.pushNamed(context, '/admin-bookings'),
                            ),
                            SummaryCard(
                              title: t.parkingOccupancy,
                              value: '$parkingUsed/${DemoDataService.totalParkingCapacity}',
                              description: t.parkingDesc,
                              icon: Icons.local_parking_rounded,
                              onTap: () => Navigator.pushNamed(context, '/admin-parking'),
                            ),
                            SummaryCard(
                              title: t.delayedShuttles,
                              value: '$delayed',
                              description: t.localDataExplanation,
                              icon: Icons.warning_amber_rounded,
                              onTap: () => Navigator.pushNamed(context, '/admin-routes'),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        FilledButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/admin-routes'),
                          icon: const Icon(Icons.alt_route_rounded),
                          label: Text(t.routesOverview),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/admin-bookings'),
                          icon: const Icon(Icons.receipt_long_rounded),
                          label: Text(t.bookingsOverview),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/admin-parking'),
                          icon: const Icon(Icons.local_parking_rounded),
                          label: Text(t.parkingOverview),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/tracking'),
                          icon: const Icon(Icons.map_rounded),
                          label: Text(t.mapTracking),
                        ),
                      ],
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

class _AdminHero extends StatelessWidget {
  const _AdminHero({required this.activeBookings, required this.parkingUsed});

  final int activeBookings;
  final int parkingUsed;

  @override
  Widget build(BuildContext context) {
    final t = AppLanguageScope.stringsOf(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.transportOverview,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.alpha(Colors.white, 0.78),
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            t.todayOverview,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            '${t.activeBookings}: $activeBookings • ${t.parkingOccupancy}: $parkingUsed. ${t.adminHeroText}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.alpha(Colors.white, 0.84),
                  height: 1.45,
                ),
          ),
        ],
      ),
    );
  }
}
