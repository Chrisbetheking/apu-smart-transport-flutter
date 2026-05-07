import 'package:flutter/material.dart';

import '../../core/i18n/app_strings.dart';
import '../../services/booking_service.dart';
import '../../services/demo_data_service.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/route_card.dart';
import '../student/route_detail_screen.dart';

class RoutesOverviewScreen extends StatelessWidget {
  const RoutesOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLanguageScope.stringsOf(context);
    final bookingService = BookingScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.routesOverview),
        actions: const [LanguageToggle()],
      ),
      body: AnimatedBuilder(
        animation: bookingService,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 920),
                child: ListView.separated(
                  itemCount: DemoDataService.shuttleRoutes.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final route = DemoDataService.shuttleRoutes[index];
                    return RouteCard(
                      route: route,
                      availableSeats: bookingService.seatsForRoute(route),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RouteDetailScreen(route: route)),
                      ),
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
