import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/i18n/app_strings.dart';
import '../../models/shuttle_route.dart';
import '../../services/booking_service.dart';
import '../../services/demo_data_service.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/route_card.dart';
import 'route_detail_screen.dart';

class ShuttleRoutesScreen extends StatefulWidget {
  const ShuttleRoutesScreen({super.key});

  @override
  State<ShuttleRoutesScreen> createState() => _ShuttleRoutesScreenState();
}

class _ShuttleRoutesScreenState extends State<ShuttleRoutesScreen> {
  String _selectedGroupId = 'all';

  @override
  Widget build(BuildContext context) {
    final t = AppLanguageScope.stringsOf(context);
    final lang = AppLanguageScope.languageOf(context);
    final bookingService = BookingScope.of(context);
    final routes = _selectedGroupId == 'all'
        ? DemoDataService.shuttleRoutes
        : DemoDataService.shuttleRoutes
            .where((route) => route.routeGroupId == _selectedGroupId)
            .toList(growable: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.shuttleRoutes),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Intro(totalRoutes: routes.length),
                    const SizedBox(height: 14),
                    Text(
                      t.routeFilter,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ChoiceChip(
                          label: Text(t.allRoutes),
                          selected: _selectedGroupId == 'all',
                          onSelected: (_) => setState(() => _selectedGroupId = 'all'),
                        ),
                        ..._routeGroups.map(
                          (group) => ChoiceChip(
                            label: Text(group.label(lang)),
                            selected: _selectedGroupId == group.id,
                            onSelected: (_) => setState(() => _selectedGroupId = group.id),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    ListView.separated(
                      itemCount: routes.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final route = routes[index];
                        return RouteCard(
                          route: route,
                          availableSeats: bookingService.seatsForRoute(route),
                          onTap: () => _openRouteDetail(context, route),
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

  List<_RouteGroupFilter> get _routeGroups {
    final seen = <String>{};
    final groups = <_RouteGroupFilter>[];
    for (final route in DemoDataService.shuttleRoutes) {
      if (seen.add(route.routeGroupId)) {
        groups.add(_RouteGroupFilter(
          id: route.routeGroupId,
          labelZh: route.routeGroupZh,
          labelEn: route.routeGroupEn,
        ));
      }
    }
    return groups;
  }

  void _openRouteDetail(BuildContext context, ShuttleRoute route) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RouteDetailScreen(route: route)),
    );
  }
}

class _RouteGroupFilter {
  const _RouteGroupFilter({required this.id, required this.labelZh, required this.labelEn});

  final String id;
  final String labelZh;
  final String labelEn;

  String label(AppLanguage language) => language == AppLanguage.zh ? labelZh : labelEn;
}

class _Intro extends StatelessWidget {
  const _Intro({required this.totalRoutes});

  final int totalRoutes;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${t.shuttleRoutes}: $totalRoutes',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '${t.routeBrowsingDesc} ${t.sharedStateNote}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }
}
