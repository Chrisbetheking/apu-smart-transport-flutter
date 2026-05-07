import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/i18n/app_strings.dart';
import '../models/shuttle_route.dart';
import 'status_badge.dart';

class RouteCard extends StatelessWidget {
  const RouteCard({
    super.key,
    required this.route,
    required this.availableSeats,
    required this.onTap,
  });

  final ShuttleRoute route;
  final int availableSeats;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLanguageScope.stringsOf(context);
    final lang = AppLanguageScope.languageOf(context);
    final effectiveStatus = availableSeats <= 0
        ? RouteStatus.arrived
        : availableSeats <= 5
            ? RouteStatus.limitedSeats
            : route.status;

    return Card(
      elevation: 0,
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: AppColors.alpha(Colors.black, 0.06)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
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
                    child: const Icon(
                      Icons.directions_bus_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          route.routeName(lang),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${route.startPoint(lang)} → ${route.destination(lang)}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.35,
                              ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(label: t.routeStatusLabel(effectiveStatus), compact: true),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _Metric(label: t.bus, value: route.busCode),
                  _Metric(label: t.direction, value: route.direction(lang)),
                  _Metric(label: t.nextDeparture, value: route.nextDepartureTime),
                  _Metric(label: t.estimatedDuration, value: route.estimatedDuration(lang)),
                  _Metric(label: t.distance, value: '${route.distanceKm.toStringAsFixed(1)} km'),
                  _Metric(label: t.availableSeats, value: '$availableSeats'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

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
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}
