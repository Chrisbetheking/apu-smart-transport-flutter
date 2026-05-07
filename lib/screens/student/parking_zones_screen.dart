import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/i18n/app_strings.dart';
import '../../models/booking.dart';
import '../../models/parking_zone.dart';
import '../../services/booking_service.dart';
import '../../services/demo_data_service.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/parking_card.dart';

class ParkingZonesScreen extends StatefulWidget {
  const ParkingZonesScreen({super.key});

  @override
  State<ParkingZonesScreen> createState() => _ParkingZonesScreenState();
}

class _ParkingZonesScreenState extends State<ParkingZonesScreen> {
  final Map<String, String> _selectedSlots = {};

  @override
  Widget build(BuildContext context) {
    final t = AppLanguageScope.stringsOf(context);
    final bookingService = BookingScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.parkingZones),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ParkingHeader(totalAvailable: bookingService.totalAvailableParkingSlots),
                    const SizedBox(height: 18),
                    LayoutBuilder(
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
                            final availableSlots = bookingService.availableSlotsForZone(zone);
                            final reservedSlots = bookingService.reservedSlotLabelsForZone(zone);
                            final selectedSlot = _selectedSlots[zone.id];
                            return ParkingCard(
                              zone: zone,
                              availableSlots: availableSlots,
                              reservedSlots: reservedSlots,
                              selectedSlot: selectedSlot,
                              onSlotSelected: availableSlots > 0
                                  ? (slot) => setState(() => _selectedSlots[zone.id] = slot)
                                  : null,
                              onReserve: availableSlots > 0
                                  ? () => _reserveParking(context, bookingService, zone, t)
                                  : null,
                            );
                          },
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

  void _reserveParking(
    BuildContext context,
    BookingService bookingService,
    ParkingZone zone,
    AppStrings t,
  ) {
    try {
      final slot = _selectedSlots[zone.id] ?? bookingService.firstAvailableSlotForZone(zone);
      if (slot == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.chooseSlot)));
        return;
      }
      final booking = bookingService.reserveParking(zone, slotLabel: slot);
      setState(() => _selectedSlots.remove(zone.id));
      _showConfirmation(context, booking, t, slot);
    } on StateError {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.noSlots)),
      );
    }
  }

  void _showConfirmation(BuildContext context, Booking booking, AppStrings t, String slot) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(t.parkingReserved),
          content: Text('${t.bookingId}: ${booking.id}\n${t.selectedSlot}: $slot'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(t.continueText),
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

class _ParkingHeader extends StatelessWidget {
  const _ParkingHeader({required this.totalAvailable});

  final int totalAvailable;

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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.local_parking_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${t.availableSlots}: $totalAvailable',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${t.parkingDesc} ${t.sharedStateNote}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.35,
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
