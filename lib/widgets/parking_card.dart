import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/i18n/app_strings.dart';
import '../models/parking_zone.dart';
import 'status_badge.dart';

class ParkingCard extends StatelessWidget {
  const ParkingCard({
    super.key,
    required this.zone,
    required this.availableSlots,
    required this.reservedSlots,
    this.selectedSlot,
    this.onSlotSelected,
    this.onReserve,
  });

  final ParkingZone zone;
  final int availableSlots;
  final Set<String> reservedSlots;
  final String? selectedSlot;
  final ValueChanged<String>? onSlotSelected;
  final VoidCallback? onReserve;

  @override
  Widget build(BuildContext context) {
    final t = AppLanguageScope.stringsOf(context);
    final lang = AppLanguageScope.languageOf(context);
    final status = zone.statusFor(availableSlots);

    return Card(
      elevation: 0,
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
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
                Expanded(
                  child: Text(
                    zone.zoneName(lang),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
                StatusBadge(label: t.parkingStatus(status), compact: true),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${zone.distance(lang)} • ${zone.location(lang)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: zone.totalSlots == 0 ? 0 : availableSlots / zone.totalSlots,
              minHeight: 8,
              borderRadius: BorderRadius.circular(99),
            ),
            const SizedBox(height: 10),
            Text(
              '$availableSlots / ${zone.totalSlots} ${t.availableSlots}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 14),
            _MiniParkingMap(
              zone: zone,
              reservedSlots: reservedSlots,
              selectedSlot: selectedSlot,
              enabled: availableSlots > 0,
              onSlotSelected: onSlotSelected,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                _LegendDot(label: t.free, color: AppColors.primarySoft),
                _LegendDot(label: t.occupied, color: AppColors.alpha(AppColors.danger, 0.16)),
                _LegendDot(label: t.selectedSlot, color: AppColors.alpha(AppColors.accent, 0.20)),
              ],
            ),
            const Spacer(),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onReserve,
                icon: const Icon(Icons.local_parking_rounded),
                label: Text(selectedSlot == null ? t.reserveSlot : '${t.reserveSlot} $selectedSlot'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniParkingMap extends StatelessWidget {
  const _MiniParkingMap({
    required this.zone,
    required this.reservedSlots,
    required this.selectedSlot,
    required this.enabled,
    this.onSlotSelected,
  });

  final ParkingZone zone;
  final Set<String> reservedSlots;
  final String? selectedSlot;
  final bool enabled;
  final ValueChanged<String>? onSlotSelected;

  @override
  Widget build(BuildContext context) {
    final labels = zone.visibleSlotLabels;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: GridView.builder(
        itemCount: labels.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: zone.mapColumns,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.65,
        ),
        itemBuilder: (context, index) {
          final label = labels[index];
          final occupied = reservedSlots.contains(label);
          final selected = selectedSlot == label;
          final canTap = enabled && !occupied;
          return InkWell(
            onTap: canTap ? () => onSlotSelected?.call(label) : null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: occupied
                    ? AppColors.alpha(AppColors.danger, 0.16)
                    : selected
                        ? AppColors.alpha(AppColors.accent, 0.20)
                        : AppColors.primarySoft,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? AppColors.accent
                      : occupied
                          ? AppColors.alpha(AppColors.danger, 0.36)
                          : AppColors.alpha(AppColors.primary, 0.12),
                ),
              ),
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: occupied ? AppColors.danger : AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
