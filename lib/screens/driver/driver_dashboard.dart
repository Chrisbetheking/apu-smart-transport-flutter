import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/i18n/app_strings.dart';
import '../../services/booking_service.dart';
import '../../services/demo_data_service.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/summary_card.dart';

class DriverDashboard extends StatelessWidget {
  const DriverDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLanguageScope.stringsOf(context);
    final bookingService = BookingScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.driverDashboard),
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
          final trips = DemoDataService.driverTrips;
          final totalPassengers = bookingService.todayPassengerCount;
          final totalCapacity = trips.fold<int>(0, (sum, item) => sum + item.capacity);

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DriverHero(totalPassengers: totalPassengers, totalCapacity: totalCapacity),
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
                              title: t.assignedRoute,
                              value: '${trips.length}',
                              description: t.assignedRouteDesc,
                              icon: Icons.alt_route_rounded,
                              onTap: () => Navigator.pushNamed(context, '/assigned-route'),
                            ),
                            SummaryCard(
                              title: t.passengerList,
                              value: '$totalPassengers',
                              description: t.passengerListDesc,
                              icon: Icons.groups_rounded,
                              onTap: () => Navigator.pushNamed(context, '/passengers'),
                            ),
                            SummaryCard(
                              title: t.mapTracking,
                              value: t.simulated,
                              description: t.mapNote,
                              icon: Icons.map_rounded,
                              onTap: () => Navigator.pushNamed(context, '/tracking'),
                            ),
                            SummaryCard(
                              title: t.routeStatus,
                              value: t.routeStatusLabel(DemoDataService.sportsRoute.status),
                              description: t.localDataExplanation,
                              icon: Icons.info_rounded,
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
                          onPressed: () => Navigator.pushNamed(context, '/tracking'),
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: Text(t.startSimulation),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/passengers'),
                          icon: const Icon(Icons.how_to_reg_rounded),
                          label: Text(t.passengerList),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/assigned-route'),
                          icon: const Icon(Icons.route_rounded),
                          label: Text(t.assignedRoute),
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

class _DriverHero extends StatelessWidget {
  const _DriverHero({required this.totalPassengers, required this.totalCapacity});

  final int totalPassengers;
  final int totalCapacity;

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
            t.driverRole,
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
            '${t.todayPassengers}: $totalPassengers / $totalCapacity. ${t.driverHeroText}',
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
