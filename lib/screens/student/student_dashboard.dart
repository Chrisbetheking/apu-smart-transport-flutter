import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/i18n/app_strings.dart';
import '../../services/booking_service.dart';
import '../../services/demo_data_service.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/summary_card.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLanguageScope.stringsOf(context);
    final bookingService = BookingScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.studentDashboard),
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
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroPanel(activeBookings: bookingService.myBookings.length),
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
                              title: t.shuttleRoutes,
                              value: '${DemoDataService.shuttleRoutes.length}',
                              description: t.routeBrowsingDesc,
                              icon: Icons.directions_bus_rounded,
                              onTap: () => Navigator.pushNamed(context, '/routes'),
                            ),
                            SummaryCard(
                              title: t.parkingZones,
                              value: '${bookingService.totalAvailableParkingSlots}',
                              description: t.parkingDesc,
                              icon: Icons.local_parking_rounded,
                              onTap: () => Navigator.pushNamed(context, '/parking'),
                            ),
                            SummaryCard(
                              title: t.myBookings,
                              value: '${bookingService.myBookings.length}',
                              description: t.emptyBookingsDesc,
                              icon: Icons.event_available_rounded,
                              onTap: () => Navigator.pushNamed(context, '/bookings'),
                            ),
                            SummaryCard(
                              title: t.transportNotices,
                              value: '${bookingService.unreadNoticeCount}',
                              description: t.noticesDesc,
                              icon: Icons.notifications_active_outlined,
                              onTap: () => Navigator.pushNamed(context, '/notices'),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      t.quickAccess,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _QuickActionButton(
                          label: t.shuttleRoutes,
                          icon: Icons.route_rounded,
                          onTap: () => Navigator.pushNamed(context, '/routes'),
                        ),
                        _QuickActionButton(
                          label: t.mapTracking,
                          icon: Icons.map_rounded,
                          onTap: () => Navigator.pushNamed(context, '/tracking'),
                        ),
                        _QuickActionButton(
                          label: t.parkingZones,
                          icon: Icons.local_parking_rounded,
                          onTap: () => Navigator.pushNamed(context, '/parking'),
                        ),
                        _QuickActionButton(
                          label: t.myBookings,
                          icon: Icons.receipt_long_rounded,
                          onTap: () => Navigator.pushNamed(context, '/bookings'),
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

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.activeBookings});

  final int activeBookings;

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
            t.todayOverview,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.alpha(Colors.white, 0.82),
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 18),
          Text(
            '${t.welcomeBack}, Kevin',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            t.studentHeroText,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.alpha(Colors.white, 0.82),
                  height: 1.45,
                ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.alpha(Colors.white, 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '${t.myBookings}: $activeBookings',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
