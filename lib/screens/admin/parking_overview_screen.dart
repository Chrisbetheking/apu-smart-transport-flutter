import 'package:flutter/material.dart';

import '../../core/i18n/app_strings.dart';
import '../../services/booking_service.dart';
import '../../services/demo_data_service.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/parking_card.dart';

class ParkingOverviewScreen extends StatelessWidget {
  const ParkingOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLanguageScope.stringsOf(context);
    final bookingService = BookingScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.parkingOverview),
        actions: const [LanguageToggle()],
      ),
      body: AnimatedBuilder(
        animation: bookingService,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 980),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 760 ? 2 : 1;
                    return GridView.builder(
                      itemCount: DemoDataService.parkingZones.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: columns == 1 ? 0.92 : 0.78,
                      ),
                      itemBuilder: (context, index) {
                        final zone = DemoDataService.parkingZones[index];
                        return ParkingCard(
                          zone: zone,
                          availableSlots: bookingService.availableSlotsForZone(zone),
                          reservedSlots: bookingService.reservedSlotLabelsForZone(zone),
                        );
                      },
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
